-- 1
-- Speisekarte generieren: Wähle 5 saisonale Gerichte für jede Kategorie aus und sortiere die Gerichte zu jeder
-- Kategorie nach Marge und Verkaufspreis.

with karte as (
    select g.name,
           g.KATEGORIE,
           ak.GEWINNMARGE,
           ak.VERKAUFSPREIS,
           -- Sortierung von jedem Gericht zu seiner jeweiligen Kategorie nach Gewinnmarge und Verkaufspreis absteigend
           -- speichern der Position des Gerichts in rn
           ROW_NUMBER() over (partition by g.KATEGORIE order by g.KATEGORIE, ak.GEWINNMARGE desc, ak.VERKAUFSPREIS desc) as rn
    from GERICHT g 
        join AktuellsteKalkulationen ak on g.name = ak.FK_GERICHT_NAME
)
select k.NAME, k.KATEGORIE, ROUND(k.GEWINNMARGE, 2) Gewinnmarge, k.VERKAUFSPREIS
from karte k
-- gebe die 5 besten Gerichte nach Gewinnmarge und Verkaufspreis
where rn <= 5
order by k.KATEGORIE, k.GEWINNMARGE desc, k.VERKAUFSPREIS desc;

-- 2
-- Kochreihenfolge generieren/Anzeige in der Küche bereitstellen: Sortiere Komponenten von nicht fertigen
-- Bestellungen nach Aufgabe-Datum und Zubereitungsdauer. Filtere das Ergebnis nach Kategorie und Tisch.
-- Es wurde für die Abfrage die Tischnr "1" gewählt
select K.NAME, KM.MENGE, KM.EINHEIT, K.KATEGORIE, G.ZUBEREITUNGSDAUER, to_char(B.AUFGEGEBEN, 'HH:MI') "Aufgegeben", B.FK_PERSON_TISCH "Tisch", B.FK_PERSON_PLATZ "Platz"
from KOMPONENTENMENGE KM
         join KOMPONENTE K on KM.FK_KOMPONENTE_NAME = K.NAME
         join GERICHT G on KM.FK_GERICHT_NAME = G.NAME
         join BESTELLUNG B on B.FK_GERICHT_NAME = G.NAME
where
        B.FERTIG = 0 and
        -- Filter auf Kategorie
        --K.KATEGORIE = 'ENTREMETIER' and
        -- Filter auf Tisch und Person
        B.FK_PERSON_TISCH = 1
order by K.KATEGORIE, B.AUFGEGEBEN, G.ZUBEREITUNGSDAUER;

-- 3
-- Welches Gericht aus der Kategorie „x“ hat sich in Bezug auf die aktivierten Tage am meisten verkauft?
-- Es wurde für die Abfrage die Kategorie "GETRAENK" gewählt
select distinct B.FK_GERICHT_NAME "Gericht", Round((
                                                       select count(*)
                                                       from BESTELLUNG
                                                       where FK_GERICHT_NAME = G.NAME
                                                   ) / G.AKTIVIERTETAGE, 3) as "Kaeufe Pro Tag"
from BESTELLUNG B 
    join GERICHT G on B.FK_GERICHT_NAME = G.NAME
where KATEGORIE = 'GETRAENK'
order by "Kaeufe Pro Tag" desc;

-- 4
-- In welcher Kalenderwoche wurde der höchste Gewinn erzielt?
-- Um den richtigen "Gewinn" zu erhalten müsste dieser Wert noch mit den tatsächlichen Kosten der Woche verrechnet werden
-- Diese sind uns jedoch nicht bekannt (nicht modeliert).
-- Hier dargestellt ist also die Kalenderwoche in welcher der höchste Umsatz erzielt wurde

-- Nur Maximum
with SummierteAbrechnungen as (
    select A.BEZAHLBETRAG,
           TO_CHAR(A.DATUM, 'WW') as KW,
           sum(AEG.PREIS) Einkaufspreis,
           (A.BEZAHLBETRAG - sum(AEG.PREIS)) Gewinn
    from ABRECHNUNG A
             join BESTELLUNG B on A.RECHNUNGSNR = B.FK_ABRECHNUNG_RECHNUNGSNR
             join GERICHT G on G.NAME = B.FK_GERICHT_NAME
             join KALKULATION K on K.FK_GERICHT_NAME = G.NAME
             join AKTUELLEREINKAUFSPREISG AEG on AEG.NAME = G.NAME
    -- wähle Kalkulation aus, welche zum Zeitpunkt der Abrechnung gültig war
    where K.DATUM <= A.DATUM and A.DATUM - K.DATUM < ANY (
        select A.DATUM - K2.DATUM
        from KALKULATION K2
        where K2.DATUM != K.DATUM and K2.FK_GERICHT_NAME != K.FK_GERICHT_NAME -- Nicht mit sich selbst vergleichen
    )
    -- Gruppierung für Berechnung des Gewinns
    group by A.BEZAHLBETRAG, A.DATUM
)
select sum(SummierteAbrechnungen.GEWINN) Gewinnsumme, SummierteAbrechnungen.KW
from SummierteAbrechnungen
group by SummierteAbrechnungen.KW
having sum(SummierteAbrechnungen.Gewinn) = (
    select max(sum(SummierteAbrechnungen.Gewinn))
    from SummierteAbrechnungen
    group by SummierteAbrechnungen.KW
);

-- Als Rangliste
select sum(Abrechnungen.GEWINN), Abrechnungen.KW
from (
    select A.BEZAHLBETRAG,
           TO_CHAR(A.DATUM, 'WW') as KW,
           sum(AEG.PREIS) Einkaufspreis,
           (A.BEZAHLBETRAG - sum(AEG.PREIS)) Gewinn
    from ABRECHNUNG A
             join BESTELLUNG B on A.RECHNUNGSNR = B.FK_ABRECHNUNG_RECHNUNGSNR
             join GERICHT G on G.NAME = B.FK_GERICHT_NAME
             join KALKULATION K on K.FK_GERICHT_NAME = G.NAME
             join AKTUELLEREINKAUFSPREISG AEG on AEG.NAME = G.NAME
    where K.DATUM <= A.DATUM and A.DATUM - K.DATUM < ANY (
        select A.DATUM - K2.DATUM
        from KALKULATION K2
        where K2.DATUM != K.DATUM and K2.FK_GERICHT_NAME != K.FK_GERICHT_NAME -- Nicht mit sich selbst vergleichen
    )
    group by A.BEZAHLBETRAG, A.DATUM
) Abrechnungen
group by Abrechnungen.KW
order by sum(Abrechnungen.Gewinn) desc;

-- 5
-- Sortiere Gerichte nach bestem Verhältnis von Marge zu Bestellungen in einem bestimmten Zeitraum.
-- Es wurde ein Zeitraum von 360 Tagen gewählt 
select distinct G.NAME "Gerichtsname", Round((
    select count(*)
    from BESTELLUNG B2
    where B2.FK_GERICHT_NAME = G.NAME
) * AK.GEWINNMARGE, 2) "Bestellungen zu Gewinnmarge",(
    select count(*)
    from BESTELLUNG B2
    where B2.FK_GERICHT_NAME = G.NAME
) "Bestellungen", Round(AK.GEWINNMARGE, 2) "Gewinnmarge"
from GERICHT G
         join BESTELLUNG B on G.NAME = B.FK_GERICHT_NAME
         join AKTUELLSTEKALKULATIONEN AK on AK.FK_GERICHT_NAME = G.NAME
where B.AUFGEGEBEN >= (CURRENT_DATE - NUMTODSINTERVAL(360, 'DAY')) -- Im letzten Jahr
order by "Bestellungen zu Gewinnmarge" desc;

-- 6
-- Welches Lebensmittel wurde im letzten Monat am meisten gebraucht?
-- (Gebraucht: Menge verwendetes Lebensmittel pro Einheit)
select L.NAME, NVL(ROUND((
           select sum((
                      select MENGELEBENSMITTEL
                      from LebensMittelMengeInKM LKM
                      where B.FK_GERICHT_NAME = LKM.GERICHTNAME AND
                              L.NAME = LKM.LMNAME
                  ) * count(*))
           from BESTELLUNG B
           where B.AUFGEGEBEN >= (CURRENT_DATE - NUMTODSINTERVAL(30, 'DAY'))
           group by FK_GERICHT_NAME
           having (
                      select MENGELEBENSMITTEL
                      from LebensMittelMengeInKM LKM
                      where B.FK_GERICHT_NAME = LKM.GERICHTNAME AND
                              L.NAME = LKM.LMNAME
                  ) * count(*) is not null
       ), 2), 0) Benutzt,
       NVL((
           select distinct EINHEIT
           from LEBENSMITTELMENGE LM
           where L.NAME = LM.FK_LEBENSMITTEL_NAME
       ), '-') Einheit        
from LEBENSMITTEL L
order by Einheit desc, Benutzt desc;

-- 7
-- Was ist die durchschnittliche Aufenthaltsdauer eines Gastes im Restaurant und wieviel Geld gibt er dabei aus?
-- (Aufenthaltsdauer: Abrechnungsdatum – Datum der ersten Bestellung einer Person)
with Verweilzeit As (
    select min(B.BESTELLNR) minBestellNr, 
            B.FK_ABRECHNUNG_RECHNUNGSNR, 
            (cast(A.DATUM as Date) - cast(B1.AUFGEGEBEN as Date)) as Zeit,
            A.RECHNUNGSNR RechnNr
    from BESTELLUNG B
        join BESTELLUNG B1 on B1.BESTELLNR = B.BESTELLNR
        join ABRECHNUNG A on B.FK_ABRECHNUNG_RECHNUNGSNR = A.RECHNUNGSNR
    group by B.FK_ABRECHNUNG_RECHNUNGSNR, (cast(A.DATUM as Date) - cast(B1.AUFGEGEBEN as Date)), A.RECHNUNGSNR
    having B.FK_ABRECHNUNG_RECHNUNGSNR > 0
)
select ROUND(avg(V.ZEIT)*24*60,1) "durch Verweilzeit in Minuten", Round(avg(A.BEZAHLBETRAG),2) "Ausgabe"
from VERWEILZEIT V
    join ABRECHNUNG A on V.RECHNNR = A.RECHNUNGSNR


-- 8
-- Wie viel Trinkgeld wird im Schnitt gegeben? (Für alle Bestellungen: Trinkgeld = Bezahlbetrag - Summe Preis Bestellungen)
-- siehe Logik in "insert_example_values.sql" --> "shuffleAbrechnungDates" in welcher den Abrechnungen Bezahlbeträge in Höhe 
-- der Summe der Bestellungen + einen Zufallswert zugeordnet werden.
Select ROUND(avg(BEZAHLBETRAG - ABRECHUNGSSUMME),2) "Durchschnittliches Trinkgeld"
from ABRECHNUNG;

-- 9
-- Welche Gerichte aus Kategorie „x“ wird in welcher Saison am meisten bestellt?
-- alle Bestellungen werden verwendet, da Beispieldaten nicht ausreichend
select distinct G.NAME, 
    GS.FK_SPEISEKARTE_NAME as "Speisekarte", 
    G.KATEGORIE as "Katergorie",
    (select count(*) 
    from BESTELLUNG best
    where best.FK_GERICHT_NAME = G.NAME
    group by G.NAME) as "Summe Bestellungen" 
from GERICHTSPEISEKARTE GS
    join GERICHT G on G.NAME = GS.FK_GERICHT_NAME 
    join BESTELLUNG B on B.FK_GERICHT_NAME = G.NAME
order by GS.FK_SPEISEKARTE_NAME, "Summe Bestellungen" desc;

-- 10
-- Zeige alternative Komponenten zu einem Gericht „x“, welches Allergen „y“ nicht enthält
-- Beispiel Zwiebelrostbraten und Allergen Ei - nur hier wurden die Allergene gesetzt
with KomponeteMitAllergen as (
    select G.NAME Gericht, K.NAME KmitAllergen, AIK.LEBENSMITTEL LM, AIK.KATEGORIE 
    from KOMPONENTE K 
        join KOMPONENTENMENGE KM on KM.FK_KOMPONENTE_NAME = K.NAME
        join GERICHT G on G.NAME = KM.FK_GERICHT_NAME
        join ALLERGENEINKOMPONENTE AIK on AIK.KOMPONENTE = KM.FK_KOMPONENTE_NAME
    where G.NAME = 'Zwiebelrostbraten mit Spätzle')
select KMA.GERICHT "gewaehltes Gericht", 
    KMA.KMITALLERGEN "Komponente mit Allergen", 
    KMA.LM "betroffenes Lebensmittel",
    K.NAME as "Alternative ohne Allergen"
from KomponeteMitAllergen KMA
    join KOMPONENTE K on K.KATEGORIE = KMA.KATEGORIE
where KMA.KMITALLERGEN != K.NAME;
