-- 1
-- Speisekarte generieren: Wähle 5 saisonale Gerichte für jede Kategorie aus und sortiere die Gerichte zu jeder
-- Kategorie nach Marge und Verkaufspreis.

WITH karte AS (
    SELECT g.name,
           g.KATEGORIE,
           ak.GEWINNMARGE,
           ak.VERKAUFSPREIS,
           ROW_NUMBER() OVER (PARTITION BY g.KATEGORIE ORDER BY g.KATEGORIE) AS rn
    FROM GERICHT g join AktuellsteKalkulationen ak on g.name = ak.FK_GERICHT_NAME)
SELECT k.NAME, k.KATEGORIE, ROUND(k.GEWINNMARGE, 2), k.VERKAUFSPREIS
FROM karte k
where rn <= 5
order by k.GEWINNMARGE desc, k.VERKAUFSPREIS desc;

-- 2
-- Kochreihenfolge generieren/Anzeige in der Küche bereitstellen: Sortiere Komponenten von nicht fertigen
-- Bestellungen nach Aufgabe-Datum und Zubereitungsdauer. Filtere das Ergebnis nach Kategorie und Tisch und Person.
select K.NAME, KM.MENGE, KM.EINHEIT, K.KATEGORIE, G.ZUBEREITUNGSDAUER, to_char(B.AUFGEGEBEN, 'HH:mm') "Aufgegeben", B.FK_PERSON_TISCH "Tisch", B.FK_PERSON_PLATZ "Platz"
from KOMPONENTENMENGE KM
         join KOMPONENTE K on KM.FK_KOMPONENTE_NAME = K.NAME
         join GERICHT G on KM.FK_GERICHT_NAME = G.NAME
         join BESTELLUNG B on B.FK_GERICHT_NAME = G.NAME
where
        B.FERTIG = 0 and
        K.KATEGORIE = 'GARDEMANGER'
  -- Filter auf Tisch und Person
  -- and B.FK_PERSON_TISCH = 0 and
  -- B.FK_PERSON_PLATZ = 0
order by B.AUFGEGEBEN, G.ZUBEREITUNGSDAUER;

-- 3
-- Welches Gericht aus der Kategorie „x“ hat sich in Bezug auf die aktivierten Tage am besten verkauft?
select distinct B.FK_GERICHT_NAME "Gericht", Round((
                                                       select count(*)
                                                       from BESTELLUNG
                                                       where FK_GERICHT_NAME = G.NAME
                                                   ) / G.AKTIVIERTETAGE, 3) as KaeufeProTag
from BESTELLUNG B join GERICHT G on B.FK_GERICHT_NAME = G.NAME
where KATEGORIE = 'GETRAENK'
order by KaeufeProTag desc;

-- 4
-- In welcher Kalenderwoche wurde der höchste Gewinn erzielt?
select *
from KALKULATION;

select *
from ABRECHNUNG A
         join BESTELLUNG B on A.RECHNUNGSNR = B.FK_ABRECHNUNG_RECHNUNGSNR
         join GERICHT G on G.NAME = B.FK_GERICHT_NAME
         join KALKULATION K on K.FK_GERICHT_NAME = G.NAME
where K.DATUM <= A.DATUM and A.DATUM - K.DATUM < ANY (
    select A.DATUM - K2.DATUM
    from KALKULATION K2
    where K2.DATUM != K.DATUM and K2.FK_GERICHT_NAME != K.FK_GERICHT_NAME -- Nicht mit sich selbst vergleichen
);


select
    TO_CHAR(A.DATUM, 'WW') AS "Quartal",
    sum(A.ABRECHUNGSSUMME) "Gesamtbetrag",
    sum(A.ABRECHUNGSSUMME - sum(K.VERKAUFSPREIS)) "Davon Trinkgeld"
from ABRECHNUNG A
         join BESTELLUNG B on A.RECHNUNGSNR = B.FK_ABRECHNUNG_RECHNUNGSNR
         join GERICHT G on G.NAME = B.FK_GERICHT_NAME
         join KALKULATION K on K.FK_GERICHT_NAME = G.NAME
where K.DATUM >= A.DATUM and K.DATUM - A.DATUM < ANY (
    select K2.DATUM - A.DATUM
    from KALKULATION K2
    where K2.DATUM != K.DATUM and K2.FK_GERICHT_NAME != K.FK_GERICHT_NAME -- Nicht mit sich selbst vergleichen
)
group by TO_CHAR(A.DATUM, 'WW'); -- Kalkulation, die älter als Abrechnungsdatum und am nächsten dran ist


-- 5
-- Sortiere Gerichte nach bestem Verhältnis von Marge zu Bestellungen in einem bestimmten Zeitraum.
select G.NAME "Gerichtsname", K.GEWINNMARGE "Gewinnmarge", (
    select count(*)
    from BESTELLUNG
    where B.FK_GERICHT_NAME = G.NAME
) "Bestellungen"
from GERICHT G
         join BESTELLUNG B on G.NAME = B.FK_GERICHT_NAME
         join KALKULATION K on K.FK_GERICHT_NAME = G.NAME;

-- 6
-- Welches Lebensmittel wurde im letzten Monat am meisten gebraucht?

-- 7
-- Was ist die durchschnittliche Aufenthaltsdauer eines Gastes im Restaurant und wieviel Geld gibt er dabei aus?
-- (Aufenthaltsdauer: Abrechnungsdatum – Datum der ersten Bestellung einer Person)

-- 8
-- Wie viel Trinkgeld wird im Schnitt gegeben? (Für alle Bestellungen: Trinkgeld = Bezahlbetrag - Summe Preis Bestellungen)

-- 9
-- Welche Gerichte aus Kategorie „x“ wird in welcher Saison am meisten bestellt?

-- 10
-- Zeige alternative Komponenten zu einem Gericht „x“, welches Allergen „y“ nicht enthält