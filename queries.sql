-- Umsatz pro Filiale und Monat (group by)
select sum(Umsatz), filiale, monat from absatz group by(filiale,monat);

-- Welche Filiale hat vom 1.9. – 3.9.2012 die höchste Anzahl von Handcremes verkauft?
SELECT MAX (anzahl_verkaeufe), filiale
	FROM (
		SELECT COUNT(*) AS anzahl_verkaeufe 
		FROM Absatz
		WHERE Absatz.Datum = 1.9.2012 OR Absatz.Datum = 2.9.2012  OR Absatz.Datum = 3.9.2012 
		GROUP BY filiale);
		
-- Umsatz pro Artikelgruppe
select sum(umsatz), artikel.artikelgruppe 
	from absatz, artikel 
	where absatz.artikelnr = artikel.artikelnr
	group by artikelgruppe;
	
-- Umsatz pro Artikelgruppe
select round(sum(Anzahl)/Anzahl)*100 AS Prozent, filiale.filialname 
	from absatz, artikel, 
		select(count(*) from absatz, filiale as anzahl where )
	where absatz.artikelnr = artikel.artikelnr
	group by artikelgruppe;