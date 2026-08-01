-- ====================================================================
-- Project: M&A Valuation & Financial Forecast Analysis
-- Script: 05_cagr_five_year_projections.sql
-- Purpose: Create a 5-year company financial projects based off
--          CAGR/Expense CAGR market trend scenarios (Bull, Base, Bear)
-- Created By: Aiden Chen
-- ====================================================================

-- Step 1: Determine Scenario Classifications
-- Bull: Optimistic market categorized by faster revenue expansion alongside margin expansions (+4.5% CAGR, +2.5% Expense CAGR)
-- Base: Most likely scenario based off 10Y historical company CAGR (+-0% CAGR, +-0% Expense CAGR)
-- Bear: Pessemistic market categorized by decrease in revenue alongside compressed margins (-1.87% CAGR, +2.0% Expense CAGR)

-- Step 2: Create View of Scenario-Based Projections (Bull, Base, Bear)
CREATE VIEW v_cagr_five_year_projections AS (
    WITH latest_year AS (
        SELECT
            year AS base_year,
            gross_income AS base_revenue,
            expense AS base_expense,
            net_profit AS base_profit,
            (net_profit::NUMERIC / NULLIF(gross_income, 0)) AS base_profit_margin
        FROM company_financials_incl_2026
        WHERE year = 2026
    ),
    scenarios AS (
        SELECT 
            'Bull Case (Expansion)' AS scenario,
            0.0450 AS rev_growth,
            0.0250 AS exp_growth
        UNION ALL

        SELECT 'Base Case (Historical CAGR)' AS scenario, 
            0.0187 AS rev_growth, 
            0.0189 AS exp_growth
        UNION ALL

        SELECT 'Bear Case (Flat)' AS scenario,
            0.0000 AS rev_growth,
            0.0200 AS exp_growth
    ),
    projection_years AS (
        SELECT generate_series(1, 5) AS year_offset
    )
    SELECT
        s.scenario,
        l.base_year + p.year_offset AS projected_year,
        p.year_offset AS year_index,

        ROUND(l.base_revenue * POWER(1+s.rev_growth, p.year_offset), 2) AS projected_revenue,
        ROUND(l.base_expense * POWER(1+s.exp_growth, p.year_offset), 2) AS projected_expense,
        ROUND((l.base_revenue * POWER(1+s.rev_growth, p.year_offset)) - (l.base_expense * POWER(1+exp_growth, p.year_offset)), 2) AS projected_profit,
        ROUND(
            ((l.base_revenue * POWER(1 + s.rev_growth, p.year_offset)) - 
            (l.base_expense * POWER(1 + s.exp_growth, p.year_offset))) / 
            NULLIF(l.base_revenue * POWER(1 + s.rev_growth, p.year_offset), 0) * 100, 
            2
        ) AS projected_net_margin_pct
    FROM latest_year l
    CROSS JOIN scenarios s
    CROSS JOIN projection_years p
    ORDER BY s.scenario, projected_year
);

-- Step 3: Report Output Query
SELECT *
FROM v_cagr_five_year_projections