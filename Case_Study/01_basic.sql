
/*=============================================================================
Q1. Display the customer name, city, and monthly income for every customer.
===============================================================================

Business Requirement
--------------------
The business requires a customer profile report containing customer names,
cities, and monthly income. This report helps understand customer demographics,
analyze income distribution, and support marketing or loan eligibility decisions.

Approach
--------
Retrieve the required customer details from the CUSTOMER_MASTER table and
sort the records by monthly income.

SQL Query
---------*/

SELECT
    CUSTOMERNAME,
    CITY,
    MONTHLY_INCOME
FROM CUSTOMER_MASTER
ORDER BY MONTHLY_INCOME;

/*Explanation
-------------
• CUSTOMERNAME returns the customer's name.
• CITY identifies the customer's location.
• MONTHLY_INCOME displays monthly earnings.
• ORDER BY arranges customers based on income.

Business Insight
----------------
This report enables business teams to segment customers based on income levels
for product offerings, credit assessment, and targeted marketing.

=============================================================================*/


/*=============================================================================
Q2. List all loans with a rate of interest between 10% and 16%, ordered from
lowest to highest.
===============================================================================

Business Requirement
--------------------
The lending department wants to review loans issued within the standard interest
rate range to monitor pricing consistency and evaluate loan products.

Approach
--------
Filter loans whose interest rates fall between 10% and 16%, then sort them
in ascending order.

SQL Query
---------*/

SELECT *
FROM LOAN_MASTER
WHERE RATE_OF_INTEREST BETWEEN 10 AND 16
ORDER BY RATE_OF_INTEREST ASC;

/*Explanation
-------------
• BETWEEN filters loans within the specified range.
• ORDER BY sorts loans from the lowest to highest interest rate.

Business Insight
----------------
This helps identify loans offered under standard pricing policies and supports
interest rate analysis across the portfolio.

=============================================================================*/


/*=============================================================================
Q3. Find the distinct designations held by loan officers across the organization.
===============================================================================

Business Requirement
--------------------
HR and management need a list of unique job designations among loan officers
to understand role distribution and organizational hierarchy.

Approach
--------
Retrieve unique designation values using the DISTINCT keyword.

SQL Query
---------*/

SELECT DISTINCT(DESIGNATION)
FROM LOAN_OFFICER_MASTER;

/*Explanation
-------------
• DISTINCT removes duplicate designation values.
• Returns only unique job titles.

Business Insight
----------------
Provides a quick overview of available loan officer roles and supports
workforce planning and reporting.

=============================================================================*/


/*=============================================================================
Q4. Fetch the 15 oldest customer relationships based on the customer since date.
===============================================================================

Business Requirement
--------------------
The business wants to identify long-term customers for loyalty programs,
relationship management, and premium service offerings.

Approach
--------
Sort customers by CUSTOMER_SINCE_DATE in ascending order and return the
first 15 records.

SQL Query
---------*/

SELECT *
FROM CUSTOMER_MASTER
ORDER BY CUSTOMER_SINCE_DATE ASC
LIMIT 15;

/*Explanation
-------------
• ORDER BY arranges customers from oldest relationship to newest.
• LIMIT returns only the first 15 customers.

Business Insight
----------------
Long-term customers often represent loyal clients and may be ideal candidates
for retention campaigns and premium banking products.

=============================================================================*/


/*=============================================================================
Q5. List all products along with their maximum permissible tenure in descending
order.
===============================================================================

Business Requirement
--------------------
The product team wants to review all loan products and compare their maximum
allowed repayment tenure.

Approach
--------
Retrieve product names and maximum tenure, then sort from highest tenure
to lowest.

SQL Query
---------*/

SELECT
    PRODUCT_NAME,
    MAX_TENURE_MONTHS
FROM PRODUCT_MASTER
ORDER BY MAX_TENURE_MONTHS DESC;

/*Explanation
-------------
• PRODUCT_NAME displays loan products.
• MAX_TENURE_MONTHS shows the maximum repayment period.
• DESC orders products from longest tenure to shortest.

Business Insight
----------------
Helps compare loan products and supports product design and customer advisory.

=============================================================================*/


/*=============================================================================
Q6. Find all loans where the EMI overdue count is missing and replace it with
zero using COALESCE.
===============================================================================

Business Requirement
--------------------
The operations team requires a clean report where missing EMI overdue values
are displayed as zero instead of NULL.

Approach
--------
Use COALESCE() to replace NULL values with zero.

SQL Query
---------*/

SELECT
    LOAN_ID,
    COALESCE(EMI_OVERDUE,0) AS EMI_OVERDUE
FROM LOAN_MASTER;

/*Explanation
-------------
• COALESCE returns the first non-null value.
• NULL EMI overdue values become zero.

Business Insight
----------------
Improves reporting accuracy and avoids missing values in operational dashboards.

=============================================================================*/


/*=============================================================================
Q7. Calculate the total number of loans booked.
===============================================================================

Business Requirement
--------------------
Management requires the total number of loans booked to measure business volume.

Approach
--------
Count all records available in the LOAN_MASTER table.

SQL Query
---------*/

SELECT COUNT(*)
FROM LOAN_MASTER;

/*Explanation
-------------
• COUNT(*) returns the total number of loan records.

Business Insight
----------------
Provides a key business KPI representing the overall loan portfolio size.

=============================================================================*/


/*=============================================================================
Q8. Find the minimum and maximum financed loan amount across the portfolio.
===============================================================================

Business Requirement
--------------------
The finance team wants to understand the financing range offered to customers.

Approach
--------
Use aggregate functions to calculate the minimum and maximum financed amounts.

SQL Query
---------*/

SELECT
    MIN(AMOUNT_FIN) AS MINIMUM_AMOUNT_FINANCED,
    MAX(AMOUNT_FIN) AS MAXIMUM_AMOUNT_FINANCED
FROM LOAN_MASTER;

/*Explanation
-------------
• MIN() returns the smallest financed amount.
• MAX() returns the largest financed amount.

Business Insight
----------------
Shows the lending range and helps evaluate portfolio diversity and exposure.

=============================================================================*/


/*=============================================================================
Q9. Calculate the average Days Past Due (DPD) for all active loans.
===============================================================================

Business Requirement
--------------------
The collections team wants to monitor repayment performance by measuring
average delinquency among active loans.

Approach
--------
Filter active loans and calculate the average DPD.

SQL Query
---------*/

SELECT
    AVG(DPD) AS AVG_DPD
FROM LOAN_MASTER
WHERE STATUS = 'ACTIVE';

/*Explanation
-------------
• AVG() calculates the average DPD.
• WHERE filters only active loans.

Business Insight
----------------
A higher average DPD may indicate increased repayment risk and the need for
stronger collection efforts.

=============================================================================*/


/*=============================================================================
Q10. Count the number of loans disbursed for each product.
===============================================================================

Business Requirement
--------------------
Business wants to understand product-wise loan distribution to evaluate product
popularity and demand.

Approach
--------
Group loans by product and count the number of loans in each category.

SQL Query
---------*/

SELECT
    PRODUCTFLAG,
    COUNT(LOAN_ID) AS COUNT_OF_LOANS
FROM LOAN_MASTER
GROUP BY PRODUCTFLAG
ORDER BY COUNT_OF_LOANS DESC;

/*Explanation
-------------
• GROUP BY creates product-wise groups.
• COUNT() calculates total loans for each product.
• ORDER BY ranks products based on loan count.

Business Insight
----------------
Helps identify the most popular loan products and supports product strategy,
sales planning, and portfolio analysis.

=============================================================================*/

