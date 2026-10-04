/*
	Naslov: Kreiranje pomočnih pogleda za insert u silver tablice
	Autor: Marko Vresk
	Datum: 02.10.2026.
	Opis: Ova skripta kreira poglede za insert u silver tablice u SQL Serveru. Pojedini pogledi omogućuju filtriranje i transformaciju podataka iz bronze sloja prije nego što se unesu u silver sloj, osiguravajući kvalitetu i integritet podataka.
	Upozorenje: Prilikom kreiranja pogleda, važno je osigurati da su svi potrebni stupci i uvjeti ispravno definirani kako bi se izbjegle pogreške u izvršavanju i osiguralo točno dohvaćanje podataka.
*/
CREATE OR ALTER VIEW silver.erp_customers_view AS
	SELECT * FROM 
		(SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_first_name + ' ' + customer_last_name, email, customer_birthdate ORDER BY customer_first_name + ' ' + customer_last_name) AS duplikati
    FROM bronze.erp_customers) AS t WHERE duplikati = 1;
GO

CREATE OR ALTER VIEW silver.erp_payments_view AS
	SELECT oi.order_id as orderitems_order_id,oi.quantity,oi.price,p.order_id as payments_order_id, p.payment_type, p.payment_installments,  
	CASE 
		WHEN quantity*price != payment_value THEN quantity*price
		ELSE payment_value 
	END as items_total, p.payment_value 
	FROM bronze.erp_order_items oi INNER JOIN bronze.erp_payments p ON oi.order_id=p.order_id;
GO

CREATE OR ALTER VIEW silver.erp_orders_view AS
	SELECT eo.customer_id, eo.order_id, eo.order_status, eo.order_purchase_timestamp, eo.order_delivered_customer_date, eo.order_estimated_delivery_date 
	FROM silver.erp_customers ec INNER JOIN bronze.erp_orders eo ON ec.customer_id=eo.customer_id;
GO

CREATE OR ALTER VIEW silver.erp_reviews_view AS
	SELECT er.order_id, er.review_comment_title, er.review_id, er.review_score  
	FROM silver.erp_orders eo INNER JOIN bronze.erp_reviews er ON eo.order_id=er.order_id;
GO

CREATE OR ALTER VIEW silver.crm_customer_profile_view AS
	SELECT * FROM 
		(SELECT *, ROW_NUMBER()OVER(PARTITION BY customer_id ORDER BY customer_id) as duplikati 
	FROM bronze.crm_customer_profile) as pom WHERE duplikati=1;
GO

CREATE OR ALTER VIEW silver.crm_interactions_view AS
	SELECT ci.interaction_id, ci.customer_id, ci.interaction_date, ci.interaction_type, ci.sales_rep_id, ci.outcome 
	FROM bronze.crm_interactions ci INNER JOIN silver.erp_customers ec ON ci.customer_id=ec.customer_id;
GO

CREATE OR ALTER VIEW silver.crm_leads_view AS
	SELECT  cl.lead_id, cl.customer_id, cl.lead_date, cl.lead_source , cl.is_qualified, cl.is_converted 
	FROM bronze.crm_leads cl INNER JOIN silver.erp_customers ec ON ec.customer_id=cl.customer_id;
GO

CREATE OR ALTER VIEW silver.marketing_performance_view AS
	SELECT * FROM bronze.marketing_performance WHERE date_performance<GETDATE();
GO

 
CREATE OR ALTER VIEW silver.returns_returns_view AS
 SELECT 
	rr.return_id, rr.order_id as rr_order_id, rr.order_item_id, rr.product_id as rr_product_id, rr.seller_id, rr.customer_id as rr_customer_id, rr.return_date, rr.return_quantity, rr.return_reason, rr.refund_amount, 
	oi.order_id as oi_order_id, oi.order_item, oi.price, oi.product_id as oi_product_id, oi.quantity,
	o.customer_id as o_customer_id, o.order_id as o_order_id, o.order_status   
FROM  bronze.returns_returns rr 
INNER JOIN silver.erp_order_items oi ON rr.order_id=oi.order_id AND rr.order_item_id=oi.order_item
INNER JOIN silver.erp_orders o ON rr.order_id=o.order_id;
