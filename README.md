# Vehicle Rental System - Database Design & SQL Queries

The Vehicle Rental Management System is a relational database project designed to manage vehicle rentals efficiently. It handles users, vehicles, and bookings while ensuring data integrity through constraints, ENUM types, triggers, and functions. This project is implemented using PostgreSQL and demonstrates real-world database design and querying techniques.


#### Below are the SQL queries used in this project along with their corresponding solutions.

```
Query-1: Retrieve booking information along with customer name and vehicle name.

Solutions:-

select
  b.booking_id,
  b.user_id,
  b.vehicle_id,
  u.user_name as "Customer Name",
  v.vehicle_name as "Vehicle Name",
  b.start_date,
  b.end_date,
  b.booking_status,
  b.total_price
from bookings as b
inner join users as u using(user_id)
inner join vehicles as v using(vehicle_id)
```
```
Query-2: Find all vehicles that have never been booked.
Solutions:

select * from vehicles as v
where not exists(select * from bookings as b where v.vehicle_id = b.vehicle_id);
```

```
Query-3: Retrieve all available of specific type car.
Solutions:

select * from vehicles
where type = 'car' and availability_status = 'available';
```

```
Query-4: Find the total number of bookings for each vehicle 
and display only those vehicles that have more the 2 booking.

Solutions:

select vehicle_name, count(*) as "Total bookings" from bookings
inner join vehicles using(vehicle_id)
group by vehicle_name
having count(*) > 2;
```
