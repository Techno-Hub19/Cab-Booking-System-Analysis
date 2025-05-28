# Use the database
USE Cab_Booking_System;

-- 1. Customer and Booking Anaylsis:
SELECT c.name,b.customerid,b.status
FROM bookings as b
INNER JOIN customers as c ON c.customerid = b.customerid
WHERE status = 'Completed';

/*
Insight: We get from this query is 4 peoples have travelled successfully.
*/

-- 2. Customers with More Than 30% Cancellations
SELECT * FROM Bookings;

WITH Cancellation AS (
	SELECT
		customerid,
		SUM(CASE WHEN status ='Canceled' THEN 1 ELSE 0 END)
 		AS CancelLed,
		COUNT(*) AS Total
	FROM bookings
		GROUP BY customerid 
)
SELECT 
	customerid,
	CancelLed,
	Total,
	ROUND(CancelLed / Total*100.0 ,2) AS CancellationRate
FROM Cancellation
	WHERE (CancelLed / Total*100.0 ) > 30;
    
/* 
Insight: The query identifies customers with a cancellation rate over 30%,
highlighting those with potentially risky or unreliable booking behavior.
*/

-- 3. Busiest Day of the Week
SELECT * FROM bookings;

WITH BusiestDay AS (
	SELECT 
			dayofweek(bookingdate) AS MostBookingDone,
            COUNT(*) AS TotalBooking
	FROM bookings
			GROUP BY MostBookingDone
	
)
SELECT 
	TotalBooking,
	MostBookingDone
FROM BusiestDay
	WHERE TotalBooking > 2;

/*
Insight: It shows the day_of_week as (7) is busiest day of week, 
where most of the bookings are done.
*/

# 4. Drivers with Average Rating < 3 in Last 3 Months

SELECT c.driverid AS 'Driver ID',d.name AS 'Driver Name', AVG(f.rating) AS 'Average Rating'
	FROM bookings b
		JOIN feedback f ON f.bookingid = b.bookingid
		JOIN cabs c ON c.cabid = b.cabid
		JOIN Drivers d ON d.driverid= c.driverid
	WHERE f.Rating IS NOT NULL 
		AND f.FeedbackDate >= DATE_SUB('2024-12-01 00:00:00',INTERVAL 3 MONTH)
    GROUP BY c.driverid, d.name
	HAVING AVG(f.rating) < 3;
    
/*
Insights: This query identifies drivers whose average rating from customer feedback in the last 3 months (since 2024-09-01) is below 3, 
signaling potentially poor service quality.
*/

# 5. Top 2 Drivers by Total Distance Covered

SELECT d.driverid AS 'Driver ID',d.name AS 'Driver Name',SUM(tp.distanceKM) AS 'Top Distance Covered'
	FROM bookings b
		JOIN cabs c ON c.cabid = b.cabid
		JOIN Drivers d ON d.driverid= c.driverid
        JOIN tripdetails tp ON tp.bookingid = b.bookingid
		WHERE status = 'Completed'
	GROUP BY d.driverid,d.name 
    ORDER BY SUM(tp.distanceKM) DESC
    LIMIT 2;
    
/*
Insights: This query identifies the top 2 drivers who have covered the greatest total distance in completed trips, 
highlighting the most active drivers.
*/

# 6. Drivers with High Cancellation Rate (>25%)

SELECT d.DriverID, d.Name,
 SUM(CASE WHEN b.Status = 'Canceled' THEN 1 ELSE 0 END) *
100.0 / COUNT(*) AS CancellationRate
FROM Drivers d
JOIN Cabs c ON d.DriverID = c.DriverID
JOIN Bookings b ON c.CabID = b.CabID
GROUP BY d.DriverID, d.Name
HAVING CancellationRate > 25;

/*
Insights: This query identifies drivers whose trip cancellation rate exceeds 25%, 
which may indicate poor reliability or customer service concerns.
*/

 # 7. Monthly Revenue in the Last 6 Months.

SELECT 
    DATE_FORMAT(t.endtime, '%Y-%m') AS `Month`,
    SUM(t.fare) AS `Total Revenue`
FROM tripdetails t
JOIN bookings b ON b.bookingid = t.bookingid
WHERE b.status = 'Completed'
  AND t.endtime >= DATE_SUB(DATE('2025-03-15'), INTERVAL 6 MONTH)
  AND t.endtime < DATE('2025-03-15')
GROUP BY DATE_FORMAT(t.endtime, '%Y-%m')
ORDER BY `Month`;

/*
Insights : Monthly revenue from completed trips steadily increased over the 6 months leading up to March 15, 2025, 
indicating strong business growth.
*/

# 8. Wait Time Per Pickup Location

SELECT 
	b.PickupLocation,
    timestampdiff(MINUTE,bookingdate,starttime) AS 'WaitTime(Minutes)'
FROM bookings b
JOIN tripdetails t ON t.bookingid = b.bookingid;

/*
Insights: Getting the Wait Time Per Pickup Location.
*/

# 9. Sedan vs SUV Revenue Comparison

SELECT 
	c.VehicleType ,
	SUM(t.fare) AS TotalRevenue,
    SUM(t.DistanceKM) AS DistanceCovered0
FROM bookings b
	JOIN cabs c ON c.cabid= b.cabid
	JOIN drivers d ON d.driverid = c.driverid
	JOIN tripdetails t ON t.bookingid = b.bookingid
GROUP BY VehicleType;

/*
Insights: This query compares total revenue and distance covered by Sedan vs. SUV, 
helping identify which vehicle type generates more business value.
*/

# 10. Revenue by Trip Type (Short vs Long)

SELECT * FROM tripdetails;
WITH DistanceRevenue AS (
	SELECT 
		DistanceKM,
        Fare,
		(CASE 
			WHEN DistanceKM < 15 THEN 'Short Trip'
            WHEN DistanceKM >= 15 THEN 'Long Trip' 
		END) AS TripCategory
    FROM tripdetails
)
SELECT 
	TripCategory,
    COUNT(*) AS TotalTrips,
    SUM(Fare) AS TotalRevenue,
    ROUND(AVG(Fare), 2) AS AvgFare,
    ROUND(AVG(DistanceKM), 2) AS AvgDistance
FROM DistanceRevenue
GROUP BY TripCategory;

/*
Insights: Long trips generate more total revenue per trip, while short trips occur more frequently, 
showing a balance between volume and value.
*/