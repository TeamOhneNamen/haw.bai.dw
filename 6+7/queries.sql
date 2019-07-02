-- Realisieren Sie dir Fremdschlüsselbeziehungen zwischen der Faktentabelle 
-- und den Dimensionstabellen durch Bitmap-Indizes. 
DROP INDEX fakten_bitmap_index;
CREATE BITMAP INDEX fakten_bitmap_index 
    ON absatz(kundennummer);
CREATE BITMAP INDEX absatz_artikel_bitmap_index 
    ON absatz(artikel);
    
SELECT /*+ index(a absatz_artikel_bitmap_index) index(k fakten_bitmap_index)*/  * FROM Absatz
    inner join Kunden on  Kunden.Kundennummer = Absatz.Kundennummer
    inner join Artikel on Artikel.ArtNr = ABsatz.Artikel
    where Kunden.name = 'Kraft' 
    AND Artikel.artname = 'Handcreme';


-- Rangfolge der Umsätze der einzelnen Kunden in den einzelnen Monaten,  
-- incl. Umsatz und Prozentsatz am gesamten Monatsumsatz

select Datum.Monat, nvl(Kunden.name,'Unbekannt') as Name, 
    sum(Absatz.Umsatz) as Monatsumsatz, 
    round(100/Gesamt.Umsatz * sum(Absatz.Umsatz),2) as Prozent,
    rank() over(order by sum(Absatz.Umsatz) desc) as Rang
    from Absatz
    left join Kunden on Absatz.Kundennummer = Kunden.kundennummer
    inner join datum on Absatz.datum = Datum.datum
    inner join (select Datum.Monat, sum(Absatz.Umsatz) as Umsatz 
        from Absatz 
            inner join Datum on Absatz.datum = Datum.datum 
    group by Datum.monat) Gesamt 
        on Gesamt.Monat = Datum.Monat
    group by  Datum.Monat, Name, Gesamt.Umsatz;
    
-- Umsatzsummen pro Monat, Artikelgruppe sowie Artikelgruppe und Monat.
SELECT SUM(Umsatz),artikel.grpname, datum.monat FROM Absatz
    inner join Artikel on absatz.artikel = artikel.artnr
    inner join Datum on datum.datum = Absatz.datum
    GROUP BY GROUPING SETS((GRPNAME),(Monat),(artikel.grpname, datum.monat));

DROP VIEW verkaufsdaten_view  ;
CREATE VIEW verkaufsdaten_view AS 
SELECT SUM(absatz.anzahl) as Anzahl, kunden.name, Artikel.ARTNAME, SUM(Absatz.Preis) AS Gesamtpreis from Absatz
    inner join Kunden on absatz.kundennummer = kunden.kundennummer 
    inner join Artikel on ABSATZ.ARTIKEL = artikel.ARTNR 
    GROUP BY kunden.name, artikel.ARTNAME
    ;
SELECT * FROM  verkaufsdaten_view;

DROP MATERIALIZED VIEW verkaufsdaten_mat_view  ;
CREATE MATERIALIZED VIEW verkaufsdaten_mat_view
AS 
SELECT SUM(absatz.anzahl) as Anzahl, kunden.name, Artikel.ARTNAME, SUM(Absatz.Preis) AS Gesamtpreis from Absatz
    inner join Kunden on absatz.kundennummer = kunden.kundennummer 
    inner join Artikel on ABSATZ.ARTIKEL = artikel.ARTNR 
    GROUP BY kunden.name, artikel.ARTNAME
    ;
SELECT * FROM  verkaufsdaten_mat_view;
