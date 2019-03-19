-- Umsatz pro Filiale und Monat (group by)
-- fertig
select sum(Umsatz) as Umsatz, filiale, monat from absatz, Datum group by(filiale,monat);

-- Welche Filiale hat vom 1.9. – 3.9.2012 die höchste Anzahl von Handcremes verkauft?
-- feritg
		SELECT absatz.filiale, COUNT(*) AS anzahl_verkaeufe
		FROM Absatz
		WHERE Absatz.Datum = '1.9.2012' OR Absatz.Datum = '2.9.2012'  OR Absatz.Datum = '3.9.2012' 
		GROUP BY Absatz.filiale
        ORDER BY anzahl_verkaeufe DESC
        fetch first 1 row only;
		
-- Umsatz pro Artikelgruppe
-- fertig
select sum(umsatz), artikel.artgrp 
	from absatz, artikel 
	where absatz.artikel = artikel.artnr
	group by artgrp;
	
-- Umsatz pro Artikelgruppe
select round(sum(Anzahl)/Anzahl)*100 AS Prozent, filiale.filialname 
	from absatz, artikel, 
		select(count(*) from absatz, filiale as anzahl where )
	where absatz.artikelnr = artikel.artikelnr
	group by artikelgruppe;