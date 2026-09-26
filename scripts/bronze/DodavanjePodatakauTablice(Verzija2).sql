/*NASLOV: Skripta za unošenje podataka u tablice u schemi "bronze".
 AUTOR: Marko Vresk
 DATUM: 23.9.2026.
 OPIS: Skripta sadrži SQL naredbe za unošenje podataka u tablice u  schemi "bronze". Procedura bronze.učitaj_jednu_tablicu služi za učitavanje podataka iz CSV datoteke u zadanu tablicu pomoću naredbe BULK INSERT. Naziv tablice i putanja do datoteke primaju se kao parametri, a pomoću dinamičkog SQL-a omogućeno je učitavanje različitih CSV datoteka u različite tablice.
Procedura bronze.učitaj_podatke služi za pokretanje procesa učitavanja svih podataka u Bronze sloj. Poziva proceduru bronze.učitaj_jednu_tablicu za svaku tablicu i pripadajuću CSV datoteku. Procedurauključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa unosa podataka.
UPOZORENJA:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za unošenje podataka u tablice u schemi "bronze". Prije toga potrebno je pokrenuti odgovarajuće skripte za kreiranje tablica. 
*/

--KREIRANJE PROCEDURE ZA PRIPREMU SQL NAREDBE ZA UMETANJE PODATAKA U TABLICU
CREATE OR ALTER PROCEDURE bronze.učitaj_jednu_tablicu @ime_tablice VARCHAR(100), @putanja VARCHAR(255) AS
	BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = N'
        BULK INSERT ' + @ime_tablice + N'
        FROM ''' + @putanja + N'''
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0a'',
			CODEPAGE = ''65001''
        );';

    EXEC sys.sp_executesql @sql;
END;
GO

--KREIRANJE PROCEDURE ZA UMETANJE PODATAKA U TABLICE
CREATE OR ALTER PROCEDURE bronze.učitaj_podatke AS
	BEGIN
	DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME;
		BEGIN TRY
			SET @početno_vrijeme=GETDATE();
			PRINT('Proces unosa podataka u tablice počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			BEGIN TRANSACTION;
			--UMETANJE PODATAKA U TABLICU bronze.erp_customers
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_customers',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\customers.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_customers--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_order_items
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_order_items',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\order_items.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_order_items--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_orders
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_orders',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\orders.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_orders--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_payments
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_payments',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\payments.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_payments--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_products
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_products',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\products.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_products--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_reviews
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_reviews',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\reviews.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_reviews--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_sellers
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.erp_sellers',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\sellers.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.erp_sellers--');

			--UMETANJE PODATAKA U TABLICU bronze.crm_customer_profile
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.crm_customer_profile',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\02_crm\customer_profile.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.crm_customer_profile--');

			--UMETANJE PODATAKA U TABLICU bronze.crm_interactions
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.crm_interactions',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\02_crm\interactions.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.crm_interactions--');

			--UMETANJE PODATAKA U TABLICU bronze.crm_leads
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.crm_leads',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\02_crm\leads.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.crm_leads--');

			--UMETANJE PODATAKA U TABLICU bronze.marketing_campaigns
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.marketing_campaigns',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\03_marketing\campaigns.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.marketing_campaigns--');

			--UMETANJE PODATAKA U TABLICU bronze.marketing_performance
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.marketing_performance',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\03_marketing\performance.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.marketing_performance--');

			--UMETANJE PODATAKA U TABLICU  bronze.finance_operating_costs
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.finance_operating_costs',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\04_finance\operating_costs.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.finance_operating_costs--');

			--UMETANJE PODATAKA U TABLICU bronze.finance_sales_budget
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.finance_sales_budget',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\04_finance\sales_budget.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.finance_sales_budget--');

			--UMETANJE PODATAKA U TABLICU bronze.operations_inventory
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.operations_inventory',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\05_operations\inventory.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.operations_inventory--');

			--UMETANJE PODATAKA U TABLICU bronze.operations_supplier_product
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.operations_supplier_product',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\05_operations\supplier_product.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.operations_supplier_product--');

			--UMETANJE PODATAKA U TABLICU bronze.operations_suppliers
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.operations_suppliers',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\05_operations\suppliers.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.operations_suppliers--');

			--UMETANJE PODATAKA U TABLICU bronze.returns_returns
			exec bronze.učitaj_jednu_tablicu @ime_tablice='bronze.returns_returns',
			@putanja ='C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\06_returns\returns.csv';
			PRINT('--Podaci su uneseni u tablicu bronze.returns_returns--');
			COMMIT TRANSACTION;
			SET @završno_vrijeme=GETDATE();
			PRINT('Proces unosa podataka u tablice završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Proces unosa podataka u tablice trajao je : ' + CAST(DATEDIFF(millisecond, @početno_vrijeme, @završno_vrijeme) as NVARCHAR) + ' ms');
		END TRY
		BEGIN CATCH
			IF  @@TRANCOUNT>0
				ROLLBACK TRANSACTION;
			PRINT('')
			PRINT('PONIŠTAVAM SVE UNOSE PODATAKA U TABLICU')
			PRINT('ERROR MESSAGE: '+ ERROR_MESSAGE());
			PRINT('ERROR NUMBER: '+ CAST(ERROR_NUMBER() AS NVARCHAR));
		END CATCH;
	END;
	GO

exec bronze.učitaj_podatke;