# Olist E-Commerce Customer Churn Analysis

An end-to-end data analytics pipeline analyzing customer churn patterns for Brazil's largest e-commerce platform, using 100K+ real transactions across a modern data stack.

## Live Dashboard
**[View on Tableau Public →]((https://public.tableau.com/app/profile/prannay.khushalani6822/viz/OlistE-commerceCustomerChurnAnalysis/Dashboard1))**

## Tech Stack
| Layer | Tool |
|---|---|
| Cloud Warehouse | Snowflake |
| Data Transformation | dbt (3-layer architecture) |
| ML Modeling | XGBoost + SHAP |
| Visualization | Tableau Public |
| Language | Python (pandas, scikit-learn, matplotlib) |
| Version Control | Git |

## Project Architecture
```
Raw CSV Data (Kaggle Olist Dataset)
        ↓
Snowflake RAW Schema (8 tables, RSA key-pair auth)
        ↓
dbt Staging Layer (6 views — cleaning & renaming)
        ↓
dbt Intermediate Layer (2 views — joins & enrichment)
        ↓
dbt Mart Layer (2 tables — RFM + Churn features)
        ↓
Python (EDA, A/B Testing, XGBoost, SHAP)
        ↓
Tableau Dashboard (4 charts, 4 KPI tiles, 2 filters)
```

## Key Findings
- **81.6% churn rate** across 98,207 customers (no purchase in 90+ days)
- **Delivery speed is the #1 churn driver**: Very High Risk customers wait **27.3 days** vs **5.5 days** for Low Risk — a 5x difference
- **14,015 customers** identified as Very High Risk (churn probability > 75%)
- **XGBoost AUC: 0.737** after removing data leakage
- States **RR, AP, AM** have highest churn rates (>85%)
- A/B test confirmed statistically significant churn difference between delivery cohorts (p < 0.001)

## Business Recommendations
1. Target 14,015 Very High Risk customers with re-engagement campaigns
2. Reduce avg delivery time from 27 to 15 days for high-risk customers
3. Deploy regional fulfillment centers in Northern Brazil (AM, PA, RR)
4. Implement post-delivery follow-up for customers with avg review score < 3.0

## Model Details
- **Algorithm:** XGBoost Classifier
- **AUC-ROC:** 0.737
- **Top SHAP Features:** avg_delivery_days, avg_order_value, state_encoded, monetary, avg_review_score
- **Data Leakage Fix:** Removed recency_days which directly encoded the churn label (caused AUC=1.0)

## Dataset
[Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 100K orders from 2016–2018
