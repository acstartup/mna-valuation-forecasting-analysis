-- ====================================================================
-- Project: M&A Valuation & Financial Forecasting Analysis
-- Script: 02_profitability_kpis.sql
-- Purpose: Calculate profitability margin metrics: net profit 
--          margin %, expense to revenue %
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Create Profibility Margins View With Net Margin % & Expense Ratio %
CREATE OR REPLACE VIEW v_profitability_kpis AS
SELECT
    year,
    revenue,
    expense,
    profit,
    ROUND((profit/gross_income) * 100, 2) AS net_margin_pct,
    ROUND((expense/gross_income) * 100, 2) AS expense_revenue_pct
FROM company_financials;

-- Step 2: Report Output Query
SELECT * 
FROM v_profitability_kpis
ORDER BY year ASC;