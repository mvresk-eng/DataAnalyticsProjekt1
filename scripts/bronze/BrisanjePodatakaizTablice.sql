/*NASLOV: Skripta za brisanje podataka iz tablica u schemi "bronze".
 AUTOR: Marko Vresk
 DATUM: 22.9.2026.
 OPIS: Skripta sadrži SQL naredbe za brisanje podataka iz tablica u bazi schemi "bronze".  Skripta uključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa brisanja podataka. Kroz proceduru bronze.brisanje_podataka, korisnik može jednostavno pokrenuti sve naredbe za brisanje podataka iz tablica u bazi podataka "bronze". Nakon što se procedura izvrši, svi podaci u tim tablicama će biti obrisani.
UPOZORENJA:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za brisanje podataka iz tablica u bazi podataka "bronze". Prije toga potrebno je pokrenuti odgovarajuće skripte za kreiranje tablica. Također, budite oprezni prilikom brisanja podataka jer će svi podaci u tim tablicama biti izgubljeni. 
*/
--Procedura koja briše sve podatke iz tablica u schemi "bronze"
CREATE OR ALTER PROCEDURE bronze.brisanje_podataka AS
	BEGIN
	DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME
		BEGIN TRY
			SET @početno_vrijeme=GETDATE();
			PRINT('Proces brisanja podataka iz tablica počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			BEGIN TRANSACTION;
				--BRISANJE PODATAKA IZ TABLICE bronze.erp_customers
				TRUNCATE TABLE bronze.erp_customers;
				PRINT('--Brisanje podataka iz tablice bronze.erp_customers--');

				--BRISANJE PODATAKA IZ TABLICE bronze.erp_order_items
				TRUNCATE TABLE bronze.erp_order_items;
				PRINT('--Brisanje podataka iz tablice bronze.erp_order_items--')

				--BRISANJE PODATAKA IZ TABLICE bronze.erp_orders
				TRUNCATE TABLE bronze.erp_orders;
				PRINT('--Brisanje podataka iz tablice bronze.erp_orders--');

				--BRISANJE PODATAKA IZ TABLICE bronze.erp_payments
				TRUNCATE TABLE bronze.erp_payments;
				PRINT('--Brisanje podataka iz tablice bronze.erp_payments--');

				--BRISANJE PODATAKA IZ TABLICE bronze.erp_products
				TRUNCATE TABLE bronze.erp_products;
				PRINT('--Brisanje podataka iz tablice bronze.erp_products--');

				--BRISANJE PODATAKA IZ TABLICE bronze.erp_reviews
				TRUNCATE TABLE bronze.erp_reviews;
				PRINT('--Brisanje podataka iz tablice bronze.erp_reviews--');

				--BRISANJE PODATAKA IZ TABLICE bronze.erp_sellers
				TRUNCATE TABLE bronze.erp_sellers;
				PRINT('--Brisanje podataka iz tablice bronze.erp_sellers--');

				--BRISANJE PODATAKA IZ TABLICE bronze.crm_customer_profile
				TRUNCATE TABLE bronze.crm_customer_profile;
				PRINT('--Brisanje podataka iz tablice bronze.crm_customer_profile--');

				--BRISANJE PODATAKA IZ TABLICE bronze.crm_interactions
				TRUNCATE TABLE bronze.crm_interactions;
				PRINT('--Brisanje podataka iz tablice bronze.crm_interactions--');

				--BRISANJE PODATAKA IZ TABLICE bronze.crm_leads
				TRUNCATE TABLE bronze.crm_leads;
				PRINT('--Brisanje podataka iz tablice bronze.crm_leads--');

				--BRISANJE PODATAKA IZ TABLICE bronze.marketing_campaigns
				TRUNCATE TABLE bronze.marketing_campaigns;
				PRINT('--Brisanje podataka iz tablice bronze.marketing_campaigns--');

				--BRISANJE PODATAKA IZ TABLICE bronze.marketing_performance
				TRUNCATE TABLE bronze.marketing_performance;
				PRINT('--Brisanje podataka iz tablice bronze.marketing_performance--');

				--BRISANJE PODATAKA IZ TABLICE bronze.finance_operating_costs
				TRUNCATE TABLE bronze.finance_operating_costs;
				PRINT('--Brisanje podataka iz tablice bronze.finance_operating_costs--');

				--BRISANJE PODATAKA IZ TABLICE bronze.finance_sales_budget
				TRUNCATE TABLE bronze.finance_sales_budget;
				PRINT('--Brisanje podataka iz tablice bronze.finance_sales_budget--');

				--BRISANJE PODATAKA IZ TABLICE bronze.operations_inventory
				TRUNCATE TABLE bronze.operations_inventory;
				PRINT('--Brisanje podataka iz tablice bronze.operations_inventory--');

				--BRISANJE PODATAKA IZ TABLICE bronze.operations_supplier_product
				TRUNCATE TABLE bronze.operations_supplier_product;
				PRINT('--Brisanje podataka iz tablice bronze.operations_supplier_product--');
		
				--BRISANJE PODATAKA IZ TABLICE bronze.operations_suppliers
				TRUNCATE TABLE bronze.operations_suppliers;
				PRINT('--Brisanje podataka iz tablice bronze.operations_suppliers--');
		
				--BRISANJE PODATAKA IZ TABLICE bronze.returns_returns
				TRUNCATE TABLE bronze.returns_returns;
				PRINT('--Brisanje podataka iz tablice bronze.returns_returns--');
			COMMIT TRANSACTION;
			SET @završno_vrijeme=GETDATE();
			PRINT('Proces brisanja podataka iz tablica završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Proces brisanja podataka iz tablica trajao je : ' + CAST(DATEDIFF(millisecond, @početno_vrijeme, @završno_vrijeme) as NVARCHAR) + ' ms');
		END TRY
		BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION;
				PRINT('');
				PRINT ('Sva prethodna brisanja se poništavaju');
				PRINT('ERROR MESSAGE: '+ ERROR_MESSAGE());
				PRINT('ERROR NUMBER: '+ CAST(ERROR_NUMBER() AS NVARCHAR));
				PRINT('ERROR LINE: '+ CAST(ERROR_LINE() AS NVARCHAR));
		END CATCH;
	END;

GO
exec bronze.brisanje_podataka;