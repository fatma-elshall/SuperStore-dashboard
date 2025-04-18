SELECT * FROM final_project.`superstore sales dataset`;

/*Explore data*/
show columns 
from final_project.`superstore sales dataset`;

/*select total number of rows*/
select count(*)
from final_project.`superstore sales dataset`;

 
 /* change data type of 'ship date' and 'order date' */
 
 /*first  Convert the String Date Format Before Changing Column Type */
/* MySQL expects dates in YYYY-MM-DD format  1-Create a New Temporary Column for Converted Dates */ 
ALTER TABLE final_project.`superstore sales dataset`
ADD COLUMN `Order_Date_Temp` DATETIME, 
ADD COLUMN `Ship_Date_Temp` DATETIME;

SET SQL_SAFE_UPDATES = 0;  /*to turn off safe updates*/

/* 2- Convert Existing String Dates to YYYY-MM-DD Format*/
 UPDATE  final_project.`superstore sales dataset` 
SET `Order_Date_Temp` = STR_TO_DATE(`Order Date`, '%d/%m/%Y'),
    `Ship_Date_Temp` = STR_TO_DATE(`Ship Date`, '%d/%m/%Y');
    
  /* 3-Replace the Original Columns with Cleaned Date Columns*/  
ALTER TABLE final_project.`superstore sales dataset`
DROP COLUMN `Order Date`, 
DROP COLUMN `Ship Date`;

ALTER TABLE final_project.`superstore sales dataset`
CHANGE COLUMN `Order_Date_Temp` `Order Date` DATETIME, 
CHANGE COLUMN `Ship_Date_Temp` `Ship Date` DATETIME;

/*check updates again*/ 
show columns 
from final_project.`superstore sales dataset`;

SELECT * FROM 
final_project.`superstore sales dataset`;

/* Delete postal code column as we won’t use this column in analysis stage*/
/*also I will delete columns 'Row_id'  as we don’t use them in analysis stage*/
alter table final_project.`superstore sales dataset`
drop column `Postal Code`,
drop column `Row ID`;

/* check for nulls in all columns */ 
SELECT 
    SUM(CASE WHEN `Order ID` IS NULL THEN 1 ELSE 0 END) AS Order_ID_nulls,
    SUM(CASE WHEN `Order Date` IS NULL THEN 1 ELSE 0 END) AS Order_Date_nulls,
    SUM(CASE WHEN `Ship Date` IS NULL THEN 1 ELSE 0 END) AS Ship_Date_nulls,
    SUM(CASE WHEN `Ship Mode` IS NULL THEN 1 ELSE 0 END) AS Ship_Mode_nulls,
    SUM(CASE WHEN `City` IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN `Country` IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN `Sales` IS NULL THEN 1 ELSE 0 END) AS sales_nulls,
    SUM(CASE WHEN `Region` IS NULL THEN 1 ELSE 0 END) AS region_nulls,
    SUM(CASE WHEN `State` IS NULL THEN 1 ELSE 0 END) AS region_nulls,
    SUM(CASE WHEN `Category` IS NULL THEN 1 ELSE 0 END) AS region_nulls,
    SUM(CASE WHEN `Sub-Category` IS NULL THEN 1 ELSE 0 END) AS region_nulls
FROM final_project.`superstore sales dataset`;

/* check duplicates in data*/
SELECT 
    `Order ID`,`Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Region`, 
    `Product ID`, `Category`, `Sub-Category`, `Product Name`,`Sales`, `Order Date`, `Ship Date`, 
    COUNT(*) AS duplicate_count
FROM final_project.`superstore sales dataset`
GROUP BY 
`Order ID`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Region`, 
`Product ID`, `Category`, `Sub-Category`, `Product Name`, `Sales`, `Order Date`, `Ship Date`
HAVING COUNT(*) > 1;

/* drop duplicates */
/* create new table for cleaned data*/
CREATE TABLE final_project.`superstore sales dataset` AS
SELECT DISTINCT *
FROM final_project.`superstore sales dataset`;



/* check duplicates again after drop*/
SELECT 
    `Order ID`,`Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Region`, 
    `Product ID`, `Category`, `Sub-Category`, `Product Name`,`Sales`, `Order Date`, `Ship Date`, 
    COUNT(*) AS duplicate_count
FROM final_project.`superstore sales dataset`
GROUP BY 
`Order ID`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Region`, 
`Product ID`, `Category`, `Sub-Category`, `Product Name`, `Sales`, `Order Date`, `Ship Date`
HAVING COUNT(*) > 1;

/* check number of rows again after delete duplicates */
select count(*)
from final_project.`superstore sales dataset`;

/*Check validate Dates ( if Ship Date before Order Date)*/
SELECT *
 FROM final_project.`superstore sales dataset`
WHERE `Ship Date` < `Order Date`;