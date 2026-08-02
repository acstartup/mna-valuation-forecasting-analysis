-- ====================================================================
-- Project: M&A Valuation & Financial Forecasting Analysis
-- Script: 03_growth_kpis.sql
-- Purpose: Create growth metrics: YoY Revenue Growth % & and 10Y Compounded Annual Growth Rate (CAGR) %
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Create View Of YoY Revenue Growth %, 10Y CAGR, And 10Y Expense CAGR
CREATE OR REPLACE VIEW v_growth_kpis AS
    WITH prior_years AS (
        SELECT
            year,
            revenue,
            expense,
            net_profit,
            LAG(revenue, 1) OVER (ORDER BY year) AS prior_year_revenue,
            LAG(revenue, 10) OVER (ORDER BY year ASC) AS ten_year_prior_revenue
            LAG(expense, 10) OVER (ORDER BY year ASC) AS ten_year_prior_expense
        FROM company_financials
    )
    SELECT
        c.year,
        c.revenue,
        c.expense,
        c.net_profit,
        ROUND((c.revenue - p.prior_year_revenue)/(p.prior_year_revenue) * 100, 2) AS yoy_growth_pct,
        ROUND(POWER((c.revenue/p.ten_year_prior_revenue) * 100, (1.0/10.0)) - 1, 2) AS ten_year_cagr,
        ROUND(POWER((c.expense/p.ten_year_prior_expense) * 100, (1.0/10.0)) - 1, 2) AS ten_year_expense_cagr
    FROM company_financials c
    JOIN prior_years p
        ON c.year = p.year;

-- Step 2: Report Output Query
SELECT *
FROM v_growth_kpis
ORDER BY year ASC;
