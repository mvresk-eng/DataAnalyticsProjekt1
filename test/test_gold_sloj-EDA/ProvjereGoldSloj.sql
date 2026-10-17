/*
    Naslov: Provjere tablica gold sloja
    Autor: Marko Vresk
    Datum: 16.10.2026.
    Opis: Ova skripta provjerava sve tablice u gold sloju i dohvaća sve zapise iz svake tablice te ukupni broj redaka za svaku tablicu. Također, dohvaća informacije o tablicama i procedurama u bazi podataka.
    */
--PROCEDURA ZA DOHVAČANJE ZAPISA IZ SVIH TABLICA I UKUPNOG BROJA REDAKA ZA SVAKU TABLICU
CREATE OR ALTER PROCEDURE gold.dohvati_sve_podatke_iz_tablica @imetablice VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(max);
		SET @sql=N'
		SELECT *, COUNT(*) OVER() As broj_zapisa_u_tablici FROM ' + @imetablice + N';';
		EXEC sys.sp_executesql @sql;
	END;
GO

EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_date';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_product_category';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_supplier';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_campaign';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_warehouse';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_seller';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_customer';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.dim_product';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_return';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_product_supplier';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_inventory_snapshot';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_sales_budget';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_operating_cost';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_marketing_performance';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_lead';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_interaction';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_review';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_payment';
EXEC gold.dohvati_sve_podatke_iz_tablica @imetablice='gold.fact_sales';

--INFORMACIJE O TABLICAMA I SCHEMI
SELECT st.name as table_name, st.type, st.type_desc, st.create_date, st.modify_date, st.schema_id, ss.name as schema_name   FROM SYS.tables st INNER JOIN sys.schemas ss ON  st.schema_id=ss.schema_id AND ss.name='gold';
--INFORMACIJE O PROCEDURAMA

SELECT ao.name, ao.object_id,  ao.type, ao.type_desc, ao.create_date, ao.modify_date, ao.schema_id, ss.name as schema_name FROM sys.all_objects ao INNER JOIN sys.schemas ss ON ao.schema_id=ss.schema_id WHERE ao.type = 'P' AND ss.name='gold' ;