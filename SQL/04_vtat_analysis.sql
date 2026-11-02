-- ============================================================
-- PROJECT 1
-- 04_vtat_analysis.sql
-- VTAT / Driver Arrival Time Analysis
-- ============================================================


-- Q1. Overall VTAT statistics

SELECT
    COUNT(Avg_VTAT) AS bookings_with_vtat,
    ROUND(AVG(Avg_VTAT), 2) AS avg_vtat,
    MIN(Avg_VTAT) AS min_vtat,
    MAX(Avg_VTAT) AS max_vtat
FROM rides
WHERE Avg_VTAT IS NOT NULL;


-- Q2. Customer cancellation rate by VTAT quartile

WITH vtat_ranked AS (
    SELECT
        row_id,
        Avg_VTAT,
        is_customer_cancelled,
        NTILE(4) OVER (
            ORDER BY Avg_VTAT
        ) AS vtat_quartile
    FROM rides
    WHERE Avg_VTAT IS NOT NULL
)

SELECT
    vtat_quartile,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,
    ROUND(AVG(Avg_VTAT), 2) AS avg_vtat
FROM vtat_ranked
GROUP BY vtat_quartile
ORDER BY vtat_quartile;


-- Q3. High-VTAT vs normal-VTAT cancellation rate

SELECT
    CASE
        WHEN Avg_VTAT > 11.3 THEN 'High VTAT'
        ELSE 'Normal VTAT'
    END AS vtat_group,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
WHERE Avg_VTAT IS NOT NULL
GROUP BY vtat_group
ORDER BY vtat_group;


-- Q4. VTAT by vehicle type

SELECT
    Vehicle_Type,
    COUNT(Avg_VTAT) AS bookings_with_vtat,
    ROUND(AVG(Avg_VTAT), 2) AS avg_vtat,
    ROUND(MIN(Avg_VTAT), 2) AS min_vtat,
    ROUND(MAX(Avg_VTAT), 2) AS max_vtat
FROM rides
WHERE Avg_VTAT IS NOT NULL
GROUP BY Vehicle_Type
ORDER BY avg_vtat DESC;


-- Q5. Customer cancellation rate by vehicle and VTAT group

SELECT
    Vehicle_Type,
    CASE
        WHEN Avg_VTAT > 11.3 THEN 'High VTAT'
        ELSE 'Normal VTAT'
    END AS vtat_group,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
WHERE Avg_VTAT IS NOT NULL
GROUP BY Vehicle_Type, vtat_group
ORDER BY Vehicle_Type, vtat_group;


-- Q6. Customer cancellation rate by exact VTAT value

SELECT
    Avg_VTAT,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
WHERE Avg_VTAT IS NOT NULL
GROUP BY Avg_VTAT
ORDER BY Avg_VTAT;


-- Q7. Share of all customer cancellations from each VTAT quartile

WITH vtat_ranked AS (
    SELECT
        row_id,
        Avg_VTAT,
        is_customer_cancelled,
        NTILE(4) OVER (
            ORDER BY Avg_VTAT
        ) AS vtat_quartile
    FROM rides
    WHERE Avg_VTAT IS NOT NULL
)

SELECT
    vtat_quartile,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        SUM(is_customer_cancelled) * 100.0 /
        (
            SELECT SUM(is_customer_cancelled)
            FROM vtat_ranked
        ),
        2
    ) AS share_of_customer_cancellations_pct
FROM vtat_ranked
GROUP BY vtat_quartile
ORDER BY vtat_quartile;