/*NASLOV: Skripta za unošenje podataka u tablice u schemi "bronze".
 AUTOR: Marko Vresk
 DATUM: 23.9.2026.
 OPIS: Skripta sadrži SQL naredbe za unošenje podataka u tablice u  schemi "bronze".  Skripta uključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa unosa podataka. Kroz proceduru bronze.učitaj_podatke, korisnik može jednostavno pokrenuti sve naredbe za unošenje podataka u tablice u schemi "bronze". Nakon što se procedura izvrši, svi podaci u tim tablicama će biti uneseni.
UPOZORENJA:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za unošenje podataka u tablice u schemi "bronze". Prije toga potrebno je pokrenuti odgovarajuće skripte za kreiranje tablica. Također, budite oprezni prilikom upisa imena tablica jer greške u imenovanju nisu obuhvaćene try-catch blokom. 
*/
--PROCEDURA ZA UMETANJE PODATAKA U TABLICU bronze.erp_customers
CREATE OR ALTER PROCEDURE bronze.učitaj_podatke AS
	BEGIN
	DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME;
		BEGIN TRY
			SET @početno_vrijeme=GETDATE();
			PRINT('Proces unosa podataka u tablice počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			BULK INSERT bronze.erp_customers
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\customers.csv'
			WITH
			(
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.erp_customers--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_order_items
			BULK INSERT bronze.erp_order_items 
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\order_items.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR= ',',
				ROWTERMINATOR='0x0a'
				);
			PRINT('--Podaci su uneseni u tablicu bronze.erp_order_items--');

				--UMETANJE PODATAKA U TABLICU bronze.erp_orders
			BULK INSERT bronze.erp_orders
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\orders.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR= '0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.erp_orders--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_payments
			BULK INSERT bronze.erp_payments
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\payments.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			)
			PRINT('--Podaci su uneseni u tablicu bronze.erp_payments--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_products
			BULK INSERT bronze.erp_products
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\products.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			)
			PRINT('--Podaci su uneseni u tablicu bronze.erp_products--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_reviews
			BULK INSERT bronze.erp_reviews
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\reviews.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			)
			PRINT('--Podaci su uneseni u tablicu bronze.erp_reviews--');

			--UMETANJE PODATAKA U TABLICU bronze.erp_sellers
			BULK INSERT bronze.erp_sellers
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\01_erp\sellers.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			)
			PRINT('--Podaci su uneseni u tablicu bronze.erp_sellers--');

			--UMETANJE PODATAKA U TABLICU bronze.crm_customer_profile
			BULK INSERT bronze.crm_customer_profile
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\02_crm\customer_profile.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.crm_customer_profile--');

			--UMETANJE PODATAKA U TABLICU bronze.crm_interactions
			BULK INSERT bronze.crm_interactions
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\02_crm\interactions.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.crm_interactions--');

			--UMETANJE PODATAKA U TABLICU bronze.crm_leads
			BULK INSERT bronze.crm_leads
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\02_crm\leads.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.crm_leads--');

			--UMETANJE PODATAKA U TABLICU bronze.marketing_campaigns
			BULK INSERT bronze.marketing_campaigns
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\03_marketing\campaigns.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.marketing_campaigns--');

			--UMETANJE PODATAKA U TABLICU bronze.marketing_performance
			BULK INSERT bronze.marketing_performance
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\03_marketing\performance.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.marketing_performance--');

			--UMETANJE PODATAKA U TABLICU  bronze.finance_operating_costs
			BULK INSERT bronze.finance_operating_costs
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\04_finance\operating_costs.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.finance_operating_costs--');

			--UMETANJE PODATAKA U TABLICU bronze.finance_sales_budget
			BULK INSERT bronze.finance_sales_budget
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\04_finance\sales_budget.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.finance_sales_budget--');

			--UMETANJE PODATAKA U TABLICU bronze.operations_inventory
			BULK INSERT bronze.operations_inventory
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\05_operations\inventory.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.operations_inventory--');

			--UMETANJE PODATAKA U TABLICU bronze.operations_supplier_product
			BULK INSERT bronze.operations_supplier_product
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\05_operations\supplier_product.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.operations_supplier_product--');

			--UMETANJE PODATAKA U TABLICU bronze.operations_suppliers
			BULK INSERT bronze.operations_suppliers
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\05_operations\suppliers.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.operations_suppliers--');

			--UMETANJE PODATAKA U TABLICU bronze.returns_returns
			BULK INSERT bronze.returns_returns
			FROM 'C:\Users\marko\OneDrive\Desktop\DataAnalyticsProjekt1\datasets\06_returns\returns.csv'
			WITH(
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='0x0a'
			);
			PRINT('--Podaci su uneseni u tablicu bronze.returns_returns--');
			SET @završno_vrijeme=GETDATE();
			PRINT('Proces unosa podataka u tablice završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Proces unosa podataka u tablice trajao je : ' + CAST(DATEDIFF(millisecond, @početno_vrijeme, @završno_vrijeme) as NVARCHAR) + ' ms');
		END TRY
		BEGIN CATCH
			PRINT('ERROR MESSAGE: '+ ERROR_MESSAGE());
			PRINT('ERROR NUMBER: '+ CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('ERROR LINE: '+ CAST(ERROR_LINE() AS NVARCHAR));
		END CATCH;
	END;
	GO

exec bronze.učitaj_podatke;