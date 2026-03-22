# 📊 Marketing Metrics & KPIs Analysis Using SQL
---
## 📊 Executive Summary


This project evaluates marketing campaign performance through SQL-based KPI analysis, including CAC, ROMI, and conversion efficiency across the funnel.

The analysis reveals significant performance variation across campaigns, with **“youtube_blogger”** and **“facebook_retargeting”** emerging as the most efficient and scalable, while campaigns like “facebook_lal” show negative returns and inefficient cost structures.

The results highlight clear opportunities for **budget reallocation, campaign optimization, and data-driven marketing strategy improvement.**





## 📌 Project Overview

This project focuses on analyzing marketing campaign performance by calculating key KPIs using SQL. The objective is to evaluate campaign efficiency, profitability, and conversion performance to support data-driven decision-making.

The analysis covers the full marketing funnel—from impressions to conversions—and includes cost efficiency metrics such as CAC, CPM, and ROMI. Additionally, campaign segmentation is applied to identify high-performing and underperforming campaigns for better budget allocation.

---

## 🎯 Business Questions

- Which campaigns generate the highest return on investment (ROMI)?

- Which campaigns are the most cost-efficient in acquiring customers (CAC)?

- How does performance vary across campaign categories?

- Are customers more likely to convert on weekdays or weekends?

- Which campaigns should be scaled, optimized, or discontinued?

--------

## 🗂 Dataset Description

The dataset contains campaign-level marketing data, including:

- Campaign Name

- Category

- Impressions, Clicks, Leads, Orders

- Marketing Spend

- Revenue

- Conversion Date

--------

## 🔄 Analysis Workflow

**1.** Data preparation and validation

**2.** Date transformation for time-based analysis

**3.** Funnel KPI calculations (CTR, conversion rates, AOV)

**4.** Cost and efficiency metrics (CPM, CPC, CPL, CAC)

**5.** Profitability analysis (Gross Profit, ROMI)

**6.** Campaign segmentation for decision-making

**7.** Behavioral analysis (weekday vs weekend performance)

--------

## 📊 Key Metrics

- CTR (Click-Through Rate)

- Visitor-to-Lead Conversion Rate

- MQL to SQL Conversion Rate

- Average Order Value (AOV)

- Customer Acquisition Cost (CAC)

- Cost per Click (CPC), Cost per Lead (CPL), CPM

- Return on Marketing Investment (ROMI)

- Profit & ROI

  --------

 ## 💻 Example SQL – Campaign KPI Calculation
 
```sql
SELECT campaign_name,

       SUM(mark_spent) AS Total_Spend,

       ROUND(SUM(mark_spent) * 1.0 / NULLIF(SUM(orders),0),6) AS CAC,
       
       SUM(revenue) - SUM(mark_spent) AS Profit,
       
       ROUND((SUM(revenue) - SUM(mark_spent)) * 1.0 / NULLIF(SUM(mark_spent),0),6) * 100 AS ROMI       
FROM dbo.MarketingAnalysis2

GROUP BY campaign_name

ORDER BY ROMI DESC;
```



-------

## 🎯 Campaign Performance Segmentation

Campaigns were classified based on efficiency and profitability:

- High Performers → High ROMI & Low CAC → Scalable

- Moderate Performers → Positive ROMI → Optimization opportunities

- Underperformers → Negative ROMI → Require restructuring or discontinuation

This segmentation enables clear budget allocation decisions.


------

## 💡 Key Insights

- The **“youtube_blogger”** campaign demonstrated the strongest overall performance, achieving the **highest ROMI (277.32%),** the **highest gross profit (11.25M),** and the **lowest CAC (2120.13),** making it the most efficient and scalable campaign.

- The **“facebook_retargeting”** campaign also performed strongly, with a **ROMI of 101.49%** and a high **MQL-to-SQL conversion rate (21.34%),** indicating effective audience targeting and conversion efficiency.

- In contrast, the **“facebook_lal”** campaign showed the weakest performance, with a **negative ROMI (-88.63%), high CAC (8986.18),** and significant negative profit, highlighting inefficient budget allocation.

- The **“instagram_tier2”** campaign recorded the **lowest conversion rate (3.01%),** suggesting poor lead quality or ineffective targeting strategy.

- **Influencer campaigns** outperformed other categories overall, achieving the **highest ROI (1.54)** and **Segment Profitability Margin (60%),** confirming their effectiveness in driving profitable growth.

- Customer activity is **higher on weekdays,** resulting in stronger conversion rates and higher average revenue compared to weekends.

  ---------

  ## 📊 Business Recommendations

- Reallocate budget toward high-performing campaigns with strong ROMI and low CAC

- Optimize or pause underperforming campaigns with negative returns

- Focus campaign execution on weekday performance windows

- Continuously monitor both efficiency (CAC) and profitability (ROMI) for decision-making

- Align campaign strategy with high-performing categories

--------

## 🛠 Tools Used

- SQL Server

- SQL (CTEs, Aggregations, KPI Calculations)

  ----------

## 🧠 Skills Demonstrated

- Marketing analytics & KPI framework design

- SQL data analysis and transformation

- Funnel and conversion analysis

- Campaign performance evaluation

- Profitability and cost analysis

- Data-driven business decision making


---------

## ⚠️ Limitations

- The dataset represents a single-month campaign period, limiting long-term trend and seasonality analysis

- No customer-level data available, restricting cohort or retention analysis

  -----------

## 💼 Business Relevance

This project demonstrates how SQL can be used to transform raw marketing data into actionable insights that support:

- Budget allocation decisions

- Campaign optimization strategies

- Performance tracking and reporting

- Marketing efficiency improvement

--------

## 📂 Repository Structure

marketing-kpi-analysis
│
├── data
├── sql
│   └── marketing_kpi_queries.sql
├── images
├── README.md





---------















