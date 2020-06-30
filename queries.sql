-- 1
-- Speisekarte generieren: Wähle 5 saisonale Gerichte für jede Kategorie aus und sortiere die Gerichte zu jeder
-- Kategorie nach Marge und Verkaufspreis.
select G.NAME, K.VERKAUFSPREIS
from GERICHT G join KALKULATION K on G.NAME = K.FK_GERICHT_NAME
order by K.GEWINNMARGE desc, K.VERKAUFSPREIS desc
FETCH FIRST 5 ROWS Only;

-- 2
-- Kochreihenfolge generieren/Anzeige in der Küche bereitstellen: Sortiere Komponenten von nicht fertigen
-- Bestellungen nach Aufgabe-Datum und Zubereitungsdauer. Filtere das Ergebnis nach Kategorie und Tisch und Person.

-- 3
-- Welches Gericht aus der Kategorie „x“ hat sich in Bezug auf die aktivierten Tage am besten verkauft?

-- 4
-- In welcher Kalenderwoche wurde der höchste Gewinn erzielt? Wieviel davon war Trinkgeld?
-- (Trinkgeld = Bezahlbetrag - Summe Preis Bestellungen)

-- 5
-- Sortiere Gerichte nach bestem Verhältnis von Marge zu Bestellungen in einem bestimmten Zeitraum.

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