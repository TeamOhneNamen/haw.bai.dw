-- 1. Umsatz pro Filiale und Monat (group by)
-- fertig
select sum(Umsatz) as Umsatz, filiale, monat from absatz, Datum group by filiale, monat;

-- 2. Umsatz  pro Filiale und Monat (group by cube)
-- fertig
select sum(Umsatz) as Umsatz, filiale, monat from absatz, Datum group by cube(filiale, monat);

-- 3. Welche Filiale hat vom 1.9. – 3.9.2012 die höchste Anzahl von Handcremes verkauft?
-- feritg
SELECT absatz.filiale, COUNT(*) AS anzahl_verkaeufe
    FROM Absatz, Artikel
    WHERE (Absatz.Datum = '1.9.2012' 
        OR Absatz.Datum = '2.9.2012'  
        OR Absatz.Datum = '3.9.2012')
        AND Absatz.artikel = Artikel.ArtNr
        AND artikel.artname = 'Handcreme'
    GROUP BY Absatz.filiale
    ORDER BY anzahl_verkaeufe DESC
    fetch first 1 row only;
		
-- 4. Umsatz pro Artikelgruppe
-- fertig
select sum(umsatz), artikel.artgrp 
	from absatz, artikel 
	where absatz.artikel = artikel.artnr
	group by artgrp;
	
-- 5. Prozentualer Absatz der Artikelgruppe Körperpflege in den einzelnen Filialen
-- fertig
select Sub.filiale, round((sub.anzahl / gesamt.anzahl)*100) as Prozent
from (
select count(*) as Anzahl, filiale
	from absatz, artikel 
	where absatz.artikel = artikel.artnr and artikel.grpname = 'Körperpflege'
	group by filiale) Sub,(
select sum(count(*)) as Anzahl
	from absatz, artikel 
	where absatz.artikel = artikel.artnr and artikel.grpname = 'Körperpflege'
	group by filiale) Gesamt;
    
    
-- 6. Umsatz pro Kunden.
-- fertig
select sum(umsatz)as umsatz, absatz.kundennummer
	from absatz, kunden, artikel
	where absatz.artikel = artikel.artnr and kunden.kundennummer = absatz.kundennummer
	group by kunden.kundennummer;
    
-- 7. Buchungen pro Verkäufer und Tag.
-- fertig
select count(*) as Buchungen, Verkaeufer, absatz.datum as Datum 
    from absatz, Datum 
    group by Verkaeufer, Absatz.datum;