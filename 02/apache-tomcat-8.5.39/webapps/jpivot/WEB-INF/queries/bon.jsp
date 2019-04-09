<%@ page session="true" contentType="text/html; charset=ISO-8859-1" %> 
<%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<jp:mondrianQuery id="query01" jdbcDriver="oracle.jdbc.driver.OracleDriver"
 jdbcUrl="jdbc:oracle:thin:ACF040/Pa55wort@ora14.informatik.haw-hamburg.de:1521:inf14" catalogUri="/WEB-INF/queries/BonDaten.xml"> 

	select {[Measures].[ANZAHL], [Measures].[Preis]} on columns, 	
	{([Kunden].[Alle Kunden], [ARTIKEL].[Alle ARTIKEL], [Verkaeufer].[Alle Verkaeufer], [Datum].[Alle Daten])} on rows 
	from [BonDaten]     


</jp:mondrianQuery> 
<c:set var="title01" scope="session">Test it</c:set> 
