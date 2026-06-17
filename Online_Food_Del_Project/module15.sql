CREATE DATABASE module15;
USE module15;
-- create tables cust - (columns as customer_id,name,signup_date)
CREATE TABLE cust(
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    signup_date DATE
);
DESCRIBE cust;
-- fill values in cust table
INSERT INTO cust (customer_id, name, signup_date) VALUES (1, 'John Doe', '2023-01-15');
INSERT INTO cust (customer_id, name, signup_date) VALUES (2, 'Jane Smith', '2023-02-20');
INSERT INTO cust (customer_id, name, signup_date) VALUES (3, 'Alice Johnson', '2023-03-10');
INSERT INTO cust (customer_id, name, signup_date) VALUES (4, 'Bob Brown', '2023-04-05');
INSERT INTO cust (customer_id, name, signup_date) VALUES (5, 'Charlie Davis', '2023-05-25');
CREATE TABLE product(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255),
    price DECIMAL(10, 2)
);
INSERT INTO product (product_id, product_name, category, price) VALUES (1, 'Laptop', 'Electronics', 999.99);
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES cust(customer_id)
);
INSERT INTO orders (order_id, customer_id, order_date) VALUES (1, 1, '2023-06-01');
INSERT INTO orders (order_id, customer_id, order_date) VALUES (2, 2, '2023-06-02');
INSERT INTO orders (order_id, customer_id, order_date) VALUES (3, 3, '2023-06-03');
INSERT INTO orders (order_id, customer_id, order_date) VALUES (4, 4, '2023-06-04');
CREATE TABLE order_details(
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity) VALUES (1, 1, 1, 2);
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity) VALUES (2, 1, 1, 1);
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity) VALUES (3, 2, 1, 1);
-- 1. display all products under the 'Electronics' category
select * from product where category='Electronics';
-- 2. list products names with price greater than 500
select product_name,price from product where price > 500;
-- 3. count total number of customers
select count(*) as total_customers from cust;
-- 4. find total number of orders per customer
select customer_id, count(*) as total_orders from orders group by customer_id;
-- 5. show category-wise total revenue
select p.category, sum(p.price * od.quantity) as total_revenue
from order_details od
join product p on od.product_id = p.product_id
group by p.category;
