-- Realisieren Sie dir Fremdschlüsselbeziehungen zwischen der Faktentabelle 
-- und den Dimensionstabellen durch Bitmap-Indizes. 
DROP INDEX fakten_bitmap_index;
CREATE BITMAP INDEX fakten_bitmap_index 
    ON absatz(kundennummer);
CREATE BITMAP INDEX absatz_artikel_bitmap_index 
    ON absatz(artikel);
    
SELECT /*+ index(a absatz_artikel_bitmap_index) index(k fakten_bitmap_index)*/  * FROM Absatz a, Kunden k, Artikel art
    WHERE k.Kundennummer = a.Kundennummer AND K.name = 'Kraft' 
    AND art.artname = 'Handcreme'
    AND a.artikel = art.artnr;


-- Rangfolge der Umsätze der einzelnen Kunden in den einzelnen Monaten,  
-- incl. Umsatz und Prozentsatz am gesamten Monatsumsatz
Select Einzel.GesamtUmsatz AS "Umsatz pro Kunde", 
round((Einzel.GesamtUmsatz/Gesamt.Monatsumsatz)*100) AS "%", 
Einzel.Monat, 
Einzel.KDNR AS "Kundennummer"
    FROM
    (Select SUM(Sub.Umsatz) AS GesamtUmsatz, Sub.monat, Sub.KDNR FROM
        (Select Umsatz, absatz.kundennummer as KDNR , datum.monat as monat  from ABSATZ, Datum 
            Where Absatz.datum = Datum.datum) Sub
    
    GROUP BY Sub.KDNR, Sub.monat) Einzel,
    
    (select sum(Umsatz) as Monatsumsatz, Datum.Monat AS Monat
            from ABSATZ, Datum 
            Where Absatz.datum = Datum.datum
            group by Datum.Monat) Gesamt
            
    WHERE Einzel.monat = Gesamt.monat
    ORDER BY monat DESC, "Umsatz pro Kunde" DESC;
    
-- Umsatzsummen pro Monat, Artikelgruppe sowie Artikelgruppe und Monat.
SELECT SUM(Umsatz),artikel.grpname, datum.monat FROM Absatz, Datum, Artikel
    WHERE absatz.artikel = artikel.artnr
    AND datum.datum = Absatz.datum
    GROUP BY GROUPING SETS((GRPNAME),(Monat),(artikel.grpname, datum.monat));

DROP VIEW verkaufsdaten_view  ;
CREATE VIEW verkaufsdaten_view AS 
SELECT SUM(absatz.anzahl) as Anzahl, kunden.name, Artikel.ARTNAME, SUM(Absatz.Preis) AS Gesamtpreis from Absatz, Kunden, Artikel
    Where absatz.kundennummer = kunden.kundennummer AND ABSATZ.ARTIKEL = artikel.ARTNR 
    GROUP BY kunden.name, artikel.ARTNAME
    ;
SELECT * FROM  verkaufsdaten_view;

DROP MATERIALIZED VIEW verkaufsdaten_mat_view  ;
CREATE MATERIALIZED VIEW verkaufsdaten_mat_view
AS 
SELECT SUM(absatz.anzahl) as Anzahl, kunden.name, Artikel.ARTNAME, SUM(Absatz.Preis) AS Gesamtpreis from Absatz, Kunden, Artikel
    Where absatz.kundennummer = kunden.kundennummer AND ABSATZ.ARTIKEL = artikel.ARTNR 
    GROUP BY kunden.name, artikel.ARTNAME
    ;
SELECT * FROM  verkaufsdaten_mat_view;
