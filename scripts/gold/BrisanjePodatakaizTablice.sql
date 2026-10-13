/*
    Naslov: Brisane podataka iz tablica u shemi "gold"
    Autor: Marko Vresk
    Datum: 09.10.2026.
    Opis: Skripta sadrži SQL naredbe za brisanje podataka iz tablica u bazi podataka "gold".
    Upozorenja:  Prije pokretanja skripte, provjerite da li imate odgovarajuće privilegije za brisanje podataka iz tablica u schemi podataka "gold". Također, budite oprezni prilikom brisanja podataka jer će svi podaci u tim tablicama biti izgubljeni.
*/
CREATE OR ALTER PROCEDURE gold.brisanje_podataka_interno AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
    BEGIN TRY
		BEGIN TRANSACTION;
        -- BRISANJE PODATAKA IZ TABLICE gold.fact_sales
        DELETE FROM gold.fact_sales;
        PRINT('--Brisanje podataka iz tablice gold.fact_sales--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_payment
        DELETE FROM gold.fact_payment;
        PRINT('--Brisanje podataka iz tablice gold.fact_payment--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_review
        DELETE FROM gold.fact_review;
        PRINT('--Brisanje podataka iz tablice gold.fact_review--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_interaction
        DELETE FROM gold.fact_interaction;
        PRINT('--Brisanje podataka iz tablice gold.fact_interaction--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_lead
        DELETE FROM gold.fact_lead;
        PRINT('--Brisanje podataka iz tablice gold.fact_lead--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_marketing_performance
        DELETE FROM gold.fact_marketing_performance;
        PRINT('--Brisanje podataka iz tablice gold.fact_marketing_performance--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_operating_cost
        DELETE FROM gold.fact_operating_cost;
        PRINT('--Brisanje podataka iz tablice gold.fact_operating_cost--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_sales_budget
        DELETE FROM gold.fact_sales_budget;
        PRINT('--Brisanje podataka iz tablice gold.fact_sales_budget--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_inventory_snapshot
        DELETE FROM gold.fact_inventory_snapshot;
        PRINT('--Brisanje podataka iz tablice gold.fact_inventory_snapshot--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_product_supplier
        DELETE FROM gold.fact_product_supplier;
        PRINT('--Brisanje podataka iz tablice gold.fact_product_supplier--');

        -- BRISANJE PODATAKA IZ TABLICE gold.fact_return
        DELETE FROM gold.fact_return;
        PRINT('--Brisanje podataka iz tablice gold.fact_return--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_product
        DELETE FROM gold.dim_product;
        PRINT('--Brisanje podataka iz tablice gold.dim_product--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_customer
        DELETE FROM gold.dim_customer;
        PRINT('--Brisanje podataka iz tablice gold.dim_customer--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_seller
        DELETE FROM gold.dim_seller;
        PRINT('--Brisanje podataka iz tablice gold.dim_seller--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_warehouse
        DELETE FROM gold.dim_warehouse;
        PRINT('--Brisanje podataka iz tablice gold.dim_warehouse--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_campaign
        DELETE FROM gold.dim_campaign;
        PRINT('--Brisanje podataka iz tablice gold.dim_campaign--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_supplier
        DELETE FROM gold.dim_supplier;
        PRINT('--Brisanje podataka iz tablice gold.dim_supplier--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_product_category
        DELETE FROM gold.dim_product_category;
        PRINT('--Brisanje podataka iz tablice gold.dim_product_category--');

        -- BRISANJE PODATAKA IZ DIMENZIJSKE TABLICE gold.dim_date
        DELETE FROM gold.dim_date;
        PRINT('--Brisanje podataka iz tablice gold.dim_date--');
		COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT>0
			BEGIN
				ROLLBACK TRANSACTION;
			END;
        PRINT('');
        PRINT('Došlo je do pogreške prilikom brisanja podataka. Poništavam sva brisanja');
        PRINT('ERROR MESSAGE: ' + ERROR_MESSAGE());
        PRINT('ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR));
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE gold.brisanje_podataka AS
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
				EXEC sys.sp_executesql N' EXEC gold.brisanje_podataka_interno;'
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT>1
				BEGIN
					ROLLBACK TRANSACTION
				END;
			PRINT '';
			PRINT('Došlo je do pogreške prilikom brisanja podataka. Poništavam sva brisanja');
			PRINT('ERROR MESSAGE: ' + ERROR_MESSAGE());
			PRINT('ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR));
		END CATCH;
	END;
GO
EXECUTE gold.brisanje_podataka;