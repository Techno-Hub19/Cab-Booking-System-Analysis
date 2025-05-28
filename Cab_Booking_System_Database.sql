-- Creating the necessary tables for the CAB_BOOKING_SYSTEM...

-- Customers Table
CREATE TABLE Customers (
 CustomerID INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(100),
 RegistrationDate DATE
);

-- Drivers Table
CREATE TABLE Drivers (
 DriverID INT PRIMARY KEY,
 Name VARCHAR(100),
 JoinDate DATE
);

-- Cabs Table
CREATE TABLE Cabs (
 CabID INT PRIMARY KEY,
 DriverID INT,
 VehicleType VARCHAR(20),
 PlateNumber VARCHAR(20),
 FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

-- Bookings Table
CREATE TABLE Bookings (
 BookingID INT PRIMARY KEY,
 CustomerID INT,
 CabID INT,
 BookingDate TIMESTAMP,
 Status VARCHAR(20),
 PickupLocation VARCHAR(100),
 DropoffLocation VARCHAR(100),
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
 FOREIGN KEY (CabID) REFERENCES Cabs(CabID)
);

-- TripDetails Table
CREATE TABLE TripDetails (
 TripID INT PRIMARY KEY,
 BookingID INT,
 StartTime TIMESTAMP,
 EndTime TIMESTAMP,
 DistanceKM FLOAT,
 Fare FLOAT,
 FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Feedback Table
CREATE TABLE Feedback (
 FeedbackID INT PRIMARY KEY,
 BookingID INT,
 Rating FLOAT,
 Comments TEXT,
 FeedbackDate TIMESTAMP,
 FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Inserting the necessary data into the tables of CAB_BOOKING_SYSYTEM

-- Insert Customers:
INSERT INTO Customers (CustomerID, Name, Email, RegistrationDate) VALUES
(1, 'Alice Johnson', 'alice@example.com', '2023-01-15'),
(2, 'Bob Smith', 'bob@example.com', '2023-02-20'),
(3, 'Charlie Brown', 'charlie@example.com', '2023-03-05'),
(4, 'Diana Prince', 'diana@example.com', '2023-04-10');

-- Insert Drivers:
INSERT INTO Drivers (DriverID, Name, JoinDate) VALUES
(101, 'John Driver', '2022-05-10'),
(102, 'Linda Miles', '2022-07-25'),
(103, 'Kevin Road', '2023-01-01'),
(104, 'Sandra Swift', '2022-11-11');

-- Insert Cabs:
INSERT INTO Cabs (CabID, DriverID, VehicleType, PlateNumber) VALUES
(1001, 101, 'Sedan', 'ABC1234'),
(1002, 102, 'SUV', 'XYZ5678'),
(1003, 103, 'Sedan', 'LMN8901'),
(1004, 104, 'SUV', 'PQR3456');

-- Insert Bookings:
INSERT INTO Bookings (BookingID, CustomerID, CabID, BookingDate,
Status, PickupLocation, DropoffLocation) VALUES
(201, 1, 1001, '2024-10-01 08:30:00', 'Completed', 'Downtown',
'Airport'),
(202, 2, 1002, '2024-10-02 09:00:00', 'Completed', 'Mall',
'University'),
(203, 3, 1003, '2024-10-03 10:15:00', 'Canceled', 'Station',
'Downtown'),
(204, 4, 1004, '2024-10-04 14:00:00', 'Completed', 'Suburbs',
'Downtown'),
(205, 1, 1002, '2024-10-05 18:45:00', 'Completed', 'Downtown',
'Airport'),
(206, 2, 1001, '2024-10-06 07:20:00', 'Canceled', 'University',
'Mall'),
(207, 2, 1002, '2024-10-05 07:45:00',  'Completed',	'Downtown',	
'Airport'),
(208, 1, 1002, '2024-10-05 18:45:00', 'Canceled', 'Suburbs',
'Airport');

-- Insert Trip Details:
INSERT INTO TripDetails (TripID, BookingID, StartTime, EndTime,
DistanceKM, Fare) VALUES
(301, 201, '2024-10-01 08:45:00', '2024-10-01 09:20:00', 18.5,
250.00),
(302, 202, '2024-10-02 09:10:00', '2024-10-02 09:40:00', 12.0,
180.00),
(303, 204, '2024-10-04 14:10:00', '2024-10-04 14:40:00', 10.0,
150.00),
(304, 205, '2024-10-05 18:50:00', '2024-10-05 19:30:00', 20.0,
270.00);

-- Insert Feedback:
INSERT INTO Feedback (FeedbackID, BookingID, Rating, Comments,
FeedbackDate) VALUES
(401, 201, 4.5, 'Smooth ride', '2024-10-01'),
(402, 202, 3.0, 'Driver was late', '2024-10-02'),
(403, 204, 5.0, 'Excellent service', '2024-10-04'),
(404, 205, 2.5, 'Cab was not clean', '2024-10-05');
