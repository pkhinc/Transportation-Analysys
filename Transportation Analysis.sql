-- You work in a shipping company called Sea Lions
-- Sea Lions takes orders from customers  - you can order transporation cy-cy (from one port to another)
-- You can also order from Sea Lions inland transporation to/from port 

CREATE database transportation;

show databases;

use transportation;

create table sea_freight (
	ID int auto_increment,
    POL varchar(150) not null,
    POD varchar(150) not null,
    sea_price decimal(7,2) not null,
    currency varchar(50) not null,
    result_period datetime not null,
    sea_vendor varchar(150) not null,
    container_type varchar(150) not null,
    PRIMARY KEY (ID)
    );

create table inland_freight (
	ID int auto_increment,
    start_point varchar(150) not null,
    end_point varchar(150) not null,
    inl_price decimal(7,2) not null,
    currency varchar(50) not null,
    result_period datetime not null,
    inl_vendor varchar(150) not null,
    container_type varchar(150) not null,
    PRIMARY KEY (ID)
    );
    
create table customer_order (
	ID int auto_increment,
    customer varchar(150),
    total_price decimal(7,2) not null,
    currency varchar(50) not null,
    PRIMARY KEY (ID),
    Inl_ID INT,
	foreign key (Inl_ID) references inland_freight(ID),
    Sea_ID INT,
    foreign key (Sea_ID) references sea_freight(ID)
    );
    
show tables;

drop table customer_order;
drop table sea_freight;
drop  table inland_freight;
    
insert into sea_freight 
( POL, POD, sea_price, currency, result_period, sea_vendor, container_type)
values
('Shanghai', 'Gdynia', 1500, 'USD', '2023-06-30', 'EmSiki', 20),
('Reykjavik', 'Helsinborg', 1800, 'EUR', '2023-06-15', 'Hapali', 40),
( 'Gdynia', 'New York', 2500, 'USD', '2023-07-10', 'Mask', 40),
( 'New York', 'Hamburg', 2200, 'USD', '2023-08-10', 'Hapali', 20),
( 'Singapore', 'Gdynia', 1300, 'USD', '2023-09-05', 'Hapali', 20),
( 'Chicago', 'Rauma', 2500, 'EUR', '2023-08-15', 'EmSiKi', 20),
( 'New York', 'Rotterdam', 2200, 'USD', '2023-06-15', 'Mask', 40),
( 'Hong Kong', 'Gdynia', 1500, 'USD', '2023-08-01', 'Hapali', 20),
( 'Los Angeles', 'Gotheborg', 2300, 'EUR', '2023-07-15', 'Mask', 40),
( 'Gdynia', 'Cape Town', 2800, 'USD', '2023-06-10', 'EmSiKi', 40);

select * from sea_freight;

insert into inland_freight
(start_point, end_point, inl_price, currency, result_period, inl_vendor, container_type)
values
('Helsinborg', 'Halmstad', 300, 'EUR', '2023-06-17', 'SE_Trucker', 40),
( 'New York', 'Allentown', 250, 'USD', '2023-07-20', 'US_Trucker', 40),
( 'Hamburg', 'Prague', 550, 'USD', '2023-08-20', 'DE_Trucker', 40),
( 'Gdynia', 'Wejherowo', 150, 'USD', '2023-09-10', 'PL_Trucker', 20),
( 'Rauma', 'Tampere', 550, 'EUR', '2023-08-18', 'FI_Trucker', 20),
( 'Rotterdam', 'Prague', 230, 'USD', '2023-06-16', 'DE_Trucker', 40),
( 'Gotheborg', 'Halmstad', 450, 'EUR', '2023-07-18', 'SE_Trucker', 40);

select * from inland_freight;

insert into customer_order
(customer, total_price, currency, Inl_ID, Sea_ID)
values
('Sabino',  1500, 'USD', null, 1),
('Swedes',  2180, 'EUR', 1, 2),
('Pesese',  3000, 'USD', 2, 3),
('Pesese',  2830, 'USD', 3, 4),
('Sabino',  1530, 'USD', 4, 5),
('Finala',  3250, 'EUR', 5, 6),
('Pesese',  2680, 'USD', 6, 7),
('Finala',  1500, 'USD', null, 8),
('Swedes',  3000, 'EUR', 7, 9),
('Sabino',  2800, 'USD', null, 10);

select * from customer_order;

-- Select all orders which have additional inland leg 

select customer, POL, POD, end_point, total_price, sea_price, inl_price 
from customer_order
join sea_freight
	on sea_freight.ID = customer_order.Sea_ID
join inland_freight
	on inland_freight.ID = customer_order.Inl_ID
group by customer, POL, POD, end_point, total_price, sea_price, inl_price 
order by total_price;

-- Calculate which on which sea vendor shipping company Sea Lions adds highest profit
select customer, sea_vendor, POL, POD, end_point, total_price, sea_price, inl_price, (total_price - (sea_price + inl_price)) as profit
from customer_order
join sea_freight
	on sea_freight.ID = customer_order.Sea_ID
join inland_freight
	on inland_freight.ID = customer_order.Inl_ID
group by customer, sea_vendor, POL, POD, end_point, total_price, sea_price, inl_price
order by profit DESC;

-- Select all orders - also these ones without inland leg
    
select customer, POL, POD, end_point
from sea_freight
left join customer_order
	on sea_freight.ID = customer_order.Sea_ID
left join inland_freight
	on inland_freight.ID = customer_order.Inl_ID;
