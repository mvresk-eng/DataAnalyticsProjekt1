/* NASLOV: Provjera kreiranih baza podataka i schema
   AUTOR: Marko Vresk
   DATUM: 21.9.2026.
   OPIS: Ovaj SQL skript provjerava postojeće baze podataka i schema u SQL Serveru.
*/
--PROVJERA KREIRANIH BAZA PODATAKA
SELECT* FROM sys.databases;
--PROVJERA KREIRANI SCHEMA
SELECT *, DB_NAME() as Database_name FROM sys.schemas;