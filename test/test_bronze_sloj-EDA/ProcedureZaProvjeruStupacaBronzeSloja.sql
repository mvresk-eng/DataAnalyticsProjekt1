/*
    Naslov: Procedure stupaca tablica bronze sloja
    Autor: Marko Vresk
    Datum: 27.09.2026.
    Opis: Ova skripta sadrži procedure za provjeru stupaca tablica bronze sloja u SQL Serveru. Provjere uključuju duplikate, null vrijednosti, razmake u nazivima, negativne vrijednosti, valjanost datuma, referencijalni integritet i druge specifične provjere za svaki stupac.
	Upozorenje: Prilikom pozivanja procedura važno je osigurati da su parametri ispravno postavljeni kako bi se izbjegle pogreške u izvršavanju i osiguralo točno dohvaćanje podataka.
	*/
	
--PROVJERA DUPLIKATA 
CREATE OR ALTER PROCEDURE bronze.provjera_duplikata @naziv_tablice VARCHAR(200), @naziv_stupca VARCHAR(100) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @SQL=N'
		SELECT ' + @naziv_stupca+ N', COUNT(*) as duplikat FROM ' + @naziv_tablice + N' GROUP BY ' + @naziv_stupca + N' HAVING COUNT(*)>1 ;'
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA NULL VRIJEDNOSTI
CREATE OR ALTER PROCEDURE bronze.provjera_null_vrijednosti @naziv_tablice VARCHAR(200), @ključ VARCHAR(100)=NULL, @naziv_stupca VARCHAR(100) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql=N' SELECT '; 
		IF @ključ IS NOT NULL
			SET @sql += @ključ+ ',' ;
		SET @sql +=@naziv_stupca + N' FROM ' + @naziv_tablice + ' WHERE ' + @naziv_stupca + N' IS NULL;'
		exec sys.sp_executesql @sql;
	END;
GO

-- PROVJERA RAZMAKA U NAZIVIMA
CREATE OR ALTER PROCEDURE bronze.provjera_razmaka_u_nazivima @naziv_tablice VARCHAR(200), @ključ VARCHAR(100)=NULL, @naziv_stupca VARCHAR(100) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql= N' SELECT ';
		IF @ključ IS NOT NULL
			SET @sql += @ključ + N',';
		SET @sql += @naziv_stupca + N' FROM ' + @naziv_tablice +  N' WHERE TRIM(CAST(' + @naziv_stupca + N' AS NVARCHAR(100)))!=' + @naziv_stupca + N';'
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA DISTINKTNIH IMENA
CREATE OR ALTER PROCEDURE bronze.provjera_distinktnih_naziva @naziv_tablice VARCHAR(200), @naziv_stupca VARCHAR(100) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql= N'
		SELECT DISTINCT ' + @naziv_stupca + N' FROM ' + @naziv_tablice + N' ORDER BY ' +@naziv_stupca+ N';'
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA VALJANOSTI DATUMA
CREATE OR ALTER PROCEDURE bronze.provjera_valjanosti_datuma @naziv_tablice VARCHAR(100), @ključ VARCHAR(200), @naziv_stupca VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql = N' SELECT ' + @ključ + N', ' + @naziv_stupca + N'
		FROM ' + @naziv_tablice + N'
		WHERE TRY_CONVERT(DATE, ' + @naziv_stupca + N') > CAST(GETDATE() AS DATE)
		OR DATEDIFF(YEAR, TRY_CONVERT(DATE, ' + @naziv_stupca + N'), GETDATE()) > 100;';
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA NEGATIVNOSTI NEKE VRIJEDNOSTI
CREATE OR ALTER PROCEDURE bronze.provjera_negativnosti_vrijednosti @naziv_tablice VARCHAR(100), @ključ VARCHAR(200), @naziv_stupca VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql=N'SELECT '+ @ključ+ ',' + @naziv_stupca+ N' FROM '+ @naziv_tablice + N' WHERE ' +@naziv_stupca+ N' <0;' 
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA START I END DATUMA
CREATE OR ALTER PROCEDURE bronze.provjera_valjanosti_start_i_end_datuma @naziv_tablice VARCHAR(100), @ključ VARCHAR(200), @naziv_start VARCHAR(200), @naziv_end VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql=N'SELECT '+ @ključ+ ',' + @naziv_start+ ','+@naziv_end+ N' FROM '+ @naziv_tablice + N' WHERE ' +@naziv_start+ N' >' +@naziv_end+ ';'
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA POSTOJANJA FK KLJUČA KAO PK KLJUČA
CREATE OR ALTER PROCEDURE bronze.provjera_referencijalnog_integriteta @naziv_tablice_FK VARCHAR(100), @naziv_tablice_PK VARCHAR(100), @naziv_stupca_FK VARCHAR(200), @naziv_stupca_PK VARCHAR(200)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N' SELECT *
        FROM ' + @naziv_tablice_FK + N' AS FK
        WHERE NOT EXISTS (
            SELECT 1
            FROM ' + @naziv_tablice_PK + N' AS PK
            WHERE PK.' + @naziv_stupca_PK + N' = FK.' + @naziv_stupca_FK + N'
        );';

    EXEC sys.sp_executesql @sql;
END;
GO

--PROVJERA MAX 10 VRIJEDNOSTI
CREATE OR ALTER PROCEDURE bronze.provjera_max10_vrijednosti @naziv_tablice VARCHAR(100), @ključ VARCHAR(200), @naziv_stupca VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql=N'SELECT TOP 10 '+ @ključ+ ',' + @naziv_stupca+ N' FROM '+ @naziv_tablice + N' ORDER BY '+ @naziv_stupca+' DESC;' 
		exec sys.sp_executesql @sql;
	END;
GO

--PROVJERA MIN 10 VRIJEDNOSTI
CREATE OR ALTER PROCEDURE bronze.provjera_min10_vrijednosti @naziv_tablice VARCHAR(100), @ključ VARCHAR(200), @naziv_stupca VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(MAX);
		SET @sql=N'SELECT TOP 10 '+ @ključ+ ',' + @naziv_stupca+ N' FROM '+ @naziv_tablice + N' ORDER BY '+ @naziv_stupca+';' 
		exec sys.sp_executesql @sql;
	END;