-- ====================================================================
-- Project: M&A Valuation & Financial Forecasting Analysis
-- Script: 01_profitability_margin_analysis.sql
-- Purpose: Calculate general profitability margin metrics of 
--            net profit margin %, expense to revenue ratio
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Database Schema Creation
CREATE TABLE IF NOT EXISTS company_financials (
    year INT PRIMARY KEY,
    gross_income NUMERIC(12, 2) NOT NULL,
    expense NUMERIC(12, 2) NOT NULL,
    net_profit NUMERIC(12, 2) NOT NULL
);

-- Step 2: Data Insertion From Files (Client-Given)
COPY company_financials(year, gross_income, expense, net_profit)
FROM '/tmp/mna_data.csv'
WITH (FORMAT csv, HEADER true);

-- Step 3: Create Profibility Margins View With Net Margin % & Expense Ratio %
CREATE OR REPLACE VIEW v_profitability_margins AS
SELECT
    year,
    gross_income,
    expense,
    net_profit,
    ROUND((net_profit/gross_income) * 100, 2) AS net_margin_pct,
    ROUND((expense/gross_income) * 100, 2) AS expense_revenue_pct
FROM company_financials;

-- Step 4: Report Output Query
SELECT * 
FROM v_profitability_margins
ORDER BY year ASC;