/*
   Naslov: Skripta za provjeru stupaca tablica gold sloja
    Autor: Marko Vresk
    Datum: 15.10.2026. 
    Opis: Ova skripta provjerava sve stupce tablica gold sloja u SQL Serveru. Provjere uključuju provjeru duplikata, null vrijednosti, valjanosti datuma, negativnosti vrijednosti, razmaka u nazivima i distinktnih naziva.
    Upozorenje: Ova skripta ne mijenja podatke u tablicama gold sloja, već samo provjerava njihovu valjanost. Preporučuje se redovito pokretanje ove skripte kako bi se osigurala kvaliteta podataka u tablicama gold sloja.
*/
-- ================================================================
-- Provjere za tablicu 1.gold.dim_date
-- ================================================================
-- 1.1. stupac date_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_date', @naziv_stupca='date_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_date', @ključ='date_key', @naziv_stupca='date_key';
-- 1.2. stupac full_date
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_date', @naziv_stupca='full_date';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_date', @ključ='date_key', @naziv_stupca='full_date';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_date', @ključ='date_key', @naziv_stupca='full_date';
-- 1.3. stupac day_number
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date', @naziv_stupca='day_number';
-- 1.4. stupac day_name
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date', @naziv_stupca='day_name';
-- 1.5. stupac month_number
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date', @naziv_stupca='month_number';
-- 1.6. stupac month_name
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date', @naziv_stupca='month_name';
-- 1.5. stupac month_number + 1.6. stupac month_name
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date', @naziv_stupca='CAST(month_number AS VARCHAR(50)) + '' '' + month_name';
-- 1.7. stupac quarter_number
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date',  @naziv_stupca='quarter_number';
-- 1.8. stupac week_number
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date',  @naziv_stupca='week_number';
-- 1.9. stupac year_number
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_date', @naziv_stupca='year_number';
-- 1.10. stupac is_weekend
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_date', @ključ='date_key', @naziv_stupca='is_weekend';
SELECT * FROM gold.dim_date WHERE (day_name IN ('Saturday', 'Sunday') AND is_weekend=0) OR (day_name NOT IN ('Saturday', 'Sunday') AND is_weekend=1)

-- ================================================================
-- Provjere za tablicu 2.gold.dim_customer
-- ================================================================
-- 2.1. stupac customer_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_customer', @naziv_stupca='customer_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @naziv_stupca='customer_key';
-- 2.2. stupac customer_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_customer', @naziv_stupca='customer_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_id';
-- 2.3. stupac customer_full_name
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_full_name';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_full_name';
-- 2.4. stupac email
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_customer', @naziv_stupca='email';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='email';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='email';
-- 2.5. stupac customer_birthdate
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_birthdate';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_birthdate';
-- 2.6. stupac customer_age
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_age';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='customer_age';
-- 2.7. stupac customer_segment
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_customer', @naziv_stupca='customer_segment';
-- 2.8. stupac acquisition_channel
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_customer', @naziv_stupca='acquisition_channel';
-- 2.9. stupac first_contact_date
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='first_contact_date';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='first_contact_date';
-- 2.10. stupac last_contact_date
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='last_contact_date';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_customer', @ključ='customer_id', @naziv_stupca='last_contact_date';
-- 2.11. stupac city
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_customer', @naziv_stupca='city';
-- 2.12. stupac state
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_customer', @naziv_stupca='state';

-- ================================================================
-- Provjere za tablicu 3.gold.dim_product_category
-- ================================================================
-- 3.1. stupac product_category_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_product_category', @naziv_stupca='product_category_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product_category', @naziv_stupca='product_category_key';
-- 3.2. stupac product_category_name
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_product_category', @naziv_stupca='product_category_name';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_product_category', @naziv_stupca='product_category_name';

-- ================================================================
-- Provjere za tablicu 4.gold.dim_product
-- ================================================================
-- 4.1. stupac product_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_product', @naziv_stupca='product_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @naziv_stupca='product_key';
-- 4.2. stupac product_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_product', @naziv_stupca='product_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='product_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='product_id';
-- 4.3. stupac product_category_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='product_category_key';
-- 4.4. stupac product_name
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_product', @naziv_stupca='product_name';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='product_name';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='product_name';
-- 4.5. stupac base_price
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='base_price';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='base_price';
-- 4.6. stupac weight_g
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='weight_g';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='weight_g';
-- 4.7. stupac length_cm
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='length_cm';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='length_cm';
-- 4.8. stupac height_cm
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='height_cm';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='height_cm';
-- 4.9. stupac width_cm
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='width_cm';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_product', @ključ='product_id', @naziv_stupca='width_cm';


-- ================================================================
-- Provjere za tablicu 5.gold.dim_seller
-- ================================================================
-- 5.1. stupac seller_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_seller', @naziv_stupca='seller_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_seller', @naziv_stupca='seller_key';
-- 5.2. stupac seller_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_seller', @naziv_stupca='seller_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_id';
-- 5.3. stupac seller_full_name
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_full_name';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_full_name';
-- 5.4. stupac seller_email
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_seller', @naziv_stupca='seller_email';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_email';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_email';
-- 5.5. stupac seller_birthdate
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_birthdate';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_birthdate';
-- 5.6. stupac seller_age
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_age';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_seller', @ključ='seller_id', @naziv_stupca='seller_age';
-- 5.7. stupac seller_city
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_seller', @naziv_stupca='seller_city';
-- 5.8. stupac seller_state
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_seller', @naziv_stupca='seller_state';

-- ================================================================
-- Provjere za tablicu 6.gold.dim_warehouse
-- ================================================================
-- 6.1. stupac warehouse_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_key';
-- 6.2. stupac warehouse_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_id';
-- 6.3. stupac warehouse_name
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_name';
-- 6.4. stupac warehouse_address
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_address';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_address';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_address';
-- 6.5. stupac warehouse_city
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_city';
-- 6.6. stupac capacity_m3
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='capacity_m3';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='capacity_m3';
-- 6.7. stupac warehouse_phone
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_phone';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_phone';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_phone';
-- 6.8. stupac warehouse_email
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_email';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_email';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_warehouse', @ključ='warehouse_id', @naziv_stupca='warehouse_email';
-- 6.9. stupac warehouse_status
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_warehouse', @naziv_stupca='warehouse_status';

-- ================================================================
-- Provjere za tablicu 7.gold.dim_campaign
-- ================================================================
-- 7.1. stupac campaign_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_campaign', @naziv_stupca='campaign_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_campaign', @naziv_stupca='campaign_key';
-- 7.2. stupac campaign_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_campaign', @naziv_stupca='campaign_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='campaign_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='campaign_id';
-- 7.3. stupac campaign_name
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='campaign_name';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='campaign_name';
-- 7.4. stupac channel
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_campaign', @naziv_stupca='channel';
-- 7.3. stupac campaign_name + 7.4. stupac channel
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_campaign', @naziv_stupca='campaign_name + '' '' + channel';
-- 7.5. stupac start_date_campaign
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='start_date_campaign';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='start_date_campaign';
-- 7.6. stupac end_date_campaign
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='end_date_campaign';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='end_date_campaign';
-- 7.7. stupac budget
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='budget';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_stupca='budget';

-- ================================================================
-- Provjere za tablicu 8.gold.dim_supplier
-- ================================================================
-- 8.1. stupac supplier_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_supplier', @naziv_stupca='supplier_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_supplier', @naziv_stupca='supplier_key';
-- 8.2. stupac supplier_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_supplier', @naziv_stupca='supplier_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='supplier_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='supplier_id';
-- 8.3. stupac supplier_name
EXEC gold.provjera_duplikata @naziv_tablice='gold.dim_supplier', @naziv_stupca='supplier_name';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='supplier_name';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='supplier_name';
-- 8.4. stupac supplier_state
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.dim_supplier', @naziv_stupca='supplier_state';
-- 8.5. stupac lead_time_days
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='lead_time_days';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='lead_time_days';
-- 8.6. stupac avg_unit_cost
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='avg_unit_cost';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.dim_supplier', @ključ='supplier_id', @naziv_stupca='avg_unit_cost';

-- ================================================================
-- Provjere za tablicu 9.gold.fact_sales
-- ================================================================
-- 9.1. stupac sales_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_sales', @naziv_stupca='sales_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @naziv_stupca='sales_key';
-- 9.2. stupac order_id
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='order_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='order_id';
-- 9.3. stupac order_item
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='order_item';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='order_item';
-- 9.4. stupac date_order_purchase_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='date_order_purchase_key';
-- 9.5. stupac date_order_delivered_key
SELECT * FROM gold.fact_sales WHERE date_order_delivered_key IS NULL AND order_status ='delivered'
-- 9.6. stupac date_order_estimated_delivery_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='date_order_estimated_delivery_key';
-- 9.7. stupac customer_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='customer_key';
-- 9.8. stupac product_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='product_key';
-- 9.9. stupac seller_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='seller_key';
-- 9.10. stupac order_status
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_sales', @naziv_stupca='order_status';
-- 9.11. stupac order_purchase_timestamp
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='order_purchase_timestamp';
-- 9.12. stupac order_delivered_customer_date
SELECT * FROM gold.fact_sales WHERE order_delivered_customer_date IS NULL AND order_status ='delivered'
-- 9.13. stupac quantity
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='quantity';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='quantity';
-- 9.14. stupac price
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='price';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='price';
-- 9.15. stupac total_amount
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='total_amount';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_sales', @ključ='sales_key', @naziv_stupca='total_amount';

-- ================================================================
-- Provjere za tablicu 10.gold.fact_payment
-- ================================================================
-- 10.1. stupac payment_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_payment', @naziv_stupca='payment_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @naziv_stupca='payment_key';
-- 10.2. stupac order_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_payment', @naziv_stupca='order_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='order_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='order_id';
-- 10.3. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='date_key';
-- 10.4. stupac customer_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='customer_key';
-- 10.5. stupac payment_type
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_payment', @naziv_stupca='payment_type';
-- 10.6. stupac payment_installments
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='payment_installments';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='payment_installments';
-- 10.7. stupac items_total
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='items_total';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='items_total';
-- 10.8. stupac shipping_cost
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='shipping_cost';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='shipping_cost';
-- 10.9. stupac payment_value
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='payment_value';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_payment', @ključ='payment_key', @naziv_stupca='payment_value';

-- ================================================================
-- Provjere za tablicu 11.gold.fact_review
-- ================================================================
-- 11.1. stupac review_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @naziv_stupca='review_key';
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_review', @naziv_stupca='review_key';
-- 11.2. stupac review_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_review', @naziv_stupca='review_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='review_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='review_id';
-- 11.3. stupac order_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_review', @naziv_stupca='order_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='order_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='order_id';
-- 11.4. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='date_key';
-- 11.5. stupac customer_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='customer_key';
-- 11.6. stupac review_score
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='review_score';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_review', @naziv_stupca='review_score';
-- 11.7. stupac review_comment_title
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_review', @ključ='review_key', @naziv_stupca='review_comment_title';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_review', @naziv_stupca='review_comment_title';

-- ================================================================
-- Provjere za tablicu 12.gold.fact_interaction
-- ================================================================
-- 12.1. stupac interaction_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_interaction', @naziv_stupca='interaction_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @naziv_stupca='interaction_key';
-- 12.2. stupac interaction_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_interaction', @naziv_stupca='interaction_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='interaction_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='interaction_id';
-- 12.3. stupac customer_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='customer_key';
-- 12.4. stupac seller_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='seller_key';
-- 12.5. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='date_key';
-- 12.6. stupac interaction_date
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='interaction_date';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='interaction_date';
-- 12.7. stupac interaction_type
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='interaction_type';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_interaction', @naziv_stupca='interaction_type';
-- 12.8. stupac outcome
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_interaction', @ključ='interaction_key', @naziv_stupca='outcome';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_interaction', @naziv_stupca='outcome';

-- ================================================================
-- Provjere za tablicu 13.gold.fact_lead
-- ================================================================
-- 13.1. stupac lead_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_lead', @naziv_stupca='lead_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @naziv_stupca='lead_key';
-- 13.2. stupac lead_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_lead', @naziv_stupca='lead_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='lead_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='lead_id';
-- 13.3. stupac customer_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='customer_key';
-- 13.4. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='date_key';
-- 13.5. stupac lead_source
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='lead_source';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_lead', @naziv_stupca='lead_source';
-- 13.6. stupac is_qualified
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='is_qualified';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_lead', @naziv_stupca='is_qualified';
-- 13.7. stupac is_converted
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_lead', @ključ='lead_key', @naziv_stupca='is_converted';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_lead', @naziv_stupca='is_converted';

-- ================================================================
-- Provjere za tablicu 14.gold.fact_marketing_performance
-- ================================================================
-- 14.1. stupac marketing_performance_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_marketing_performance', @naziv_stupca='marketing_performance_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @naziv_stupca='marketing_performance_key';
-- 14.2. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='date_key';
-- 14.3. stupac campaign_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='campaign_key';
-- 14.4. stupac impressions
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='impressions';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='impressions';
-- 14.5. stupac clicks
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='clicks';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='clicks';
-- 14.6. stupac leads
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='leads';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='leads';
-- 14.7. stupac conversions
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='conversions';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='conversions';
-- 14.8. stupac spend
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='spend';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_marketing_performance', @ključ='marketing_performance_key', @naziv_stupca='spend';


-- ================================================================
-- Provjere za tablicu 15.gold.fact_operating_cost
-- ================================================================
-- 15.1. stupac operating_cost_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_operating_cost', @naziv_stupca='operating_cost_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @naziv_stupca='operating_cost_key';
-- 15.2. stupac cost_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_operating_cost', @naziv_stupca='cost_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_id';
-- 15.3. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='date_key';
-- 15.4. stupac cost_date
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_date';
EXEC gold.provjera_valjanosti_datuma @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_date';
-- 15.5. stupac operating_cost_state
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='operating_cost_state';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_operating_cost', @naziv_stupca='operating_cost_state';
-- 15.6. stupac cost_type
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_type';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_operating_cost', @naziv_stupca='cost_type';
-- 15.7. stupac cost_amount
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_amount';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_operating_cost', @ključ='operating_cost_key', @naziv_stupca='cost_amount';

-- ================================================================
-- Provjere za tablicu 16.gold.fact_sales_budget
-- ================================================================
-- 16.1. stupac sales_budget_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_sales_budget', @naziv_stupca='sales_budget_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales_budget', @naziv_stupca='sales_budget_key';
-- 16.2. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales_budget', @ključ='sales_budget_key', @naziv_stupca='date_key';
-- 16.3. stupac state_sales_budget
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales_budget', @ključ='sales_budget_key', @naziv_stupca='state_sales_budget';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_sales_budget', @naziv_stupca='state_sales_budget';
-- 16.4. stupac product_category_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales_budget', @ključ='sales_budget_key', @naziv_stupca='product_category_key';
-- 16.5. stupac budget_amount
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_sales_budget', @ključ='sales_budget_key', @naziv_stupca='budget_amount';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_sales_budget', @ključ='sales_budget_key', @naziv_stupca='budget_amount';

-- ================================================================
-- Provjere za tablicu 17.gold.fact_inventory_snapshot
-- ================================================================
-- 17.1. stupac inventory_snapshot_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_inventory_snapshot', @naziv_stupca='inventory_snapshot_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @naziv_stupca='inventory_snapshot_key';
-- 17.2. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='date_key';
-- 17.3. stupac product_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='product_key';
-- 17.4. stupac warehouse_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='warehouse_key';
-- 17.5. stupac stock_quantity
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='stock_quantity';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='stock_quantity';
-- 17.6. stupac reserved_quantity
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='reserved_quantity';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='reserved_quantity';
-- 17.7. stupac reorder_point
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='reorder_point';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='reorder_point';
-- 17.8. stupac available_quantity
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='available_quantity';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_inventory_snapshot', @ključ='inventory_snapshot_key', @naziv_stupca='available_quantity';

-- ================================================================
-- Provjere za tablicu 18.gold.fact_product_supplier
-- ================================================================
-- 18.1. stupac product_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_product_supplier', @ključ='product_key', @naziv_stupca='product_key';
-- 18.2. stupac supplier_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_product_supplier', @ključ='product_key', @naziv_stupca='supplier_key';
-- 18.3. stupac unit_cost
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_product_supplier', @ključ='product_key', @naziv_stupca='unit_cost';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_product_supplier', @ključ='product_key', @naziv_stupca='unit_cost';

-- ================================================================
-- Provjere za tablicu 19.gold.fact_return
-- ================================================================
-- 19.1. stupac return_key
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_return', @naziv_stupca='return_key';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @naziv_stupca='return_key';
-- 19.2. stupac return_id
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_return', @naziv_stupca='return_id';
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='return_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='return_id';
-- 19.3. stupac order_id
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='order_id';
EXEC gold.provjera_razmaka_u_nazivima @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='order_id';
-- 19.4. stupac order_item
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='order_item';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='order_item';
-- 19.3. stupac order_id + 19.4. stupac order_item
EXEC gold.provjera_duplikata @naziv_tablice='gold.fact_return', @naziv_stupca='return_id + '' ''+ CAST(order_item AS VARCHAR(50))';
-- 19.5. stupac date_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='date_key';
-- 19.6. stupac customer_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='customer_key';
-- 19.7. stupac product_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='product_key';
-- 19.8. stupac seller_key
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='seller_key';
-- 19.9. stupac return_quantity
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='return_quantity';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='return_quantity';
-- 19.10. stupac return_reason
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='return_reason';
EXEC gold.provjera_distinktnih_naziva @naziv_tablice='gold.fact_return', @naziv_stupca='return_reason';
-- 19.11. stupac refund_amount
EXEC gold.provjera_null_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='refund_amount';
EXEC gold.provjera_negativnosti_vrijednosti @naziv_tablice='gold.fact_return', @ključ='return_key', @naziv_stupca='refund_amount';

-- ================================================================
-- Provjere referencijalnog integriteta
-- ================================================================
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.dim_product', @naziv_tablice_PK='gold.dim_product_category', @naziv_stupca_FK='product_category_key', @naziv_stupca_PK='product_category_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_order_purchase_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_order_delivered_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_order_estimated_delivery_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales', @naziv_tablice_PK='gold.dim_customer', @naziv_stupca_FK='customer_key', @naziv_stupca_PK='customer_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales', @naziv_tablice_PK='gold.dim_product', @naziv_stupca_FK='product_key', @naziv_stupca_PK='product_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales', @naziv_tablice_PK='gold.dim_seller', @naziv_stupca_FK='seller_key', @naziv_stupca_PK='seller_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_payment', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_payment', @naziv_tablice_PK='gold.dim_customer', @naziv_stupca_FK='customer_key', @naziv_stupca_PK='customer_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_review', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_review', @naziv_tablice_PK='gold.dim_customer', @naziv_stupca_FK='customer_key', @naziv_stupca_PK='customer_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_interaction', @naziv_tablice_PK='gold.dim_customer', @naziv_stupca_FK='customer_key', @naziv_stupca_PK='customer_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_interaction', @naziv_tablice_PK='gold.dim_seller', @naziv_stupca_FK='seller_key', @naziv_stupca_PK='seller_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_interaction', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_lead', @naziv_tablice_PK='gold.dim_customer', @naziv_stupca_FK='customer_key', @naziv_stupca_PK='customer_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_lead', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_marketing_performance', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_marketing_performance', @naziv_tablice_PK='gold.dim_campaign', @naziv_stupca_FK='campaign_key', @naziv_stupca_PK='campaign_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_operating_cost', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales_budget', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_sales_budget', @naziv_tablice_PK='gold.dim_product_category', @naziv_stupca_FK='product_category_key', @naziv_stupca_PK='product_category_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_inventory_snapshot', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_inventory_snapshot', @naziv_tablice_PK='gold.dim_product', @naziv_stupca_FK='product_key', @naziv_stupca_PK='product_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_inventory_snapshot', @naziv_tablice_PK='gold.dim_warehouse', @naziv_stupca_FK='warehouse_key', @naziv_stupca_PK='warehouse_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_product_supplier', @naziv_tablice_PK='gold.dim_product', @naziv_stupca_FK='product_key', @naziv_stupca_PK='product_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_product_supplier', @naziv_tablice_PK='gold.dim_supplier', @naziv_stupca_FK='supplier_key', @naziv_stupca_PK='supplier_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_return', @naziv_tablice_PK='gold.dim_date', @naziv_stupca_FK='date_key', @naziv_stupca_PK='date_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_return', @naziv_tablice_PK='gold.dim_customer', @naziv_stupca_FK='customer_key', @naziv_stupca_PK='customer_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_return', @naziv_tablice_PK='gold.dim_product', @naziv_stupca_FK='product_key', @naziv_stupca_PK='product_key';
EXEC gold.provjera_referencijalnog_integriteta @naziv_tablice_FK='gold.fact_return', @naziv_tablice_PK='gold.dim_seller', @naziv_stupca_FK='seller_key', @naziv_stupca_PK='seller_key';
GO

-- ================================================================
-- Dodatne poslovne provjere
-- ================================================================

-- Provjera kontakta kupca: prvi kontakt ne smije biti nakon zadnjeg.
SELECT customer_id, first_contact_date, last_contact_date FROM gold.dim_customer WHERE first_contact_date > last_contact_date;

-- Provjera trajanja kampanje.
EXEC gold.provjera_valjanosti_start_i_end_datuma @naziv_tablice='gold.dim_campaign', @ključ='campaign_id', @naziv_start='start_date_campaign', @naziv_end='end_date_campaign';

-- Isporuka ne smije prethoditi kupnji.
SELECT order_id, order_item, order_purchase_timestamp, order_delivered_customer_date FROM gold.fact_sales WHERE order_delivered_customer_date < order_purchase_timestamp;

-- Količina klikova, leadova i konverzija ne bi trebala premašiti prethodnu fazu.
SELECT marketing_performance_key, impressions, clicks, leads, conversions FROM gold.fact_marketing_performance WHERE clicks > impressions OR conversions > leads;

-- Zaliha: rezervirana količina ne smije biti veća od stanja, a raspoloživa = stanje - rezervirano.
SELECT inventory_snapshot_key, stock_quantity, reserved_quantity, available_quantity FROM gold.fact_inventory_snapshot WHERE reserved_quantity > stock_quantity OR available_quantity <> stock_quantity - reserved_quantity;

-- Količina povrata ne smije biti veća od prodane količine za isti order_id i order_item.
SELECT r.return_id, r.order_id, r.order_item, r.return_quantity, s.quantity FROM gold.fact_return r JOIN gold.fact_sales s ON s.order_id = r.order_id AND s.order_item = r.order_item WHERE r.return_quantity > s.quantity;