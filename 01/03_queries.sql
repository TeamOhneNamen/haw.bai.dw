-- 1. Umsatz pro Filiale und Monat (group by)
-- fertig
select sum(Umsatz) as Umsatz, Filiale, Monat 
    from Absatz 
    inner join Datum on Absatz.datum = Datum.Datum  
    group by Filiale, Monat;

-- 2. Umsatz  pro Filiale und Monat (group by cube)
-- fertig
select sum(Umsatz) as Umsatz, Filiale, Monat 
    from Absatz 
    inner join Datum on Absatz.datum = Datum.Datum  
    group by cube(Filiale, Monat);

-- 3. Welche Filiale hat vom 1.9. – 3.9.2012 die höchste Anzahl von Handcremes verkauft?
-- feritg
select Absatz.Filiale, sum(Absatz.anzahl) as anzahl_verkauefe
    from Absatz 
    inner join Artikel on Absatz.Artikel = Artikel.ArtNr
    where Absatz.Datum >= '01.09.2012' and Absatz.Datum <= '03.09.2012'
    group by Absatz.Filiale
    order by anzahl_verkauefe desc
    fetch first row only;
		
-- 4. Umsatz pro Artikelgruppe
-- fertig
select sum(Umsatz), Artikel.Artgrp 
	from absatz
	inner join Artikel on absatz.artikel = artikel.artnr
	group by artgrp;
	
-- 5. Prozentualer Absatz der Artikelgruppe Körperpflege in den einzelnen Filialen
-- fertig
select Absatz.Filiale,(100/(sum(Absatz.anzahl)) * (select sum(Absatz.anzahl) 
    from Absatz inner join Artikel on Absatz.Artikel = Artikel.ArtNr 
    where Artikel.grpname = 'Körperpflege' and Absatz.filiale = 'A')) as "% Umsatz Körperpflege" 
    from Absatz group by Absatz.filiale;
    
-- 6. Umsatz pro Kunden.
-- fertig
select Absatz.Kundennummer, sum(Umsatz) from Absatz GROUP by Absatz.Kundennummer;
    
-- 7. Buchungen pro Verkäufer und Tag.
-- fertig
select count(*) as Buchungen, Verkaeufer, absatz.datum as Datum 
    from absatz, Datum 
    group by Verkaeufer, Absatz.datum;