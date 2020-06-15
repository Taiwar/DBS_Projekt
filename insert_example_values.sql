/**
  >===========================================================================================================<
  >================================================Felix======================================================<
*/

-- Lebensmittel

insert into LEBENSMITTEL values ('Salat', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- Einkaufspreise

-- Gerichte
insert into GERICHT values ('Test', 1, 1, 10, CURRENT_TIMESTAMP, 'HAUPTGERICHT', 'Testgericht', 10.0);

/**
  >===========================================================================================================<
  >================================================Jonas======================================================<
*/

-- Tische
insert into TISCH values (1, 4, 'Fenster rechts', 'BESTELLT', 'GETRAENKE', CURRENT_TIMESTAMP);
insert into TISCH values (2, 4, 'Fenster links', 'BESTELLT', 'VORSPEISE', CURRENT_TIMESTAMP);
insert into TISCH values (3, 6, 'Familientisch 1', 'ERHALTEN', 'GETRAENKE', CURRENT_TIMESTAMP);
insert into TISCH values (4, 6, 'Familientisch 2', 'ERHALTEN', 'VORSPEISE', CURRENT_TIMESTAMP);
insert into TISCH values (5, 2, 'Paartisch 1', 'FERTIG', 'HAUPTGANG', CURRENT_TIMESTAMP);
insert into TISCH values (6, 2, 'Paartisch 2', 'FERTIG', 'NACHTISCH', CURRENT_TIMESTAMP);

-- Personen
insert into PERSON values (1, 'NEIN', 1);
insert into PERSON values (2, 'NEIN', 1);
insert into PERSON values (3, 'NEIN', 1);
insert into PERSON values (4, 'NEIN', 1);
insert into PERSON values (1, 'NEIN', 2);
insert into PERSON values (2, 'NEIN', 2);
insert into PERSON values (1, 'NEIN', 3);
insert into PERSON values (2, 'NEIN', 3);
insert into PERSON values (3, 'NEIN', 3);
insert into PERSON values (1, 'NEIN', 6);

-- Abrechnungen
insert into ABRECHNUNG values (1, 10.50, 11.00, CURRENT_DATE, 1, 1);
insert into ABRECHNUNG values (2, 52.00, 55.00, CURRENT_DATE, 1, 2);
insert into ABRECHNUNG values (3, 51.90, 60.00, CURRENT_DATE, 2, 2);
insert into ABRECHNUNG values (4, 20.00, 20.00, CURRENT_DATE, 3, 3);
insert into ABRECHNUNG values (5, 15.50, 16.00, CURRENT_DATE, 1, 6);

-- Bestellungen
insert into BESTELLUNG values (0.0, 0, 0, CURRENT_TIMESTAMP, 1, 'Test', 1, 1);