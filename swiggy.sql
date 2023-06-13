-- SWIGGY CASE STUDY

-- 1. Find customers who have never ordered 

SELECT name from users WHERE user_id NOT IN (SELECT DISTINCT(user_id) FROM orders);

-- 2. Average Price/dish

SELECT m.f_id,f.f_name, AVG(price) AS 'Average price' 
FROM menu m 
JOIN food f ON m.f_id = f.f_id
GROUP BY m.f_id,f_name;

-- 3. Find the top 3 restaurant in terms of the number of orders for a given month

SELECT r_id,COUNT(*) AS 'No.Of Orders' 
FROM orders 
WHERE MONTHNAME(date) LIKE 'MAY' 
GROUP BY r_id 
ORDER BY 'No.Of Orders' 
DESC LIMIT 3;

-- 4. restaurants with monthly sales greater than x for 

SELECT r_name,SUM(amount) AS "REVENUE" 
FROM orders o
JOIN restaurants r
ON o.r_id = r.r_id
WHERE MONTHNAME(date) LIKE 'MAY' 
GROUP BY o.r_id 
HAVING REVENUE > 1500;  

-- 5. Show all orders with order details for a particular customer in a particular date range

SELECT o.user_id,name,COUNT(*) as 'No. Of orders' 
from orders o 
JOIN users u 
ON o.user_id = u.user_id 
WHERE u.name LIKE 'Vartika'
AND
date BETWEEN '2022-05-10' AND '2022-07-10';

-- 6. Find restaurants with max repeated customers

SELECT r_name,COUNT(t.r_id) AS "Repeated_customers"
FROM (
	SELECT r_id,user_id,COUNT(*) AS 'Visits' 
	FROM orders o
	GROUP BY r_id,user_id 
	HAVING Visits > 1 
	) t
JOIN restaurants r 
ON r.r_id = t.r_id
GROUP BY t.r_id
ORDER BY Repeated_customers DESC
LIMIT 1; 

-- 7. Month over month revenue growth of swiggy

SELECT month,((Prev-Earning)/Earning)*100 AS 'GROWTH' FROM(
	WITH Sales AS
		(
		SELECT MONTHNAME(date) AS 'month', SUM(amount) AS 'Earning' 
		FROM orders 
		GROUP BY month
		ORDER BY MONTH(date)
		)
	
SELECT month,Earning,LAG(Earning) OVER() AS Prev FROM Sales
)t;

-- 8. Customer - favorite food 

WITH temp AS
(
	SELECT o.user_id,od.f_id,COUNT(*) AS 'frequency'
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY o.user_id,od.f_id
)
SELECT u.name,f.f_name,frequency FROM
temp t1
JOIN users u 
ON u.user_id = t1.user_id
JOIN food f
ON f.f_id = t1.f_id
WHERE t1.frequency = (
	SELECT MAX(frequency)
    FROM temp t2
    WHERE t2.user_id = t1.user_id
);