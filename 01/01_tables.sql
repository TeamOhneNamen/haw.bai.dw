drop table artikel CASCADE CONSTRAINTS;
drop table Datum CASCADE CONSTRAINTS;
drop table TempAbsatz CASCADE CONSTRAINTS;
drop table Absatz CASCADE CONSTRAINTS;
drop table kunden CASCADE CONSTRAINTS;
drop table verkaeufer CASCADE CONSTRAINTS;

create table artikel as select * from GERKEN.artikel;
alter table artikel add primary key (artnr);


create table kunden(
    Kundennummer number(5),
    Vorname VARCHAR(20),
    Name VARCHAR(20),
    Strasse VARCHAR(20),
    PLZ CHAR(5), 
    Wohnort VARCHAR(20),
    primary key (Kundennummer)
);

create table Datum(
    Datum date not null,
    Jahr number(4),
    Monat number(2),
    Tag number(2),
    primary key (Datum)
);

create table Verkaeufer(
    Name VARCHAR(20),
    Filiale VARCHAR(1) not null,
	Geburtstag date not null,
    Wohnort VARCHAR(20),
    primary key (Name)
);

create table TempAbsatz(
    Filiale VARCHAR(1) not null,
    Datum date not null,
    Uhrzeit VARCHAR(5) not null,
    Artikel number(5) not null,
    Anzahl number(5) not null, 
    Preis number(10) not null,
    Verkaeufer VARCHAR(20) not null,
    Kunde number(5)
);

create table Absatz(
    Filiale VARCHAR(1) not null,
    Datum date not null,
    Uhrzeit VARCHAR(5) not null,
    Artikel number(5) not null,
    Anzahl number(5) not null, 
    Preis number(7,2) not null,
    Umsatz number (35,2) not null,
    Verkaeufer VARCHAR(20) not null,
    Kundennummer number(5),
    foreign key (Datum) references Datum,
    foreign key (Kundennummer) references Kunden,
    foreign key (Artikel) references Artikel,
    foreign key (Verkaeufer) references Verkaeufer
);

create or replace TRIGGER trigger_absatz_datum
AFTER INSERT OR UPDATE ON tempabsatz
REFERENCING NEW AS NEW OLD AS OLD

FOR EACH ROW
declare 

Temp number(20);
NewPreis number (7, 2);
Umsatz     number(25,2);
jahr    number(4);
monat   number(2);
monatstag     number(2);
begin
    NewPreis := :new.preis/100;
    Umsatz := NewPreis* :new.anzahl;
    SELECT COUNT(*) INTO Temp FROM Datum WHERE Datum.datum = :new.datum;
    IF (Temp=0)
    THEN
        jahr := extract(year from :new.datum);
        monat := extract(month from :new.datum);
        monatstag := extract(day from :new.datum);
        Insert into datum values(:new.datum, jahr, monat, monatstag);
    END IF;

    SELECT COUNT(*) INTO Temp FROM kunden WHERE kundennummer = :new.Kunde;
    IF (Temp=0 AND :new.Kunde IS NOT null)
    THEN
        Insert into kunden values(:new.Kunde, 'Kunde ' || :new.Kunde, null, null, null, null);
    end if;

    SELECT COUNT(*) INTO Temp FROM artikel WHERE artnr = :new.Artikel;
    IF (Temp=0 AND :new.Artikel IS NOT null)
    THEN
        Insert into Artikel values(:new.Artikel, 'Artikel ' || :new.Artikel, null, 'Anderes');
    end if;

    Insert into absatz values(:new.Filiale, :new.Datum, :new.Uhrzeit, :new.Artikel, :new.Anzahl, NewPreis, umsatz, :new.verkaeufer, :new.kunde);

    end;
/
