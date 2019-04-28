--Summarized the monthly data
--drop table SALES_HIS_MONTHLY_SUM
--create table SALES_HIS_MONTHLY_SUM(OrderDate DATE,Country VARCHAR(300),City VARCHAR(300),State VARCHAR(300),
--Region VARCHAR(300),Category VARCHAR(300),SubCategory VARCHAR(300),ProductName VARCHAR(300),ProductID INT,Sales float)

Delete  from SALES_HIS_MONTHLY_SUM

insert into  SALES_HIS_MONTHLY_SUM
(
OrderDate,
Country,
City,
State,
Region,
Category,
SubCategory ,
ProductName,
ProductID , 
Sales)

SELECT OrderDate, 
Country,
City,
State,
Region,
Category,
SubCategory,
ProductName,
ProductID,
sum(Sales) as Sales
		from [dbo].[sales_final]
		group by Country,City,State,Region,Category,SubCategory,ProductName,ProductID,OrderDate
		order by OrderDate Asc


--create table SALES_MONTHLY_APPEND(id int,OrderDate DATE,Country VARCHAR(300),City VARCHAR(300),State VARCHAR(300),
--Region VARCHAR(300),Category VARCHAR(300),SubCategory VARCHAR(300),ProductName VARCHAR(300),ProductID VARCHAR(300),Sales float,
--M1 INT,M2 INT,M3 INT,M4 INT,M5 INT,M6 INT,M7 INT,M8 INT,M9 INT,M10 INT,ALGORITHM VARCHAR(100))


DELETE FROM SALES_MONTHLY_APPEND
INSERT INTO SALES_MONTHLY_APPEND (
id,
Country,
City,
State,
Region,
Category,
SubCategory,
ProductName,
ProductID,
M1 ,M2 ,M3 ,M4 ,M5 ,M6 ,M7 ,
M8 ,M9 ,M10,ALGORITHM
)


  SELECT * FROM SALES_AUTO_ARIMA_MONTHLY_FORECAST
  --UNION ALL
  --SELECT * FROM SALES_ARIMA_MONTHLY_FORECAST
  --union all 
  --SELECT * FROM SALES_RWF_MONTHLY_FORECAST
  --union all
  --SELECT * FROM SALES_MEANF_MONTHLY_FORECAST
  --union all
  --SELECT * FROM SALES_NAIVE_MONTHLY_FORECAST
  --union all
  --SELECT * FROM SALES_HOLTW_MONTHLY_FORECAST


  create table SALES_MONTHLY_MINMAE(id int,OrderDate DATE,Country VARCHAR(300),City VARCHAR(300),State VARCHAR(300),
Region VARCHAR(300),Category VARCHAR(300),SubCategory VARCHAR(300),ProductName VARCHAR(300),ProductID VARCHAR(300),Sales float,
M1 INT,M2 INT,M3 INT,M4 INT,M5 INT,M6 INT,M7 INT,M8 INT,M9 INT,M10 INT,MAE INT,ALGORITHM VARCHAR(100))


delete from SALES_MONTHLY_MINMAE
INSERT INTO SALES_MONTHLY_MINMAE(
id,
Country,
City,
State,
Region,
Category,
SubCategory,
ProductName,
ProductID,
M1 ,M2 ,M3 ,M4 ,M5 ,M6 ,M7 ,
M8 ,M9 ,M10,MAE,ALGORITHM
)



SELECT tt.*
FROM SALES_MONTHLY_APPEND tt
INNER JOIN
    (SELECT ProductName,ProductID, MIN(MAE) AS MAE
    FROM SALES_MONTHLY_APPEND
    GROUP BY ProductName,ProductID) SRINU 
ON  tt.ProductID = SRINU.ProductID 
AND tt.MAE = SRINU.MAE and tt.ProductName=SRINU.ProductName

 
 ;WITH cte AS (
  SELECT ProductName,ProductID,
     row_number() OVER(PARTITION BY ProductName,ProductID  ORDER BY ProductName,ProductID) AS [rn]
  FROM SALES_MONTHLY_MINMAE
)
DELETE cte WHERE [rn] > 1;



create table SALES_MONTHLY_MAXFORECAST_PBI(OrderDate DATE,Country VARCHAR(300),City VARCHAR(300),State VARCHAR(300),
Region VARCHAR(300),Category VARCHAR(300),SubCategory VARCHAR(300),ProductName VARCHAR(300),ProductID VARCHAR(300),Sales float,
M1 INT,M2 INT,M3 INT,M4 INT,M5 INT,M6 INT,M7 INT,M8 INT,M9 INT,M10 INT,MAE INT,ALG VARCHAR(100))


DELETE FROM SALES_MONTHLY_MAXFORECAST_PBI
INSERT INTO SALES_MONTHLY_MAXFORECAST_PBI(
Country,
City,
State,
Region,
Category,
SubCategory,
ProductName,
ProductID,
M1 ,M2 ,M3 ,M4 ,M5 ,M6 ,M7 ,
M8 ,M9 ,M10,ALG
)


  select B.Country,B.City,B.State,B.Region,B.Category,B.SubCategory,B.ProductName,B.ProductID,B.M1,B.M2,B.M3,B.M4,B.M5,B.M6,B.M7,B.M8,B.M9,B.M10,B.M11,B.M12,B.M13,B.M14,B.M15,B.M16,B.M17,B.M18,B.ALGORITHM
 from SALES_MONTHLY_MINMAE as B


