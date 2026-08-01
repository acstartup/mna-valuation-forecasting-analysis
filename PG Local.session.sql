CREATE OR REPLACE VIEW v_profitability_margins AS
SELECT
    year,
    gross_income,
    expense,
    net_profit,
    ROUND((net_profit/gross_income) * 100, 2) AS net_margin_pct,
    ROUND((expense/gross_income) * 100, 2) AS expense_revenue_pct
FROM company_financials
ORDER BY year; 
