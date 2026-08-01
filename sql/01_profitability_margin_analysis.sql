-- ====================================================================
-- Project: M&A Valuation & Financial Forecasting Analysis
-- Script: 01_profitability_margin_analysis.sql
-- Purpose: Calculate general profitability margin metrics of 
--            gross profit margin % and net profit margin %
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