/*
    Naslov: Kreiranje tablica u schemi "silver"
    Autor: Marko Vresk
    Datum: 02.10.2026.
    Opis: Ova skripta kreira tablice u schemi "silver" u SQL Serveru. Tablice su dizajnirane za pohranu podataka iz različitih domena, uključujući ERP, CRM, marketing, financije, operacije i povrate. Svaka tablica sadrži odgovarajuće stupce i tipove podataka kako bi se osigurala pravilna pohrana i integritet podataka.
    Upozorenje: Prilikom kreiranja tablica, važno je osigurati da su svi potrebni stupci i tipovi podataka ispravno definirani kako bi se izbjegle pogreške u izvršavanju i osiguralo točno pohranjivanje podataka.
*/
CREATE OR ALTER PROCEDURE silver.kreiranje_tablica AS
	BEGIN
		BEGIN TRY
			DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME2;
			SET @početno_vrijeme= GETDATE();
			PRINT('Proces kreiranja tablica počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			-- BRISANJE TABLICE silver.erp_customers
			IF OBJECT_ID('silver.erp_customers', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_customers;
				PRINT '--Brišem tablicu "silver.erp_customers"--';
			END;

			-- KREIRANJE TABLICE silver.erp_customers
			CREATE TABLE silver.erp_customers
			( 
				customer_id        VARCHAR(20),
				customer_full_name VARCHAR(255),
				email              VARCHAR(255),
				customer_birthdate DATE,
				customer_age       INT,
				city               VARCHAR(100),
				city_state         VARCHAR(80),
				dwh_create_date    DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_customers"--';

			-- BRISANJE TABLICE silver.erp_order_items
			IF OBJECT_ID('silver.erp_order_items', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_order_items;
				PRINT '--Brišem tablicu "silver.erp_order_items"--';
			END;

			-- KREIRANJE TABLICE silver.erp_order_items
			CREATE TABLE silver.erp_order_items
			(
				order_id        VARCHAR(20),
				order_item      INT,
				product_id      VARCHAR(20),
				seller_id       VARCHAR(20),
				quantity        INT,
				price           FLOAT,
				total_amount    FLOAT,
				dwh_create_date DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_order_items"--';

			-- BRISANJE TABLICE silver.erp_orders
			IF OBJECT_ID('silver.erp_orders', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_orders;
				PRINT '--Brišem tablicu "silver.erp_orders"--';
			END;

			-- KREIRANJE TABLICE silver.erp_orders
			CREATE TABLE silver.erp_orders
			(
				order_id                       VARCHAR(20),
				customer_id                    VARCHAR(20),
				order_purchase_timestamp       DATETIME2(0),
				order_status                   VARCHAR(30),
				order_delivered_customer_date  DATETIME2(0),
				order_estimated_delivery_date  DATETIME2(0),
				dwh_create_date                DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_orders"--';

			-- BRISANJE TABLICE silver.erp_payments
			IF OBJECT_ID('silver.erp_payments', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_payments;
				PRINT '--Brišem tablicu "silver.erp_payments"--';
			END;

			-- KREIRANJE TABLICE silver.erp_payments
			CREATE TABLE silver.erp_payments
			(
				order_id            VARCHAR(20),
				payment_type        VARCHAR(30),
				payment_installments INT,
				items_total         FLOAT,
				shipping_cost       INT,
				payment_value       FLOAT,
				dwh_create_date     DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_payments"--';

			-- BRISANJE TABLICE silver.erp_products
			IF OBJECT_ID('silver.erp_products', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_products;
				PRINT '--Brišem tablicu "silver.erp_products"--';
			END;

			-- KREIRANJE TABLICE silver.erp_products
			CREATE TABLE silver.erp_products
			(
				product_id            VARCHAR(20),
				product_category_name VARCHAR(100),
				base_price            FLOAT,
				weight_g              FLOAT,
				length_cm             FLOAT,
				height_cm             FLOAT,
				width_cm              FLOAT,
				dwh_create_date       DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_products"--';

			-- BRISANJE TABLICE silver.erp_reviews
			IF OBJECT_ID('silver.erp_reviews', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_reviews;
				PRINT '--Brišem tablicu "silver.erp_reviews"--';
			END;

			-- KREIRANJE TABLICE silver.erp_reviews
			CREATE TABLE silver.erp_reviews
			(
				review_id           VARCHAR(20),
				order_id            VARCHAR(20),
				review_score        INT,
				review_comment_title VARCHAR(60),
				dwh_create_date     DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_reviews"--';

			-- BRISANJE TABLICE silver.erp_sellers
			IF OBJECT_ID('silver.erp_sellers', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_sellers;
				PRINT '--Brišem tablicu "silver.erp_sellers"--';
			END;

			-- KREIRANJE TABLICE silver.erp_sellers
			CREATE TABLE silver.erp_sellers
			(
				seller_id        VARCHAR(20),
				seller_full_name VARCHAR(255),
				seller_email     VARCHAR(255),
				seller_birthdate DATE,
				seller_age       INT,
				seller_city      VARCHAR(100),
				seller_state     VARCHAR(50),
				dwh_create_date  DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_sellers"--';

			-- BRISANJE TABLICE silver.erp_warehouse
			IF OBJECT_ID('silver.erp_warehouse', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.erp_warehouse;
				PRINT '--Brišem tablicu "silver.erp_warehouse"--';
			END;

			-- KREIRANJE TABLICE silver.erp_warehouse
			CREATE TABLE silver.erp_warehouse
			(
				warehouse_id      VARCHAR(20),
				warehouse_name    VARCHAR(100),
				warehouse_address VARCHAR(200),
				warehouse_city    VARCHAR(100),
				capacity_m3       INT,
				warehouse_phone   VARCHAR(100),
				warehouse_email   VARCHAR(100),
				warehouse_status  VARCHAR(50),
				dwh_create_date   DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.erp_warehouse"--';

			-- BRISANJE TABLICE silver.crm_customer_profile
			IF OBJECT_ID('silver.crm_customer_profile', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.crm_customer_profile;
				PRINT '--Brišem tablicu "silver.crm_customer_profile"--';
			END;

			-- KREIRANJE TABLICE silver.crm_customer_profile
			CREATE TABLE silver.crm_customer_profile
			(
				customer_id         VARCHAR(20),
				customer_segment    VARCHAR(100),
				acquisition_channel VARCHAR(100),
				first_contact_date  DATETIME2(0),
				last_contact_date   DATETIME2(0),
				dwh_create_date     DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.crm_customer_profile"--';

			-- BRISANJE TABLICE silver.crm_interactions
			IF OBJECT_ID('silver.crm_interactions', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.crm_interactions;
				PRINT '--Brišem tablicu "silver.crm_interactions"--';
			END;

			-- KREIRANJE TABLICE silver.crm_interactions
			CREATE TABLE silver.crm_interactions
			(
				interaction_id   VARCHAR(20),
				customer_id      VARCHAR(20),
				interaction_date DATETIME2(0),
				interaction_type VARCHAR(50),
				seller_id        VARCHAR(20),
				outcome           VARCHAR(50),
				dwh_create_date   DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.crm_interactions"--';

			-- BRISANJE TABLICE silver.crm_leads
			IF OBJECT_ID('silver.crm_leads', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.crm_leads;
				PRINT '--Brišem tablicu "silver.crm_leads"--';
			END;

			-- KREIRANJE TABLICE silver.crm_leads
			CREATE TABLE silver.crm_leads
			(
				lead_id          VARCHAR(20),
				customer_id      VARCHAR(20),
				lead_date        DATE,
				lead_source      VARCHAR(100),
				is_qualified     BIT,
				is_converted     BIT,
				dwh_create_date  DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.crm_leads"--';

			-- BRISANJE TABLICE silver.marketing_campaigns
			IF OBJECT_ID('silver.marketing_campaigns', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.marketing_campaigns;
				PRINT '--Brišem tablicu "silver.marketing_campaigns"--';
			END;

			-- KREIRANJE TABLICE silver.marketing_campaigns
			CREATE TABLE silver.marketing_campaigns
			(
				campaign_id          VARCHAR(20),
				campaign_name        VARCHAR(50),
				channel              VARCHAR(50),
				start_date_campaigns DATE,
				end_date_campaigns   DATE,
				budget                FLOAT,
				dwh_create_date       DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.marketing_campaigns"--';
		-- BRISANJE TABLICE silver.marketing_performance
			IF OBJECT_ID('silver.marketing_performance', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.marketing_performance;
				PRINT '--Brišem tablicu "silver.marketing_performance"--';
			END;

			-- KREIRANJE TABLICE silver.marketing_performance
			CREATE TABLE silver.marketing_performance
			(
				date_performance DATE,
				campaign_id      VARCHAR(20),
				channel          VARCHAR(100),
				impressions      INT,
				clicks           INT,
				leads            INT,
				conversions      INT,
				spend            FLOAT,
				dwh_create_date  DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.marketing_performance"--';

			-- BRISANJE TABLICE silver.finance_operating_costs
			IF OBJECT_ID('silver.finance_operating_costs', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.finance_operating_costs;
				PRINT '--Brišem tablicu "silver.finance_operating_costs"--';
			END;

			-- KREIRANJE TABLICE silver.finance_operating_costs
			CREATE TABLE silver.finance_operating_costs
			(
				cost_id              VARCHAR(20),
				cost_date            DATETIME2(0),
				operating_cost_state VARCHAR(10),
				cost_type            VARCHAR(50),
				cost_amount          FLOAT,
				dwh_create_date      DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.finance_operating_costs"--';

			-- BRISANJE TABLICE silver.finance_sales_budget
			IF OBJECT_ID('silver.finance_sales_budget', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.finance_sales_budget;
				PRINT '--Brišem tablicu "silver.finance_sales_budget"--';
			END;

			-- KREIRANJE TABLICE silver.finance_sales_budget
			CREATE TABLE silver.finance_sales_budget
			(
				date_sales_budget    DATE,
				state_sales_budget   VARCHAR(40),
				product_category_name VARCHAR(100),
				budget_amount        FLOAT,
				dwh_create_date      DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.finance_sales_budget"--';

			-- BRISANJE TABLICE silver.operations_inventory
			IF OBJECT_ID('silver.operations_inventory', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.operations_inventory;
				PRINT '--Brišem tablicu "silver.operations_inventory"--';
			END;

			-- KREIRANJE TABLICE silver.operations_inventory
			CREATE TABLE silver.operations_inventory
			(
				snapshot_date    DATE,
				product_id       VARCHAR(50),
				warehouse_id     VARCHAR(50),
				stock_quantity   INT,
				reserved_quantity INT,
				reorder_point    INT,
				dwh_create_date  DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.operations_inventory"--';

			-- BRISANJE TABLICE silver.operations_supplier_product
			IF OBJECT_ID('silver.operations_supplier_product', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.operations_supplier_product;
				PRINT '--Brišem tablicu "silver.operations_supplier_product"--';
			END;

			-- KREIRANJE TABLICE silver.operations_supplier_product
			CREATE TABLE silver.operations_supplier_product
			(
				product_id       VARCHAR(20),
				supplier_id      VARCHAR(20),
				unit_cost        FLOAT,
				dwh_create_date  DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.operations_supplier_product"--';

			-- BRISANJE TABLICE silver.operations_suppliers
			IF OBJECT_ID('silver.operations_suppliers', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.operations_suppliers;
				PRINT '--Brišem tablicu "silver.operations_suppliers"--';
			END;

			-- KREIRANJE TABLICE silver.operations_suppliers
			CREATE TABLE silver.operations_suppliers
			(
				supplier_id       VARCHAR(20),
				supplier_name     VARCHAR(50),
				state_suppliers   VARCHAR(50),
				lead_time_days    INT,
				avg_unit_cost     FLOAT,
				dwh_create_date   DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.operations_suppliers"--';

			-- BRISANJE TABLICE silver.returns_returns
			IF OBJECT_ID('silver.returns_returns', 'U') IS NOT NULL
			BEGIN
				DROP TABLE silver.returns_returns;
				PRINT '--Brišem tablicu "silver.returns_returns"--';
			END;

			-- KREIRANJE TABLICE silver.returns_returns
			CREATE TABLE silver.returns_returns
			(
				return_id       VARCHAR(20),
				order_id        VARCHAR(20),
				order_item		VARCHAR(20),
				product_id      VARCHAR(20),
				seller_id       VARCHAR(20),
				customer_id     VARCHAR(20),
				return_date     DATETIME2(0),
				return_quantity INT,
				return_reason   VARCHAR(100),
				refund_amount   FLOAT,
				dwh_create_date DATETIME2 DEFAULT GETDATE()
			);

			PRINT '--Kreiram tablicu "silver.returns_returns"--';
			SET @završno_vrijeme= GETDATE();
			PRINT('Proces kreiranja tablica završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Ukupno trajanje procesa kreiranja tablica: ' + CAST(DATEDIFF(millisecond, @početno_vrijeme, @završno_vrijeme)as NVARCHAR) + ' ms')
		END TRY
		BEGIN CATCH
			PRINT('ERROR_MESSAGE: ' + ERROR_MESSAGE());
			PRINT('ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('ERROR_LINE: ' + CAST(ERROR_LINE() AS NVARCHAR))
		END CATCH;
	END;
GO

EXEC silver.kreiranje_tablica;