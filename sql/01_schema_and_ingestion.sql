-- ====================================================================
-- Project: M&A Valuation & Financial Forecasting Analysis
-- Script: 01_schema_and_ingestion.sql
-- Purpose: Create company_financials table schema and insert 
--          client-given downloaded csv data for M&A into table.
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Database Schema Creation
CREATE TABLE IF NOT EXISTS company_financials (
    year INT PRIMARY KEY,
    revenue NUMERIC(12, 2) NOT NULL,
    expense NUMERIC(12, 2) NOT NULL,
    profit NUMERIC(12, 2) NOT NULL
);

-- Step 2: Data Insertion From Files (Client-Given)
COPY company_financials(year, revenue, expense, profit)
FROM '/tmp/mna_data.csv'
WITH (FORMAT csv, HEADER true);