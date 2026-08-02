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

/* SELECT *
FROM v_cagr_yr_projections