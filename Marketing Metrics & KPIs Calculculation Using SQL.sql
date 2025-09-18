
--Marketing Metrics & KPIs Calculation Using SQL--


----------------------------------------------------------------------------------------------------
SELECT *
INTO dbo.MarketingAnalysis2
FROM  [Portfolio Project].[dbo].[Marketing];


SELECT * 
FROM dbo.MarketingAnalysis2;


--Identify the unique campaign name

SELECT DISTINCT campaign_name, category, campaign_id
FROM dbo.MarketingAnalysis2
ORDER BY campaign_name;


--Check for NULL values

SELECT COUNT(*) AS count_null_values
FROM dbo.MarketingAnalysis2
WHERE c_date IS NULL
             OR campaign_name IS NULL
           OR category  IS NULL
         OR campaign_id IS NULL
       OR impressions IS NULL
     OR mark_spent IS NULL
   OR clicks IS NULL
     OR leads IS NULL 
       OR orders IS NULL
         AND revenue IS NULL;

--There are no NULL values in a table 


--Extract the Date format from Timepstamp


SELECT c_date, CONVERT(date, c_date) AS c_dateconverted
FROM dbo.MarketingAnalysis2

ALTER TABLE dbo.MarketingAnalysis2
ADD c_dateconverted Date;

UPDATE dbo.MarketingAnalysis2
SET c_dateconverted = CONVERT(date, c_date)


--Find the start and end dates of a campaign 


SELECT campaign_name,
    MIN(c_dateconverted) AS CampaignStartDate,
    MAX(c_dateconverted) AS CampaignAndDate
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name;



-- Funnel calculations

--Calculate Campaign goal KPIs and Campaign supporting metrics

SELECT *
FROM dbo.MarketingAnalysis2


SELECT campaign_name, category,
       SUM(impressions) AS total_impressions,
	   SUM(clicks) AS total_clicks,
	   ROUND(SUM(clicks) *1.0 / SUM(impressions),5) * 100 AS CTR,
	   ROUND(SUM(leads) *1.0/ SUM(clicks),5) *100 AS Visitor_to_lead_conversion_rate,
	   ROUND(SUM(orders) *1.0 / SUM(leads),6) * 100 AS MQL_to_SQL_conversion_rate,
	   ROUND(SUM(revenue) / SUM(orders),5) AS AOV
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name, category
ORDER BY MQL_to_SQL_conversion_rate DESC;


--Spending calculations


SELECT campaign_name,
       SUM(mark_spent) AS Total_Mark_Spent,
	  ROUND(SUM(mark_spent) * 1.0 / SUM(impressions),6) * 1000 AS CPM,
	   ROUND(SUM(mark_spent) * 1.0 / SUM( clicks),6) AS CPC,
	   ROUND(SUM(mark_spent) * 1.0 / SUM( leads),6) AS CPL,
	   ROUND(SUM(mark_spent) * 1.0 / SUM(orders),6) AS CAC,
	   SUM(revenue) - SUM(mark_spent) AS Gross_Profit,
	  ROUND((SUM(revenue) * 1.0 - SUM(mark_spent)) /SUM(mark_spent),6) *100 AS ROMI
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name
ORDER BY CAC DESC;


--What is the highest CAC where ROMI is still pozitive?


SELECT campaign_name, c_dateconverted,
	  MAX(CAST(mark_spent AS float) * 1.0 /NULLIF (orders,0)) AS max_CAC,
	  ROUND(SUM(revenue - mark_spent ) / SUM(mark_spent),3) AS pozitive_ROMI 
FROM  dbo.MarketingAnalysis2
WHERE (revenue - mark_spent ) / mark_spent > 0 
GROUP BY campaign_name,c_dateconverted
ORDER BY max_CAC DESC;


--What is the lowest CAC with pozitive ROMI?


SELECT campaign_name, c_dateconverted,
	  MIN(CAST(mark_spent AS float) * 1.0 /NULLIF (orders,0)) AS min_CAC,
	  ROUND(SUM(revenue - mark_spent ) / SUM(mark_spent),3) AS pozitive_ROMI 
FROM  dbo.MarketingAnalysis2
WHERE (revenue - mark_spent ) / mark_spent > 0 
GROUP BY campaign_name,c_dateconverted
ORDER BY  min_CAC ASC;


--Customer Segment Profitability(CSP) calculations


SELECT category,
       SUM(revenue) AS Total_Revenue,
	   SUM(mark_spent) AS Total_Mark_Spent,
       SUM(revenue) - SUM(mark_spent) AS Profit,
	   ROUND((SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent),6) AS ROI,
	   ROUND((SUM(revenue) - SUM(mark_spent)) / SUM(revenue),4) * 100 AS Segment_Profitability_Margin_SPM
FROM dbo.MarketingAnalysis2
GROUP BY category
ORDER BY Profit DESC;



--What is the highest CAC in the second half of the month, between '2021-02-15' AND'2021-02-28'where ROMI is still pozitive?



SELECT campaign_name, c_dateconverted,  
       MAX((mark_spent) * 1.0 /NULLIF (orders,0)) AS max_CAC,
       SUM(revenue - mark_spent ) / SUM(mark_spent) AS pozitive_ROMI
FROM   dbo.MarketingAnalysis2
WHERE  ( revenue - mark_spent ) / mark_spent > 0 
       AND c_dateconverted between '2021-02-15' AND'2021-02-28'   
GROUP BY campaign_name, c_dateconverted
ORDER BY max_CAC DESC;


--What is the lowest CAC with pozitive ROMI in the second half of the month, between '2021-02-15' AND'2021-02-28'?



SELECT campaign_name, c_dateconverted,
	  MIN(CAST(mark_spent AS float) * 1.0 /NULLIF (orders,0)) AS min_CAC,
	  ROUND(SUM(revenue - mark_spent ) / SUM(mark_spent),3) AS pozitive_ROMI 
FROM  dbo.MarketingAnalysis2
WHERE (revenue - mark_spent ) / mark_spent > 0 
      AND c_dateconverted between '2021-02-15' AND '2021-02-28'
GROUP BY campaign_name,c_dateconverted
ORDER BY min_CAC ASC;



 --When buyers are more active? MQL_to_SQL_conversion_rate is greater on weekdays or weekends?

--1--MQL_to_SQL_conversion_rate on 'weekdays'


 SELECT campaign_name, category,
       SUM(impressions) AS total_impressions,
	   SUM(clicks) AS total_clicks,
	   ROUND(SUM(clicks) *1.0 / SUM(impressions),5) * 100 AS CTR,
	   ROUND(SUM(leads) *1.0/ SUM(clicks),5) *100 AS Visitor_to_lead_conversion_rate,
	   ROUND(SUM(orders) *1.0 / SUM(leads),6) * 100 AS MQL_to_SQL_conversion_rate,
	   ROUND(SUM(revenue) / SUM(orders),5) AS AOV
FROM dbo.MarketingAnalysis2
WHERE DATENAME(weekday, c_dateconverted) NOT IN ('Saterday', 'Sunday')
GROUP BY campaign_name, category
ORDER BY MQL_to_SQL_conversion_rate DESC;


--2--MQL_to_SQL_conversion_rate on 'weekends'


SELECT campaign_name, category,
       SUM(impressions) AS total_impressions,
	   SUM(clicks) AS total_clicks,
	   ROUND(SUM(clicks) *1.0 / SUM(impressions),5) * 100 AS CTR,
	   ROUND(SUM(leads) *1.0/ SUM(clicks),5) *100 AS Visitor_to_lead_conversion_rate,
	   ROUND(SUM(orders) *1.0 / SUM(leads),6) * 100 AS MQL_to_SQL_conversion_rate,
	   ROUND(SUM(revenue) / SUM(orders),5) AS AOV
FROM dbo.MarketingAnalysis2
WHERE DATENAME(weekday, c_dateconverted) IN ('Saterday', 'Sunday')
GROUP BY campaign_name, category
ORDER BY MQL_to_SQL_conversion_rate DESC;



--What is the ratio of gross profit between weekdays and weekends?


SELECT campaign_name, category,
       MAX( revenue - mark_spent )AS max_gross_profit
FROM   dbo.MarketingAnalysis2
WHERE DATENAME(weekday, c_dateconverted) NOT IN ('Saterday', 'Sunday')
GROUP BY campaign_name, category
ORDER  BY max_gross_profit DESC;




SELECT campaign_name, category,
       MAX( revenue - mark_spent )AS max_gross_profit
FROM   dbo.MarketingAnalysis2
WHERE DATENAME(weekday, c_dateconverted) IN ('Saterday', 'Sunday')
GROUP BY campaign_name, category
ORDER  BY max_gross_profit DESC; 



--Delete unused column


ALTER TABLE dbo.MarketingAnalysis2
DROP COLUMN c_date

SELECT*
FROM dbo.MarketingAnalysis2
