-- ============================================================
-- PROJECT 1
-- 07_location_vehicle_analysis.sql
-- Location & Vehicle Analysis
-- ============================================================


-- Q1. Customer cancellation rate by pickup location
-- Minimum 500 bookings to make comparisons more reliable

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,
    ROUND(
        AVG(Avg_VTAT),
        2
    ) AS avg_vtat
FROM rides
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY customer_cancellation_rate_pct DESC;


-- Q2. 15 pickup locations with the highest cancellation rate

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,
    ROUND(
        AVG(Avg_VTAT),
        2
    ) AS avg_vtat
FROM rides
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY customer_cancellation_rate_pct DESC
LIMIT 15;


-- Q3. 15 pickup locations with the lowest cancellation rate

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,
    ROUND(
        AVG(Avg_VTAT),
        2
    ) AS avg_vtat
FROM rides
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY customer_cancellation_rate_pct ASC
LIMIT 15;


-- Q4. Pickup locations with the most customer cancellations
-- This is cancellation VOLUME, not cancellation RATE

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        SUM(is_customer_cancelled) * 100.0 /
        COUNT(*),
        2
    ) AS customer_cancellation_rate_pct
FROM rides
GROUP BY Pickup_Location
ORDER BY customer_cancellations DESC
LIMIT 15;


-- Q5. Customer cancellation rate by vehicle type

SELECT
    Vehicle_Type,
    COUNT(*) AS bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,
    ROUND(
        AVG(Avg_VTAT),
        2
    ) AS avg_vtat
FROM rides
GROUP BY Vehicle_Type
ORDER BY customer_cancellation_rate_pct DESC;


-- Q6. Vehicle type and cancellation outcome mix

SELECT
    Vehicle_Type,
    COUNT(*) AS bookings,
    SUM(is_completed) AS completed_bookings,
    SUM(is_customer_cancelled) AS customer_cancellations,
    SUM(is_driver_cancelled) AS driver_cancellations,
    SUM(is_no_driver) AS no_driver_cases,
    ROUND(
        AVG(is_completed) * 100,
        2
    ) AS completion_rate_pct,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,
    ROUND(
        AVG(is_driver_cancelled) * 100,
        2
    ) AS driver_cancellation_rate_pct
FROM rides
GROUP BY Vehicle_Type
ORDER BY customer_cancellation_rate_pct DESC;


-- Q7. Pickup location + VTAT + customer cancellation

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,
    ROUND(
        AVG(Avg_VTAT),
        2
    ) AS avg_vtat,
    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct
FROM rides
WHERE Avg_VTAT IS NOT NULL
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY avg_vtat DESC;


-- Q8. Vehicle type × period

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


-- Q9. Top pickup locations by customer cancellation rate
-- while also showing driver/no-driver problems

SELECT
    Pickup_Location,
    COUNT(*) AS bookings,

    ROUND(
        AVG(is_customer_cancelled) * 100,
        2
    ) AS customer_cancellation_rate_pct,

    ROUND(
        AVG(is_driver_cancelled) * 100,
        2
    ) AS driver_cancellation_rate_pct,

    ROUND(
        AVG(is_no_driver) * 100,
        2
    ) AS no_driver_rate_pct,

    ROUND(
        AVG(Avg_VTAT),
        2
    ) AS avg_vtat

FROM rides
GROUP BY Pickup_Location
HAVING COUNT(*) >= 500
ORDER BY customer_cancellation_rate_pct DESC
LIMIT 20;