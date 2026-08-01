-- ====================================================================
-- Project: M&A Valuation & Financial Forecasting Analysis
-- Script: 03_growth_kpis.sql
-- Purpose: Create growth metrics: YoY Revenue Growth % & and 10Y Compounded Annual Growth Rate (CAGR) %
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Create View of YoY Revenue Growth % & 10Y CAGR
CREATE OR REPLACE VIEW v_growth_kpis AS
    WITH prior_years AS (
        SELECT
            year,
            gross_income,
            LAG(gross_income, 1) OVER (ORDER BY year) AS prior_year_gross_income,
            LAG(gross_income, 10) OVER (ORDER BY year ASC) AS ten_year_prior_revenue
        FROM company_financials
    )
    SELECT
        c.year,
        c.gross_income,
        c.expense,
        c.net_profit,
        ROUND((c.gross_income - p.prior_year_gross_income)/(p.prior_year_gross_income) * 100, 2) AS yoy_growth_pct,
        POWER((c.gross_income/p.ten_year_prior_revenue) * 100, (1.0/10.0)) - 1 AS ten_year_cagr
    FROM company_financials c
    JOIN prior_years p
        ON c.year = p.year;

-- Step 2: Report Output Query
SELECT *
FROM v_growth_kpis
ORDER BY year ASC;
