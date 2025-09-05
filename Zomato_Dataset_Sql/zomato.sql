CREATE DATABASE zomato;
USE zomato;

-- customers dataset
CREATE TABLE customers(
customer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
email VARCHAR(40) NOT NULL,
phone BIGINT NOT NULL,
address TEXT NOT NULL,
CITY VARCHAR(50),
signup_date DATE
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customers.csv'
into table customers
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- restaurants dataset
CREATE TABLE restaurants(
restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
cuisine VARCHAR(50) NOT NULL,
location VARCHAR(100) NOT NULL,
rating DECIMAL(2,1),
opening_date DATE 
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\restaurants.csv'
into table restaurants
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Select * from restaurants;

-- menu_items dataset
CREATE TABLE menu_items(
item_id INT PRIMARY KEY AUTO_INCREMENT,
restaurant_id INT,
item_name VARCHAR(100),
category VARCHAR(100),
price DECIMAL(8,2),
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\menu_items.csv'
into table menu_items
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- orders dataset
CREATE TABLE orders(
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
restaurant_id INT, 
order_date DATE,
status VARCHAR(70),
total_amount DECIMAL(10,2),
payment_method VARCHAR(50),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\orders.csv'
into table orders
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Select * from orders;

-- order_details dataset
CREATE TABLE order_details(
order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
item_id INT,
quantity INT,
price DECIMAL(8,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\order_details.csv'
into table order_details
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Select *from order_details;

-- delivery_partners
CREATE TABLE delivery_partners(
partner_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40),
phone BIGINT,
vehicle_type VARCHAR(40),
rating DECIMAL(2,1)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\delivery_partners.csv'
into table delivery_partners
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- deliveries
CREATE TABLE deliveries(
delivery_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
partner_id INT,
delivery_time TIME,
delivery_date DATE,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (partner_id) REFERENCES delivery_partners(partner_id)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\deliveries.csv'
into table deliveries
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- ratings dataset
CREATE TABLE ratings(
rating_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
restaurant_id INT,
order_id INT,
rating INT,
review TEXT,
rating_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ratings.csv'
into table ratings
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- Insights
#1. Top 5 restaurants by average rating
	SELECT r.name, r.cuisine, ROUND(AVG(rt.rating),2) AVERAGE_RATING
    FROM restaurants r 
    JOIN ratings rt 
    ON r.restaurant_id = rt.restaurant_id
    GROUP BY r.restaurant_id
    order by AVERAGE_RATING desc
    LIMIT 5;
    
#2. Most popular cuisine by number of orders
	SELECT r.cuisine, count(o.order_id) TOTAL_ORDERS
    from orders o
    JOIN restaurants r
    ON r.restaurant_id = r.restaurant_id
	GROUP BY r.cuisine
	ORDER BY TOTAL_ORDERS desc;
    
#3. Customers who spent the most money
	SELECT c.name, SUM(o.total_amount) TOTAL_SPENT
    from customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    group by name 
    order by TOTAL_SPENT desc
    LIMIT 5;
    
#4. Delivery partner with fastest average delivery time
	SELECT dp.partner_id, dp.name, round(avg(d.delivery_time),2) Delivery_time
    from delivery_partners dp
    Join deliveries d
    on d.partner_id = dp.partner_id
    Group by dp.partner_id
    order by Delivery_time desc
    Limit 1;
    
#5. Restaurant with the highest revenue
	SELECT r.name, sum(o.total_amount) Revenue
    from orders o
    Join restaurants r
    on o.restaurant_id = r.restaurant_id
    Group by r.name
    Order by Revenue desc
    limit 10;
    
#6. Month-wise sales trend
	SELECT date_format(order_date, '%y-%m') Month, sum(total_amount) Total_Sales
    from orders
    Group by month
    Order by Total_Sales desc;
    
#7. Percentage of orders paid by each payment method
	SELECT payment_method, concat(round(count(*) * 100/(Select count(*) from orders),0),'%')Percentage
    From orders
    Group by payment_method
    Order by Percentage desc;
    
#8. Average order value by cuisine
	SELECT r.cuisine, round(avg(o.total_amount),2) Average_Value
    from orders o
    Join restaurants r
    on o.restaurant_id = r.restaurant_id
    Group by cuisine
    Order by Average_Value desc;
    
#9. Most frequently ordered item
	SELECT mi.item_name, count(mi.item_id) Order_court
    From order_details od
    Join menu_items mi
    on od.item_id = mi.item_id 
    Group by item_name
    Order by Order_court desc
    Limit 2;
    
#10. Repeat customers
	SELECT c.name, count(o.customer_id) as Repeated_Customer
    From orders o
    Join customers c
    on o.customer_id = c.customer_id
    Group by name 
    Order by Repeated_Customer desc;
    
#11. Average delivery time per city
    SELECT c.city, concat(round(avg(d.delivery_time),0),' min') Average_Time
    From deliveries d
    Join orders o 
    on d.order_id = o.order_id
    Join customers c
    on o.customer_id = c.customer_id 
    Group by c.city
    Order by Average_Time asc;
    
#12. Highest-rated cuisine 
	SELECT r.cuisine, round(avg(rt.rating)) Average_Rating
    From ratings rt
	Join restaurants r
    on rt.restaurant_id = r.restaurant_id
    Group by r.cuisine
    Order by Average_Rating desc 
    limit 1;		

#13. Customers who gave 5-star ratings
	SELECT distinct(c.name), rt.review, rt.rating
    From ratings rt
    Join customers c
    on rt.customer_id = c.customer_id
    Where rt.rating = 5;

-- ========================================================= END ==============================================================
    
    
	
    
    
    



