/*NASLOV: Skripta za kreiranje tablica u bazi podataka "bronze".
AUTOR: Marko Vresk
DATUM: 22.9.2026.
OPIS: Skripta sadrži SQL naredbe za kreiranje tablica u bazi podataka "bronze". Također, skripta provjerava postoji li tablica prije nego što je kreira ili obriše. Dodatno, skripta uključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa kreiranja tablica. Kroz proceduru bronze.kreiranje_tablica, korisnik može jednostavno pokrenuti sve naredbe za kreiranje tablica u bazi podataka "bronze". Nakon što se procedura izvrši, sve tablice će biti kreirane ili obrisane prema potrebi.
UPOZORENJA:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za kreiranje i brisanje tablica u bazi podataka "bronze". Također, budite oprezni prilikom brisanja tablica jer će svi podaci u tim tablicama biti izgubljeni. Potrebno je prvo pokrenuti naredbe za kreiranje procedure bronze.kreiranje_tablica, a zatim izvršiti naredbu EXEC bronze.kreiranje_tablica kako bi se kreirale sve tablice u bazi podataka "bronze".
*/

--PROCEDURA KOJA KREIRA SVE TABLICE U BAZI "bronze"
CREATE OR ALTER PROCEDURE bronze.kreiranje_tablica AS  
	BEGIN
		BEGIN TRY
			DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME2;
			SET @početno_vrijeme= GETDATE();
			PRINT('Proces kreiranja tablica počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			--BRISANJE TABLICE bronze.erp_customers
			IF OBJECT_ID('bronze.erp_customers', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.erp_customers;
					PRINT ('--Brišem tablicu "bronze.erp_customers"--');
				END;

			--KREIRANJE TABLICE bronze.erp_customers
			CREATE TABLE bronze.erp_customers(
				customer_id VARCHAR(20),
				email VARCHAR(255),
				customer_first_name VARCHAR(255),
				customer_last_name VARCHAR(255),
				customer_birthdate DATE,
				city VARCHAR(100),
				city_state VARCHAR(10),
				zip_prefix INT
			);
			PRINT ('--Kreiram tablicu "bronze.erp_customers"--')

			--BRISANJE TABLICE bronze.erp_order_items
			IF OBJECT_ID('bronze.erp_order_items', 'U') IS NOT NULL
			BEGIN
				DROP TABLE bronze.erp_order_items ;
				PRINT('--Brišem tablicu "bronze.erp_order_items"--')
			END;

			--KREIRANJE TABLICE bronze.erp_order_items
			CREATE TABLE bronze.erp_order_items (
				order_id VARCHAR(20),
				order_item INT,
				product_id VARCHAR(20),
				seller_id VARCHAR(20),
				quantity INT, 
				price FLOAT,
				freight_value FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.erp_order_items"--')

			--BRISANJE TABLICE bronze.erp_orders
			IF OBJECT_ID('bronze.erp_orders', 'U') IS NOT NULL
			BEGIN
				DROP TABLE bronze.erp_orders ;
				PRINT('--Brišem tablicu "bronze.erp_orders"--')
			END;

			--KREIRANJE TABLICE bronze.erp_orders
			CREATE TABLE bronze.erp_orders (
				order_id VARCHAR(20),
				customer_id VARCHAR(20),
				order_purchase_timestamp DATETIME,
				order_status VARCHAR(30),
				order_delivered_customer_date DATETIME,
				order_estimated_delivery_date DATETIME
			);
			PRINT ('--Kreiram tablicu "bronze.erp_orders"--');

			--BRISANJE TABLICE bronze.erp_payments
			IF OBJECT_ID('bronze.erp_payments', 'U') IS NOT NULL
			BEGIN
				DROP TABLE bronze.erp_payments ;
				PRINT('--Brišem tablicu "bronze.erp_payments"--')
			END;

			--KREIRANJE TABLICE bronze.erp_payments
			CREATE TABLE bronze.erp_payments (
				order_id VARCHAR(20),
				payment_sequential INT,
				payment_type VARCHAR(30),
				payment_installments INT,
				payment_value FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.erp_payments"--');

			--BRISANJE TABLICE bronze.erp_products
			IF OBJECT_ID('bronze.erp_products', 'U') IS NOT NULL
			BEGIN
				DROP TABLE bronze.erp_products ;
				PRINT('--Brišem tablicu "bronze.erp_products"--')
			END;

			--KREIRANJE TABLICE bronze.erp_products
			CREATE TABLE bronze.erp_products (
				product_id VARCHAR(20),
				product_category_name VARCHAR(100),
				base_price FLOAT,
				weight_g FLOAT,
				length_cm FLOAT,
				height_cm FLOAT,
				width_cm FLOAT
			);

			PRINT ('--Kreiram tablicu "bronze.erp_products"--');

			--BRISANJE TABLICE bronze.erp_reviews
			IF OBJECT_ID('bronze.erp_reviews', 'U') IS NOT NULL
			BEGIN
				DROP TABLE bronze.erp_reviews ;
				PRINT('--Brišem tablicu "bronze.erp_reviews"--')
			END;

			--KREIRANJE TABLICE bronze.erp_reviews
			CREATE TABLE bronze.erp_reviews (
				review_id VARCHAR(20),
				order_id VARCHAR(20),
				review_score INT,
				review_comment_title VARCHAR(60)
			);

			PRINT ('--Kreiram tablicu "bronze.erp_reviews"--');

			--BRISANJE TABLICE bronze.erp_sellers
			IF OBJECT_ID('bronze.erp_sellers', 'U') IS NOT NULL
			BEGIN
				DROP TABLE bronze.erp_sellers ;
				PRINT('--Brišem tablicu "bronze.erp_sellers"--')
			END;

			--KREIRANJE TABLICE bronze.erp_sellers
			CREATE TABLE bronze.erp_sellers (
				seller_id VARCHAR(20),
				seller_email VARCHAR(255),
				seller_first_name VARCHAR(255),
				seller_last_name VARCHAR(255),
				seller_birthdate DATE,
				seller_city VARCHAR(100),
				seller_state VARCHAR(10),
				seller_zip_prefix INT
			);
			PRINT ('--Kreiram tablicu "bronze.erp_sellers"--');

			--BRISANJE TABLICE bronze.crm_customer_profile
			IF OBJECT_ID('bronze.crm_customer_profile', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.crm_customer_profile;
					PRINT('--Brišem tablicu "bronze.erp_customer_profile"--');
				END;

			--KREIRANJE TABLICE bronze.crm_customer_profile
			CREATE TABLE bronze.crm_customer_profile (
				customer_id VARCHAR(20),
				customer_segment VARCHAR(100),
				acquisition_channel VARCHAR(100),
				sales_rep_id VARCHAR(20),
				first_contact_date DATETIME,
				last_contact_date DATETIME
			);
			PRINT ('--Kreiram tablicu "bronze.crm_customer_profile"--');

			--BRISANJE TABLICE bronze.crm_interactions
			IF OBJECT_ID('bronze.crm_interactions', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.crm_interactions;
					PRINT('--Brišem tablicu "bronze.crm_interactions"--');
				END;

			--KREIRANJE TABLICE bronze.crm_interactions
			CREATE TABLE bronze.crm_interactions (
				interaction_id VARCHAR(20),
				customer_id VARCHAR(20),
				interaction_date DATETIME,
				interaction_type VARCHAR(50),
				sales_rep_id VARCHAR(20),
				outcome VARCHAR(50)
			);
			PRINT ('--Kreiram tablicu "bronze.crm_interactions"--');

			--BRISANJE TABLICE bronze.crm_leads
			IF OBJECT_ID('bronze.crm_leads', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.crm_leads;
					PRINT('--Brišem tablicu "bronze.crm_leads"--');
				END;

			--KREIRANJE TABLICE bronze.crm_leads
			CREATE TABLE bronze.crm_leads (
				lead_id VARCHAR(20),
				customer_id VARCHAR(20),
				lead_date DATE,
				lead_source VARCHAR(100),
				is_qualified BIT,
				is_converted BIT
			);
			PRINT ('--Kreiram tablicu "bronze.crm_leads"--');

			--BRISANJE TABLICE bronze.marketing_campaigns
			IF OBJECT_ID('bronze.marketing_campaigns', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.marketing_campaigns;
					PRINT('--Brišem tablicu "bronze.marketing_campaigns"--');
				END;

			--KREIRANJE TABLICE bronze.marketing_campaigns
			CREATE TABLE bronze.marketing_campaigns (
				campaign_id VARCHAR(20),
				campaign_name VARCHAR(50),
				channel VARCHAR(50),
				start_date_campaigns DATE,
				end_date_campaigns DATE,
				budget FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.marketing_campaigns"--');

			--BRISANJE TABLICE bronze.marketing_performance
			IF OBJECT_ID('bronze.marketing_performance', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.marketing_performance;
					PRINT('--Brišem tablicu "bronze.marketing_performance"--');
				END;

			--KREIRANJE TABLICE bronze.marketing_performance
			CREATE TABLE bronze.marketing_performance (
				date_performance DATE,
				campaign_id VARCHAR(20),
				channel VARCHAR(100),
				impressions INT,
				clicks INT,
				leads INT,
				conversions INT,
				spend FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.marketing_performance"--');

			--BRISANJE TABLICE bronze.finance_operating_costs
			IF OBJECT_ID('bronze.finance_operating_costs', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.finance_operating_costs;
					PRINT('--Brišem tablicu "bronze.finance_operating_costs"--');
				END;

			--KREIRANJE TABLICE bronze.finance_operating_costs
			CREATE TABLE bronze.finance_operating_costs (
				cost_id VARCHAR(20),
				cost_date DATETIME,
				operating_cost_state VARCHAR(10),
				cost_type VARCHAR(50),
				cost_amount FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.finance_operating_costs"--');

			--BRISANJE TABLICE bronze.finance_sales_budget
			IF OBJECT_ID('bronze.finance_sales_budget', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.finance_sales_budget;
					PRINT('--Brišem tablicu "bronze.finance_sales_budget"--');
				END;

			--KREIRANJE TABLICE bronze.finance_sales_budget
			CREATE TABLE bronze.finance_sales_budget (
				date_sales_budget DATE,
				state_sales_budget VARCHAR(10),
				product_category_name VARCHAR(100),
				budget_amount FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.finance_sales_budget"--');

			--BRISANJE TABLICE bronze.operations_inventory
			IF OBJECT_ID('bronze.operations_inventory', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.operations_inventory;
					PRINT('--Brišem tablicu "bronze.operations_inventory"--');
				END;

			--KREIRANJE TABLICE bronze.operations_inventory
			CREATE TABLE bronze.operations_inventory (
				snapshot_date DATE,
				product_id VARCHAR(50),
				warehouse_id VARCHAR(50),
				stock_quantity INT,
				reserved_quantity INT,
				reorder_point INT
			);
			PRINT ('--Kreiram tablicu "bronze.operations_inventory"--');

			--BRISANJE TABLICE bronze.operations_supplier_product
			IF OBJECT_ID('bronze.operations_supplier_product', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.operations_supplier_product;
					PRINT('--Brišem tablicu "bronze.operations_supplier_product"--');
				END;

			--KREIRANJE TABLICE bronze.operations_supplier_product
			CREATE TABLE bronze.operations_supplier_product (
				product_id VARCHAR(20),
				supplier_id VARCHAR(20),
				unit_cost FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.operations_supplier_product"--');

			--BRISANJE TABLICE bronze.operations_suppliers
			IF OBJECT_ID('bronze.operations_suppliers', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.operations_suppliers;
					PRINT('--Brišem tablicu "bronze.operations_suppliers"--');
				END;

			--KREIRANJE TABLICE bronze.operations_suppliers
			CREATE TABLE bronze.operations_suppliers (
				supplier_id VARCHAR(20),
				supplier_name VARCHAR(50),
				state_suppliers VARCHAR(10),
				lead_time_days INT,
				avg_unit_cost FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.operations_suppliers"--');

			--BRISANJE TABLICE bronze.returns_returns
			IF OBJECT_ID('bronze.returns_returns', 'U') IS NOT NULL
				BEGIN
					DROP TABLE bronze.returns_returns;
					PRINT('--Brišem tablicu "bronze.returns_returns"--');
				END;

			--KREIRANJE TABLICE bronze.returns_returns
			CREATE TABLE bronze.returns_returns (
				return_id VARCHAR(20),
				order_id VARCHAR(20),
				order_item_id VARCHAR(20),
				product_id VARCHAR(20),
				seller_id VARCHAR(20),
				customer_id VARCHAR(20),
				return_date DATETIME,
				return_quantity INT,
				return_reason VARCHAR(100),
				refund_amount FLOAT
			);
			PRINT ('--Kreiram tablicu "bronze.returns_returns"--');
			SET @završno_vrijeme= GETDATE();
			PRINT('Proces kreiranja tablica završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Ukupno trajanje procesa kreiranja tablica: ' + CAST(DATEDIFF(millisecond, @početno_vrijeme, @završno_vrijeme)as NVARCHAR) + ' ms')
		END TRY
		BEGIN CATCH
			PRINT('ERROR_MESSAGE: ' + ERROR_MESSAGE());
			PRINT('ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('ERROR_LINE: ' + CAST(ERROR_LINE() AS NVARCHAR))
		END CATCH
	END;

--POKRENUTI NAKON ŠTO SE POKRENE PROCEDURA bronze.kreiranje_tablica
	EXEC bronze.kreiranje_tablica;