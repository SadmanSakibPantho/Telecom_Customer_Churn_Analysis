-- Parent Table => telecom_customer_churn_clean1
select * from Maven_Churn_Challenge..telecom_customer_churn_clean1

-- Exploring the dataset
select MAX(Total_Revenue) as MaxTotalRevenue from Maven_Churn_Challenge..telecom_customer_churn_clean1
select MIN(Total_Revenue) as MinTotalRevenue from Maven_Churn_Challenge..telecom_customer_churn_clean1

-- Total revenue generated by the firm till end of Q2 2022
select SUM(Total_Revenue) from Maven_Churn_Challenge..telecom_customer_churn_clean1

-- Total number of churned customers
select COUNT(Customer_ID) as TotalChurnedCustomers from Maven_Churn_Challenge..telecom_customer_churn_clean1
where Customer_Status = 'churned'

-- Total revenue generated by churned customers
select sum(total_revenue) from Maven_Churn_Challenge..telecom_customer_churn_clean1
where Customer_Status = 'churned'

select MAX(Monthly_charge) as MaxMonthlyCharge from Maven_Churn_Challenge..telecom_customer_churn_clean1
select MAX(Tenure_in_Months) as HighestTenureInMonths from Maven_Churn_Challenge..telecom_customer_churn_clean1 

-- The Monthly_Charge only includes data for the latest month
-- In order to properly understand the monthly income from each customer, we need to look at Monthly Recurring Revenue (i.e. Total revenue/Tenure in months)
-- We will add Monthly Recurring Revenue as a column in our database
ALTER TABLE Maven_Churn_Challenge..telecom_customer_churn_clean1
ADD Recurring_Monthly_Revenue DECIMAL(18,10)

UPDATE Maven_Churn_Challenge..telecom_customer_churn_clean1
SET Recurring_Monthly_Revenue = (Total_Revenue/Tenure_in_Months)


-- Total recurring monthly revenue generated by churned customers
select avg(Recurring_Monthly_Revenue) from Maven_Churn_Challenge..telecom_customer_churn_clean1
where Customer_Status = 'churned'

-- Average income from a customer
select AVG(Total_Revenue) as Average_Revenue from Maven_Churn_Challenge..telecom_customer_churn_clean1 

-- Average income from a One Year contract customer
select AVG(Total_Revenue) as Average_Revenue from Maven_Churn_Challenge..telecom_customer_churn_clean1 
where Customer_Contract = 'One Year'

-- Average income from a Month-to-Month contract customer
select AVG(Total_Revenue) as Average_Revenue from Maven_Churn_Challenge..telecom_customer_churn_clean1 
where Customer_Contract = 'Month-to-Month'

-- Average income from a Two Year contract customer
select AVG(Total_Revenue) as Average_Revenue from Maven_Churn_Challenge..telecom_customer_churn_clean1 
where Customer_Contract = 'Two Year'

-- Let us have a look at the top customers bringing in 75% of the company's total revenue till end of Q2 2022
WITH CTE_RunningTotalRevenue AS
(
SELECT *, SUM(Total_Revenue) OVER (ORDER BY Total_Revenue DESC)  AS RunningTotalRevenue
        FROM Maven_Churn_Challenge..telecom_customer_churn_clean1
)
SELECT *
FROM CTE_RunningTotalRevenue
WHERE RunningTotalRevenue <= (SELECT 0.75 * SUM(Total_Revenue) FROM CTE_RunningTotalRevenue)

-- And the customers at the bottom (i.e. customers responsible for only 25% of company's total revenue)
WITH CTE_RunningTotalRevenue AS
(
SELECT *, SUM(Total_Revenue) OVER (ORDER BY Total_Revenue DESC)  AS RunningTotalRevenue
        FROM Maven_Churn_Challenge..telecom_customer_churn_clean1
)
SELECT *
FROM CTE_RunningTotalRevenue
WHERE RunningTotalRevenue >= (SELECT 0.75 * SUM(Total_Revenue) FROM CTE_RunningTotalRevenue)

-- Determining High value customers using Running Total and CTE (Common table expression)
-- We have assumed that high value customers are the ones in 75th recurring monthly revenue percentile + 75th total revenue percentile
-- Customers bringing in total revenue of $3380.51 or more fall in 75th total revenue percentile (found in previous query to find top customers bringing in 75% of total revenue)
WITH CTE_RunningRecurringMonthlyRevenue AS
(
SELECT *, SUM(Recurring_Monthly_Revenue) OVER (ORDER BY Recurring_Monthly_Revenue DESC) AS RunningRecurringMonthlyRevenue
        FROM Maven_Churn_Challenge..telecom_customer_churn_clean1
)
SELECT *
FROM CTE_RunningRecurringMonthlyRevenue
WHERE RunningRecurringMonthlyRevenue <= (SELECT 0.75 * SUM(Recurring_Monthly_Revenue) FROM CTE_RunningRecurringMonthlyRevenue)
AND Total_Revenue >= 3380.51

-- Table added to database => High_Value_Customers

--How many of high value customers churned?
select COUNT(customer_ID) as Churned_HV_Customers from Maven_Churn_Challenge..High_Value_Customers
where Customer_Status = 'churned'

--How many of high value customers stayed?
select COUNT(customer_ID) as Stayed_HV_Customers from Maven_Churn_Challenge..High_Value_Customers
where Customer_Status = 'stayed'

-- Average recurring monthly revenue generated by High value customers
select avg(Recurring_Monthly_Revenue) as Avg_HV_Recurring_Monthly_Revenue from Maven_Churn_Challenge..High_Value_Customers

-- average total revenue generated by each high value customer
select AVG(total_revenue) from Maven_Churn_Challenge..High_Value_Customers

-- average total revenue generated by each CHURNED high value customer
select AVG(total_revenue) from Maven_Churn_Challenge..High_Value_Customers
where Customer_Status = 'churned'

-- Non High Value customers
SELECT *
FROM Maven_Churn_Challenge..telecom_customer_churn_clean1
LEFT JOIN Maven_Churn_Challenge..High_value_customers ON Maven_Churn_Challenge..High_value_customers.Customer_ID = Maven_Churn_Challenge..telecom_customer_churn_clean1.Customer_ID
WHERE Maven_Churn_Challenge..High_value_customers.Customer_ID IS NULL

-- Table added to database => Non_HV_Customers

-- average total revenue generated by each non-high value customer
select AVG(Total_Revenue) from Maven_Churn_Challenge..Non_HV_Customers


SELECT sum(Total_Revenue)
FROM Maven_Churn_Challenge..High_Value_Customers
WHERE Customer_Status = 'Churned'


select SUM(Recurring_Monthly_Revenue) from Maven_Churn_Challenge..telecom_customer_churn_clean1