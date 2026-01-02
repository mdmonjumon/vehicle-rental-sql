create database Vehicle_Rental

-- create enum type for vehicle
create type vehicle_type as enum('car', 'bike', 'truck');

-- create emnu type for availability status
create type availability_type as enum('available', 'rented', 'maintenance');

-- create enum type for booking status
create type booking_type as enum('pending', 'confirmed','completed', 'cancelled');


create table users(
  user_id serial primary key,
  user_name varchar(50) not null,
  email varchar(50) unique not null,
  password varchar(100) not null,
  phone varchar(20) not null
)


create table vehicles(
  vehicle_id serial primary key,
  vehicle_name varchar(100) not null,
  type vehicle_type,
  model varchar(50) not null,
  registration_number varchar(100) unique not null,
  price_per_day decimal(10,2) not null,
  availability_status availability_type
);


create table bookings(
  booking_id serial primary key,
  user_id int,
  foreign key (user_id) references users(user_id),
  vehicle_id int,
  foreign key (vehicle_id) references vehicles(vehicle_id),
  start_date date not null,
  end_date date not null,
  booking_status booking_type,
  total_price decimal(10,2)
);


-- insert data into users table
insert into users(user_name, email, password, phone)
values
  ('Alice Johnson',  'alice.johnson@gmail.com',  'password123',  '1234567890'),
  ('Bob Smith',      'bob.smith@gmail.com',      'password123',  '1234567891'),
  ('Charlie Brown',  'charlie.brown@gmail.com',  'password123',  '1234567892'),
  ('Diana Miller',   'diana.miller@gmail.com',   'password123',  '1234567893'),
  ('Ethan Wilson',   'ethan.wilson@gmail.com',   'password123',  '1234567894'),
  ('Fiona Davis',    'fiona.davis@gmail.com',    'password123',  '1234567895'),
  ('George Taylor',  'george.taylor@gmail.com',  'password123',  '1234567896'),
  ('Hannah Moore',   'hannah.moore@gmail.com',   'password123',  '1234567897'),
  ('Ian Anderson',   'ian.anderson@gmail.com',   'password123',  '1234567898'),
  ('Julia Thomas',   'julia.thomas@gmail.com',   'password123',  '1234567899');

-- insert data into vehicles table
insert into vehicles(vehicle_name, type, model, registration_number, price_per_day, availability_status)
values
('Toyota Corolla',   'car',   '2021', 'TN01AB1234', 2500.00, 'available'),
('Honda City',       'car',   '2022', 'TN02CD5678', 2800.00, 'available'),
('Hyundai i20',      'car',   '2020', 'TN03EF9012', 2200.00, 'rented'),
('Maruti Swift',     'car',   '2019', 'TN04GH3456', 2000.00, 'available'),
('Tata Ace',         'truck', '2018', 'TN05IJ7890', 5000.00, 'available'),
('Mahindra Bolero',  'truck', '2020', 'TN06KL1122', 5500.00, 'rented'),
('Ashok Leyland',    'truck', '2019', 'TN07MN3344', 7000.00, 'maintenance'),
('Eicher Pro',       'truck', '2021', 'TN08OP5566', 6500.00, 'available'),
('Isuzu D-Max',      'truck', '2022', 'TN09QR7788', 6000.00, 'available'),
('BharatBenz 1217',  'truck', '2020', 'TN10ST9900', 7200.00, 'rented'),
('Royal Enfield',    'bike',  '2020', 'TN11UV1212', 1200.00, 'available'),
('Yamaha R15',       'bike',  '2021', 'TN12WX3434', 1000.00, 'available'),
('Bajaj Pulsar',     'bike',  '2019', 'TN13YZ5656', 900.00,  'rented'),
('TVS Apache',       'bike',  '2022', 'TN14AA7878', 1100.00, 'available'),
('Honda Activa',     'bike',  '2021', 'TN15BB9090', 800.00,  'maintenance');


-- insert datas into bookings table
insert into bookings(user_id, vehicle_id, start_date, end_date, booking_status)
values
(1,  1,  '2025-01-01', '2025-01-05', 'pending'),
(2,  3,  '2025-01-03', '2025-01-06', 'completed'),
(3,  5,  '2025-01-10', '2025-01-15', 'confirmed'),
(4,  2,  '2025-01-12', '2025-01-14', 'completed'),
(5,  7,  '2025-01-18', '2025-01-22', 'pending'),
(6,  10, '2025-01-20', '2025-01-25', 'confirmed'),
(7,  11, '2025-01-05', '2025-01-07', 'completed'),
(8,  13, '2025-01-08', '2025-01-10', 'cancelled'),
(9,  4,  '2025-01-15', '2025-01-18', 'pending'),
(10, 15, '2025-01-21', '2025-01-23', 'cancelled');

-- creating trigger to calculate total price for bookings table
create trigger calculate_bookings_total_price
before insert or update
on bookings
for each row
execute function calculate_bookings_total_price();

-- creating function to calculate total price for bookings table
create function calculate_bookings_total_price()
returns trigger
language plpgsql
as
$$
declare price decimal(10, 2);
begin
select 
price_per_day
into price
from vehicles as v
where v.vehicle_id = new.vehicle_id;
new.total_price:= (new.end_date - new.start_date) * price;
return new;
end;
$$

-- Retrieve booking information along with customer name and vehicle name
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

-- Find all vehicles that have never been booked
select * from vehicles as v
where not exists(select * from bookings as b where v.vehicle_id = b.vehicle_id);


-- Retrieve all available of specific type car
select * from vehicles
where type = 'car' and availability_status = 'available';

-- Find the total number of bookings for each vehicle 
-- and display only those vehicles that have more the 2 booking

select vehicle_name, count(*) as "Total bookings" from bookings
inner join vehicles using(vehicle_id)
group by vehicle_name
having count(*) > 2;