alter session set nls_date_format = 'yyyy-mm-dd';
alter session set nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS.FF';

/**
  >===========================================================================================================<
  >================================================Felix======================================================<
*/

-- Lebensmittel

insert into LEBENSMITTEL values ('Salat', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
insert into LEBENSMITTEL values ('Kartoffeln', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
insert into LEBENSMITTEL values ('Schweinesteak', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
insert into LEBENSMITTEL values ('Frittierfett', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
insert into LEBENSMITTEL values ('Gemüsebrühe', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
insert into LEBENSMITTEL values ('Rinderbouillon', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
insert into LEBENSMITTEL values ('Hühnerbrühe', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- Einkaufspreise

insert into EINKAUFSPREIS values (10.0, 'GRAMM', 500, '2020-02-01', 'Salat');
insert into EINKAUFSPREIS values (12.5, 'GRAMM', 2000, '2020-03-12', 'Kartoffeln');
insert into EINKAUFSPREIS values (30.0, 'GRAMM', 1000, '2020-02-03', 'Schweinesteak');
insert into EINKAUFSPREIS values (10.0, 'GRAMM', 1000, '2020-06-11', 'Frittierfett');
insert into EINKAUFSPREIS values (7.0, 'ML', 1000, '2020-04-13', 'Gemüsebrühe');
insert into EINKAUFSPREIS values (10.0, 'GRAMM', 1000, '2020-05-19', 'Rinderbouillon');
insert into EINKAUFSPREIS values (15.0, 'ML', 1000, '2020-02-13', 'Hühnerbrühe');

-- Komponente
insert into KOMPONENTE values ('Pommes', 1000, 'GRAMM', 'Pommes machen', 'POTAGER');
insert into KOMPONENTE values ('Schnitzel', 400, 'GRAMM', 'Schnitzel machen', 'ROTISSEUR');

-- LebensmittelMenge
insert into LEBENSMITTELMENGE values ('Kartoffeln', 'Pommes', 1000, 'GRAMM');
insert into LEBENSMITTELMENGE values ('Schweinesteak', 'Schnitzel', 400, 'GRAMM');
insert into LEBENSMITTELMENGE values ('Frittierfett', 'Pommes', 200, 'GRAMM');

-- Gericht
insert into GERICHT values ('Schnitzel mit Pommes', 1, 1, 30, '2020-03-01', 'HAUPTGERICHT', 'Pommes und Schnitzel zusammen auf Teller', 12.0);

-- KomponentenMenge
insert into KOMPONENTENMENGE values ('Pommes', 'Schnitzel mit Pommes', 300, 'GRAMM');
insert into KOMPONENTENMENGE values ('Schnitzel', 'Schnitzel mit Pommes', 400, 'GRAMM');

-- Kalkulation
insert into KALKULATION values (30.0, 90.0, 1.5, 2, '2019-02-1', 'Schnitzel mit Pommes');

-- Saison
insert into SAISON values ('Sommer', 16, 40);

-- Speisekarte

-- GerichtSpeisekarte


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
insert into BESTELLUNG values (0.0, 0, 0, CURRENT_TIMESTAMP, 1, 'Schnitzel mit Pommes', 1, 1);