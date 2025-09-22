# 🍽️ Zomato SQL Project

## 👋 Overview

This project simulates a **Zomato-like Food Delivery Platform** using **MySQL**. It includes customer management, restaurants, menu items, orders, deliveries, and ratings.
The dataset contains **10,000+ rows** and is ideal for practicing SQL queries, joins, aggregations, and analytics.

---

## 🗂️ Tables

| Table Name          | Description                                                    |
| ------------------- | -------------------------------------------------------------- |
| `customers`         | Stores customer information, signup date, and city             |
| `restaurants`       | Contains restaurant details, cuisine, rating, and opening date |
| `menu_items`        | Menu items for each restaurant with price and category         |
| `orders`            | Customer orders including total amount and payment method      |
| `order_details`     | Items ordered per order with quantity and price                |
| `delivery_partners` | Delivery partner info including vehicle type and rating        |
| `deliveries`        | Tracks order delivery time and delivery partner                |
| `ratings`           | Customer ratings and reviews for orders/restaurants            |

---

## 🔑 Key Features

* Realistic simulation of a food delivery platform
* Fully normalized schema with **foreign key constraints**
* Sample data of **10,000+ records**
* Supports **complex SQL queries** and analytics

---

## 💾 Sample Queries

### 1️⃣ Customer Analytics

* **Top 10 cities with the most customers**

```sql
SELECT CITY, COUNT(*) AS customer_count
FROM customers
GROUP BY CITY
ORDER BY customer_count DESC
LIMIT 10;
```

* **Recent signups in last 30 days**

```sql
SELECT * FROM customers
WHERE signup_date >= CURDATE() - INTERVAL 30 DAY;
```

---

### 2️⃣ Restaurant Insights

* **Top 5 highest-rated restaurants**

```sql
SELECT name, rating
FROM restaurants
ORDER BY rating DESC
LIMIT 5;
```

* **Restaurants by cuisine type**

```sql
SELECT cuisine, COUNT(*) AS total_restaurants
FROM restaurants
GROUP BY cuisine
ORDER BY total_restaurants DESC;
```

---

### 3️⃣ Menu & Orders

* **Most ordered menu items**

```sql
SELECT mi.item_name, COUNT(*) AS total_orders
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.item_id
GROUP BY mi.item_name
ORDER BY total_orders DESC
LIMIT 10;
```

* **Total revenue per restaurant**

```sql
SELECT r.name, SUM(o.total_amount) AS revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.name
ORDER BY revenue DESC;
```

---

### 4️⃣ Delivery Analytics

* **Top 5 delivery partners by average rating**

```sql
SELECT name, rating
FROM delivery_partners
ORDER BY rating DESC
LIMIT 5;
```

* **Average delivery time per restaurant**

```sql
SELECT r.name, AVG(TIME_TO_SEC(delivery_time)/60) AS avg_delivery_minutes
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.name
ORDER BY avg_delivery_minutes ASC;
```

---

### 5️⃣ Customer Feedback

* **Top-rated restaurants by customers**

```sql
SELECT r.name, AVG(rt.rating) AS avg_rating
FROM ratings rt
JOIN restaurants r ON rt.restaurant_id = r.restaurant_id
GROUP BY r.name
ORDER BY avg_rating DESC
LIMIT 10;
```

* **Orders with ratings below 3**

```sql
SELECT o.order_id, c.name AS customer, r.name AS restaurant, rt.rating
FROM ratings rt
JOIN orders o ON rt.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE rt.rating < 3;
```

---

## 📊 Advanced SQL Use Cases

* Using **window functions** to rank top customers by spending
* Using **subqueries** to find items never ordered
* Using **JOINs** to link customers, orders, deliveries, and ratings

---

## 🚀 Conclusion

This project demonstrates practical SQL skills with **real-world-like datasets**, perfect for:

* Data analysis
* Reporting & dashboards
* SQL interview preparation

---

## 🎯 Highlights

* 💡 Normalized schema
* 🔗 Foreign key relationships
* 📊 Aggregate functions & analytics queries
* 🏆 Ready for **10,000+ row datasets**

---

## ✨ Author

**Aditya Bet**
📧 [adityabet214@gmail.com](mailto:adityabet214@gmail.com)
🔗 [LinkedIn](https://linkedin.com/in/aditya-bet-592372219)
🔗 [GitHub](https://github.com/adityabet)

---

If you want, I can also **create a ready-made PPT slide content** with emojis and screenshots for each query to directly use in your presentation.

Do you want me to do that next?
