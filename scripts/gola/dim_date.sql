USE DataWarehouseOlist;
GO

IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
    DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date (
    date_key       INT PRIMARY KEY,    
    full_date      DATE,              
    year_num       INT,            
    quarter_num    INT,            
    month_num      INT,         
    month_name     VARCHAR(20),
    day_num        INT,
    day_name       VARCHAR(20),
    is_weekend     BIT
);
GO



DECLARE @StartDate DATE = '2016-01-01';
DECLARE @EndDate DATE = '2018-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO gold.dim_date (
        date_key,
        full_date,
        year_num,
        quarter_num,
        month_num,
        month_name,
        day_num,
        day_name,
        is_weekend
    )
    SELECT 
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT) AS date_key,
        @StartDate AS full_date,
        DATEPART(YEAR, @StartDate) AS year_num,
        DATEPART(QUARTER, @StartDate) AS quarter_num,
        DATEPART(MONTH, @StartDate) AS month_num,
        DATENAME(MONTH, @StartDate) AS month_name,
        DATEPART(DAY, @StartDate) AS day_num,
        DATENAME(WEEKDAY, @StartDate) AS day_name,
        CASE WHEN DATENAME(WEEKDAY, @StartDate) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END AS is_weekend;

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

--SELECT TOP 10 * FROM gold.dim_date ORDER BY date_key ASC;
