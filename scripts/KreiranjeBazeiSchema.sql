/*NASLOV: Skripta za kreiranje baze podataka i schema za Data Analytics Olist projekt.
 AUTOR: Marko Vresk
DATUM: 20.9.2026.
OPIS: Skripta sadrži naredbe za kreiranje baze podataka "DataAnalyticsOlist" i schema "bronze", "silver" i "gold". Također, skripta provjerava postoji li baza podataka i schema prije nego što ih kreira ili obriše.
UPOZORENJA: Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za kreiranje i brisanje baza podataka i schema. Također, budite oprezni prilikom brisanja baze podataka jer će svi podaci u bazi biti izgubljeni.
*/
-- KORIŠTENJE MASTER BAZE PODATAKA (OBAVEZNO KAKO BI SE MOGAO OBRISATI BAZU)
USE master
GO

-- BRISANJE BAZE PODATAKA
IF DB_ID('DataAnalyticsOlist') IS NOT NULL
	BEGIN 
		ALTER DATABASE  DataAnalyticsOlist
		SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE DataAnalyticsOlist;
		PRINT('--BRISANJE BAZE PODATAKA "DataAnalyticsOlist"--')
	END;
GO

--KREIRANJE BAZE PODATAKA
CREATE DATABASE DataAnalyticsOlist;
PRINT('--KREIRANJE BAZE PODATAKA "DataAnalyticsOlist"--')
GO

--KORIŠTENJE BAZE PODATAKA
USE DataAnalyticsOlist;
PRINT('--KORIŠTENJE BAZE PODATAKA "'+DB_NAME()+'"--')
GO

--BRISANJE SCHEMA
IF SCHEMA_ID('bronze') IS NOT NULL
	DROP SCHEMA bronze;
	PRINT('--BRISANJE SCHEME "bronze" --');
IF SCHEMA_ID('silver') IS NOT NULL
	DROP SCHEMA silver;
	PRINT('--BRISANJE SCHEME "silver" --');
IF SCHEMA_ID('gold') IS NOT NULL
	DROP SCHEMA gold;
	PRINT('--BRISANJE SCHEME "gold" --');
GO

--KREIRANJE SCHEMA
CREATE SCHEMA bronze;
GO	
PRINT('--KREIRANJE SCHEME "bronze" --');
GO
CREATE SCHEMA silver;
GO
PRINT('--KREIRANJE SCHEME "silver" --');
GO
CREATE SCHEMA gold;
GO
PRINT('--KREIRANJE SCHEME "gold" --');
GO
