/*
    Naslov: Kreiranje tablica gold sheme
    Autor: Marko Vresk
    Datum: 08.10.2026.
    Opis: Skripta sadrži SQL naredbe za kreiranje tablica u bazi podataka "gold". Skripta uključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa kreiranja tablica. Kroz proceduru gold.kreiranje_tablica, korisnik može jednostavno pokrenuti sve naredbe za kreiranje tablica u bazi podataka "gold". Nakon što se procedura izvrši, sve tablice u bazi podataka "gold" će biti kreirane.
    Upozorenja:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za kreiranje tablica u schemi podataka "gold". Također, provjeriti da li već ne postoje tablice s istim imenom.
*/
CREATE OR ALTER PROCEDURE gold.kreiranje_tablica AS  
	BEGIN
		BEGIN TRY
			DECLARE @početno_vrijeme DATETIME2, @završno_vrijeme DATETIME2;
			SET @početno_vrijeme= GETDATE();		
			CREATE TABLE gold.dim_date (
					date_key		INT NOT NULL,
					full_date		DATE NOT NULL,
					day_number		INT NOT NULL,
					day_name		VARCHAR(20) NOT NULL,
					month_number	INT NOT NULL,
					month_name		VARCHAR(20) NOT NULL,
					quarter_number	INT NOT NULL,
					week_number		INT NOT NULL,
					year_number		INT NOT NULL,
					is_weekend		BIT NOT NULL,
					CONSTRAINT pk_dim_date PRIMARY KEY (date_key),
					CONSTRAINT unique_dim_date_full_date UNIQUE(full_date)
				);
				PRINT '--Kreiram tablicu "gold.dim_date"--';

				-- KREIRANJE TABLICE gold.dim_customer
				CREATE TABLE gold.dim_customer(
					customer_key		  INT IDENTITY(1,1) NOT NULL,
					customer_id			  VARCHAR(20) NOT NULL,
					customer_full_name    VARCHAR(255),
					email                 VARCHAR(255),
					customer_birthdate    DATE,
					customer_age          INT,
					customer_segment      VARCHAR(100),
					acquisition_channel   VARCHAR(100),
					first_contact_date    DATETIME2(0),
					last_contact_date     DATETIME2(0),
					city                  VARCHAR(100),
					state                 VARCHAR(80),
					dwh_create_date       DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_customer PRIMARY KEY(customer_key),
					CONSTRAINT unique_dim_customer_id UNIQUE(customer_id)
				);
				PRINT '--Kreiram tablicu "gold.dim_customer"--';

				-- KREIRANJE TABLICE gold.dim_product_category
				CREATE TABLE gold.dim_product_category(
					product_category_key	INT IDENTITY(1,1) NOT NULL,
					product_category_name	VARCHAR(100),
					dwh_create_date			DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_product_category PRIMARY KEY(product_category_key),
					CONSTRAINT unique_dim_product_category_name UNIQUE(product_category_name)
				);
				PRINT '--Kreiram tablicu "gold.dim_product_category"--';

				-- KREIRANJE TABLICE gold.dim_product
				CREATE TABLE gold.dim_product(
					product_key				INT IDENTITY(1,1) NOT NULL,
					product_id				VARCHAR(20) NOT NULL,
					product_category_key	INT,
					product_name			VARCHAR(200) NOT NULL,
					base_price				DECIMAL(18,2),
					weight_g				DECIMAL(18,2),
					length_cm				DECIMAL(18,2),
					height_cm				DECIMAL(18,2),
					width_cm				DECIMAL(18,2),
					dwh_create_date			DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_product PRIMARY KEY(product_key),
					CONSTRAINT unique_dim_product_product_id UNIQUE (product_id),
					CONSTRAINT unique_dim_product_product_name UNIQUE(product_name),
					CONSTRAINT fk_dim_product_dim_product_category FOREIGN KEY(product_category_key) REFERENCES gold.dim_product_category(product_category_key)
				);
				PRINT '--Kreiram tablicu "gold.dim_product"--';

				-- KREIRANJE TABLICE gold.dim_seller
				CREATE TABLE gold.dim_seller(
					seller_key		   INT IDENTITY(1,1) NOT NULL,
					seller_id          VARCHAR(20)       NOT NULL,
					seller_full_name   VARCHAR(255),
					seller_email       VARCHAR(255),
					seller_birthdate   DATE,
					seller_age		   INT,
					seller_city        VARCHAR(100),
					seller_state       VARCHAR(50),
					dwh_create_date    DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_seller PRIMARY KEY (seller_key),
					CONSTRAINT unique_dim_seller_seller_id UNIQUE (seller_id)
				);
				PRINT '--Kreiram tablicu "gold.dim_seller"--';

				-- KREIRANJE TABLICE gold.dim_warehouse
				CREATE TABLE gold.dim_warehouse
				(
					warehouse_key       INT IDENTITY(1,1) NOT NULL,
					warehouse_id        VARCHAR(20)       NOT NULL,
					warehouse_name      VARCHAR(100),
					warehouse_address   VARCHAR(200),
					warehouse_city      VARCHAR(100),
					capacity_m3         INT,
					warehouse_phone     VARCHAR(100),
					warehouse_email     VARCHAR(100),
					warehouse_status    VARCHAR(50),
					dwh_create_date     DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_warehouse PRIMARY KEY (warehouse_key),
					CONSTRAINT unique_dim_warehouse_warehouse_id UNIQUE (warehouse_id)
				);
				PRINT '--Kreiram tablicu "gold.dim_warehouse"--';

				-- KREIRANJE TABLICE gold.dim_campaign
				CREATE TABLE gold.dim_campaign
				(
					campaign_key          INT IDENTITY(1,1) NOT NULL,
					campaign_id           VARCHAR(20)       NOT NULL,
					campaign_name         VARCHAR(50),
					channel               VARCHAR(50),
					start_date_campaign   DATE,
					end_date_campaign     DATE,
					budget                DECIMAL(18,2),
					dwh_create_date       DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_campaign PRIMARY KEY (campaign_key),
					CONSTRAINT unique_dim_campaign_campaign_id UNIQUE (campaign_id)
				);
				PRINT '--Kreiram tablicu "gold.dim_campaign"--';

				-- KREIRANJE TABLICE gold.dim_supplier
				CREATE TABLE gold.dim_supplier
				(
					supplier_key       INT IDENTITY(1,1) NOT NULL,
					supplier_id        VARCHAR(20)       NOT NULL,
					supplier_name      VARCHAR(50),
					supplier_state     VARCHAR(50),
					lead_time_days     INT,
					avg_unit_cost      DECIMAL(18,2),
					dwh_create_date    DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_dim_supplier PRIMARY KEY (supplier_key),
					CONSTRAINT unique_dim_supplier_supplier_id UNIQUE (supplier_id)
				);
				PRINT '--Kreiram tablicu "gold.dim_supplier"--';
	
				-- KREIRANJE TABLICE gold.fact_sales
				CREATE TABLE gold.fact_sales(
					sales_key								INT IDENTITY(1,1) NOT NULL,
					order_id								VARCHAR(20), 
					order_item								INT,
					date_order_purchase_key					INT,
					date_order_delivered_key				INT,
					date_order_estimated_delivery_key		INT,
					customer_key							INT,
					product_key								INT,
					seller_key								INT,
					order_status							VARCHAR(30),
					order_purchase_timestamp				DATETIME2(0),
					order_delivered_customer_date			DATETIME2(0),
					quantity								INT,
					price									DECIMAL(10,2),
					total_amount							DECIMAL(10,2),
					dwh_create_date							DATETIME2(0) DEFAULT GETDATE(),
					CONSTRAINT pk_fact_sales PRIMARY KEY(sales_key),
					CONSTRAINT unique_fact_sales_order_id_order_item UNIQUE(order_id,order_item),
					CONSTRAINT fk_fact_sales_dim_date_order_purchase FOREIGN KEY (date_order_purchase_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_sales_dim_date_order_delivered_key FOREIGN KEY (date_order_delivered_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_sales_dim_date_order_estimated_delivery_key FOREIGN KEY (date_order_estimated_delivery_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_sales_dim_customer FOREIGN KEY (customer_key) REFERENCES gold.dim_customer(customer_key),
					CONSTRAINT fk_fact_sales_dim_product FOREIGN KEY (product_key) REFERENCES gold.dim_product(product_key),
					CONSTRAINT fk_fact_sales_dim_seller FOREIGN KEY (seller_key) REFERENCES gold.dim_seller(seller_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_sales"--';

				-- KREIRANJE TABLICE gold.fact_payment
				CREATE TABLE gold.fact_payment(
					payment_key			INT IDENTITY(1,1) NOT NULL,
					order_id			VARCHAR(20) NOT NULL,
					date_key             INT,
					customer_key         INT,
					payment_type         VARCHAR(30),
					payment_installments INT,
					items_total          DECIMAL(20,2),
					shipping_cost        DECIMAL(20,2),
					payment_value        DECIMAL(20,2),
					dwh_create_date      DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_payment PRIMARY KEY (payment_key),
					CONSTRAINT unique_fact_payment_order_id UNIQUE (order_id),
					CONSTRAINT fk_fact_payment_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_payment_dim_customer FOREIGN KEY (customer_key) REFERENCES gold.dim_customer(customer_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_payment"--';

				-- KREIRANJE TABLICE gold.fact_review
				CREATE TABLE gold.fact_review(
					review_key		     INT IDENTITY(1,1) NOT NULL,
					review_id			 VARCHAR(20) NOT NULL,
					order_id			 VARCHAR(20) NOT NULL,
					date_key			 INT,
					customer_key	     INT,
					review_score         INT,
					review_comment_title VARCHAR(60),
					dwh_create_date      DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_review PRIMARY KEY (review_key),
					CONSTRAINT unique_fact_review_review_id UNIQUE (review_id),
					CONSTRAINT unique_fact_review_order_id UNIQUE (order_id),
					CONSTRAINT fk_fact_review_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_review_dim_customer FOREIGN KEY(customer_key) REFERENCES gold.dim_customer(customer_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_review"--';
			
				-- KREIRANJE TABLICE gold.fact_interaction
				CREATE TABLE gold.fact_interaction
				(
					interaction_key  INT IDENTITY(1,1) NOT NULL,
					interaction_id   VARCHAR(20) NOT NULL,
					customer_key     INT,
					seller_key       INT,
					date_key         INT,
					interaction_date DATETIME2(0),
					interaction_type VARCHAR(50),
					outcome          VARCHAR(50),
					dwh_create_date  DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_interaction PRIMARY KEY (interaction_key),
					CONSTRAINT unique_fact_interaction_id UNIQUE (interaction_id),
					CONSTRAINT fk_fact_interaction_dim_customer FOREIGN KEY (customer_key) REFERENCES gold.dim_customer(customer_key),
					CONSTRAINT fk_fact_interaction_dim_seller FOREIGN KEY (seller_key) REFERENCES gold.dim_seller(seller_key),
					CONSTRAINT fk_fact_interaction_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_interaction"--';

				-- KREIRANJE TABLICE gold.fact_lead
				CREATE TABLE gold.fact_lead
				(
					lead_key        INT IDENTITY(1,1) NOT NULL,
					lead_id         VARCHAR(20) NOT NULL,
					customer_key    INT,
					date_key        INT,
					lead_source     VARCHAR(100),
					is_qualified    BIT,
					is_converted    BIT,
					dwh_create_date DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_lead PRIMARY KEY (lead_key),
					CONSTRAINT unique_fact_lead_lead_id UNIQUE (lead_id),
					CONSTRAINT fk_fact_lead_dim_customer FOREIGN KEY (customer_key) REFERENCES gold.dim_customer(customer_key),
					CONSTRAINT fk_fact_lead_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_lead"--';
	
				-- KREIRANJE TABLICE gold.fact_marketing_performance
				CREATE TABLE gold.fact_marketing_performance
				(
					marketing_performance_key INT IDENTITY(1,1) NOT NULL,
					date_key				  INT,
					campaign_key			  INT,
					impressions				  INT,
					clicks					  INT,
					leads					  INT,
					conversions			      INT,
					spend                     DECIMAL(18,2),
					dwh_create_date           DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_marketing_performance PRIMARY KEY (marketing_performance_key),
					CONSTRAINT fk_fact_marketing_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_marketing_dim_campaign FOREIGN KEY (campaign_key) REFERENCES gold.dim_campaign(campaign_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_marketing_performance"--';

				-- KREIRANJE TABLICE gold.fact_operating_cost
				CREATE TABLE gold.fact_operating_cost
				(
					operating_cost_key   INT IDENTITY(1,1) NOT NULL,
					cost_id              VARCHAR(20) NOT NULL,
					date_key             INT,
					cost_date            DATETIME2(0),
					operating_cost_state VARCHAR(10),
					cost_type            VARCHAR(50),
					cost_amount          DECIMAL(18,2),
					dwh_create_date      DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_operating_cost PRIMARY KEY (operating_cost_key),
					CONSTRAINT unique_fact_operating_cost_id UNIQUE (cost_id),
					CONSTRAINT fk_fact_operating_cost_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_operating_cost"--';

				-- KREIRANJE TABLICE gold.fact_sales_budget
				CREATE TABLE gold.fact_sales_budget
				(
					sales_budget_key       INT IDENTITY(1,1) NOT NULL,
					date_key               INT,
					state_sales_budget     VARCHAR(40),
					product_category_key   INT,
					budget_amount          DECIMAL(18,2),
					dwh_create_date        DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_sales_budget PRIMARY KEY (sales_budget_key),
					CONSTRAINT unique_fact_sales_budget UNIQUE (date_key, state_sales_budget, product_category_key),
					CONSTRAINT fk_fact_sales_budget_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_sales_budget_dim_product_category FOREIGN KEY (product_category_key) REFERENCES gold.dim_product_category(product_category_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_sales_budget"--';

				-- KREIRANJE TABLICE gold.fact_inventory_snapshot
				CREATE TABLE gold.fact_inventory_snapshot
				(
					inventory_snapshot_key INT IDENTITY(1,1) NOT NULL,
					date_key               INT,
					product_key            INT,
					warehouse_key          INT,
					stock_quantity		   INT,
					reserved_quantity	   INT,
					reorder_point          INT,
					available_quantity	   INT,
					dwh_create_date        DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_inventory_snapshot PRIMARY KEY (inventory_snapshot_key),
					CONSTRAINT unique_fact_inventory_snapshot UNIQUE (date_key, product_key, warehouse_key),
					CONSTRAINT fk_fact_inventory_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_inventory_dim_product FOREIGN KEY (product_key) REFERENCES gold.dim_product(product_key),
					CONSTRAINT fk_fact_inventory_dim_warehouse FOREIGN KEY (warehouse_key) REFERENCES gold.dim_warehouse(warehouse_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_inventory_snapshot"--';

				-- KREIRANJE TABLICE gold.fact_product_supplier
				CREATE TABLE gold.fact_product_supplier(
					product_key		INT NOT NULL,
					supplier_key	INT NOT NULL,
					unit_cost		DECIMAL(18,2),
					dwh_create_date  DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_product_supplier PRIMARY KEY(product_key, supplier_key),
					CONSTRAINT fk_fact_product_supplier_dim_product FOREIGN KEY (product_key) REFERENCES gold.dim_product(product_key),
					CONSTRAINT fk_fact_product_supplier_dim_supplier FOREIGN KEY (supplier_key) REFERENCES gold.dim_supplier(supplier_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_product_supplier"--';

				-- KREIRANJE TABLICE gold.fact_return
				CREATE TABLE gold.fact_return
				(
					return_key       INT IDENTITY(1,1) NOT NULL,
					return_id        VARCHAR(20) NOT NULL,
					order_id         VARCHAR(20),
					order_item       INT,
					date_key         INT,
					customer_key     INT,
					product_key      INT,
					seller_key       INT,
					return_quantity  INT,
					return_reason    VARCHAR(100),
					refund_amount    DECIMAL(18,2),
					dwh_create_date  DATETIME2 DEFAULT GETDATE(),
					CONSTRAINT pk_fact_return PRIMARY KEY (return_key),
					CONSTRAINT unique_fact_return_return_id UNIQUE (return_id),
					CONSTRAINT fk_fact_return_dim_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key),
					CONSTRAINT fk_fact_return_dim_customer FOREIGN KEY (customer_key) REFERENCES gold.dim_customer(customer_key),
					CONSTRAINT fk_fact_return_dim_product FOREIGN KEY (product_key) REFERENCES gold.dim_product(product_key),
					CONSTRAINT fk_fact_return_dim_seller FOREIGN KEY (seller_key) REFERENCES gold.dim_seller(seller_key)
				);
				PRINT '--Kreiram tablicu "gold.fact_return"--';
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
GO
	EXEC gold.kreiranje_tablica;