/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:olist
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseOlist' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseOlist')
BEGIN
    ALTER DATABASE DataWarehouseOlist SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseOlist;
END;
GO

-- Create the 'DataWarehouseOlist' database
CREATE DATABASE DataWarehouseOlist;
GO

USE DataWarehouseOlist;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
