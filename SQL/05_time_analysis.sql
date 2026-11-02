-- ============================================================
-- PROJECT 1
-- 05_time_analysis.sql
-- Time-Based Customer Cancellation Analysis
-- ============================================================


-- Q1. Customer cancellation rate by hour

SELECT
    hour,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY hour
ORDER BY hour;


-- Q2. Peak vs Off-Peak cancellation rate

SELECT
    period,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY period
ORDER BY period;


-- Q3. Weekday vs Weekend cancellation rate

SELECT
    CASE
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY day_type;


-- Q4. Customer cancellation rate by day of week

SELECT
    day_of_week,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY day_of_week
ORDER BY customer_cancellation_rate_pct DESC;


-- Q5. Monthly customer cancellation trend

SELECT
    month,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY month
ORDER BY month;


-- Q6. Hourly cancellation rate by customer type

SELECT
    hour,
    customer_type,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY hour, customer_type
ORDER BY hour, customer_type;


-- Q7. Peak vs Off-Peak cancellation rate by vehicle type

SELECT
    Vehicle_Type,
    period,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY Vehicle_Type, period
ORDER BY Vehicle_Type, period;