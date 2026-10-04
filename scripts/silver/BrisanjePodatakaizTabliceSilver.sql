BEGIN
    DECLARE @početno_vrijeme DATETIME, @završno_vrijeme DATETIME;
    BEGIN TRY
        SET @početno_vrijeme = GETDATE();
        PRINT('Proces brisanja podataka iz tablica počeo je : ' + CAST(FORMAT(@početno_vrijeme, 'yyyy-MM-dd HH:mm:ss:fff') AS NVARCHAR));
        BEGIN TRANSACTION;

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_customers
        TRUNCATE TABLE silver.erp_customers;
        PRINT('--Brisanje podataka iz tablice silver.erp_customers--');

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_order_items
        TRUNCATE TABLE silver.erp_order_items;
        PRINT('--Brisanje podataka iz tablice silver.erp_order_items--');

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_orders
        TRUNCATE TABLE silver.erp_orders;
        PRINT('--Brisanje podataka iz tablice silver.erp_orders--');

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_payments
        TRUNCATE TABLE silver.erp_payments;
        PRINT('--Brisanje podataka iz tablice silver.erp_payments--');

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_products
        TRUNCATE TABLE silver.erp_products;
        PRINT('--Brisanje podataka iz tablice silver.erp_products--');

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_reviews
        TRUNCATE TABLE silver.erp_reviews;
        PRINT('--Brisanje podataka iz tablice silver.erp_reviews--');

        -- BRISANJE PODATAKA IZ TABLICE silver.erp_sellers
        TRUNCATE TABLE silver.erp_sellers;
        PRINT('--Brisanje podataka iz tablice silver.erp_sellers--');

		-- BRISANJE PODATAKA IZ TABLICE silver.erp_warehouse
        TRUNCATE TABLE silver.erp_warehouse;
        PRINT('--Brisanje podataka iz tablice silver.erp_warehouse--');

        -- BRISANJE PODATAKA IZ TABLICE silver.crm_customer_profile
        TRUNCATE TABLE silver.crm_customer_profile;
        PRINT('--Brisanje podataka iz tablice silver.crm_customer_profile--');

        -- BRISANJE PODATAKA IZ TABLICE silver.crm_interactions
        TRUNCATE TABLE silver.crm_interactions;
        PRINT('--Brisanje podataka iz tablice silver.crm_interactions--');

        -- BRISANJE PODATAKA IZ TABLICE silver.crm_leads
        TRUNCATE TABLE silver.crm_leads;
        PRINT('--Brisanje podataka iz tablice silver.crm_leads--');

        -- BRISANJE PODATAKA IZ TABLICE silver.marketing_campaigns
        TRUNCATE TABLE silver.marketing_campaigns;
        PRINT('--Brisanje podataka iz tablice silver.marketing_campaigns--');

        -- BRISANJE PODATAKA IZ TABLICE silver.marketing_performance
        TRUNCATE TABLE silver.marketing_performance;
        PRINT('--Brisanje podataka iz tablice silver.marketing_performance--');

        -- BRISANJE PODATAKA IZ TABLICE silver.finance_operating_costs
        TRUNCATE TABLE silver.finance_operating_costs;
        PRINT('--Brisanje podataka iz tablice silver.finance_operating_costs--');

        -- BRISANJE PODATAKA IZ TABLICE silver.finance_sales_budget
        TRUNCATE TABLE silver.finance_sales_budget;
        PRINT('--Brisanje podataka iz tablice silver.finance_sales_budget--');

        -- BRISANJE PODATAKA IZ TABLICE silver.operations_inventory
        TRUNCATE TABLE silver.operations_inventory;
        PRINT('--Brisanje podataka iz tablice silver.operations_inventory--');

        -- BRISANJE PODATAKA IZ TABLICE silver.operations_supplier_product
        TRUNCATE TABLE silver.operations_supplier_product;
        PRINT('--Brisanje podataka iz tablice silver.operations_supplier_product--');

        -- BRISANJE PODATAKA IZ TABLICE silver.operations_suppliers
        TRUNCATE TABLE silver.operations_suppliers;
        PRINT('--Brisanje podataka iz tablice silver.operations_suppliers--');

        -- BRISANJE PODATAKA IZ TABLICE silver.returns_returns
        TRUNCATE TABLE silver.returns_returns;
        PRINT('--Brisanje podataka iz tablice silver.returns_returns--');

        COMMIT TRANSACTION;
        SET @završno_vrijeme = GETDATE();
        PRINT('Proces brisanja podataka iz tablica završio je : ' + CAST(FORMAT(@završno_vrijeme, 'yyyy-MM-dd HH:mm:ss:fff') AS NVARCHAR));
        PRINT('Proces brisanja podataka iz tablica trajao je : ' + CAST(DATEDIFF(MILLISECOND, @početno_vrijeme, @završno_vrijeme) AS NVARCHAR) + ' ms');
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT('');
        PRINT('Sva prethodna brisanja se poništavaju');
        PRINT('ERROR MESSAGE: ' + ERROR_MESSAGE());
        PRINT('ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR));
    END CATCH;
END;

GO

EXEC silver.brisanje_podataka;
