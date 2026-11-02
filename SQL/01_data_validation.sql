-- ============================================================
-- PROJECT 1
-- 01_data_validation.sql
-- ============================================================


-- Q1. Check total rows and unique row IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT row_id) AS unique_row_ids
FROM rides;


-- Q2. Find duplicated booking IDs
SELECT
    booking_ID,
    COUNT(*) AS row_count
FROM rides
GROUP BY booking_ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC;


-- Q3. Count how many different booking IDs are duplicated
SELECT
    COUNT(*) AS duplicated_booking_ids
FROM (
    SELECT booking_ID
    FROM rides
    GROUP BY booking_ID
    HAVING COUNT(*) > 1
) AS duplicate_ids;


-- Q4. Check booking status distribution
SELECT
    Booking_Status,
    COUNT(*) AS bookings
FROM rides
GROUP BY Booking_Status
ORDER BY bookings DESC;


-- Q5. Check customer cancellation flag

SELECT
    COUNT(*) AS invalid_customer_cancel_flags
FROM rides
WHERE is_customer_cancelled NOT IN (0, 1);

   
-- Q6. Check driver cancellation flag

SELECT
    COUNT(*) AS invalid_driver_cancel_flags
FROM rides
WHERE is_driver_cancelled NOT IN (0, 1);

-- Q7. Check negative booking values
SELECT
    COUNT(*) AS negative_booking_values
FROM rides
WHERE Booking_Value IS NOT NULL
  AND Booking_Value < 0;


-- Q8. Check negative ride distances
SELECT
    COUNT(*) AS negative_ride_distances
FROM rides
WHERE Ride_Distance IS NOT NULL
  AND Ride_Distance < 0;


-- Q9. Check zero ride distances
SELECT
    COUNT(*) AS zero_ride_distances
FROM rides
WHERE Ride_Distance IS NOT NULL
  AND Ride_Distance = 0;




SELECT * FROM rides;