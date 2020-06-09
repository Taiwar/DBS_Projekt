/*
-- Ent-Kommentieren beim Wiederneuaufsetzen
drop table Lebensmittel cascade constraints purge;
drop table Einkaufspreis cascade constraints purge;
drop table Allergen cascade constraints purge;
drop table AllergenLebensmittel cascade constraints purge;
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
    name varchar(100) primary key not null
);


create table Einkaufspreis(
                              preis number not null,
                              einheit varchar(5) check (einheit in ('STK', 'GRAMM', 'ML')) not null,
                              grundmenge number not null,
                              datum timestamp not null,
                              l_name varchar(100) references Lebensmittel(name) not null,
                              primary key (datum, l_name)
);

create table Allergen(
    name varchar(100) primary key check (
            name in (
                     'MILCH',
                     'GLUTENHALTIGES_GETREIDE',
                     'HASELNUSS',
                     'KREBSTIERE',
                     'EIER',
                     'FISCH',
                     'ERDNUSS',
                     'SOJA',
                     'SCHALENFRUECHTE',
                     'SELLERIE',
                     'SENF',
                     'SESAMSAMEN',
                     'SCHWEFELDIOXID',
                     'LUPINE',
                     'WEICHTIERE'
            )
        )
);

create table AllergenLebensmittel(
                                     l_name varchar(100) references Lebensmittel(name) not null,
                                     a_name varchar(100) references Allergen(name) not null,
                                     primary key (l_name, a_name)
);

create table LebensmittelMenge(
                                  id int primary key not null,
                                  l_name varchar(100) references Lebensmittel(name) not null,
                                  menge int not null,
                                  einheit varchar(5) check (einheit in ('STK', 'GRAMM', 'ML'))
);

create table Komponente(
                           name varchar(100) primary key not null,
                           grundmenge int not null,
                           einheit varchar(5) check (einheit in ('STK', 'GRAMM', 'ML')),
                           langtext varchar(2000),
                           kategorie varchar(100) check (
                                   kategorie in (
                                                 'CHEF DE CUISINE',
                                                 'SOUS CHEF',
                                                 'SAUCIER',
                                                 'PATISSIER',
                                                 'ROTISSEUR',
                                                 'GARDEMANAGER',
                                                 'POTAGER',
                                                 'POISSONNIER'
                                   )
                               )
);

create table KomponentenMenge(
                                 id int primary key not null,
                                 k_name varchar(100) references Komponente(name) not null,
                                 menge int not null,
                                 einheit varchar(5) check (einheit in ('STK', 'GRAMM', 'ML'))
);

create table Gericht(
                        name varchar(100) primary key not null,
                        aktiviert number(1) default 0 not null,
                        standard number(1) default 0 not null,
                        aktivierteTage int not null,
                        aktivierungsDatum date not null,
                        kategorie varchar(100) check (
                                kategorie in (
                                              'VORSPEISE',
                                              'HAUPTGERICHT',
                                              'NACHTISCH',
                                              'GETRAENK'
                                )
                            ),
                        langtext varchar(2000),
                        zubereitungsdauer int not null
);

create table Kalkulation(
                            einkaufspreisSumme number not null,
                            verkaufspreis number not null,
                            gewinnmarge number not null,
                            kostenmarge number not null,
                            datum timestamp not null,
                            g_name varchar(100) references Gericht(name) not null,
                            primary key (datum, g_name)
);

create table Saison(
                       name varchar(100) primary key not null,
                       startKW int not null,
                       stopKW int not null
);

create table Speisekarte(
                            name varchar(100) primary key not null,
                            saison varchar(100) references Saison(name) not null,
                            startDatum date not null,
                            endDatum date not null,
                            langtext varchar(2000)
);

create table GerichtSpeisekarte(
                                   g_name varchar(100) references Gericht(name) not null,
                                   s_name varchar(100) references Speisekarte(name) not null,
                                   primary key (g_name, s_name)
);


create table Tisch(
                      nummer int primary key not null,
                      name varchar(100),
                      statusEssen varchar(10) check (
                              statusEssen in (
                                              'BESTELLT',
                                              'ERHALTEN',
                                              'FERTIG'
                              )
                          ),
                      phaseEssen varchar(20) check (
                              phaseEssen in (
                                             'GETREANKE',
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
                       id int primary key not null,
                       platz int not null,
                       vip varchar(20) check (
                               vip in (
                                       'NEIN',
                                       'GEBURTSTAGSKIND',
                                       'FRAU'
                               )
                           ),
                       tisch int references Tisch(nummer) not null
);

create table Abrechnung(
                           rechnungsnr int primary key not null,
                           bezahlbetrag number not null,
                           abrechungssumme number not null,
                           datum timestamp not null,
                           kunde int references Person(id) not null
);

create table Bestellung(
                           bestellungsnr int primary key not null,
                           aufpreis number default 0,
                           reklamiert number(1) default 0 not null,
                           fertig number(1) default 0 not null,
                           aufgegeben timestamp not null,
                           abrechung int references Abrechnung(rechnungsnr) not null,
                           gericht varchar(100) references Gericht(name) not null,
                           kunde int references Person(id) not null
);