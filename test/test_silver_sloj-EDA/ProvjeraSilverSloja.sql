/*
    NASLOV: Provjera podataka u silver sloju
    AUTOR: Marko Vresk
    DATUM: 04.10.2026.
    OPIS: Skripta sadrži SQL naredbe za provjeru podataka u tablicama u bazi schemi "silver".  Skripta uključuje izvršavanje procedure silver.dohvati_sve_podatke_iz_tablica za dohvaćanje svih zapisa iz svake tablice u silver sloju, zajedno s ukupnim brojem redaka za svaku tablicu. Također, skripta dohvaća informacije o tablicama, procedurama i pogledima unutar schemi "silver" kako bi se osigurala pravilna struktura i integritet podataka.
    UPOZORENJA:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za dohvaćanje podataka iz tablica u schemi podataka "silver". Prije toga potrebno je pokrenuti odgovarajuće skripte za kreiranje tablica i procedura. Također, budite oprezni prilikom unosa imena tablica jer će unos nepostojeće tablice rezultirati greškom.
*/
USE DataAnalyticsOlist;
GO

--PROCEDURA ZA DOHVAČANJE ZAPISA IZ SVIH TABLICA I UKUPNOG BROJA REDAKA ZA SVAKU TABLICU
CREATE OR ALTER PROCEDURE silver.dohvati_sve_podatke_iz_tablica @imetablice VARCHAR(200) AS
	BEGIN
		DECLARE @sql NVARCHAR(max);
		SET @sql=N'
		SELECT *, COUNT(*) OVER() As broj_zapisa_u_tablici FROM ' + @imetablice + N';';
		EXEC sys.sp_executesql @sql;
	END;

EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_customers';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_order_items';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_orders';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_payments';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_products';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_reviews';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_sellers';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.erp_warehouse';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.crm_customer_profile';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.crm_interactions';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.crm_leads';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.marketing_campaigns';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.marketing_performance';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.finance_operating_costs';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.finance_sales_budget';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.operations_inventory';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.operations_supplier_product';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.operations_suppliers';
EXEC silver.dohvati_sve_podatke_iz_tablica @imetablice='silver.returns_returns';

--INFORMACIJE O TABLICAMA I SCHEMI
SELECT st.name as table_name, st.type, st.type_desc, st.create_date, st.modify_date, st.schema_id, ss.name as schema_name FROM SYS.tables st INNER JOIN sys.schemas ss ON  st.schema_id=ss.schema_id AND ss.name='silver';
--INFORMACIJE O PROCEDURAMA
SELECT ao.name, ao.object_id,  ao.type, ao.type_desc, ao.create_date, ao.modify_date, ao.schema_id, ss.name as schema_name FROM sys.all_objects ao INNER JOIN sys.schemas ss ON ao.schema_id=ss.schema_id WHERE ao.type = 'P' AND ss.name='silver';
--INFORMACIJE O POGLEDIMA
SELECT ao.name, ao.object_id,  ao.type, ao.type_desc, ao.create_date, ao.modify_date, ao.schema_id, ss.name as schema_name FROM sys.all_objects ao INNER JOIN sys.schemas ss ON ao.schema_id=ss.schema_id WHERE ao.type = 'V' AND ss.name='silver';