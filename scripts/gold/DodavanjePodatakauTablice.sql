/*
    Naslov: Dodavanje podataka u tablice gold sheme
    Autor: Marko Vresk
    Datum: 10.10.2026.
    Opis: Skripta sadrži SQL naredbe za dodavanje podataka u tablice u bazi schemi "gold".  Skripta uključuje try-catch blok za hvatanje i ispisivanje eventualnih grešaka tijekom procesa dodavanja podataka. Kroz proceduru gold.učitaj_podatke, korisnik može jednostavno pokrenuti sve naredbe za dodavanje podataka u tablice u bazi podataka "gold". Nakon što se procedura izvrši, svi podaci u tim tablicama će biti dodani.
    Upozorenja:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za dodavanje podataka u tablice u schemi podataka "gold". Prije toga potrebno je pokrenuti odgovarajuće skripte za kreiranje tablica. Također, budite oprezni prilikom dodavanja podataka jer će svi podaci u tim tablicama biti dodani.

*/
CREATE OR ALTER PROCEDURE gold.učitaj_podatke_interno AS
	BEGIN
		set nocount on;
		SET XACT_ABORT ON
		begin try
			begin transaction
			DECLARE @početno_vrijeme DATETIME2, @završno_vrijeme DATETIME2;
			SET @početno_vrijeme= GETDATE();
			PRINT('Proces kreiranja tablica počeo je : ' + CAST(FORMAT(@početno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			DECLARE @MinDate DATE;
			DECLARE @MaxDate DATE;
			SET @MinDate=(SELECT MIN(d) as min_date FROM( 
						SELECT CAST(MIN(order_purchase_timestamp) AS DATE) AS d
						FROM silver.erp_orders
						UNION ALL
						SELECT MIN(CAST(order_delivered_customer_date AS DATE))
						FROM silver.erp_orders
						UNION ALL
						SELECT MIN(CAST(order_estimated_delivery_date AS DATE))
						FROM silver.erp_orders
						UNION ALL
						SELECT MIN(CAST(lead_date AS DATE))
						FROM silver.crm_leads
						UNION ALL
						SELECT MIN(CAST(interaction_date AS DATE))
						FROM silver.crm_interactions
						UNION ALL
						SELECT MIN(CAST(date_performance AS DATE))
						FROM silver.marketing_performance
						UNION ALL
						SELECT MIN(CAST(cost_date AS DATE))
						FROM silver.finance_operating_costs
						UNION ALL
						SELECT MIN(CAST(date_sales_budget AS DATE))
						FROM silver.finance_sales_budget
						UNION ALL
						SELECT MIN(CAST(snapshot_date AS DATE))
						FROM silver.operations_inventory
						UNION ALL
						SELECT MIN(CAST(return_date AS DATE))
						FROM silver.returns_returns
						)AS min_date)

			SET @MaxDate=(SELECT MAX(d) as max_date FROM( 
						SELECT CAST(MAX(order_purchase_timestamp) AS DATE) AS d
						FROM silver.erp_orders
						UNION ALL
						SELECT MAX(CAST(order_delivered_customer_date AS DATE))
						FROM silver.erp_orders
						UNION ALL
						SELECT MAX(CAST(order_estimated_delivery_date AS DATE))
						FROM silver.erp_orders
						UNION ALL
						SELECT MAX(CAST(lead_date AS DATE))
						FROM silver.crm_leads
						UNION ALL
						SELECT MAX(CAST(interaction_date AS DATE))
						FROM silver.crm_interactions
						UNION ALL
						SELECT MAX(CAST(date_performance AS DATE))
						FROM silver.marketing_performance
						UNION ALL
						SELECT MAX(CAST(cost_date AS DATE))
						FROM silver.finance_operating_costs
						UNION ALL
						SELECT MAX(CAST(date_sales_budget AS DATE))
						FROM silver.finance_sales_budget
						UNION ALL
						SELECT MAX(CAST(snapshot_date AS DATE))
						FROM silver.operations_inventory
						UNION ALL
						SELECT MAX(CAST(return_date AS DATE))
						FROM silver.returns_returns
					) as max_date );

			WITH cte_raspon_date AS(
			SELECT @MinDate as FullDate
			UNION ALL
			SELECT DATEADD(Day,1,FullDate) FROM  cte_raspon_date WHERE FullDate<@MaxDate)
			INSERT INTO gold.dim_date(date_key, full_date, day_number, day_name, month_number, month_name, quarter_number, week_number, year_number,is_weekend)
			SELECT
				REPLACE(FullDate, '-',''),
				FullDate,
				DATEPART(DAY,FullDate) as day_number,
				DATENAME(WEEKDAY,FullDate)as day_name,
				DATEPART(MONTH,FullDate) as month_number,
				DATENAME(MONTH, FullDate) as month_name,
				DATEPART(QUARTER, FullDate) AS quarter_number,
				DATEPART(WEEK, FullDate) AS week_number,
				YEAR(FullDate) as year_number,
				CASE 
					WHEN DATENAME(WEEKDAY,FullDate)='Saturday' THEN 1
					WHEN DATENAME(WEEKDAY,FullDate)='Sunday' THEN 1
					ELSE 0	
				END as is_weekend
			FROM cte_raspon_date
			OPTION (MAXRECURSION 0);
			PRINT('-- Podaci su uneseni u tablicu gold.dim_date --');

			INSERT INTO gold.dim_customer(customer_id, customer_full_name, email, customer_birthdate, customer_age, customer_segment, acquisition_channel, first_contact_date, last_contact_date, city, state)
			SELECT
					ec.customer_id, 
					ec.customer_full_name, 
					ec.email, 
					ec.customer_birthdate, 
					ec.customer_age,
					ccp.customer_segment,
					ccp.acquisition_channel, 
					ccp.first_contact_date, 
					ccp.last_contact_date,
					ec.city,
					ec.city_state
			FROM silver.erp_customers ec INNER JOIN silver.crm_customer_profile ccp ON ec.customer_id= ccp.customer_id ORDER BY customer_id;
				PRINT('-- Podaci su uneseni u tablicu gold.dim_customer --');

			INSERT INTO gold.dim_product_category(product_category_name)
			SELECT DISTINCT
				product_category_name
			FROM silver.erp_products;
			PRINT('-- Podaci su uneseni u tablicu gold.dim_product_category --');

			INSERT INTO gold.dim_product(product_id, product_category_key, product_name, base_price, weight_g, length_cm, height_cm, width_cm)
			SELECT
				ep.product_id, 
				dpc.product_category_key, 
				ep.product_name, 
				ep.base_price, 
				ep.weight_g, 
				ep.length_cm, 
				ep.height_cm, 
				ep.width_cm
			FROM silver.erp_products ep INNER JOIN gold.dim_product_category dpc ON ep.product_category_name=dpc.product_category_name;
			PRINT('-- Podaci su uneseni u tablicu gold.dim_product --');


			INSERT INTO gold.dim_seller(seller_id, seller_full_name, seller_email, seller_birthdate, seller_age, seller_city, seller_state)
			SELECT
				seller_id, 
				seller_full_name, 
				seller_email, 
				seller_birthdate,  
				seller_age, 
				seller_city, 
				seller_state
			FROM silver.erp_sellers;
			PRINT('-- Podaci su uneseni u tablicu gold.dim_seller --');

			INSERT INTO gold.dim_warehouse (warehouse_id, warehouse_name, warehouse_address, warehouse_city, capacity_m3, warehouse_phone, warehouse_email, warehouse_status)
			SELECT warehouse_id, 
				   warehouse_name, 
				   warehouse_address, 
				   warehouse_city, 
				   capacity_m3, 
				   warehouse_phone, 
				   warehouse_email,
				   warehouse_status
			FROM silver.erp_warehouse;

			PRINT '-- Podaci su uneseni u tablicu gold.dim_warehouse --';

			INSERT INTO gold.dim_campaign (campaign_id, campaign_name, channel, start_date_campaign, end_date_campaign, budget)
			SELECT
				campaign_id,
				campaign_name,
				channel,
				start_date_campaigns,
				end_date_campaigns,
				budget
			FROM silver.marketing_campaigns
			PRINT '-- Podaci su uneseni u tablicu gold.dim_campaign --';

			INSERT INTO gold.dim_supplier (supplier_id, supplier_name, supplier_state, lead_time_days, avg_unit_cost)
			SELECT
				supplier_id, 
				supplier_name, 
				state_suppliers, 
				lead_time_days, 
				avg_unit_cost
			FROM silver.operations_suppliers
			PRINT '-- Podaci su uneseni u tablicu gold.dim_supplier --';
	
			INSERT INTO gold.fact_sales(order_id, order_item, date_order_purchase_key, date_order_delivered_key, date_order_estimated_delivery_key, customer_key, product_key, 
				seller_key, order_status, order_purchase_timestamp,
				order_delivered_customer_date, quantity, price, total_amount)
			SELECT eo.order_id, 
				   order_item, 
				   dopk.date_key as date_order_purchase_key, 
				   dodk.date_key as date_order_delivered_key, 
				   doedk.date_key as date_order_estimated_delivery_key, 
				   dc.customer_key, 
				   dp.product_key, 
				   ds.seller_key, 
				   order_status, 
				   order_purchase_timestamp,
				   order_delivered_customer_date,  
				   quantity, 
				   price, 
				   total_amount
			FROM silver.erp_orders eo 
			INNER JOIN silver.erp_order_items eoi ON eo.order_id=eoi.order_id
			INNER JOIN gold.dim_date dopk ON dopk.date_key=REPLACE(CAST(eo.order_purchase_timestamp AS DATE),'-','')
			LEFT JOIN gold.dim_date dodk ON dodk.date_key=REPLACE(CAST(eo.order_delivered_customer_date AS DATE),'-','')
			INNER JOIN gold.dim_date doedk ON doedk.date_key=REPLACE(CAST(eo.order_estimated_delivery_date AS DATE),'-','')
			INNER JOIN gold.dim_customer dc ON eo.customer_id=dc.customer_id
			INNER JOIN gold.dim_product dp ON eoi.product_id=dp.product_id
			INNER JOIN gold.dim_seller ds ON eoi.seller_id=ds.seller_id;
			PRINT('-- Podaci su uneseni u tablicu gold.fact_sales --');

			INSERT INTO gold.fact_payment(order_id, date_key, customer_key, payment_type, payment_installments, items_total, shipping_cost, payment_value)
			SELECT
				ep.order_id,
				dd.date_key, 
				dc.customer_key, 
				payment_type, 
				payment_installments, 
				items_total, 
				shipping_cost, 
				payment_value
			FROM silver.erp_payments ep
				INNER JOIN silver.erp_orders eo ON eo.order_id= ep.order_id
				INNER JOIN gold.dim_customer dc ON dc.customer_id=eo.customer_id
				INNER JOIN gold.dim_date dd ON dd.date_key=REPLACE(CAST(eo.order_purchase_timestamp AS DATE),'-','')
				ORDER BY eo.order_id;
			PRINT '-- Podaci su uneseni u tablicu gold.fact_payment --';

			INSERT INTO gold.fact_review(review_id, order_id, date_key, customer_key, review_score, review_comment_title)
			SELECT
				er.review_id, 
				er.order_id, 
				dd.date_key, 
				dc.customer_key,
				er.review_score, 
				er.review_comment_title
			FROM silver.erp_reviews er
				INNER JOIN silver.erp_orders eo ON eo.order_id=er.order_id
				LEFT JOIN gold.dim_date dd ON dd.date_key=REPLACE(CAST(eo.order_delivered_customer_date AS DATE), '-','')
				INNER JOIN gold.dim_customer dc ON dc.customer_id=eo.customer_id;
			PRINT '-- Podaci su uneseni u tablicu gold.fact_review --';

			INSERT INTO gold.fact_interaction (interaction_id, customer_key, seller_key, date_key, interaction_date, interaction_type, outcome)
			SELECT ci.interaction_id, 
				   dc.customer_key, 
				   ds.seller_key, 
				   dd.date_key, 
				   ci.interaction_date, 
				   ci.interaction_type, 
				   ci.outcome
			FROM silver.crm_interactions ci
				INNER JOIN gold.dim_customer dc ON dc.customer_id=ci.customer_id
				INNER JOIN gold.dim_seller ds ON ds.seller_id=ci.seller_id
				INNER JOIN gold.dim_date dd ON dd.date_key=REPLACE(CAST(ci.interaction_date AS DATE),'-','')

			PRINT '-- Podaci su uneseni u tablicu gold.fact_interaction --';

			INSERT INTO gold.fact_lead(lead_id, customer_key, date_key, lead_source, is_qualified, is_converted)
			SELECT 
				cl.lead_id, 
				dc.customer_key, 
				dd.date_key, 
				cl.lead_source, 
				cl.is_qualified, 
				cl.is_converted
			FROM silver.crm_leads cl
			INNER JOIN gold.dim_date dd ON dd.date_key=REPLACE(cl.lead_date,'-','')
			INNER JOIN gold.dim_customer dc ON dc.customer_id=cl.customer_id
			PRINT '-- Podaci su uneseni u tablicu gold.fact_lead --';

			INSERT INTO gold.fact_marketing_performance(date_key, campaign_key, impressions, clicks, leads, conversions, spend)
			SELECT dd.date_key, 
				   dc.campaign_key, 
				   mp.impressions, 
				   mp.clicks, 
				   mp.leads, 
				   mp.conversions, 
				   mp.spend
			FROM silver.marketing_performance mp
			INNER JOIN gold.dim_date dd ON dd.date_key= REPLACE(mp.date_performance,'-','')
			INNER JOIN gold.dim_campaign dc ON dc.campaign_id=mp.campaign_id
			PRINT '-- Podaci su uneseni u tablicu gold.fact_marketing_performance --';

			INSERT INTO gold.fact_operating_cost(cost_id, date_key, cost_date, operating_cost_state, cost_type, cost_amount)
			SELECT foc.cost_id,
				dd.date_key,
				foc.cost_date,
				foc.operating_cost_state,
				foc.cost_type,
				foc.cost_amount
			FROM silver.finance_operating_costs foc
			INNER JOIN gold.dim_date dd ON dd.date_key= REPLACE(CAST(foc.cost_date AS DATE),'-','');
			PRINT '-- Podaci su uneseni u tablicu gold.fact_operating_cost --';

			INSERT INTO gold.fact_sales_budget (date_key, state_sales_budget, product_category_key, budget_amount)
			SELECT dd.date_key,
				   fsb.state_sales_budget,
				   dpc.product_category_key,
				   fsb.budget_amount
			FROM silver.finance_sales_budget fsb
			INNER JOIN gold.dim_date dd ON dd.date_key=REPLACE(fsb.date_sales_budget,'-','')
			INNER JOIN gold.dim_product_category dpc ON dpc.product_category_name=fsb.product_category_name;
			PRINT '-- Podaci su uneseni u tablicu gold.fact_sales_budget --';

			INSERT INTO gold.fact_inventory_snapshot (date_key, product_key, warehouse_key, stock_quantity, reserved_quantity, reorder_point, available_quantity)
			SELECT dd.date_key,
				   dp.product_key,
				   dw.warehouse_key,
				   oi.stock_quantity,
				   oi.reserved_quantity,
				   oi.reorder_point,
				   oi.stock_quantity-oi.reserved_quantity as available_quantity
			FROM silver.operations_inventory oi
			INNER JOIN gold.dim_date dd ON dd.date_key=REPLACE(oi.snapshot_date,'-','')
			INNER JOIN gold.dim_product dp ON dp.product_id=oi.product_id
			INNER JOIN gold.dim_warehouse dw ON dw.warehouse_id=oi.warehouse_id
			PRINT '-- Podaci su uneseni u tablicu gold.fact_inventory_snapshot --';

			INSERT INTO gold.fact_product_supplier(product_key, supplier_key, unit_cost)
			SELECT dp.product_key,
				   ds.supplier_key,
				   osp.unit_cost
			FROM silver.operations_supplier_product osp
			INNER JOIN gold.dim_product dp ON dp.product_id=osp.product_id
			INNER JOIN gold.dim_supplier ds ON ds.supplier_id=osp.supplier_id
			PRINT '-- Podaci su uneseni u tablicu gold.fact_product_supplier --';

			INSERT INTO gold.fact_return (return_id, order_id, order_item, date_key, customer_key, product_key, seller_key, return_quantity, return_reason, refund_amount)
			SELECT rr.return_id,
				   rr.order_id, 
				   rr.order_item,
				   dd.date_key,
				   dc.customer_key,
				   dp.product_key,
				   ds.seller_key,
				   rr.return_quantity,
				   rr.return_reason,
				   rr.refund_amount
			FROM silver.returns_returns rr
			INNER JOIN gold.dim_date dd ON dd.date_key=REPLACE(CAST(rr.return_date as DATE),'-','')
			INNER JOIN gold.dim_customer dc ON dc.customer_id=rr.customer_id
			INNER JOIN gold.dim_product dp ON dp.product_id=rr.product_id
			INNER JOIN gold.dim_seller ds ON ds.seller_id=rr.seller_id;
			PRINT '-- Podaci su uneseni u tablicu gold.fact_return --';
			SET @završno_vrijeme= GETDATE();
			PRINT('Proces kreiranja tablica završio je : ' + CAST(FORMAT(@završno_vrijeme,'yyyy-mm-dd HH:mm:ss:fff') AS NVARCHAR));
			PRINT('Ukupno trajanje procesa kreiranja tablica: ' + CAST(DATEDIFF(second, @početno_vrijeme, @završno_vrijeme)as NVARCHAR) + ' s')
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION;
			END
			PRINT '';
			PRINT 'Dogodila se greška. Poništavaju se sve transakcije.';
			PRINT 'ERROR_MESSAGE: ' + ERROR_MESSAGE();
			PRINT 'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
			PRINT 'ERROR_LINE: ' + CAST(ERROR_LINE() AS VARCHAR(20));
		END CATCH;
	END;
	GO

--EXECUTE gold.učitaj_podatke_interno
go
CREATE OR ALTER PROCEDURE gold.učitaj_podatke
AS
BEGIN
	set nocount on;
	SET XACT_ABORT ON
    BEGIN TRY
        EXEC sys.sp_executesql
            N'EXEC gold.učitaj_podatke_interno;';
    END TRY
    BEGIN CATCH
		IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
        PRINT 'Dogodila se greška. Poništavaju se sve transakcije.';
        PRINT 'ERROR_MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
        PRINT 'ERROR_LINE: ' + CAST(ERROR_LINE() AS VARCHAR(20));
    END CATCH;
END;
GO

EXEC gold.učitaj_podatke;
GO
