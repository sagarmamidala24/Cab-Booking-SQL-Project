#Table of Contents: 
#➢ Step1: Database Schema 
#➢ Step 2: Data Insertion 
#➢ Step 3: SQL Queries to Explore Insights 
#➢ Step 4: Business Analysis & Use Cases 
#➢ Step 5: Summary & Conclusion 


#Step 1: SETTING UP THE DATABASE SCHEME

# Create Database
CREATE database cb;
use cb;

#CUSTOMER TABLE
create table Customers (
CustID int primary key,
namess Varchar(100),
email varchar(100),
RegistrationDate date
);
describe Customers;
#alter table Customers change Registerationdate  RegistrationDate Date;

#DRIVERS TABLE
create table Drivers (
DriverID int primary key,
namess varchar(100),
JoinDate  date
);

#CABS TABLE
create table cabs (
cabID int primary key,
DriverID int,
VehicleType varchar(20),
PlateNumber varchar(20),
foreign key(DriverID) references Drivers(DriverID)
);

#BOOKINGS TABLE 
create table Bookings(
BookingID int primary key,
CustID int ,
cabID int,
Statuss varchar(20),
Pickuplocation varchar(100),
Dropofflocation varchar(100),
foreign key (custID) references Customers(CustID),
foreign key (cabID) references cabs(cabID)
);

#TRIPDETAILS TABLE
create table TripDetails (
TripID int primary key,
BookingID int,
StartTime datetime,
EndTime Datetime,
DistanceKM float,
Fare Float,
foreign key (BookingID) references Bookings(BookingID)
);

#FEEDBACK TABLE
create table Feedback(
feedbackID int primary key,
BookingID int,
Rating float,
comments text,
feedbackdate date,
foreign key(BookingID) references Bookings(BookingID)
);


#DATA INSERTION
#INSERT CUSTOMERS:

insert into Customers (CustID, namess, email, RegistrationDate) 
values (1, 'Alice Jhonson', 'alice@example.com', '2024-01-15'),
(2,'Bob Smith', 'bob@example.com', '2024-02-20'),
(3,'Charlie Brown', 'charlie@example.com','2024-03-05'),
(4, 'Diana Prince', 'diana@example.com', '2024-04-10');
show tables;

#INSERT DRIVERS:

insert into Drivers (DriverID, namess, JoinDate)
values (101, 'Jhon Driver', '2023-05-10'),
(102, 'Linda Miles', '2023-07-25'),
(103, 'Kevin Road', '2023-08-01'),
(104, 'Sandra Swift', '2023-10-11');

#INSERT CABS:

insert into cabs (CabID, DriverID, VehicleType, PlateNumber)
values (1001, 101, 'Sedan', 'ABCD1234'),
(1002, 102, 'SUV', 'XYZ7894'),
(1003, 103, 'Sedan', 'LMN8907'),
(1004, 104, 'TATA', 'PQR3456');
SELECT * FROM Cabs;


#INSERT BOOKINGS
alter table Bookings add column Bookingdate datetime;
describe Bookings;
insert into Bookings (BookingID, CustID, cabID, Statuss, Pickuplocation, Dropofflocation,Bookingdate)
values(201, 1,1001, 'Completed', 'Downtown','Airport','2024-10-01 08:30:00'),
(202, 2, 1002,'Completed', 'Mall', 'University','2024-10-02 09:00:00'),
(203,3,1003,'Canceled','Station','Downtown','2024-10-03 10:15:00'),
(204,4,1004,'Completed','Suburbs','DownTown','2024-10-04 14:00:00'),
(205,1,1002,'Completed','DownTown','Airport','2024-10-05 18:45:00'),
(206,2,1001,'Canceled','University','Mall','2024-10-06 07:20:00');
SELECT * FROM Bookings;

#INSERT TRIP DETAILS
insert into TripDetails (TripID, BookingID, StartTime,EndTime, DistanceKM, Fare)
values (301,201,'2024-10-01 08:45:00','2024-10-01 09:20:00',18.5,250.00),
(302,202,'2024-10-02 09:10:00', '2024-10-2 09:40:00',12.0,180.00),
(303,204,'2024-10-04 14:10:00','2024-10-04 14:40:00',10.0,150.00),
(304,205,'2024-10-05 18:50:00','2024-10-05 19:30:00',20.0,270.0);

#INSERT FEEDBACK
insert into Feedback (FeedbackID, BookingID, Rating, comments,feedbackDate)
values (401,201,4.5,'Smooth ride','2024-10-01'),
(402,202,3.0,'Driver was late', '2024-10-02'),
(403,204,5.0,'Excellent Serive', '2024-10-04'),
(404,205,2.5,'Cab was not Clean', '2024-10-05');


#Step 3 : SQL Queries to Explore Insights 
#Now that the database is set up with records, we’ll begin answering real-world 
#questions through SQL queries. These queries will help: 
#● Monitor operational efficiency 
#● Understand customer behavior 
#● Track driver performance 
#● Measure revenue and route performance 
#The next section includes SQL queries grouped by business goal along with 
#explanations: 
#● Customer & Booking Analysis 
#● Driver Performance 
#● Revenue Trends 
#● Operational Efficiency 
#● Predictive & Comparative Metrics

#STEP 4 : BUSSINESS ANALYSIS & USE CASES

DESCRIBE Customers;
DESCRIBE bookings;

#1.Customer and Booking Analysis 
select c.CustID, c.namess, count(*) as completedBooking
from Customers c
join bookings b on c.CustID = b.CustID
where b.Statuss = 'Completed'
group by c.CustID, c.namess
order by CompletedBooking desc;
#Insight: Helps identify loyal, engaged customers who complete bookings regularly.Use the SQL questions listed above to analyze: 

#2. Customers with More Than 30% Cancellations 
select CustID,
     sum(case when Statuss = 'Canceled' then 1 else 0 end) as
cancelled,
	  count(*) as total,
      round(100.0 * sum(case when Statuss = 'canceled' then 1 else 0
      end)/ count(*),2) as CancellationRate
      from Bookings
      group by CustID
      having CancellationRate >30;
#Insight: Identifies customers with a high cancellation rate. These might be users with erratic plans or bad app experience. 
      
#3.Busiest Day of the Week 
 select date_format(BookingDate, '%w') as DayofWeek, count(*) as
 TotalBookings
 from Bookings
 group by date_format(BookingDate, '%w')
order by TotalBookings desc;
#Insight: Reveals demand trends for resource and marketing planning. 

#4.Drivers with Average Rating < 3 in Last 3 Months.
SELECT d.DriverID, d.namess, AVG(f.Rating) AS AvgRating
FROM drivers d
JOIN cabs c ON d.DriverID = c.DriverID
JOIN bookings b ON c.cabID = b.cabID
JOIN feedback f ON b.BookingID = f.BookingID
WHERE f.Rating IS NOT NULL
  AND f.feedbackdate >= CURDATE() - INTERVAL 3 MONTH
GROUP BY d.DriverID, d.namess
HAVING AvgRating < 3.0;
#Insight: Spot underperforming drivers who might need training or action.

#5.Top 5 Drivers by Total Distance Covered 
select d.DriverID, d.namess, avg(f.Rating) as AveRating
from Drivers d
join cabs c on d.DriverID = c.DriverID
join Bookings b on c.cabID = b.cabID
join feedback f on b.BookingID = f.BookingID
    where f.Rating is not null and f.feedbackdate>= curdate() - interval 3 month
group by d.DriverID, d.namess
having avg(f.Rating) <3.0;
#Insight: Identify highly active drivers and reward them. 

#6. Drivers with High Cancellation Rate (>25%)
select d.DriverID, d.namess, sum(t.DistanceKM) as TotalDistance
from drivers d
join cabs c on d.DriverId = c.DriverID
join bookings b on c.cabID = b.cabID
join tripdetails t on b.BookingID = t.BookingID
where b.Statuss = 'Completed'
group by d.DriverID, d.namess
order by TotalDistance desc
limit 5;
#Insight: Recognize driver behavior issues early and improve service. 

#7. Monthly Revenue in the Last 6 Months 
select d.DriverID, d.namess,
      sum(case when b.Statuss = 'Canceled' then 1 else 0 end)*
      100.0/count(*) as CancellationRate
from drivers d
join cabs c on d.DriverID = c.DriverID
join bookings b on c.cabID = b.cabID
group by d.DriverID, d.namess
having CancellationRate>25;
#nsight: Observe monthly income trends for financial forecasting. 

#8TOP 3 ROUTES BY BOOKING VOLUME

SELECT MONTH(t.endtime) AS month, SUM(t.fare) AS revenue
FROM tripdetails t
JOIN bookings b ON t.BookingID = b.BookingID
WHERE b.Statuss = 'completed'
  AND t.endtime >= CURDATE() - INTERVAL 6 MONTH
GROUP BY MONTH(t.endtime)
ORDER BY month;
#Insight: Popular routes help optimize pricing and fleet assignment. 

#9.Driver Ratings vs Earnings
select d.DriverID, avg(f.Rating) as AvgRating, count(*) as
TotalTrips, sum(t.Fare) as TotalEarnings
from drivers d
join cabs c on d.DriverID = c.DriverID
join bookings b on c.CabID = b.CabID
join feedback f on b.BookingID = f.BookingID
join tripdetails t on b.BookingID = t.BookingID
group by d.DriverID
order by AvgRating Desc;
#Insight: Analyze the relationship between earnings and customer satisfaction.

#10. Average Wait Time Per Pickup Location.

SELECT Pickuplocation,
       AVG(TIMESTAMPDIFF(MINUTE, b.BookingDate, t.StartTime)) AS AvgWaitTimeMins
FROM bookings b
JOIN tripdetails t ON b.BookingID = t.BookingID
WHERE b.Statuss = 'completed'
GROUP BY Pickuplocation
ORDER BY AvgWaitTimeMins DESC
LIMIT 0, 1000;
#Insight: Identify bottlenecks and long wait times by location.

#11. Common Cancellation Reasons 
select Pickuplocation,
      avg(timestampdiff(minute, b.BookingDate, t.StartTime)) as 
AvgWaitTimeMins
from bookings b
join tripdetails t on b.BookingID = t.BookingID
where b.Statuss = 'completed'
group by Pickuplocation
order by AvgWaitTimeMins desc;
#Insight: Directly learn why users cancel most often. 


#12. Revenue by Trip Type (Short vs Long) 
select 
     case 
         when DistanceKM < 5 then 'Short'
         else 'Long'
	end as Triptype,
    count(*) as NumTrips,
    sum(Fare) as TotalRevenue
from tripdetails
group by 
        case
            when DistanceKm < 5 Then 'Short'
            else 'Long'
		end;
#Insight: Compare how much short and long trips contribute to business.

#13.Revenue by Trip Type (Short vs Long) 
select 
      case
          when DistanceKM < 5 then 'Short'
          else 'Long'
	  end as TripType,
      count(*) as NumTrips,
      sum(fare) as TotalRevenue
from tripdetails
group by
       case
           when DistanceKM < 5 then 'short'
           else 'long'
	   end;
#Insight: Optimize fleet planning based on vehicle profitability. 

#14.Sedan vs SUV Revenue Comparison  
select c.VehicleType, sum(t.Fare) as Revenue
from Cabs c
join bookings b on c.CabID = b.CabID
join tripdetails t on b.BookingID = t.BookingID
where b.Statuss = 'completed'
group by c.VehicleType;
#Insight: Identify at-risk customers for re-engagement campaigns.

#15. Weekend vs Weekday Performance 

SELECT
  CASE
    WHEN DAYNAME(b.BookingDate) IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
  END AS DayType,
  COUNT(*) AS TotalBookings,
  SUM(t.fare) AS TotalRevenue
FROM bookings b
JOIN tripdetails t ON b.BookingID = t.BookingID
GROUP BY
  CASE
    WHEN DAYNAME(b.BookingDate) IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
  END;
#Insight: Understand day-of-week trends for promotional planning. 

#Step 6 : Conclusion 
#This project demonstrated the power of SQL in transforming cab booking operations 
#data into actionable business insights. From customer behavior and driver performance 
#to revenue trends and operational efficiency, each query revealed patterns that help 
#optimize services, improve user satisfaction, and guide data-driven decision-making. 
#Well-structured SQL logic can empower strategic planning and improve real-world 
#business outcomes. 