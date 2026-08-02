-- ====================================================================
-- Project: M&A Valuation & Financial Forecast Analysis
-- Script: 04_ytd_2026_projection.sql
-- Purpose: Create projections for end of 2026 revenue, expense,
--          and profit based on Jan-Aug data.
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Backup company_financials Into Processed Version
CREATE TABLE company_financials_incl_2026 AS
SELECT *
FROM company_financials

-- Step 2: Calculations For (YTD/Months-into-2026) * 12
INSERT INTO company_financials(year, revenue, expense, profit)
VALUES (2026, (4813322.50/8) * 12, (4489517.21/8) * 12, 485707.93)

-- Step 3: Review Processed Table Output
SELECT *
FROM company_financials_incl_2026
