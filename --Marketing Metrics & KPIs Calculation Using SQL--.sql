
Marketing Metrics & KPIs Calculation Using SQL
--------------------------------------------------------
 
 1. Data Preparation

-- Create working table

SELECT *
INTO dbo.MarketingAnalysis2
FROM [Portfolio Project].[dbo].[Marketing];

-- Preview data
SELECT * 
FROM dbo.MarketingAnalysis2;

 2. Data Quality Checks
-- Unique campaigns

SELECT DISTINCT campaign_name, category, campaign_id
FROM dbo.MarketingAnalysis2
ORDER BY campaign_name;

-- NULL check 

SELECT COUNT(*) AS count_null_values
FROM dbo.MarketingAnalysis2
     WHERE c_date IS NULL
        OR campaign_name IS NULL
        OR category IS NULL
        OR campaign_id IS NULL
        OR impressions IS NULL
        OR mark_spent IS NULL
        OR clicks IS NULL
        OR leads IS NULL 
        OR orders IS NULL
        OR revenue IS NULL;


 3. Date Transformation

-- Add clean date column

ALTER TABLE dbo.MarketingAnalysis2
ADD c_dateconverted DATE;

-- Populate column

UPDATE dbo.MarketingAnalysis2
SET c_dateconverted = CONVERT(DATE, c_date);


 4. Campaign Duration

SELECT campaign_name,
       MIN(c_dateconverted) AS CampaignStartDate,
       MAX(c_dateconverted) AS CampaignEndDate
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name;

 5. Funnel Metrics (Core KPIs)

SELECT campaign_name, category,
       SUM(impressions) AS total_impressions,
          SUM(clicks) AS total_clicks,
            ROUND(SUM(clicks) * 1.0 / NULLIF(SUM(impressions),0),5) * 100 AS CTR,
              ROUND(SUM(leads) * 1.0 / NULLIF(SUM(clicks),0),5) * 100 AS Visitor_to_Lead_CR,
            ROUND(SUM(orders) * 1.0 / NULLIF(SUM(leads),0),6) * 100 AS MQL_to_SQL_CR,
        ROUND(SUM(revenue) * 1.0 / NULLIF(SUM(orders),0),5) AS AOV
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name, category
ORDER BY AOV DESC;


 6. Spending & Efficiency Metrics

SELECT campaign_name,
       SUM(mark_spent) AS Total_Spend,
          ROUND(SUM(mark_spent) * 1.0 / NULLIF(SUM(impressions),0),6) * 1000 AS CPM,
            ROUND(SUM(mark_spent) * 1.0 / NULLIF(SUM(clicks),0),6) AS CPC,
              ROUND(SUM(mark_spent) * 1.0 / NULLIF(SUM(leads),0),6) AS CPL,
            ROUND(SUM(mark_spent) * 1.0 / NULLIF(SUM(orders),0),6) AS CAC,
          SUM(revenue) - SUM(mark_spent) AS Gross_Profit,
       ROUND((SUM(revenue) - SUM(mark_spent)) * 1.0 / NULLIF(SUM(mark_spent),0),6) * 100 AS ROMI
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name
ORDER BY CAC DESC;


 7. Campaign Performance Segmentation 

SELECT campaign_name,
       SUM(revenue) AS total_revenue,
       SUM(mark_spent) AS total_spend,
            ROUND((SUM(revenue) - SUM(mark_spent)) * 1.0 / NULLIF(SUM(mark_spent),0),5) * 100 AS ROMI,
            ROUND(SUM(mark_spent) * 1.0 / NULLIF(SUM(orders),0),2) AS CAC,

       CASE 
           WHEN (SUM(revenue) - SUM(mark_spent)) / NULLIF(SUM(mark_spent),0) > 1 
                AND SUM(mark_spent) / NULLIF(SUM(orders),0) < 3000 
                THEN 'High Performer'
           WHEN (SUM(revenue) - SUM(mark_spent)) / NULLIF(SUM(mark_spent),0) > 0 
                THEN 'Moderate Performer'
           ELSE 'Underperformer'
       END AS performance_segment

FROM dbo.MarketingAnalysis2
GROUP BY campaign_name
ORDER BY ROMI DESC;



 8. Weekday vs Weekend Analysis

-- Weekdays

SELECT campaign_name, category,
       ROUND(SUM(orders) * 1.0 / NULLIF(SUM(leads),0),6) * 100 AS MQL_to_SQL_CR
FROM dbo.MarketingAnalysis2
WHERE DATENAME(WEEKDAY, c_dateconverted) NOT IN ('Saturday','Sunday')
GROUP BY campaign_name, category;

-- Weekends

SELECT campaign_name, category,
       ROUND(SUM(orders) * 1.0 / NULLIF(SUM(leads),0),6) * 100 AS MQL_to_SQL_CR
FROM dbo.MarketingAnalysis2
WHERE DATENAME(WEEKDAY, c_dateconverted) IN ('Saturday','Sunday')
GROUP BY campaign_name, category;



 9. Profit Comparison (Weekday vs Weekend)

SELECT campaign_name, category,
       SUM(revenue - mark_spent) AS total_profit,
       AVG(revenue) AS avg_revenue
FROM dbo.MarketingAnalysis2
WHERE DATENAME(WEEKDAY, c_dateconverted) NOT IN ('Saturday','Sunday')
GROUP BY campaign_name, category;


 10. Multi-Touch Attribution 

SELECT campaign_name,
       SUM(revenue) AS total_revenue,
       SUM(orders) AS total_orders,
       SUM(revenue) / NULLIF(SUM(orders),0) AS AOV
FROM dbo.MarketingAnalysis2
GROUP BY campaign_name
ORDER BY total_revenue DESC;


 11. Customer Segment Profitability (CSP)

SELECT category,
       SUM(revenue) AS Total_Revenue,
          SUM(mark_spent) AS Total_Spend,
             SUM(revenue) - SUM(mark_spent) AS Profit,
           ROUND((SUM(revenue) - SUM(mark_spent)) / NULLIF(SUM(mark_spent),0),6) AS ROI,
       ROUND((SUM(revenue) - SUM(mark_spent)) / NULLIF(SUM(revenue),0),4) * 100 AS SPM
FROM dbo.MarketingAnalysis2
GROUP BY category
ORDER BY Profit DESC;


 12. Cleanup

ALTER TABLE dbo.MarketingAnalysis2
DROP COLUMN c_date;
