CREATE DATABASE food_app_project;
use food_app_project;
-- 1. create table customers where columns are customer_id,name,city,signup_date,gender
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    city VARCHAR(255),
    signup_date DATE not null,
    gender varchar(10)
);
-- Table2: Restaurants(no dependency)
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(255) not null,
    city VARCHAR(255),
    cuisine VARCHAR(100),
    rating DECIMAL(3,2)
);
-- Table3: Delivery_agents(no dependency)
CREATE TABLE delivery_agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(255) not null,
    city VARCHAR(255),
    joining_date DATE,
    rating DECIMAL(3,2)
);
-- Table4: Orders (depends on customers and restaurants)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT not null,
    restaurant_id INT not null,
    order_date DATE not null,
    order_amount DECIMAL(10,2),
    discount DECIMAL(5,2),
    payment_method VARCHAR(50),
    delivery_time int,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
-- Table5: order_items (depends on orders)
CREATE TABLE order_item(
    order_item_id INT PRIMARY KEY,
    order_id INT not null,
    item_name VARCHAR(255),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
-- phase - 8

-- Index on order_date
create index idx_order_date on orders(order_date);
-- Index on customer_name COMMENT
create index i_customer_name on customers(name);

-- phase - 9:

-- auto log high value of order
create TABLE high_value_orders_log(
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    customer_id INT,
    restaurant_id INT,
    order_amount DECIMAL(10,2),
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
create trigger trg_high_value_order
after insert on orders
for each row
begin
    if new.order_amount > 1000 then
        insert into high_value_orders_log
        (order_id,customer_id,restaurant_id,order_amount)
        values
        (new.order_id,new.customer_id,new.restaurant_id,new.order_amount);
    end if;
end;

INSERT INTO orders VALUES (1010, 231, 138, '2024-01-01', 1200.00, 100.00, 'Credit Card', 30);
INSERT INTO orders VALUES (1011, 232, 139, '2024-01-02', 8000.00, 50.00, 'Cash', 25);
-- create trigger to prevent negative discount
create trigger trg_prevent_negative_discount
before insert on orders
for each row
begin
    if new.discount < 0 then
    set new.discount = 0;
    end if;
end;

INSERT INTO orders VALUES(1014,231,138,'2024-01-03',500.00,-20.00,'UPI',20);
SELECT * FROM orders WHERE order_id = 1014; -- discount should be 0

-- delivery delay warning
CREATE TABLE delivery_delay_log (
    log_id INT primary key auto_increment,
    order_id int,
    customer_id int,
    restaurant_id int,
    delivery_time int,
    created_at timestamp default current_timestamp
);

create trigger log_late_delivery
after insert on orders
for each row
begin
    if new.delivery_time > 45 then
    insert into delivery_delay_log(order_id,customer_id,restaurant_id,delivery_time)
    values(new.order_id,new.customer_id,new.restaurant_id,new.delivery_time);
    end if;
end;

INSERT INTO orders VALUES(1016,231,138,'2024-01-04',600.00,30.00,'Credit_Card',55);