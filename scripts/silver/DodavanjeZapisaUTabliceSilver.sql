/*
    NASLOV: Skripta za unos podataka u tablice u schemi "silver".
    AUTOR: Marko Vresk
    DATUM: 03.10.2026.
    OPIS: Skripta sadrži SQL naredbe za unos podataka u tablice u bazi schemi "silver".  Skripta uključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa unosa podataka. Kroz proceduru silver.učitaj_podatke, korisnik može jednostavno pokrenuti sve naredbe za unos podataka u tablice u bazi podataka "silver". Nakon što se procedura izvrši, svi podaci iz pogleda i tablica iz bronze sloja bit će uneseni u odgovarajuće tablice u silver sloju.
    UPOZORENJA:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za unos podataka u tablice u schemi podataka "silver". Prije toga potrebno je pokrenuti odgovarajuće skripte za kreiranje tablica i pogleda. Također, budite oprezni prilikom unosa imena tablica jer će unos nepostojeće tablice rezultirati greškom. Prije unosa podataka, preporučuje se provjeriti da li su svi potrebni podaci u bronze sloju ispravno uneseni i da li su svi pogledi kreirani.
*/
CREATE OR ALTER PROCEDURE silver.učitaj_podatke AS
	BEGIN
		BEGIN TRY
			DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME2;
			SET @početno_vrijeme= GETDATE();
			PRINT('Proces unosa u tablice počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));

			-- UMETANJE PODATAKA U TABLICU silver.erp_customers
			INSERT INTO silver.erp_customers
			(
				customer_id,
				customer_full_name,
				email,
				customer_birthdate,
				customer_age,
				city,
				city_state
			)
			SELECT
				customer_id,
				customer_first_name + ' ' + customer_last_name AS customer_full_name,
				CASE
					WHEN email IS NULL THEN LOWER(customer_id) + '@example.com'
					ELSE email
				END AS email,
				customer_birthdate,
				DATEDIFF(YEAR, customer_birthdate, GETDATE()) AS age,
				city,
				CASE
					WHEN city = 'Belo Horizonte' THEN 'Minas Gerais'
					WHEN city = 'Brasilia' THEN 'Distrito Federal'
					WHEN city = 'Campinas' THEN 'Sao Paulo'
					WHEN city = 'Curitiba' THEN 'Paraná'
					WHEN city = 'Florianopolis' THEN 'Santa Catarina'
					WHEN city = 'Goiania' THEN 'Goiás'
					WHEN city = 'Porto Alegre' THEN 'Rio Grande do Sul'
					WHEN city = 'Rio de Janeiro' THEN 'Rio de Janeiro'
					WHEN city = 'Salvador' THEN 'Bahia'
					WHEN city = 'Sao Paulo' THEN 'Sao Paulo'
				END AS city_state
			FROM silver.erp_customers_view;

			PRINT('--Podaci su uneseni u tablicu silver.erp_customers--');
		
			-- UMETANJE PODATAKA U TABLICU silver.erp_order_items
			INSERT INTO silver.erp_order_items
			(
				order_id,
				order_item,
				product_id,
				seller_id,
				quantity,
				price,
				total_amount
			)
			SELECT
				order_id,
				order_item,
				product_id,
				seller_id,
				quantity,
				price,
				quantity * price AS total_amount
			FROM bronze.erp_order_items;

			PRINT('--Podaci su uneseni u tablicu silver.erp_order_items--');

			-- UMETANJE PODATAKA U TABLICU silver.erp_orders
			INSERT INTO silver.erp_orders
			(
				order_id,
				customer_id,
				order_purchase_timestamp,
				order_status,
				order_delivered_customer_date,
				order_estimated_delivery_date
			)
			SELECT
				order_id,
				customer_id,
				FORMAT(order_purchase_timestamp, 'yyyy-MM-dd hh:mm:ss') AS order_purchase_timestamp,
				order_status,
				FORMAT(order_delivered_customer_date, 'yyyy-MM-dd hh:mm:ss') AS order_delivered_customer_date,
				FORMAT(order_estimated_delivery_date, 'yyyy-MM-dd hh:mm:ss') AS order_estimated_delivery_date
			FROM silver.erp_orders_view;

			PRINT('--Podaci su uneseni u tablicu silver.erp_orders--');

			-- UMETANJE PODATAKA U TABLICU silver.erp_payments
			INSERT INTO silver.erp_payments
			(
				order_id,
				payment_type,
				payment_installments,
				items_total,
				shipping_cost,
				payment_value
			)
			SELECT
				payments_order_id,
				MAX(payment_type) AS payment_type,
				MAX(payment_installments) AS payment_installments,
				SUM(items_total) AS items_total,
				CASE
					WHEN SUM(items_total) <= 200 THEN 12
					WHEN SUM(items_total) <= 500 THEN 9
					WHEN SUM(items_total) <= 1000 THEN 5
					ELSE 0
				END AS shipping_cost,
				SUM(items_total) +
				CASE
					WHEN SUM(items_total) <= 200 THEN 12
					WHEN SUM(items_total) <= 500 THEN 9
					WHEN SUM(items_total) <= 1000 THEN 5
					ELSE 0
				END AS payment_value
			FROM silver.erp_payments_view
			GROUP BY payments_order_id;

			PRINT('--Podaci su uneseni u tablicu silver.erp_payments--');

			-- UMETANJE PODATAKA U TABLICU silver.erp_products
			INSERT INTO silver.erp_products
			(
				product_id,
				product_name,
				product_category_name,
				base_price,
				weight_g,
				length_cm,
				height_cm,
				width_cm
			)
			SELECT
				product_id,
				product_name,
				CASE
					WHEN product_category_name IS NULL THEN 'unknown'
					ELSE REPLACE(product_category_name, ' & ', '_')
				END AS product_category_name,
				base_price,
				weight_g,
				length_cm,
				height_cm,
				width_cm
			FROM bronze.erp_products;

			PRINT('--Podaci su uneseni u tablicu silver.erp_products--');

			-- UMETANJE PODATAKA U TABLICU silver.erp_reviews
			INSERT INTO silver.erp_reviews
			(
				review_id,
				order_id,
				review_score,
				review_comment_title
			)
			SELECT
				review_id,
				order_id,
				review_score,
				review_comment_title
			FROM silver.erp_reviews_view;

			PRINT('--Podaci su uneseni u tablicu silver.erp_reviews--');

			-- UMETANJE PODATAKA U TABLICU silver.erp_sellers
			INSERT INTO silver.erp_sellers
			(
				seller_id,
				seller_full_name,
				seller_email,
				seller_birthdate,
				seller_age,
				seller_city,
				seller_state
			)
			SELECT
				seller_id,
				seller_first_name + ' ' + seller_last_name AS seller_fullname,
				seller_email,
				seller_birthdate,
				DATEDIFF(YEAR, seller_birthdate, GETDATE()) AS seller_age,
				seller_city,
				CASE
					WHEN seller_city = 'Belo Horizonte' THEN 'Minas Gerais'
					WHEN seller_city = 'Brasilia' THEN 'Distrito Federal'
					WHEN seller_city = 'Campinas' THEN 'Sao Paulo'
					WHEN seller_city = 'Curitiba' THEN 'Paraná'
					WHEN seller_city = 'Florianopolis' THEN 'Santa Catarina'
					WHEN seller_city = 'Goiania' THEN 'Goiás'
					WHEN seller_city = 'Porto Alegre' THEN 'Rio Grande do Sul'
					WHEN seller_city = 'Rio de Janeiro' THEN 'Rio de Janeiro'
					WHEN seller_city = 'Salvador' THEN 'Bahia'
					WHEN seller_city = 'Sao Paulo' THEN 'Sao Paulo'
				END AS seller_state
			FROM bronze.erp_sellers;

			PRINT('--Podaci su uneseni u tablicu silver.erp_sellers--');

			-- UMETANJE PODATAKA U TABLICU silver.crm_customer_profile
			INSERT INTO silver.crm_customer_profile
			(
				customer_id,
				customer_segment,
				acquisition_channel,
				first_contact_date,
				last_contact_date
			)
			SELECT
				REPLACE(customer_id,'"','') AS customer_id,
				customer_segment,
				acquisition_channel,
				first_contact_date,
				last_contact_date
			FROM silver.crm_customer_profile_view;

			PRINT('--Podaci su uneseni u tablicu silver.crm_customer_profile--');

			-- UMETANJE PODATAKA U TABLICU silver.crm_interactions
			INSERT INTO silver.crm_interactions
			(
				interaction_id,
				customer_id,
				interaction_date,
				interaction_type,
				seller_id,
				outcome
			)
			SELECT
				interaction_id,
				customer_id,
				interaction_date,
				interaction_type,
				REPLACE(sales_rep_id, 'REP', 'SELL00') AS seller_id,
				CASE
					WHEN outcome IS NULL THEN 'unknown'
					ELSE outcome
				END AS outcome
			FROM silver.crm_interactions_view;

			PRINT('--Podaci su uneseni u tablicu silver.crm_interactions--');

			-- UMETANJE PODATAKA U TABLICU silver.crm_leads
			INSERT INTO silver.crm_leads
			(
				lead_id,
				customer_id,
				lead_date,
				lead_source,
				is_qualified,
				is_converted
			)
			SELECT * FROM silver.crm_leads_view;

			PRINT('--Podaci su uneseni u tablicu silver.crm_leads--');

			-- UMETANJE PODATAKA U TABLICU silver.marketing_campaigns
			INSERT INTO silver.marketing_campaigns
			(
				campaign_id,
				campaign_name,
				channel,
				start_date_campaigns,
				end_date_campaigns,
				budget
			)
			SELECT * FROM bronze.marketing_campaigns;

			PRINT('--Podaci su uneseni u tablicu silver.marketing_campaigns--');

			-- UMETANJE PODATAKA U TABLICU silver.marketing_performance
			INSERT INTO silver.marketing_performance
			(
				date_performance,
				campaign_id,
				channel,
				impressions,
				clicks,
				leads,
				conversions,
				spend
			)
			SELECT
				date_performance,
				campaign_id,
				TRIM(channel) AS channel,
				impressions,
				clicks,
				leads,
				conversions,
				REPLACE(spend, '-', '') AS spend
			FROM silver.marketing_performance_view;

			PRINT('--Podaci su uneseni u tablicu silver.marketing_performance--');

			-- UMETANJE PODATAKA U TABLICU silver.finance_operating_costs
			INSERT INTO silver.finance_operating_costs
			(
				cost_id,
				cost_date,
				operating_cost_state,
				cost_type,
				cost_amount
			)
			SELECT * FROM bronze.finance_operating_costs;

			PRINT('--Podaci su uneseni u tablicu silver.finance_operating_costs--');

			-- UMETANJE PODATAKA U TABLICU silver.finance_sales_budget
			INSERT INTO silver.finance_sales_budget
			(
				date_sales_budget,
				state_sales_budget,
				product_category_name,
				budget_amount
			)
			SELECT
				date_sales_budget,
				CASE
					WHEN state_sales_budget = 'BA' THEN 'Bahia'
					WHEN state_sales_budget = 'DF' THEN 'Distrito Federal'
					WHEN state_sales_budget = 'MG' THEN 'Minas Gerais'
					WHEN state_sales_budget = 'PR' THEN 'Paraná'
					WHEN state_sales_budget = 'RJ' THEN 'Rio de Janeiro'
					WHEN state_sales_budget = 'RS' THEN 'Rio Grande do Sul'
					WHEN state_sales_budget = 'SC' THEN 'Santa Catarina'
					WHEN state_sales_budget = 'SP' THEN 'Sao Paulo'
				END AS state_sales_budget,
				product_category_name,
				budget_amount
			FROM bronze.finance_sales_budget;

			PRINT('--Podaci su uneseni u tablicu silver.finance_sales_budget--');

			-- UMETANJE PODATAKA U TABLICU silver.operations_inventory
			INSERT INTO silver.operations_inventory
			(
				snapshot_date,
				product_id,
				warehouse_id,
				stock_quantity,
				reserved_quantity,
				reorder_point
			)
			SELECT * FROM bronze.operations_inventory;

			PRINT('--Podaci su uneseni u tablicu silver.operations_inventory--');

			-- UMETANJE PODATAKA U TABLICU silver.operations_supplier_product
			INSERT INTO silver.operations_supplier_product
			(
				product_id,
				supplier_id,
				unit_cost
			)
			SELECT * FROM bronze.operations_supplier_product;

			PRINT('--Podaci su uneseni u tablicu silver.operations_supplier_product--');

			-- UMETANJE PODATAKA U TABLICU silver.operations_suppliers
			INSERT INTO silver.operations_suppliers
			(
				supplier_id,
				supplier_name,
				state_suppliers,
				lead_time_days,
				avg_unit_cost
			)
			SELECT
				supplier_id,
				supplier_name,
				CASE
					WHEN state_suppliers = 'BA' THEN 'Bahia'
					WHEN state_suppliers = 'DF' THEN 'Distrito Federal'
					WHEN state_suppliers = 'ES' THEN 'Espírito Santo'
					WHEN state_suppliers = 'GO' THEN 'Goiás'
					WHEN state_suppliers = 'MG' THEN 'Minas Gerais'
					WHEN state_suppliers = 'PR' THEN 'Paraná'
					WHEN state_suppliers = 'RJ' THEN 'Rio de Janeiro'
					WHEN state_suppliers = 'RS' THEN 'Rio Grande do Sul'
					WHEN state_suppliers = 'SP' THEN 'São Paulo'
					WHEN state_suppliers = 'SC' THEN 'Santa Catarina'
				END AS state_suppliers,
				lead_time_days,
				avg_unit_cost
			FROM bronze.operations_suppliers;

			PRINT('--Podaci su uneseni u tablicu silver.operations_suppliers--');


			-- UMETANJE PODATAKA U TABLICU silver.returns_returns
			INSERT INTO silver.returns_returns
			(
				return_id,
				order_id,
				order_item,
				product_id,
				seller_id,
				customer_id,
				return_date,
				return_quantity,
				return_reason,
				refund_amount
			)
			SELECT
				return_id,
				rr_order_id,
				order_item_id,
				rr_product_id,
				seller_id,
				rr_customer_id,
				return_date,
				CASE
					WHEN return_quantity > quantity THEN quantity
					ELSE return_quantity
				END AS return_quantity,
				return_reason,
				CASE
					WHEN refund_amount > price * quantity THEN price * quantity
					ELSE refund_amount
				END AS refund_amount
			FROM silver.returns_returns_view;

			PRINT('--Podaci su uneseni u tablicu silver.returns_returns--');

			-- UMETANJE PODATAKA U TABLICU silver.erp_warehouse
			INSERT INTO silver.erp_warehouse
			(
				warehouse_id,
				warehouse_name,
				warehouse_address,
				warehouse_city,
				capacity_m3,
				warehouse_phone,
				warehouse_email,
				warehouse_status
			)
			SELECT
				REPLACE(warehouse_id, '"','') as warehouse_id,
				CASE 
					WHEN warehouse_name LIKE 'Goi�nia%' THEN 'Goionia Legacy Warehouse'
					WHEN warehouse_name LIKE 'Bras�lia%' THEN 'Brasilia Distribution Center'
					ELSE warehouse_name
				END AS warehouse_name,
				CASE 
					WHEN warehouse_address LIKE 'Av. Lu%' THEN 'Av. Luis Vianna 2500'
					WHEN warehouse_address LIKE '%Tapaj%' THEN 'Av. Torquato Tapajos 4500'
					WHEN warehouse_address LIKE '%""' THEN 'Rodovia BR-100'
					ELSE warehouse_address
				END AS warehouse_address,
				CASE
					WHEN warehouse_city LIKE 'Bra%' THEN 'Brasilia'
					WHEN warehouse_city LIKE 'Goi%' THEN 'Goiania'
					ELSE warehouse_city
				END AS warehouse_city,
				capacity_m3,
				warehouse_phone,
				warehouse_email,
				CASE
					WHEN warehouse_status LIKE 'Act%' THEN 'Active'
					ELSE 'Inactive'
				END AS warehouse_status
			FROM bronze.erp_warehouse;

			PRINT('--Podaci su uneseni u tablicu silver.erp_warehouse--');
			SET @završno_vrijeme= GETDATE();
			PRINT('Proces unosa u tablice završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Ukupno trajanje procesa unosa u tablice: ' + CAST(DATEDIFF(millisecond, @početno_vrijeme, @završno_vrijeme)as NVARCHAR) + ' ms')
		END TRY
		BEGIN CATCH
			PRINT('ERROR_MESSAGE: ' + ERROR_MESSAGE());
			PRINT('ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('ERROR_LINE: ' + CAST(ERROR_LINE() AS NVARCHAR))
		END CATCH;
	END;
GO

EXECUTE silver.učitaj_podatke;
