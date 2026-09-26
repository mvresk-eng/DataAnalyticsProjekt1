/*
    ProvjeraBronzeSloj.sql
    Autor: Marko Vresk
    Datum: 26.09.2026.
    Opis: Ova skripta provjerava sve tablice u bronze sloju i dohvaća sve zapise iz svake tablice te ukupni broj redaka za svaku tablicu. Također, dohvaća informacije o tablicama i procedurama u bazi podataka.
    Upozorenja: Poželjno je pokretanje jednog po jednog executa za svaku tablicu kako bi se izbjeglo preopterećenje baze podataka i osiguralo da se svi podaci pravilno dohvaćaju. 
    */


USE DataAnalyticsOlist;

--PROCEDURA ZA DOHVAČANJE ZAPISA IZ SVIH TABLICA I UKUPNOG BROJA REDAKA ZA SVAKU TABLICU
CREATE OR ALTER PROCEDURE bronze.dohvati_sve_podatke_iz_tablica @imetablice VARCHAR(200) AS
BEGIN
DECLARE @sql NVARCHAR(max);
SET @sql=N'
SELECT *, COUNT(*) OVER() As broj_zapisa_u_tablici FROM ' + @imetablice + N';';
EXEC sys.sp_executesql @sql;
END;

EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_customers';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_order_items';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_orders';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_payments';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_products';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_reviews';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.erp_sellers';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.crm_customer_profile';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.crm_interactions';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.crm_leads';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.marketing_campaigns';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.marketing_performance';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.finance_operating_costs';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.finance_sales_budget';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.operations_inventory';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.operations_supplier_product';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.operations_suppliers';
EXEC bronze.dohvati_sve_podatke_iz_tablica @imetablice='bronze.returns_returns';

--INFORMACIJE O TABLICAMA I SCHEMI
SELECT st.name as table_name, st.type, st.type_desc, st.create_date, st.modify_date, st.schema_id, ss.name as schema_name   FROM SYS.tables st INNER JOIN sys.schemas ss ON  st.schema_id=ss.schema_id;
--INFORMACIJE O PROCEDURAMA
SELECT ao.name, ao.object_id,  ao.type, ao.type_desc, ao.create_date, ao.modify_date, ao.schema_id, ss.name as schema_name FROM sys.all_objects ao INNER JOIN sys.schemas ss ON ao.schema_id=ss.schema_id WHERE ao.type = 'P' AND ss.name='bronze' ;
