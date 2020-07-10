
-- Ent-Kommentieren beim Wiederneuaufsetzen
/*
drop table Lebensmittel cascade constraints purge;
drop table Einkaufspreis cascade constraints purge;
drop table LebensmittelMenge cascade constraints purge;
drop table Komponente cascade constraints purge;
drop table KomponentenMenge cascade constraints purge;
drop table Gericht cascade constraints purge;
drop table Kalkulation cascade constraints purge;
drop table Saison cascade constraints purge;
drop table Speisekarte cascade constraints purge;
drop table GerichtSpeisekarte cascade constraints purge;
drop table Tisch cascade constraints purge;
drop table Person cascade constraints purge;
drop table Bestellung cascade constraints purge;
drop table Abrechnung cascade constraints purge;
*/

create table Lebensmittel(
                             name varchar2(100) primary key not null,
                             milch number(1) default 0 not null,
                             gluteinhaltiges_getreide number(1) default 0 not null,
                             haselnuss number(1) default 0 not null,
                             krebstiere number(1) default 0 not null,
                             eier number(1) default 0 not null,
                             fisch number(1) default 0 not null,
                             erdnuss number(1) default 0 not null,
                             soja number(1) default 0 not null,
                             schalenfruechte number(1) default 0 not null,
                             sellerie number(1) default 0 not null,
                             senf number(1) default 0 not null,
                             sesamsamen number(1) default 0 not null,
                             schwefeldioxid number(1) default 0 not null,
                             lupine number(1) default 0 not null,
                             weichtiere number(1) default 0 not null
);


create table Einkaufspreis(
                              preis number not null,
                              einheit varchar2(5) check (einheit in ('STK', 'GRAMM', 'ML')) not null,
                              grundmenge number not null,
                              datum timestamp not null,
                              fk_lebensmittel_name varchar2(100) references Lebensmittel(name) not null,
                              primary key (datum, fk_lebensmittel_name)
);

create table Komponente(
                           name varchar2(100) primary key not null,
                           grundmenge int not null,
                           einheit varchar2(5) check (einheit in ('STK', 'GRAMM', 'ML')),
                           langtext clob,
                           kategorie varchar2(100) check (
                                   kategorie in (
                                                 'CHEF DE CUISINE',
                                                 'SOUS CHEF',
                                                 'SAUCIER',
                                                 'PATISSIER',
                                                 'ROTISSEUR',
                                                 'GARDEMANGER',
                                                 'POTAGER',
                                                 'POISSONNIER',
                                                 'ENTREMETIER',
                                                 'SERVICE'
                                   )
                               )
);

create table LebensmittelMenge(
                                  fk_lebensmittel_name varchar2(100) references Lebensmittel(name) not null,
                                  fk_komponente_name varchar2(100) references Komponente(name) not null,
                                  menge int not null,
                                  einheit varchar2(5) check (einheit in ('STK', 'GRAMM', 'ML')),
                                  primary key (fk_lebensmittel_name, fk_komponente_name)
);

create table Gericht(
                        name varchar2(100) primary key not null,
                        aktiviert number(1) default 0 not null,
                        standard number(1) default 0 not null,
                        aktivierteTage int not null,
                        aktivierungsDatum date not null,
                        kategorie varchar2(100) check (
                                kategorie in (
                                              'VORSPEISE',
                                              'HAUPTGERICHT',
                                              'NACHTISCH',
                                              'GETRAENK'
                                )
                            ),
                        langtext clob,
                        zubereitungsdauer int not null
);


create table KomponentenMenge(
                                 fk_komponente_name varchar2(100) references Komponente(name) not null,
                                 fk_gericht_name varchar2(100) references Gericht(name) not null,
                                 menge int not null,
                                 einheit varchar2(5) check (einheit in ('STK', 'GRAMM', 'ML')),
                                 primary key (fk_komponente_name, fk_gericht_name)
);

create table Kalkulation(
                            einkaufspreisSumme number not null,
                            verkaufspreis number not null,
                            gewinnmarge number not null,
                            kostenmarge number not null,
                            datum timestamp not null,
                            fk_gericht_name varchar2(100) references Gericht(name) not null,
                            primary key (datum, fk_gericht_name)
);

create table Saison(
                       name varchar2(100) primary key not null,
                       startKW int not null,
                       stopKW int not null
);

create table Speisekarte(
                            name varchar2(100) primary key not null,
                            fk_saison_name varchar2(100) references Saison(name) not null,
                            startDatum date not null,
                            endDatum date not null,
                            langtext clob
);

create table GerichtSpeisekarte(
                                   fk_gericht_name varchar2(100) references Gericht(name) not null,
                                   fk_speisekarte_name varchar2(100) references Speisekarte(name) not null,
                                   primary key (fk_gericht_name, fk_speisekarte_name)
);


create table Tisch(
                      nummer int primary key not null,
                      anzahlPlaetze int not null,
                      name varchar2(100),
                      statusEssen varchar2(10) check (
                              statusEssen in (
                                              'BESTELLT',
                                              'ERHALTEN',
                                              'FERTIG'
                              )
                          ),
                      phaseEssen varchar2(20) check (
                              phaseEssen in (
                                             'GETRAENKE',
                                             'VORSPEISE',
                                             'HAUPTGANG',
                                             'NACHTISCH',
                                             'APERETIV',
                                             'ABRECHNUNG'
                              )
                          ),
                      zuletztBetreut timestamp not null
);

create table Person(
                       platz int not null,
                       vip varchar2(20) check (
                               vip in (
                                       'NEIN',
                                       'GEBURTSTAGSKIND',
                                       'FRAU'
                               )
                           ),
                       fk_tisch_nummer int references Tisch(nummer) not null,
                       primary key (platz, fk_tisch_nummer)
);

create table Abrechnung(
                           rechnungsnr int primary key not null,
                           bezahlbetrag number not null,
                           abrechungssumme number not null,
                           datum timestamp not null,
                           fk_person_platz int not null,
                           fk_person_tisch int not null,
                           foreign key (fk_person_platz, fk_person_tisch) references Person(platz, fk_tisch_nummer)
);

create table Bestellung(
                           bestellnr int primary key not null,
                           aufpreis number default 0,
                           reklamiert number(1) default 0 not null,
                           fertig number(1) default 0 not null,
                           aufgegeben timestamp not null,
                           fk_abrechnung_rechnungsnr int references Abrechnung(rechnungsnr),
                           fk_gericht_name varchar2(100) references Gericht(name) not null,
                           fk_person_platz int not null,
                           fk_person_tisch int not null,
                           foreign key (fk_person_platz, fk_person_tisch) references Person(platz, fk_tisch_nummer)
);

alter session set nls_date_format = 'yyyy-mm-dd';
alter session set nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS';

-- Helfer-Views
CREATE OR REPLACE VIEW AktuellsteEinkaufspreise AS
SELECT *
FROM EINKAUFSPREIS E1
where datum > ALL (
    select datum
    from Einkaufspreis E2
    where E1.FK_LEBENSMITTEL_NAME = E2.FK_LEBENSMITTEL_NAME and E1.DATUM != E2.DATUM
);

CREATE OR REPLACE VIEW AktuellerEinkaufspreisLM AS
SELECT
    LM.FK_LEBENSMITTEL_NAME Name, LM.FK_KOMPONENTE_NAME KomponentenName,
    AE.PREIS * (LM.MENGE / AE.GRUNDMENGE) Preis, LM.MENGE Menge, LM.EINHEIT Einheit,
    AE.datum Datum
FROM LEBENSMITTELMENGE LM
         join LEBENSMITTEL L on L.NAME = LM.FK_LEBENSMITTEL_NAME
         join AktuellsteEinkaufspreise AE on AE.FK_LEBENSMITTEL_NAME = L.NAME
;

CREATE OR REPLACE VIEW AktuellerEinkaufspreisK AS
SELECT K.NAME Name, sum(ALM.PREIS) Preis, K.GRUNDMENGE Menge, ALM.Datum Datum
FROM KOMPONENTE K
         join AktuellerEinkaufspreisLM ALM on ALM.KomponentenName = K.NAME
group by K.Name, K.GRUNDMENGE, ALM.Datum;

CREATE OR REPLACE VIEW AktuellerEinkaufspreisKM AS
SELECT
    KM.FK_KOMPONENTE_NAME Name, KM.FK_GERICHT_NAME GerichtName,
    AEK.Preis * (KM.MENGE / AEK.Menge) Preis, KM.MENGE Menge, KM.EINHEIT Einheit, AEK.Datum Datum
FROM KOMPONENTENMENGE KM
         join KOMPONENTE K on K.NAME = KM.FK_KOMPONENTE_NAME
         join AktuellerEinkaufspreisK AEK on AEK.Name = K.NAME
;


CREATE OR REPLACE VIEW AktuellerEinkaufspreisG AS
SELECT G.NAME Name, ROUND(sum(AEM.PREIS), 2) Preis, AEM.Datum Datum
FROM GERICHT G
         join AktuellerEinkaufspreisKM AEM on AEM.GerichtName = G.NAME
group by G.Name, AEM.Datum;
