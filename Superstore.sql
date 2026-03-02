CREATE TABLE SUPERSTORE(
			 Row_ID INT Primary Key,
			 Order_ID VARCHAR(20),
		 	 Order_Date DATE,
			 Ship_Date DATE,
			 Ship_Mode VARCHAR(20),
             Customer_ID VARCHAR(20),
			 Customer_Name VARCHAR(50),
             Segment VARCHAR(20),
			 Country VARCHAR(20),
    		 City VARCHAR(20),
		     State VARCHAR(20),
  	         Postal_Code VARCHAR(20),
			 Region VARCHAR(20),
			 Product_ID VARCHAR(50),
			 Category VARCHAR(20),
			 Sub_Category VARCHAR(20),
			 Product_Name VARCHAR(200),
			 Sales NUMERIC(10,2),
			 Quantity INT,
			 Discount NUMERIC(4,2),
			 Profit NUMERIC(10,2)
);			 

SELECT * FROM SUPERSTORE;

COPY SUPERSTORE(Row_ID,Order_ID,Order_Date,Ship_Date,Ship_Mode,Customer_ID,Customer_Name,Segment,Country,City,State,Postal_Code,Region,Product_ID,Category,Sub_Category,Product_Name,Sales,Quantity,Discount,Profit)
FROM 'C:/Users/tarib/OneDrive/Desktop/projects/sql/Superstore Sales Analysis/Superstore.csv'
CSV HEADER;

--1. What is the total sales and total profit?
SELECT SUM(SALES) AS TOTAL_SALES, SUM(PROFIT) AS TOTAL_PROFITS
FROM SUPERSTORE;
-- Total Sales = $2,297,200.86 | Total Profit = $286,397.02

--2. What is the overall profit margin (%)?
SELECT SUM(SALES) AS TOTAL_SALES, SUM(PROFIT) AS TOTAL_PROFITS,
ROUND((SUM(PROFIT)/SUM(SALES))*100,2) AS PROFIT_MARGIN
FROM SUPERSTORE;
-- Overall profit margin is 12.47%, indicating moderate profitability across all categories.

--3. How many unique customers are there?
SELECT COUNT(DISTINCT customer_name) AS UNIQUE_CUSTOMERS
FROM SUPERSTORE;
-- There are 793 unique customers in the dataset.

--4. Which category has the highest total sales?
SELECT category,SUM(sales) as total_sales
FROM SUPERSTORE
GROUP BY category
ORDER BY total_sales desc limit 1;
-- Technology is the top category with $836,154.03 in total sales.

--5. Which sub-category has the highest profit?
SELECT sub_category,SUM(PROFIT) as total_profits
FROM SUPERSTORE
GROUP BY sub_category
ORDER BY total_profits desc limit 1;
-- Copiers generate the highest sub-category profit at $55,617.82 despite lower sales volume, indicating very strong margins.

--6. Which region generates the highest revenue?
SELECT region,SUM(SALES) as "revenue"
FROM SUPERSTORE
GROUP BY region
ORDER BY "revenue" desc limit 1;
-- The West region leads in revenue at $725,457.82, largely driven by California.

--7. What are the top 10 most profitable products?
SELECT product_name, SUM(PROFIT) AS total_profit
FROM SUPERSTORE
GROUP BY product_name
ORDER BY total_profit desc limit 10;
-- Canon imageCLASS copiers and high-end technology products dominate the top 10 most profitable list.

--8. How many orders were placed each year?
SELECT EXTRACT(YEAR FROM order_date) as order_year,
COUNT(DISTINCT order_id) as total_orders
FROM SUPERSTORE
GROUP BY order_year;
-- Order volume grew steadily year over year from 2011 to 2014, reflecting business growth.

--9. Which year had the highest sales?
SELECT EXTRACT(YEAR FROM order_date) as order_year,
SUM(sales) AS total_sales
FROM SUPERSTORE
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY total_sales desc limit 1;
-- 2014 was the highest sales year at $733,947.02, continuing an upward trend.

--10. Which products are making losses?
SELECT product_name,category,SUM(profit) as total_profit
FROM SUPERSTORE
GROUP BY product_name,category
HAVING SUM(profit)<0
ORDER BY total_profit ASC;
-- Multiple Furniture products (especially Tables) and some Office Supplies are generating consistent losses.
-- These products should be reviewed for repricing or discontinuation.

--11. Which category has the lowest profit margin?
SELECT category,SUM(SALES) AS total_sales,SUM(profit) AS total_profit,
ROUND((SUM(PROFIT)/SUM(SALES))*100,2) AS margin_percentage
FROM SUPERSTORE
GROUP BY CATEGORY
ORDER BY margin_percentage ASC LIMIT 1;
-- Furniture has the lowest profit margin at just 2.49%, barely breaking even despite significant sales volume.

--12. Does higher discount reduce profit?
SELECT CASE
WHEN discount=0 THEN 'NO DISCOUNT'
WHEN discount<=0.2 THEN 'LOW DISCOUNT'
WHEN discount<=0.5 THEN 'MEDIUM DISCOUNT'
ELSE 'HIGH DISCOUNT'
end as discount_group,
COUNT(*) AS total_orders,
ROUND(AVG(profit),2) as avg_profit,
ROUND(SUM(profit),2) as total_profit
FROM SUPERSTORE
group by discount_group
ORDER BY total_profit;
-- Yes, higher discounts are severely reducing profitability.
-- No Discount orders average $66.90 profit per order. High Discount orders average -$89.44 (a loss).
-- Medium Discount is the worst performer at -$109.53 avg profit. Discounting strategy needs urgent revision.

--13. Who are the top 5 customers by total sales?
SELECT customer_name,SUM(SALES) AS total_sales
FROM SUPERSTORE
GROUP BY customer_name
ORDER BY total_sales desc limit 5;
-- Top 5 customers by sales are high-value accounts that should be prioritized for retention.

--14. Who are the top 5 customers by total profit?
SELECT customer_name,SUM(PROFIT) AS total_profit
FROM SUPERSTORE
GROUP BY customer_name
ORDER BY total_profit desc limit 5;
-- Note: Top customers by sales are not always the same as top customers by profit due to discount differences.

--15. Which state generates highest sales?
SELECT state,SUM(SALES) as total_sales
FROM SUPERSTORE
GROUP BY state
ORDER BY total_sales desc limit 1;
-- California is the #1 state with $457,687.63 in sales, making it the most critical market to protect.

--16. Which city has the highest average profit?
SELECT city,ROUND(AVG(PROFIT),2) AS average_profit
FROM SUPERSTORE
GROUP BY CITY
ORDER BY average_profit desc limit 1;
-- Jamestown has the highest average profit per order at $642.89, suggesting high-value transactions.

--17. What is the monthly sales trend?
SELECT SUM(sales) AS total_sales,TO_CHAR(order_date,'Month') as order_month
FROM SUPERSTORE
GROUP BY TO_CHAR(order_date,'Month')
ORDER BY MIN(EXTRACT(MONTH FROM order_date));
-- Sales show a clear seasonal pattern, with Q4 (October-December) significantly outperforming other months.

--18. Which month historically performs best?
SELECT SUM(sales) AS total_sales,TO_CHAR(order_date,'Month') as order_month
FROM SUPERSTORE
GROUP BY TO_CHAR(order_date,'Month')
ORDER BY total_sales DESC LIMIT 1;
-- November is the best performing month historically with $349,120.07 in total sales, likely driven by holiday demand.

--19. What percentage of total revenue comes from top 10 customers?
WITH customer_sales AS (SELECT customer_name,SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_name),
top_10 AS (SELECT *FROM customer_sales
ORDER BY total_sales DESC
LIMIT 10)
SELECT ROUND((SUM(top_10.total_sales) / (SELECT SUM(sales) FROM superstore)) * 100, 2) AS percentage_of_total_revenue
FROM top_10;
-- Top 10 customers contribute only 6.70% of total revenue, indicating a healthy and well-distributed customer base with low concentration risk.

--20. Rank products within each category by sales.
SELECT category, product_name,SUM(sales) AS total_sales,
RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS product_rank
FROM superstore
GROUP BY category, product_name;
-- Technology products dominate top ranks. Within Furniture, Chairs and Bookcases lead in sales.

--21. Show top 3 products in each category.
WITH ranked_products AS (SELECT category,product_name,SUM(SALES) AS TOTAL_SALES, 
RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS product_rank
FROM SUPERSTORE
GROUP BY category,product_name)
SELECT * FROM ranked_products
WHERE product_rank <= 3;
-- Canon copiers, Nokia phones, and HON chairs are among the top performers in their respective categories.

--22. Calculate running monthly sales.
WITH monthly_sales AS (SELECT DATE_TRUNC('MONTH',order_date) AS month,
SUM(SALES) AS monthly_sales
FROM SUPERSTORE
GROUP BY DATE_TRUNC('MONTH',order_date))
SELECT *,SUM(monthly_sales) OVER(ORDER BY MONTH) AS running_monthly_sales 
FROM monthly_sales
ORDER BY MONTH;
-- Running sales show consistent upward momentum with sharp spikes in Q4 of each year.

--23. Calculate cumulative profit over time.
WITH monthly_profit AS (SELECT DATE_TRUNC('month', order_date) AS month,
SUM(profit) AS monthly_profit
FROM superstore
GROUP BY DATE_TRUNC('month', order_date))
SELECT  month,monthly_profit,SUM(monthly_profit) OVER (ORDER BY month) AS cumulative_profit
FROM monthly_profit
ORDER BY month;
-- Cumulative profit grows steadily but dips are visible in months with heavy discounting activity.

--24. Find the second highest selling product in each category.
WITH product_sales AS (SELECT category,product_name,SUM(sales) AS total_sales
FROM superstore
GROUP BY category, product_name)
SELECT category,product_name,total_sales
FROM (SELECT *,RANK() OVER (PARTITION BY category ORDER BY total_sales DESC ) AS sales_rank
FROM product_sales) ranked_products
WHERE sales_rank = 2;

--25. Divide customers into quartiles based on total sales.
WITH customer_sales AS (SELECT customer_name,SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_name)
SELECT customer_name,total_sales,
NTILE(4) OVER (ORDER BY total_sales DESC) AS sales_quartile
FROM customer_sales
ORDER BY sales_quartile, total_sales DESC;
-- Quartile 1 customers (top 25%) are the highest value accounts and should be the focus of loyalty and retention programs.

--26. Find customers whose profit is above average.
SELECT customer_name, SUM(PROFIT) AS total_profit
FROM SUPERSTORE
GROUP BY customer_name
HAVING SUM(PROFIT) > (SELECT AVG(customer_total)
FROM (SELECT SUM(PROFIT) AS customer_total
FROM SUPERSTORE
GROUP BY customer_name) AS customer_profits)
ORDER BY total_profit DESC;
-- A select group of customers generate significantly above-average profit and represent the most valuable accounts.

--27. Show year-over-year sales growth.
WITH yearly_sales AS (
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
SUM(SALES) AS total_sales
FROM SUPERSTORE
GROUP BY EXTRACT(YEAR FROM order_date))
SELECT order_year,
total_sales,
LAG(total_sales) OVER(ORDER BY order_year) AS previous_year_sales,
ROUND(((total_sales - LAG(total_sales) OVER(ORDER BY order_year)) / 
LAG(total_sales) OVER(ORDER BY order_year)) * 100, 2) AS yoy_growth_percentage
FROM yearly_sales;
-- Sales grew from $484K (2011) to $734K (2014). 2012 saw a slight dip before strong recovery in 2013 and 2014.
-- Overall 4-year growth of ~52%, showing a healthy and growing business.

--28. Identify repeat customers (more than 1 order).
SELECT customer_id, customer_name, COUNT(DISTINCT order_id) AS total_orders
FROM SUPERSTORE
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;
-- The vast majority of customers are repeat buyers, indicating strong customer loyalty and retention.

--29. Find the Pareto 80/20 customers (top 20% revenue contributors).
WITH customer_sales AS (
SELECT customer_id, customer_name, SUM(SALES) AS total_sales
FROM SUPERSTORE
GROUP BY customer_id, customer_name
),
total_sales AS (
SELECT SUM(total_sales) AS all_sales FROM customer_sales
),
ranked_customers AS (
SELECT customer_id, customer_name, total_sales,
SUM(total_sales) OVER (ORDER BY total_sales DESC) AS running_sales,
SUM(total_sales) OVER () AS cumulative_total_sales
FROM customer_sales
)
SELECT customer_id, customer_name, total_sales
FROM ranked_customers
WHERE running_sales <= 0.8 * (SELECT all_sales FROM total_sales)
ORDER BY total_sales DESC;
-- 395 out of 793 customers (~50%) drive 80% of total revenue.
-- Revenue is fairly well distributed — the business is not overly dependent on a small number of accounts.

--30. Is discount strategy effective? (Profit by discount level)
SELECT CASE
WHEN discount = 0 THEN 'No Discount'
WHEN discount <= 0.2 THEN 'Low Discount'
WHEN discount <= 0.5 THEN 'Medium Discount'
ELSE 'High Discount'
END AS discount_group,
COUNT(*) AS total_orders,
ROUND(AVG(profit),2) AS avg_profit,
ROUND(SUM(profit),2) AS total_profit
FROM SUPERSTORE
GROUP BY discount_group
ORDER BY total_profit;
-- No Discount: avg profit $66.90 | Low Discount: avg profit $26.50
-- Medium Discount: avg profit -$109.53 | High Discount: avg profit -$89.44
-- Discounting is NOT effective. Any discount above 20% destroys profitability.
-- Recommendation: Cap all discounts at 20% maximum.

--31. Which region should management focus on improving? (Lowest profit margin)
SELECT region, SUM(sales) AS total_sales,SUM(profit) AS total_profit,
ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_percentage
FROM SUPERSTORE
GROUP BY region
ORDER BY profit_margin_percentage ASC
LIMIT 1;
-- The Central region has the lowest profit margin at 7.92%, nearly half of the West region's 14.94%.
-- Central region needs urgent cost review and discount policy enforcement.

--32. Which sub-category should be discontinued? (Lowest profitability)
SELECT sub_category,SUM(sales) AS total_sales,SUM(profit) AS total_profit,
ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_percentage
FROM SUPERSTORE
GROUP BY sub_category
ORDER BY profit_margin_percentage ASC
LIMIT 1;
-- Tables have the worst profit margin at -8.56%, meaning every dollar of Tables sold loses money.
-- Strong recommendation to discontinue or significantly reprice the Tables sub-category.

--33. Which customer segment is most profitable?
SELECT segment,SUM(profit) AS total_profit,
ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin_percentage
FROM SUPERSTORE
GROUP BY segment
ORDER BY total_profit DESC
LIMIT 1;
-- The Consumer segment is the most profitable at $134,119.21 in total profit.
-- Marketing and sales efforts should prioritize acquiring and retaining Consumer segment customers.

--34. Business recommendations based on data.
SELECT region, sub_category, segment,SUM(sales) AS total_sales,SUM(profit) AS total_profit,
ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin_percentage
FROM SUPERSTORE
GROUP BY region, sub_category, segment
ORDER BY total_profit DESC;

-- Key Recommendations:
-- 1. STOP heavy discounting immediately — discounts above 20% generate consistent losses.
-- 2. DISCONTINUE or reprice Tables sub-category (-8.56% margin).
-- 3. FOCUS on Technology + Consumer segment in the West region for maximum profitability.
-- 4. INVESTIGATE the Central region's low 7.92% margin — review pricing, discounts, and product mix.
-- 5. PROTECT top Quartile 1 customers who drive the majority of revenue with loyalty programs.
-- 6. EXPAND Copiers category — highest sub-category profit at $55,617.82 with strong margins.
