/*
    Naslov: Provjere stupaca tablica silver sloja
    Autor: Marko Vresk
    Datum: 30.09.2026.
    Opis: Ova skripta sadrži provjere stupaca tablica silver sloja u SQL Serveru. Provjere uključuju duplikate, null vrijednosti, razmake u nazivima, negativne vrijednosti, valjanost datuma, referencijalni integritet i druge specifične provjere za svaki stupac.
    Upozorenje: Prilikom pozivanja procedura važno je osigurati da su parametri ispravno postavljeni kako bi se izbjegle pogreške u izvršavanju i osiguralo točno dohvaćanje podataka.
*/
-------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------PROVJERE--------------------------------------------------------------------
--Provjere za tablicu 1.silver.erp_customers--

--1.1. stupac customer_id
exec silver.provjera_duplikata @naziv_tablice='silver.erp_customers', @naziv_stupca='customer_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers', @naziv_stupca='customer_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_customers', @naziv_stupca='customer_id';
--1.2. stupac customer_full_name
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='customer_full_name';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_customers', @ključ='customer_id', @naziv_stupca='customer_full_name';
exec silver.provjera_duplikata @naziv_tablice='silver.erp_customers', @naziv_stupca='customer_full_name' ;
--1.3. stupac email
exec silver.provjera_duplikata @naziv_tablice='silver.erp_customers', @naziv_stupca='email';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='email';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_customers', @ključ='customer_id', @naziv_stupca='email';
--1.4 customer_birthdate
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='customer_birthdate';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='customer_birthdate';
--1.5 customer_age
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='customer_age';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_customers', @ključ='customer_id', @naziv_stupca='customer_age';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_customers',  @ključ='customer_id', @naziv_stupca='customer_age';
--1.6. city
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='city';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_customers', @ključ='customer_id', @naziv_stupca='city';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_customers',  @naziv_stupca='city';
--1.7.city_state
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_customers',@ključ='customer_id', @naziv_stupca='city_state';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_customers', @ključ='customer_id', @naziv_stupca='city_state';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_customers',  @naziv_stupca='city_state';
--1.6.city + 1.7.city_state
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_customers',  @naziv_stupca='city +'' ''+ city_state';

--Provjere za tablicu 2.silver.erp_order_items--

--2.1.order_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @naziv_stupca='order_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_order_items', @naziv_stupca='order_id';
--2.2.order_item
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='order_item';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='order_item';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_order_items',  @ključ='order_id', @naziv_stupca='order_item';

WITH Cte_order_item_odgovara_max_order_item AS (
SELECT order_id, MAX(order_item) as max_order_item FROM silver.erp_order_items GROUP BY order_id ),
cte_provjera_duplikata AS(SELECT  order_id, COUNT(*) as duplikat FROM silver.erp_order_items GROUP BY order_id)
SELECT * FROM Cte_order_item_odgovara_max_order_item cte_oiomoi
INNER JOIN cte_provjera_duplikata cte_pd ON cte_pd.order_id=cte_oiomoi.order_id
WHERE cte_oiomoi.max_order_item!=cte_pd.duplikat
ORDER BY cte_oiomoi.order_id ;
--2.3.product_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='product_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='product_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.erp_order_items', @naziv_tablice_PK='silver.erp_products',  @naziv_stupca_FK='product_id', @naziv_stupca_PK='product_id';
--2.4.seller_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='seller_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='seller_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.erp_order_items', @naziv_tablice_PK='silver.erp_sellers',  @naziv_stupca_FK='seller_id', @naziv_stupca_PK='seller_id';
--2.5.quantity
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='quantity';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='quantity';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_order_items',  @ključ='order_id', @naziv_stupca='quantity';
--2.6.price
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='price';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='price';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_order_items',  @ključ='order_id', @naziv_stupca='price';
--2.7 total_amount
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_order_items', @ključ='order_id', @naziv_stupca='total_amount';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_order_items',  @ključ='order_id', @naziv_stupca='total_amount';
--2.8. općenite provjere
exec silver.provjera_duplikata @naziv_tablice='silver.erp_order_items', @naziv_stupca='order_id + '' '' +  CAST(order_item as VARCHAR(50))+ '' '' + product_id + '' ''+seller_id ';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_order_items',  @naziv_stupca=' product_id +'' ''+ CAST(price as varchar(50))';

--Provjere za tablicu 3.silver.erp_orders--

--3.1 order_id
exec silver.provjera_duplikata @naziv_tablice='silver.erp_orders', @naziv_stupca='order_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_orders', @naziv_stupca='order_id';
--3.2 customer_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_orders', @ključ='order_id', @naziv_stupca='customer_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_orders', @ključ='order_id', @naziv_stupca='customer_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.erp_orders', @naziv_tablice_PK='silver.erp_customers',  @naziv_stupca_FK='customer_id', @naziv_stupca_PK='customer_id';
--3.3 order_purchase_timestamp
SELECT* FROM silver.erp_customers WHERE customer_id='CUST009976'
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_orders', @ključ='order_id', @naziv_stupca='order_purchase_timestamp';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.erp_orders',@ključ='order_id', @naziv_stupca='order_purchase_timestamp';
exec silver.provjera_valjanosti_start_i_end_datuma @naziv_tablice = 'silver.erp_orders', @ključ='order_id', @naziv_start ='order_purchase_timestamp', @naziv_end='order_delivered_customer_date';
exec silver.provjera_valjanosti_start_i_end_datuma @naziv_tablice = 'silver.erp_orders', @ključ='order_id', @naziv_start ='order_purchase_timestamp', @naziv_end='order_estimated_delivery_date';
--3.4 order_status
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_orders', @naziv_stupca='order_status';
--3.5 order_delivered_customer_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_orders', @ključ='order_id', @naziv_stupca='order_delivered_customer_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.erp_orders',@ključ='order_id', @naziv_stupca='order_delivered_customer_date';
--3.6 order_estimated_delivery_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_orders', @ključ='order_id', @naziv_stupca='order_estimated_delivery_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.erp_orders',@ključ='order_id', @naziv_stupca='order_estimated_delivery_date';
--3.7 općenite provjere
SELECT DISTINCT order_status, order_delivered_customer_date from silver.erp_orders WHERE order_delivered_customer_date IS NULL;

--Provjere za tablicu 4.silver.erp_payments--

--4.1 order_id
exec silver.provjera_duplikata @naziv_tablice='silver.erp_payments', @naziv_stupca='order_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_payments', @naziv_stupca='order_id';
--4.2 payment_type
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_payments',  @naziv_stupca='payment_type';
--4.3 payment_installments
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_payments',  @naziv_stupca='payment_installments';
--4.4 items_total
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_payments',@ključ='order_id', @naziv_stupca='items_total';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_payments',@ključ='order_id', @naziv_stupca='items_total';
--4.5 shipping_cost
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_payments',@ključ='order_id', @naziv_stupca='shipping_cost';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_payments',@ključ='order_id', @naziv_stupca='shipping_cost';
--4.6 payment_value
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_payments',@ključ='order_id', @naziv_stupca='payment_value';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_payments',@ključ='order_id', @naziv_stupca='payment_value';
--4.7 općenita prvojera
SELECT
    oi.order_id,
    SUM(oi.price * oi.quantity) AS calculated_total,
    MAX(p.payment_value) AS payment_value
FROM silver.erp_order_items oi
INNER JOIN silver.erp_payments p
    ON oi.order_id = p.order_id
GROUP BY oi.order_id
HAVING ROUND(SUM(oi.price * oi.quantity), 2)
    != ROUND(MAX(p.items_total), 2)
ORDER BY oi.order_id;
--SELECT oi.order_id, SUM(oi.price*oi.quantity)as calculated_total, MAX(p.payment_value) as payment_value FROM silver.erp_order_items oi INNER JOIN silver.erp_payments p ON oi.order_id=p.order_id GROUP by oi.order_id HAVING SUM(oi.price*oi.quantity) !=MAX(p.payment_value) ORDER BY oi.order_id ;
/*SELECT oi.order_id, SUM(oi.total_amount) AS calculated_total, MAX(p.items_total) FROM silver.erp_order_items oi INNER JOIN silver.erp_payments p ON oi.order_id=p.order_id WHERE oi.total_amount !=p.items_total group by(oi.order_id);*/
/*WITH cte_izračun_total_amount AS(
SELECT order_id, SUM(total_amount) AS calculated_total FROM silver.erp_order_items oi GROUP BY(order_id))
SELECT cita.order_id, cita.calculated_total, ep.items_total FROM cte_izračun_total_amount cita INNER JOIN silver.erp_payments ep ON cita.order_id=ep.order_id  WHERE cita.calculated_total !=ep.items_total ORDER BY(order_id);*/

--Provjere za tablicu 5.silver.erp_products--

--5.1 product_id
exec silver.provjera_duplikata @naziv_tablice='silver.erp_products', @naziv_stupca='product_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products', @naziv_stupca='product_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_products', @naziv_stupca='product_id';
--5.2 product_name
exec silver.provjera_duplikata @naziv_tablice='silver.erp_products', @naziv_stupca='product_name';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products', @naziv_stupca='product_name';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_products', @naziv_stupca='product_name';
--5.3 product_category_name
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_products',  @naziv_stupca='product_category_name';
--5.4  base_price
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='base_price';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='base_price';
SELECT oi.product_id, oi.price, p.base_price FROM silver.erp_order_items oi INNER JOIN silver.erp_products p ON oi.product_id=p.product_id WHERE oi.price!=p.base_price;
--5.5 weight_g
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='weight_g';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='weight_g';
exec silver.provjera_max10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='weight_g';
exec silver.provjera_min10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='weight_g';
--5.6 length_cm
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='length_cm';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='length_cm';
exec silver.provjera_max10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='length_cm';
exec silver.provjera_min10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='length_cm';
--5.7 height_cm
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='height_cm';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='height_cm';
exec silver.provjera_max10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='height_cm';
exec silver.provjera_min10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='height_cm';
--5.8 width_cm
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='width_cm';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='width_cm';
exec silver.provjera_max10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='width_cm';
exec silver.provjera_min10_vrijednosti @naziv_tablice='silver.erp_products',@ključ='product_id', @naziv_stupca='width_cm';

--Provjere za tablicu 6.silver.erp_reviews--

--6.1 review_id
exec silver.provjera_duplikata @naziv_tablice='silver.erp_reviews', @naziv_stupca='review_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_reviews', @naziv_stupca='review_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_reviews', @naziv_stupca='review_id';
--6.2 order_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_reviews', @ključ='review_id', @naziv_stupca='order_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_reviews', @ključ='review_id', @naziv_stupca='order_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.erp_reviews', @naziv_tablice_PK='silver.erp_orders',  @naziv_stupca_FK='order_id', @naziv_stupca_PK='order_id';
--6.3 review_score
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_reviews', @ključ='review_id', @naziv_stupca='review_score';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_reviews',  @naziv_stupca='review_score';
--6.4 review_comment_title
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_reviews', @ključ='review_id', @naziv_stupca='review_comment_title';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_reviews',  @naziv_stupca='review_comment_title';

--Provjere za tablicu 7.silver.erp_sellers--

--7.1 seller_id
exec silver.provjera_duplikata @naziv_tablice='silver.erp_sellers', @naziv_stupca='seller_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers', @naziv_stupca='seller_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_sellers', @naziv_stupca='seller_id';
--7.2 seller_full_name
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_full_name';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_sellers', @ključ='seller_id', @naziv_stupca='seller_full_name';
--7.3 seller_email
exec silver.provjera_duplikata @naziv_tablice='silver.erp_sellers', @naziv_stupca='seller_email';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_email';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_sellers', @ključ='seller_id', @naziv_stupca='seller_email';
--7.4 seller_birthdate
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_birthdate';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_birthdate';
--7.2. seller_full_name+ 7.4 seller_birthdate
exec silver.provjera_duplikata @naziv_tablice='silver.erp_sellers', @naziv_stupca='seller_full_name + '' ''+ CAST(seller_birthdate as VARCHAR(50))';
--7.5 seller_age
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_age';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_sellers', @ključ='seller_id', @naziv_stupca='seller_age';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.erp_sellers',  @ključ='seller_id', @naziv_stupca='seller_age';
--7.6 seller_city
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_city';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_sellers', @ključ='seller_id', @naziv_stupca='seller_city';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_sellers',  @naziv_stupca='seller_city';
--7.7 seller_state
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.erp_sellers',@ključ='seller_id', @naziv_stupca='seller_state';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.erp_sellers', @ključ='seller_id', @naziv_stupca='seller_state';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.erp_sellers',  @naziv_stupca='seller_state';

--Provjere za tablicu 8.silver.crm_customer_profile--

--8.1 customer_id
exec silver.provjera_duplikata @naziv_tablice='silver.crm_customer_profile', @naziv_stupca='customer_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_customer_profile', @naziv_stupca='customer_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.crm_customer_profile', @naziv_stupca='customer_id';
--8.2 customer_segment
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_customer_profile',  @naziv_stupca='customer_segment';
--8.3 acquisition_channel
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_customer_profile',  @naziv_stupca='acquisition_channel';
--8.4 first_contact_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_customer_profile', @ključ='customer_id', @naziv_stupca='first_contact_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.crm_customer_profile',@ključ='customer_id', @naziv_stupca='first_contact_date';
exec silver.provjera_valjanosti_start_i_end_datuma @naziv_tablice = 'silver.crm_customer_profile', @ključ='customer_id', @naziv_start ='first_contact_date', @naziv_end='last_contact_date';
--8.5 last_contact_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_customer_profile', @ključ='customer_id', @naziv_stupca='last_contact_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.crm_customer_profile',@ključ='customer_id', @naziv_stupca='last_contact_date';

--Provjere za tablicu 9.silver.crm_interactions--

--9.1 interaction_id
exec silver.provjera_duplikata @naziv_tablice='silver.crm_interactions', @naziv_stupca='interaction_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_interactions', @naziv_stupca='interaction_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.crm_interactions', @naziv_stupca='interaction_id';
--9.2 customer_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_interactions', @ključ='interaction_id', @naziv_stupca='customer_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.crm_interactions', @ključ='interaction_id', @naziv_stupca='customer_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.crm_interactions', @naziv_tablice_PK='silver.erp_customers',  @naziv_stupca_FK='customer_id', @naziv_stupca_PK='customer_id';
--9.3 interaction_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_interactions',@ključ='interaction_id', @naziv_stupca='interaction_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.crm_interactions',@ključ='interaction_id', @naziv_stupca='interaction_date';
--9.4 interaction_type
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_interactions',  @naziv_stupca='interaction_type';
--9.5 seller_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_interactions', @ključ='interaction_id', @naziv_stupca='seller_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.crm_interactions', @naziv_tablice_PK='silver.erp_sellers',  @naziv_stupca_FK='seller_id', @naziv_stupca_PK='seller_id';
SELECT DISTINCT ci.seller_id FROM silver.crm_interactions ci WHERE NOT EXISTS(SELECT seller_id FROM silver.erp_sellers es WHERE es.seller_id = ci.seller_id) ;
--9.6 outcome
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_interactions',  @naziv_stupca='outcome';

--Provjere za tablicu 10.silver.crm_leads--

--10.1 lead_id
exec silver.provjera_duplikata @naziv_tablice='silver.crm_leads', @naziv_stupca='lead_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_leads', @naziv_stupca='lead_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.crm_leads', @naziv_stupca='lead_id';
--10.2 customer_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_leads', @ključ='lead_id', @naziv_stupca='customer_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.crm_leads', @ključ='lead_id', @naziv_stupca='customer_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.crm_leads', @naziv_tablice_PK='silver.erp_customers',  @naziv_stupca_FK='customer_id', @naziv_stupca_PK='customer_id';
--10.3 lead_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.crm_leads',@ključ='lead_id', @naziv_stupca='lead_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.crm_leads',@ključ='lead_id', @naziv_stupca='lead_date';
--10.4 lead_source
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_leads',  @naziv_stupca='lead_source';
--10.5 is_qualified
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_leads',  @naziv_stupca='is_qualified';
--10.6 is_converted
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.crm_leads',  @naziv_stupca='is_converted';

--Provjere za tablicu 11.silver.marketing_campaigns--

--11.1 campaign_id
exec silver.provjera_duplikata @naziv_tablice='silver.marketing_campaigns', @naziv_stupca='campaign_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_campaigns', @naziv_stupca='campaign_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.marketing_campaigns', @naziv_stupca='campaign_id';
--11.2 campaign_name
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='campaign_name';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='campaign_name';
--11.3 channel
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.marketing_campaigns', @naziv_stupca='channel';
--11.4 start_date_campaigns
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='start_date_campaigns';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='start_date_campaigns';
exec silver.provjera_valjanosti_start_i_end_datuma @naziv_tablice = 'silver.marketing_campaigns', @ključ='campaign_id', @naziv_start ='start_date_campaigns', @naziv_end='end_date_campaigns';
--11.5 end_date_campaigns
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='end_date_campaigns';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='end_date_campaigns';
--11.6 budget
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='budget';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.marketing_campaigns', @ključ='campaign_id', @naziv_stupca='budget';

--Provjere za tablicu 12.silver.marketing_performance--

--12.1 date_performance
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @naziv_stupca='date_performance';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.marketing_performance', @ključ='campaign_id', @naziv_stupca='CAST(date_performance AS VARCHAR(50))';
--12.2 campaign_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @naziv_stupca='campaign_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.marketing_performance',  @naziv_stupca='campaign_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.marketing_performance', @naziv_tablice_PK='silver.marketing_campaigns',  @naziv_stupca_FK='campaign_id', @naziv_stupca_PK='campaign_id';
--12.3 channel
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='channel';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.marketing_performance', @naziv_stupca='channel';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.marketing_performance',  @naziv_stupca='channel';
--12.4 impressions
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='impressions';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.marketing_performance',@ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='impressions';
--12.5 clicks
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='clicks';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.marketing_performance',@ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='clicks';
--12.6 leads
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='leads';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.marketing_performance',@ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='leads';
--12.7 conversions
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='conversions';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.marketing_performance',@ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='conversions';
--12.8 spend
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.marketing_performance', @ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='spend';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.marketing_performance',@ključ='CAST(date_performance AS VARCHAR(50)) +'' ''+CAST(campaign_id AS VARCHAR(50))', @naziv_stupca='spend';

--Provjere za tablicu 13.silver.finance_sales_budget--

--13.1 date_sales_budget
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_sales_budget', @naziv_stupca='date_sales_budget';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.finance_sales_budget',@ključ='CAST(date_sales_budget AS VARCHAR(50))+'' ''+state_sales_budget+'' ''+product_category_name',  @naziv_stupca='date_sales_budget';
--13.2 state_sales_budget
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.finance_sales_budget', @naziv_stupca='state_sales_budget';
--13.3 product_category_name
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_sales_budget', @naziv_stupca='product_category_name';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.finance_sales_budget', @naziv_stupca='product_category_name';
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.finance_sales_budget', @naziv_stupca='product_category_name';
--13.4 budget_amount
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_sales_budget', @naziv_stupca='budget_amount';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.finance_sales_budget',@ključ='CAST(date_sales_budget AS VARCHAR(50))+'' ''+state_sales_budget+'' ''+product_category_name', @naziv_stupca='budget_amount';

--Provjere za tablicu 14.silver.finance_operating_costs--

--14.1 cost_id
exec silver.provjera_duplikata @naziv_tablice='silver.finance_operating_costs', @naziv_stupca='cost_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_operating_costs', @naziv_stupca='cost_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.finance_operating_costs', @naziv_stupca='cost_id';
--14.2 cost_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_operating_costs', @ključ='cost_id', @naziv_stupca='cost_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.finance_operating_costs', @ključ='cost_id', @naziv_stupca='cost_date';
--14.3 operating_cost_state
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_operating_costs', @ključ='cost_id', @naziv_stupca='operating_cost_state';
--14.4 cost_type
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.finance_operating_costs', @naziv_stupca='cost_type';
--14.5 cost_amount
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.finance_operating_costs', @ključ='cost_id', @naziv_stupca='cost_amount';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.finance_operating_costs',@ključ='cost_id', @naziv_stupca='cost_amount';

--Provjere za tablicu 15.silver.operations_inventory--
--15.1 snapshot_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_inventory', @naziv_stupca='snapshot_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='snapshot_date';
--15.2 product_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='product_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='product_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.operations_inventory', @naziv_tablice_PK='silver.erp_products',  @naziv_stupca_FK='product_id', @naziv_stupca_PK='product_id';
--15.3 warehouse_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='warehouse_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='warehouse_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.operations_inventory', @naziv_tablice_PK='silver.erp_warehouse',  @naziv_stupca_FK='warehouse_id', @naziv_stupca_PK='warehouse_id';
--15.4 stock_quantity
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='stock_quantity';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='stock_quantity';
--15.5 reserved_quantity
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='reserved_quantity';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='reserved_quantity';
--15.6 reorder_point
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='reorder_point';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.operations_inventory', @ključ='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id', @naziv_stupca='reorder_point';
--15.7 općenita provjera
exec silver.provjera_duplikata @naziv_tablice='silver.operations_inventory', @naziv_stupca='CAST(snapshot_date AS VARCHAR(50))+ '' ''+ product_id+'' ''+warehouse_id';

--Provjere za tablicu 16.silver.operations_suppliers--

--16.1 supplier_id
exec silver.provjera_duplikata @naziv_tablice='silver.operations_suppliers', @naziv_stupca='supplier_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_suppliers', @naziv_stupca='supplier_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.operations_suppliers', @naziv_stupca='supplier_id';
--16.2 supplier_name
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_suppliers', @ključ='supplier_id', @naziv_stupca='supplier_name';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.operations_suppliers', @ključ='supplier_id', @naziv_stupca='supplier_name';
exec silver.provjera_duplikata @naziv_tablice='silver.operations_suppliers', @naziv_stupca='supplier_name';
--16.3 state_suppliers
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.operations_suppliers', @naziv_stupca='state_suppliers';
--16.4 lead_time_days
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_suppliers', @ključ='supplier_id', @naziv_stupca='lead_time_days';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.operations_suppliers', @ključ='supplier_id', @naziv_stupca='lead_time_days';
--16.5 avg_unit_cost
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_suppliers', @ključ='supplier_id', @naziv_stupca='avg_unit_cost';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.operations_suppliers', @ključ='supplier_id', @naziv_stupca='avg_unit_cost';

--Provjere za tablicu 17.silver.operations_supplier_product--

--17.1 product_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_supplier_product', @naziv_stupca='product_id';
exec silver.provjera_duplikata @naziv_tablice='silver.operations_supplier_product', @naziv_stupca='product_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.operations_supplier_product', @naziv_tablice_PK='silver.erp_products',  @naziv_stupca_FK='product_id', @naziv_stupca_PK='product_id';
SELECT ep.product_id, ep.base_price, osp.unit_cost, osp.supplier_id FROM silver.erp_products ep INNER JOIN silver.operations_supplier_product osp ON ep.product_id=osp.product_id WHERE ep.base_price<osp.unit_cost;
--17.2 supplier_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_supplier_product', @ključ='product_id', @naziv_stupca='supplier_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.operations_supplier_product', @ključ='product_id', @naziv_stupca='supplier_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.operations_supplier_product', @naziv_tablice_PK='silver.operations_suppliers', @naziv_stupca_FK='supplier_id', @naziv_stupca_PK='supplier_id';
--17.3 unit_cost
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.operations_supplier_product', @ključ='product_id', @naziv_stupca='unit_cost';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.operations_supplier_product', @ključ='product_id', @naziv_stupca='unit_cost';

--Provjere za tablicu 18.silver.returns_returns--

--18.1 return_id
exec silver.provjera_duplikata @naziv_tablice='silver.returns_returns', @naziv_stupca='return_id';
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @naziv_stupca='return_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.returns_returns', @naziv_stupca='return_id';
--18.2 order_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='order_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='order_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.returns_returns', @naziv_tablice_PK='silver.erp_orders',  @naziv_stupca_FK='order_id', @naziv_stupca_PK='order_id';
--18.3 order_item
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='order_item';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='order_item';
--18.4 product_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='product_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='product_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.returns_returns', @naziv_tablice_PK='silver.erp_products',  @naziv_stupca_FK='product_id', @naziv_stupca_PK='product_id';
--18.5 seller_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='seller_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='seller_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.returns_returns', @naziv_tablice_PK='silver.erp_sellers',  @naziv_stupca_FK='seller_id', @naziv_stupca_PK='seller_id';
--18.6 customer_id
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='customer_id';
exec silver.provjera_razmaka_u_nazivima @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='customer_id';
exec silver.provjera_referencijalnog_integriteta @naziv_tablice_FK='silver.returns_returns', @naziv_tablice_PK='silver.erp_customers',  @naziv_stupca_FK='customer_id', @naziv_stupca_PK='customer_id';
--18.7 return_date
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='return_date';
exec silver.provjera_valjanosti_datuma @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='return_date';
--18.8 return_quantity
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='return_quantity';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='return_quantity';
--18.9 return_reason
exec silver.provjera_distinktnih_naziva @naziv_tablice='silver.returns_returns', @naziv_stupca='return_reason';
--18.10 refund_amount
exec silver.provjera_null_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='refund_amount';
exec silver.provjera_negativnosti_vrijednosti @naziv_tablice='silver.returns_returns', @ključ='return_id', @naziv_stupca='refund_amount';
--PROVJERA USKLAĐENOSTI S TABLICOM  erp_orders i erp_order_items
 SELECT 
	rr.return_id, rr.order_id, rr.order_item, rr.customer_id, rr.return_date, rr.refund_amount, rr.return_quantity,
	oi.order_id, oi.order_item, oi.price, oi.product_id, oi.quantity,
	o.customer_id, o.order_id, o.order_status   
FROM  silver.returns_returns rr 
INNER JOIN silver.erp_order_items oi ON rr.order_id=oi.order_id  AND  rr.order_item=oi.order_item
INNER JOIN silver.erp_orders o ON rr.order_id=o.order_id WHERE rr.customer_id!=o.customer_id
	OR rr.return_quantity > oi.quantity
	OR rr.return_quantity <= 0
    OR rr.refund_amount <= 0
    OR rr.refund_amount > oi.price*oi.quantity
    OR rr.return_date IS NULL
	OR (
        rr.return_reason = 'customer_changed_mind'
        AND o.order_delivered_customer_date IS NOT NULL
    )
	OR (
        rr.return_reason = 'late_delivery'
        AND NOT (
            o.order_estimated_delivery_date < o.order_delivered_customer_date
        )
);

-- Provjere za tablicu 19.silver.erp_warehouse

-- 19.1 warehouse_id
EXEC silver.provjera_duplikata @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_id';
EXEC silver.provjera_null_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_id';
EXEC silver.provjera_razmaka_u_nazivima @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_id';
-- 19.2 warehouse_name
EXEC silver.provjera_duplikata @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_name';
EXEC silver.provjera_null_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_name';
EXEC silver.provjera_razmaka_u_nazivima @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_name';
-- 19.3 warehouse_address
EXEC silver.provjera_null_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_address';
EXEC silver.provjera_razmaka_u_nazivima @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_address';
-- 19.4 warehouse_city
EXEC silver.provjera_distinktnih_naziva @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_city';
-- 19.5 capacity_m3
EXEC silver.provjera_null_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id',@naziv_stupca = 'capacity_m3';
EXEC silver.provjera_negativnosti_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id',@naziv_stupca = 'capacity_m3';
-- 19.6 warehouse_phone
EXEC silver.provjera_null_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_phone';
EXEC silver.provjera_razmaka_u_nazivima @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_phone';
-- 19.7 warehouse_email
EXEC silver.provjera_duplikata @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_email';
EXEC silver.provjera_null_vrijednosti @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_email';
EXEC silver.provjera_razmaka_u_nazivima @naziv_tablice = 'silver.erp_warehouse', @ključ = 'warehouse_id', @naziv_stupca = 'warehouse_email';
-- 19.8 warehouse_status
EXEC silver.provjera_distinktnih_naziva @naziv_tablice = 'silver.erp_warehouse', @naziv_stupca = 'warehouse_status';