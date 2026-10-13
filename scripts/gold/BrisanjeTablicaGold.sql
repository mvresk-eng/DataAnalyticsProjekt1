/*
    Naslov: Brisanje tablica gold sheme
    Autor: Marko Vresk
    Datum: 09.10.2026.
    Opis: Skripta sadrži SQL naredbe za brisanje tablica u bazi podataka "gold".
    Upozorenja:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za brisanje tablica u schemi podataka "gold". Također, budite oprezni prilikom brisanja tablica jer će sve postojeće tablice u bazi podataka "gold" biti izbrisane.
*/
CREATE OR ALTER PROCEDURE gold.brisanje_tablica AS  
	BEGIN
		BEGIN TRY
			IF OBJECT_ID('gold.fact_return', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_return;
				PRINT '--Brišem tablicu "gold.fact_return"--';
			END;

			IF OBJECT_ID('gold.fact_product_supplier', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_product_supplier;
				PRINT '--Brišem tablicu "gold.fact_product_supplier"--';
			END;

			IF OBJECT_ID('gold.fact_inventory_snapshot', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_inventory_snapshot;
				PRINT '--Brišem tablicu "gold.fact_inventory_snapshot"--';
			END;

			IF OBJECT_ID('gold.fact_sales_budget', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_sales_budget;
				PRINT '--Brišem tablicu "gold.fact_sales_budget"--';
			END;

			IF OBJECT_ID('gold.fact_operating_cost', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_operating_cost;
				PRINT '--Brišem tablicu "gold.fact_operating_cost"--';
			END;

			IF OBJECT_ID('gold.fact_marketing_performance', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_marketing_performance;
				PRINT '--Brišem tablicu "gold.fact_marketing_performance"--';
			END;

			IF OBJECT_ID('gold.fact_lead', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_lead;
				PRINT '--Brišem tablicu "gold.fact_lead"--';
			END;

			IF OBJECT_ID('gold.fact_interaction', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_interaction;
				PRINT '--Brišem tablicu "gold.fact_interaction"--';
			END;

			IF OBJECT_ID('gold.fact_review', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_review;
				PRINT '--Brišem tablicu "gold.fact_review"--';
			END;

			IF OBJECT_ID('gold.fact_payment', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_payment;
				PRINT '--Brišem tablicu "gold.fact_payment"--';
			END;

			IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.fact_sales;
				PRINT '--Brišem tablicu "gold.fact_sales"--';
			END;

			IF OBJECT_ID('gold.dim_supplier', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_supplier;
				PRINT '--Brišem tablicu "gold.dim_supplier"--';
			END;

			IF OBJECT_ID('gold.dim_campaign', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_campaign;
				PRINT '--Brišem tablicu "gold.dim_campaign"--';
			END;

			IF OBJECT_ID('gold.dim_warehouse', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_warehouse;
				PRINT '--Brišem tablicu "gold.dim_warehouse"--';
			END;

			IF OBJECT_ID('gold.dim_seller', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_seller;
				PRINT '--Brišem tablicu "gold.dim_seller"--';
			END;

			IF OBJECT_ID('gold.dim_product', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_product;
				PRINT '--Brišem tablicu "gold.dim_product"--';
			END;

			IF OBJECT_ID('gold.dim_product_category', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_product_category;
				PRINT '--Brišem tablicu "gold.dim_product_category"--';
			END;

			IF OBJECT_ID('gold.dim_customer', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_customer;
				PRINT '--Brišem tablicu "gold.dim_customer"--';
			END;

			IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
			BEGIN
				DROP TABLE gold.dim_date;
				PRINT '--Brišem tablicu "gold.dim_date"--';
			END;	
		END TRY
		BEGIN CATCH
			PRINT '';
			PRINT('ERROR_MESSAGE: ' + ERROR_MESSAGE());
			PRINT('ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('ERROR_LINE: ' + CAST(ERROR_LINE() AS NVARCHAR))
		END CATCH
	END;
GO
EXEC gold.brisanje_tablica;