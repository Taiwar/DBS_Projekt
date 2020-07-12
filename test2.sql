-- Menge der Lebensmittel in einem Gericht

select * from LebensMittelMengeInKM;


-- 6
-- Welches Lebensmittel wurde im letzten Monat am meisten gebraucht?
select
    max(sum(
                select * From LebensMittelMengeInKM
                where GerichtName = BestellName
                *
                                    (select FK_GERICHT_NAME Gericht, count(*) from BESTELLUNG
                                                                                   --where DATUM > "DATUM HEUTE-30"
                                     group by FK_GERICHT_NAME))
        From

        Select L.Name,
        (
            select FK_GERICHT_NAME Gericht, (
                                                select MENGELEBENSMITTEL
                                                from LebensMittelMengeInKM LKM
                                                where B.FK_GERICHT_NAME = LKM.GERICHTNAME AND
                                                        L.NAME = LKM.LMNAME) * count(*) AnzahlBestellungen)
        from BESTELLUNG B
        --join LebensMittelMengeInKM on GERICHTNAME = GERICHTNAME
        --where DATUM > "DATUM HEUTE-30"
--where LMName = GERICHTNAME
        group by FK_GERICHT_NAME) Menge
from LEBENSMITTEL L

-- Gibt zu den Bestellungen die Gesamtsumme der verwendeten eier zurück
with meineexpression as (
    select (
               select MENGELEBENSMITTEL
               from LebensMittelMengeInKM LKM
               where B.FK_GERICHT_NAME = LKM.GERICHTNAME) * count(*) Menge
    from BESTELLUNG B
    group by FK_GERICHT_NAME
    having (select MENGELEBENSMITTEL
            from LebensMittelMengeInKM LKM
            where B.FK_GERICHT_NAME = LKM.GERICHTNAME) * count(*) > 0)

select L.NAME, ME.MENGE
from LEBENSMITTEL L
         join meineexpression ME on ME.LMNAME = L.NAME;



select (
           select MENGELEBENSMITTEL
           from LebensMittelMengeInKM LKM
           where B.FK_GERICHT_NAME = LKM.GERICHTNAME AND
                   'Eier' = LKM.LMNAME
       ) * count(*) Menge
from BESTELLUNG B
group by FK_GERICHT_NAME
having (
           select MENGELEBENSMITTEL
           from LebensMittelMengeInKM LKM
           where B.FK_GERICHT_NAME = LKM.GERICHTNAME AND
                   'Eier' = LKM.LMNAME
       ) * count(*) > 0;


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



select L.NAME,
       sum(
           ) alles
from LEBENSMITTEL L
where L.NAME = 'Eeier'

select *
from LebensMittelMengeInKM LKM
where LKM.GERICHTNAME = 'Zwiebelrostbraten mit Spätzle' and LMNAME = 'Eier'

Select * from LebensMittelMengeInKM


--

                  select FK_GERICHT_NAME Gericht, count(*) AnzahlBestellungen
from BESTELLUNG
    join LebensMittelMengeInKM on GERICHTNAME = GERICHTNAME
    --where DATUM > "DATUM HEUTE-30"
group by FK_GERICHT_NAME


-- 7
-- Was ist die durchschnittliche Aufenthaltsdauer eines Gastes im Restaurant und wieviel Geld gibt er dabei aus?
-- (Aufenthaltsdauer: Abrechnungsdatum – Datum der ersten Bestellung einer Person)
Select (A.DATUM-B.AUFGEGEBEN)
from BESTELLUNG B
         join ABRECHNUNG A on B.FK_ABRECHNUNG_RECHNUNGSNR = A.RECHNUNGSNR

-- 8
-- Wie viel Trinkgeld wird im Schnitt gegeben? (Für alle Bestellungen: Trinkgeld = Bezahlbetrag - Summe Preis Bestellungen)
Select ROUND(avg(BEZAHLBETRAG - ABRECHUNGSSUMME),2) "Durchschnittliches Trinkgeld"
from ABRECHNUNG

-- 9
-- Welche Gerichte aus Kategorie „x“ wird in welcher Saison am meisten bestellt?

-- 10
-- Zeige alternative Komponenten zu einem Gericht „x“, welches Allergen „y“ nicht enthält