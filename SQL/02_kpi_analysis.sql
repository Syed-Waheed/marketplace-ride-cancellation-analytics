-- ============================================================
-- PROJECT 1
-- 02_kpi_analysis.sql
-- Marketplace KPI Analysis
-- ============================================================


-- Q1. Overall Customer Cancellation Rate

SELECT
    COUNT(*) AS total_bookings,
    SUM(is_customer_cancelled) AS customer_cancelled_bookings,
    ROUND(
        SUM(is_customer_cancelled) * 100.0 / COUNT(*),
        2
    ) AS customer_cancellation_rate_pct
FROM rides;


-- Q2. Booking outcome distribution

SELECT 'Completed' AS booking_outcome,
       SUM(is_completed) AS bookings,
       ROUND(
           SUM(is_completed) * 100.0 / COUNT(*),
           2
       ) AS share_of_all_bookings_pct
FROM rides

UNION ALL

SELECT 'Customer Cancelled',
       SUM(is_customer_cancelled),
       ROUND(
           SUM(is_customer_cancelled) * 100.0 / COUNT(*),
           2
       )
FROM rides

UNION ALL

SELECT 'Driver Cancelled',
       SUM(is_driver_cancelled),
       ROUND(
           SUM(is_driver_cancelled) * 100.0 / COUNT(*),
           2
       )
FROM rides

UNION ALL

SELECT 'No Driver Found',
       SUM(is_no_driver),
       ROUND(
           SUM(is_no_driver) * 100.0 / COUNT(*),
           2
       )
FROM rides

UNION ALL

SELECT 'Incomplete',
       SUM(is_incomplete),
       ROUND(
           SUM(is_incomplete) * 100.0 / COUNT(*),
           2
       )
FROM rides;


-- Q3. Overall marketplace KPI summary

SELECT
    COUNT(*) AS total_bookings,

    SUM(is_completed) AS completed_bookings,
    ROUND(
        SUM(is_completed) * 100.0 / COUNT(*),
        2
    ) AS completion_rate_pct,

    SUM(is_customer_cancelled) AS customer_cancellations,
    ROUND(
        SUM(is_customer_cancelled) * 100.0 / COUNT(*),
        2
    ) AS customer_cancellation_rate_pct,

    SUM(is_driver_cancelled) AS driver_cancellations,
    ROUND(
        SUM(is_driver_cancelled) * 100.0 / COUNT(*),
        2
    ) AS driver_cancellation_rate_pct,

    SUM(is_no_driver) AS no_driver_bookings,
    ROUND(
        SUM(is_no_driver) * 100.0 / COUNT(*),
        2
    ) AS no_driver_rate_pct,

    SUM(is_incomplete) AS incomplete_bookings,
    ROUND(
        SUM(is_incomplete) * 100.0 / COUNT(*),
        2
    ) AS incomplete_rate_pct

FROM rides;


-- Q4. Completed rides and booking value

SELECT
    COUNT(*) AS completed_bookings,
    ROUND(SUM(Booking_Value), 2) AS completed_booking_value,
    ROUND(AVG(Booking_Value), 2) AS average_booking_value
FROM rides
WHERE is_completed = 1;


-- Q5. Completed booking value by vehicle type

SELECT
    Vehicle_Type,
    COUNT(*) AS completed_bookings,
    ROUND(SUM(Booking_Value), 2) AS completed_booking_value,
    ROUND(AVG(Booking_Value), 2) AS average_booking_value
FROM rides
WHERE is_completed = 1
GROUP BY Vehicle_Type
ORDER BY completed_booking_value DESC;


-- Q6. Completed booking value by payment method

SELECT
    Payment_Method,
    COUNT(*) AS completed_bookings,
    ROUND(SUM(Booking_Value), 2) AS completed_booking_value,
    ROUND(AVG(Booking_Value), 2) AS average_booking_value
FROM rides
WHERE is_completed = 1
GROUP BY Payment_Method
ORDER BY completed_booking_value DESC;


SELECT * FROM rides;