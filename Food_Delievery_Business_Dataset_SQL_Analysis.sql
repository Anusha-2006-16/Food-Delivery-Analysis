create database food_Database;
use food_Database;

show tables;

ALTER TABLE `food_delivery_business_dataset (1)`
RENAME TO food_del;

select * 
from food_del;

-- Tasks
-- Total orders
SELECT COUNT(DISTINCT Order_ID) as total_orders
from food_del;

-- Distinct cities
SELECT COUNT(DISTINCT city) as total_cities
from food_del;

-- Distinct cuisines 
SELECT COUNT(DISTINCT cuisine) as total_cuisines
from food_del;

-- Total customers
select COUNT(DISTINCT Customer_ID) as total_customers
from food_del;

-- Total revenue

SELECT ROUND(SUM(Order_Value),2) as total_revenue
from food_del;

-- Delivery Performance Analysis-- 
-- Avg delivery time overall
SELECT ROUND(AVG(Delivery_Time_min),2) as avg_del_time
from food_del;

-- Avg delivery time by city
SELECT city, ROUND(AVG(Delivery_Time_min),2) as avg_del_time
from food_del
group by city
order by avg_del_time desc;

-- Avg delivery time by vehicle
select Vehicle_Type, ROUND(AVG(Delivery_Time_min),2) as avg_del_time
from food_del 
group by Vehicle_Type
order by avg_del_time desc;

-- Avg delivery time by weather

select weather,ROUND(AVG(Delivery_Time_min),2) as avg_del_time
from food_del 
group by weather
order by   avg_del_time desc;

-- Avg delivery time by traffic
SELECT 
    traffic_level,

    ROUND(AVG(Delivery_Time_min),2) AS avg_del_time,

    ROUND(
        (SUM(CASE 
            WHEN Delivery_Time_min > 45 THEN 1 
            ELSE 0 
        END) * 100.0) / COUNT(*),
    2) AS delay_percentage

FROM food_del
GROUP BY traffic_level
ORDER BY avg_del_time DESC;


select * 
from food_del;

-- Delay Analysis

-- Define delayed order:

-- Delivery_Time > 45 mins

-- Analyze:

-- Delayed order %
SELECT 
ROUND(
( COUNT(
	CASE WHEN Delivery_time_min >45 THEN 1
    END)*100.0)/COUNT(*),2)
AS delayed_order_percentage
from food_del;

-- Most delayed city
select city, 
	SUM(Delivery_time_min) AS delivery_time
from food_del
group by city
order by delivery_time desc limit 1;

-- Delays during festivals
select Is_Festival, ROUND(AVG(Delivery_time_min),2) as avg_delay
from food_del
WHERE Delivery_time_min >45
group by Is_Festival ;


-- Delays by weather
select weather, ROUND(AVG(Delivery_time_min),2) as avg_delay
from food_del
WHERE Delivery_time_min >45
group by weather; 

-- Delays by traffic
select Traffic_Level, ROUND(AVG(Delivery_time_min),2) as avg_delay
from food_del
WHERE Delivery_time_min >45
group by Traffic_Level; 

SELECT * FROM food_del;
-- Customer Analysis

-- Avg customer rating
SELECT ROUND(AVG(Customer_Rating),2) AS avg_rating
from food_del;

-- Rating by city
SELECT city, ROUND(AVG(Customer_Rating),2) AS avg_rating
from food_del
group by city
order by avg_rating desc;

-- Rating by cuisine
SELECT cuisine, ROUND(AVG(Customer_Rating),2) AS avg_rating
from food_del
group by cuisine
order by avg_rating desc;


-- Rating by delivery time
SELECT Delivery_Time_min, ROUND(AVG(Customer_Rating),2) AS avg_rating
from food_del
group by Delivery_Time_min
order by avg_rating desc;

-- Rating by traffic condition
SELECT traffic_level, ROUND(AVG(Customer_Rating),2) AS avg_rating
from food_del
group by traffic_level
order by avg_rating desc;


-- Total revenue

SELECT * FROM food_del;

-- Revenue by city
SELECT city,ROUND(SUM(Order_Value) ,2) as total_revenue
from food_del 
group by city
order by total_revenue desc;

-- Revenue by cuisine
SELECT cuisine,ROUND(SUM(Order_Value) ,2) as total_revenue
from food_del 
group by cuisine
order by total_revenue desc;

-- Revenue by time of day
SELECT Time_of_Day,ROUND(SUM(Order_Value) ,2) as total_revenue
from food_del 
group by Time_of_Day
order by total_revenue desc;

-- Highest order value cities
SELECT city,ROUND(SUM(Order_Value) ,2) as total_revenue
from food_del 
group by city
order by total_revenue desc limit 1;

select * from food_del;
-- Courier Performance Analysis
-- Best courier experience level
select DISTINCT Courier_Experience_Years from food_del
order by Courier_Experience_Years desc limit 5;



-- Delivery time vs experience
select Courier_Experience_Years, ROUND(AVG(Delivery_time_min),2) as avg_del_time
from food_del
group by Courier_Experience_Years
order by avg_del_time desc;

-- Ratings vs courier experience
select Courier_Experience_Years, ROUND(AVG(Customer_Rating),2) as avg_cust_rat
from food_del
group by Courier_Experience_Years
order by avg_cust_rat desc;

select * from food_del;
SET SQL_SAFE_UPDATES = 0;
-- Time-Based Analysis
ALTER TABLE food_del
ADD COLUMN Order_Date DATE;

UPDATE food_del
SET Order_Date = DATE(Order_DateTime);

ALTER TABLE food_del
ADD COLUMN Order_Time TIME;

UPDATE food_del
SET Order_Time = TIME(Order_DateTime);

-- Peak order hours
SELECT HOUR(Order_Time) as hour,
	COUNT(Order_ID) as total_orders
    FROM food_del
    group by HOUR(Order_Time)
    Order by total_orders desc;

-- Peak revenue periods
SELECT HOUR(Order_Time) as hour,ROUND( SUM(Order_Value),2) as total_revenue
FROM food_del
GROUP BY hour
ORDER BY total_revenue desc;

-- Most delayed time slots
SELECT HOUR(Order_Time) as hour,
	COUNT(Order_ID) as total_orders
    FROM food_del
    group by HOUR(Order_Time)
    Order by total_orders,hour  ;

-- Best performing shift
ALTER TABLE food_del
ADD COLUMN shift_period VARCHAR(50);

UPDATE food_del
SET shift_period =
CASE
    WHEN HOUR(Order_Time) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(Order_Time) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN HOUR(Order_Time) BETWEEN 17 AND 21 THEN 'Evening'
    ELSE 'Night'
END;


select * from food_del;

-- Rank cities by revenue
SELECT city, ROUND(SUM(Order_Value),2) AS total_revenue ,
RANK() OVER( ORDER BY SUM(Order_Value) DESC) as rnk
FROM food_del
group by city
order by total_revenue desc;

-- Rank cuisines by popularity
SELECT Cuisine, COUNT(Order_ID) AS popularity,
RANK() OVER(ORDER BY COUNT(Order_ID) DESC) as rnk
FROM food_del
group by Cuisine
order by popularity desc;



-- Running total revenue

SELECT Order_ID, Order_Date, Order_Value,
	ROUND(SUM(Order_Value) OVER(ORDER BY Order_Date),2) AS running_total_revenue
FROM food_del;

-- Monthly growth trends-- 
SELECT month(Order_Date) AS month,
ROUND(SUM(Order_Value),2) as monthly_revenue
FROM food_del
GROUP BY month(Order_Date)
ORDER BY month(Order_Date);

select * from food_del;




-- Top performing cities
with top_cities as(
SELECT City, ROUND(SUM(Order_Value),2) as total_revenue
FROM food_del
GROUP BY City
ORDER BY total_revenue DESC limit 5)
SELECT * FROM  top_cities;

-- Monthly revenue growth
WITH monthly_revenue AS (
    SELECT 
        YEAR(order_datetime) AS year,
        MONTH(order_datetime) AS month_no,
        SUM(Order_Value) AS current_month_revenue
    FROM food_del
    GROUP BY YEAR(order_datetime), MONTH(order_datetime)
)

SELECT 
    year,
    month_no,
    current_month_revenue,

    LAG(current_month_revenue) 
    OVER(ORDER BY year, month_no) AS previous_month_revenue,

    ROUND(
        (
            (current_month_revenue - 
            LAG(current_month_revenue) 
            OVER(ORDER BY year, month_no))
            /
            LAG(current_month_revenue) 
            OVER(ORDER BY year, month_no)
        ) * 100,
        2
    ) AS revenue_growth_percentage

FROM monthly_revenue;

-- Customer Satisfaction Level
SELECT 
    Customer_ID,
    `Rating Category`,

    CASE 
        WHEN `Rating Category` IN ('4-5', '5') 
            THEN 'Highly Satisfied'

        WHEN `Rating Category` = '3-4' 
            THEN 'Neutral'

        ELSE 'Dissatisfied'
    END AS satisfaction_level

FROM food_del;

-- Ranking cities & Cuisines based on deman

SELECT  City,
dense_rank( ) OVER(ORDER BY COUNT(Order_ID) DESC) AS rnk
from food_del
group by City;

SELECT  Cuisine,
dense_rank( ) OVER(ORDER BY COUNT(Order_ID) DESC) AS rnk
from food_del
group by Cuisine;

select * from food_del;

ALTER TABLE   food_del
ADD COLUMN month varchar(50);

UPDATE food_del
SET month = MONTHNAME(order_date);

with monthly_revenue as(
select month, ROUND(sum(Order_Date),2) AS total_revenue
from food_del 
group by month)

select month,
total_revenue,
lag(total_revenue) over(order by total_revenue desc) as prev_month_revenue
from monthly_revenue;

select min(Delivery_Time_min),max(Delivery_Time_min) from food_del;

select Customer_ID,ROUND(Order_Value,2),
CASE WHEN `Order_Value` >= 400 THEN 'Low Value Customers'
	WHEN `Order_Value` >=700 THEN 'Medium Value Customers'
    ELSE 'Low Value Customers'
    END AS Customer_Segmentation
from food_del;

SELECT Delivery_Time_min,
CASE WHEN `Delivery_Time_min` < 30 then 'Low Delay'
	when `Delivery_Time_min` < 45 then 'Medium Delay'
    else 'High Delay'
    END AS Delay_Segmentation
from food_del;
    
SELECT COUNT(DISTINCT Customer_ID)
FROM food_del;

SELECT Customer_ID,
COUNT(Order_ID) AS total_orders
FROM food_del
group by Customer_ID;











