-- ============================================================
-- PROJECT 1
-- 03_customer_cancellation.sql
-- Customer Cancellation Analysis
-- ============================================================


-- Q1. Customer cancellation reasons

SELECT
    Reason_for_cancelling_by_Customer AS cancellation_reason,
    COUNT(*) AS cancellations,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS share_of_customer_cancellations_pct
FROM rides
WHERE is_customer_cancelled = 1
GROUP BY Reason_for_cancelling_by_Customer
ORDER BY cancellations DESC;


-- Q2. Customer cancellation rate by vehicle type

SELECT
    Vehicle_Type,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY Vehicle_Type
ORDER BY customer_cancellation_rate_pct DESC;


-- Q3. Customer cancellation rate: New vs Repeat

SELECT
    customer_type,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY customer_type
ORDER BY customer_cancellation_rate_pct DESC;


-- Q4. Customer cancellation rate by pickup location

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY customer_cancellation_rate_pct DESC;


-- Q5. Top pickup locations by customer cancellation volume

SELECT
    Pickup_Location,
    COUNT(*) AS customer_cancellations
FROM rides
WHERE is_customer_cancelled = 1
GROUP BY Pickup_Location
ORDER BY customer_cancellations DESC
LIMIT 15;


-- Q6. Customer cancellation rate by payment method

SELECT
    COALESCE(Payment_Method, 'Missing / Not Available') AS payment_method,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY COALESCE(Payment_Method, 'Missing / Not Available')
ORDER BY customer_cancellation_rate_pct DESC;