-- ============================================================
-- PROJECT 1
-- 08_advanced_analysis.sql
-- Advanced Business Analysis
-- ============================================================


-- Q1. How much higher is cancellation in the highest VTAT quartile?

WITH vtat_groups AS (
    SELECT
        row_id,
        Avg_VTAT,
        is_customer_cancelled,
        NTILE(4) OVER (
            ORDER BY Avg_VTAT
        ) AS vtat_quartile
    FROM rides
    WHERE Avg_VTAT IS NOT NULL
),

rates AS (
    SELECT
        vtat_quartile,
        COUNT(*) AS bookings,
        SUM(is_customer_cancelled) AS customer_cancellations,
        AVG(is_customer_cancelled) AS cancellation_rate
    FROM vtat_groups
    GROUP BY vtat_quartile
)

SELECT
    vtat_quartile,
    bookings,
    customer_cancellations,
    ROUND(cancellation_rate * 100, 2) AS cancellation_rate_pct
FROM rates
ORDER BY vtat_quartile;


-- Q2. Customer cancellation rate by VTAT quartile AND customer type

WITH vtat_groups AS (
    SELECT
        customer_type,
        Avg_VTAT,
        is_customer_cancelled,
        NTILE(4) OVER (
            ORDER BY Avg_VTAT
        ) AS vtat_quartile
    FROM rides
    WHERE Avg_VTAT IS NOT NULL
)

SELECT
    customer_type,
    vtat_quartile,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS cancellation_rate_pct
FROM vtat_groups
GROUP BY customer_type, vtat_quartile
ORDER BY customer_type, vtat_quartile;


-- Q3. Which pickup locations have BOTH high VTAT and high cancellation?

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    ROUND(AVG(Avg_VTAT), 2) AS avg_vtat,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS cancellation_rate_pct
FROM rides
WHERE Avg_VTAT IS NOT NULL
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY avg_vtat DESC, cancellation_rate_pct DESC;


-- Q4. Failure-mode comparison by pickup location

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,

    SUM(is_customer_cancelled) AS customer_cancellations,
    SUM(is_driver_cancelled) AS driver_cancellations,
    SUM(is_no_driver) AS no_driver_cases,
    SUM(is_incomplete) AS incomplete_cases,

    ROUND(AVG(is_customer_cancelled) * 100, 2)
        AS customer_cancellation_rate_pct,

    ROUND(AVG(is_driver_cancelled) * 100, 2)
        AS driver_cancellation_rate_pct,

    ROUND(AVG(is_no_driver) * 100, 2)
        AS no_driver_rate_pct,

    ROUND(AVG(is_incomplete) * 100, 2)
        AS incomplete_rate_pct

FROM rides
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY customer_cancellation_rate_pct DESC;


-- Q5. Customer cancellation reasons by vehicle type

SELECT
    Vehicle_Type,
    Reason_for_cancelling_by_Customer AS cancellation_reason,
    COUNT(*) AS cancellations
FROM rides
WHERE is_customer_cancelled = 1
GROUP BY Vehicle_Type, Reason_for_cancelling_by_Customer
ORDER BY Vehicle_Type, cancellations DESC;


-- Q6. Customer cancellation rate by hour AND VTAT quartile

WITH vtat_groups AS (
    SELECT
        hour,
        Avg_VTAT,
        is_customer_cancelled,
        NTILE(4) OVER (
            ORDER BY Avg_VTAT
        ) AS vtat_quartile
    FROM rides
    WHERE Avg_VTAT IS NOT NULL
)

SELECT
    hour,
    vtat_quartile,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS cancellation_rate_pct
FROM vtat_groups
GROUP BY hour, vtat_quartile
ORDER BY hour, vtat_quartile;


-- Q7. Customer cancellation vs driver/operational failure

SELECT
    Booking_Status,
    COUNT(*) AS bookings
FROM (
    SELECT 'Customer Cancelled' AS Booking_Status
    FROM rides
    WHERE is_customer_cancelled = 1

    UNION ALL

    SELECT 'Driver Cancelled'
    FROM rides
    WHERE is_driver_cancelled = 1

    UNION ALL

    SELECT 'No Driver Found'
    FROM rides
    WHERE is_no_driver = 1

    UNION ALL

    SELECT 'Incomplete'
    FROM rides
    WHERE is_incomplete = 1

    UNION ALL

    SELECT 'Completed'
    FROM rides
    WHERE is_completed = 1
)
GROUP BY Booking_Status
ORDER BY bookings DESC;