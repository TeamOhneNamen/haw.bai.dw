ALTER TABLE ACF040.Kunden
ADD PRIMARY KEY (Kundennummer); 

ALTER TABLE ACF040.Datum
ADD PRIMARY KEY (Datum); 

ALTER TABLE ACF040.Verkaeufer
ADD PRIMARY KEY (Name); 

ALTER TABLE ACF040.Artikel
ADD PRIMARY KEY (ArtnR); 

ALTER TABLE ACF040.Absatz
    add foreign key (Datum) references ACF040.Datum;
ALTER TABLE ACF040.Absatz
    add foreign key (Kundennummer) references ACF040.Kunden;
ALTER TABLE ACF040.Absatz
    add foreign key (Artikel) references ACF040.Artikel;
ALTER TABLE ACF040.Absatz
    add foreign key (Verkaeufer) references ACF040.Verkaeufer;

commit;

select * from acf040.artikel;
select * from acf040.absatz;