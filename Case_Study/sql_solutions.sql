
## Basic SQL

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

## Aggregate Functions & Conditional Logic

/*=============================================================================
Q11. Find products whose processing fee percentage is above the overall average
processing fee.
===============================================================================

Business Requirement
--------------------
The product management team wants to identify loan products that charge a
processing fee higher than the organization's average processing fee. This
helps review pricing strategies, compare products, and determine whether
certain products require pricing adjustments.

Approach
--------
Calculate the average processing fee percentage across all products using a
subquery. Then compare each product's processing fee against this average and
return only those products with above-average processing fees.

SQL Query
---------*/

SELECT
    PRODUCTFLAG,
    PROCESSING_FEE_PCT
FROM PRODUCT_MASTER
WHERE PROCESSING_FEE_PCT >
(
    SELECT AVG(PROCESSING_FEE_PCT)
    FROM PRODUCT_MASTER
);

/*Explanation
-------------
• The subquery calculates the average processing fee percentage.
• The outer query compares each product's fee against that average.
• Only products charging more than the average processing fee are returned.

Business Insight
----------------
Products with higher processing fees may generate greater fee income but could
also affect customer affordability and competitiveness. The report helps
management review pricing policies and product positioning.

=============================================================================*/


/*=============================================================================
Q12. Find branches having fewer than 10 active loans.
===============================================================================

Business Requirement
--------------------
Operations management wants to identify branches with a low number of active
loans. This helps evaluate branch performance, customer acquisition, and
business growth opportunities.

Approach
--------
Join the Loan and Branch tables, filter only active loans, group the data by
branch, and return branches where the active loan count is less than 10.

SQL Query
---------*/

SELECT
    BRANCH_NAME,
    COUNT(LOAN_ID) AS COUNT_OF_LOAN
FROM LOAN_MASTER AS L
LEFT JOIN BRANCH_MASTER AS B
    ON L.BRANCH_ID = B.BRANCH_ID
WHERE STATUS = 'ACTIVE'
GROUP BY BRANCH_NAME
HAVING COUNT(LOAN_ID) < 10;

/*Explanation
-------------
• LEFT JOIN retrieves the corresponding branch information.
• WHERE filters only active loans.
• GROUP BY creates branch-wise loan groups.
• COUNT() calculates the number of active loans.
• HAVING filters branches with fewer than 10 active loans.

Business Insight
----------------
Branches with lower loan volumes may require additional marketing efforts,
staff support, or sales initiatives to improve business performance.

=============================================================================*/


/*=============================================================================
Q13. Classify every loan as High Value or Standard based on the financed amount.
===============================================================================

Business Requirement
--------------------
The credit risk team wants to categorize loans into High Value and Standard
segments. This classification supports portfolio monitoring, risk analysis,
and reporting.

Approach
--------
Calculate the average financed amount across all loans. Compare each loan's
financed amount against the average and classify it using a CASE expression.

SQL Query
---------*/

SELECT
    *,
    CASE
        WHEN AMOUNT_FIN >
        (
            SELECT AVG(AMOUNT_FIN)
            FROM LOAN_MASTER
        )
        THEN 'HIGH VALUE'
        ELSE 'STANDARD'
    END AS REMARKS
FROM LOAN_MASTER;

/*Explanation
-------------
• The subquery calculates the average financed amount.
• CASE evaluates each loan individually.
• Loans above the average are classified as HIGH VALUE.
• Remaining loans are classified as STANDARD.

Business Insight
----------------
This classification helps management identify high-value lending, monitor
portfolio concentration, prioritize customer relationships, and perform
risk-based analysis.

=============================================================================*/


/*=============================================================================
Q14. Classify collection agents as Experienced or New based on their years of
experience.
===============================================================================

Business Requirement
--------------------
The collections department wants to categorize collection agents based on
their experience. This information can be used for workload allocation,
performance evaluation, and training programs.

Approach
--------
Use a CASE expression to classify agents with 0–3 years of experience as
"NEW" and all remaining agents as "EXPERIENCED."

SQL Query
---------*/

SELECT
    *,
    CASE
        WHEN EXPERIENCE_YEAR BETWEEN 0 AND 3 THEN 'NEW'
        ELSE 'EXPERIENCED'
    END AS EXPERIENCE_REMARKS
FROM COLLECTION_AGENT_MASTER;

/*Explanation
-------------
• CASE evaluates each agent's years of experience.
• Agents with 0 to 3 years are labeled NEW.
• Agents with more than 3 years are labeled EXPERIENCED.

Business Insight
----------------
Experience-based segmentation helps managers distribute complex recovery cases
to experienced agents while assigning simpler accounts or training activities
to newer team members.

=============================================================================*/

## SQL Joins

/*=============================================================================
Q15. Display every loan along with the customer name and branch name.
===============================================================================

Business Requirement
--------------------
The operations team requires a consolidated loan report showing each loan
along with the corresponding customer and branch details. This report helps
track loan ownership, monitor branch performance, and simplify operational
reporting.

Approach
--------
Join the LOAN_MASTER table with CUSTOMER_MASTER using CIF_NO and with
BRANCH_MASTER using BRANCH_ID. Retrieve the required columns from all three
tables.

SQL Query
---------*/

SELECT
    LOAN_ID,
    CUSTOMERNAME,
    BRANCH_NAME
FROM LOAN_MASTER AS L
INNER JOIN CUSTOMER_MASTER AS C
    ON L.CIF_NO = C.CIF_NO
INNER JOIN BRANCH_MASTER AS B
    ON L.BRANCH_ID = B.BRANCH_ID;

/*Explanation
-------------
• INNER JOIN combines matching records from the loan, customer, and branch
  tables.
• CIF_NO is used to retrieve customer information.
• BRANCH_ID is used to retrieve branch information.
• Only loans with valid customer and branch records are displayed.

Business Insight
----------------
This report provides a complete view of loan ownership and branch allocation,
helping operations teams monitor business activity across branches.

=============================================================================*/


/*=============================================================================
Q16. List all customers along with their loans, including customers who have
never taken a loan.
===============================================================================

Business Requirement
--------------------
The business wants a complete customer list, including customers who have not
yet taken any loan. This helps identify potential customers for future loan
campaigns and cross-selling opportunities.

Approach
--------
Use a LEFT JOIN between CUSTOMER_MASTER and LOAN_MASTER so that every customer
is returned regardless of whether they have a loan.

SQL Query
---------*/

SELECT
    LOAN_ID,
    CUSTOMERNAME,
    STATUS
FROM CUSTOMER_MASTER AS C
LEFT JOIN LOAN_MASTER AS L
    ON C.CIF_NO = L.CIF_NO;

/*Explanation
-------------
• LEFT JOIN returns all customers from CUSTOMER_MASTER.
• Matching loan information is retrieved from LOAN_MASTER.
• Customers without loans will have NULL values in the loan-related columns.

Business Insight
----------------
This report helps identify untapped customers who may be targeted for loan
offers, marketing campaigns, or relationship-building initiatives.

=============================================================================*/


/*=============================================================================
Q17. Identify loan officers who joined the organization in the same year.
===============================================================================

Business Requirement
--------------------
The Human Resources department wants to identify employees who joined during
the same year. This information can support onboarding analysis, batch-wise
training, and employee cohort reporting.

Approach
--------
Perform a self join on the LOAN_OFFICER_MASTER table by comparing the joining
year of two employees while ensuring duplicate combinations are avoided.

SQL Query
---------*/

SELECT
    T1.EMPID AS FIRST_EMPID,
    T1.EMP_NAME AS FIRST_EMP_NAME,
    T2.EMPID AS SEC_EMPID,
    T2.EMP_NAME AS SEC_EMP_NAME
FROM LOAN_OFFICER_MASTER AS T1
INNER JOIN LOAN_OFFICER_MASTER AS T2
    ON EXTRACT(YEAR FROM T1.DOJ) = EXTRACT(YEAR FROM T2.DOJ)
WHERE T1.EMPID < T2.EMPID
ORDER BY T1.EMPID;

/*Explanation
-------------
• The table is joined with itself (SELF JOIN).
• EXTRACT(YEAR FROM DOJ) compares only the joining year.
• T1.EMPID < T2.EMPID prevents duplicate employee pairs.
• ORDER BY displays the results in employee ID order.

Business Insight
----------------
The report helps HR identify hiring batches, evaluate recruitment trends,
and organize training or engagement activities for employees who joined in
the same period.

=============================================================================*/


/*=============================================================================
Q18. Display loan ID, customer name, product name, branch name, and loan
officer name using multi-table joins.
===============================================================================

Business Requirement
--------------------
Management requires a comprehensive loan report that combines customer,
product, branch, and loan officer information in a single view. This report
supports operational monitoring and business reporting.

Approach
--------
Join LOAN_MASTER with CUSTOMER_MASTER, PRODUCT_MASTER, BRANCH_MASTER, and
LOAN_OFFICER_MASTER using their respective primary and foreign keys.

SQL Query
---------*/

SELECT
    LOAN_ID,
    CUSTOMERNAME,
    PRODUCT_NAME,
    BRANCH_NAME,
    EMP_NAME AS OFFICER_NAME
FROM LOAN_MASTER AS L
INNER JOIN CUSTOMER_MASTER AS C
    ON L.CIF_NO = C.CIF_NO
INNER JOIN PRODUCT_MASTER AS P
    ON L.PRODUCTFLAG = P.PRODUCTFLAG
INNER JOIN BRANCH_MASTER AS B
    ON L.BRANCH_ID = B.BRANCH_ID
INNER JOIN LOAN_OFFICER_MASTER AS LO
    ON L.EMPID = LO.EMPID;

/*Explanation
-------------
• CUSTOMER_MASTER provides customer details.
• PRODUCT_MASTER provides product information.
• BRANCH_MASTER provides branch details.
• LOAN_OFFICER_MASTER provides officer information.
• INNER JOIN combines matching records from all related tables.

Business Insight
----------------
This report provides a 360-degree view of every loan by combining customer,
product, branch, and loan officer information, making it valuable for
management reporting, auditing, and operational analysis.

=============================================================================*/

## EXISTS & Subqueries

/*=============================================================================
Q19. Find customers who currently hold at least one active loan using EXISTS.
===============================================================================

Business Requirement
--------------------
The business wants to identify customers who currently have at least one active
loan. This information is useful for customer portfolio analysis, targeted
marketing, and relationship management.

Approach
--------
Use the EXISTS operator to check whether a customer has one or more matching
active loan records in the LOAN_MASTER table.

SQL Query
---------*/

SELECT 
     CIF_NO,
     CUSTOMERNAME
FROM CUSTOMER_MASTER AS C
WHERE EXISTS (SELECT 1
	      FROM LOAN_MASTER AS L
              WHERE C.CIF_NO=L.CIF_NO AND L.STATUS = 'ACTIVE');

/*Explanation
-------------
• EXISTS checks whether at least one matching active loan exists.
• The subquery is correlated using CIF_NO.
• Only customers with an active loan are returned.

Business Insight
----------------
This report helps identify active borrowers for customer relationship
management, cross-selling opportunities, and portfolio monitoring.

=============================================================================*/


/*=============================================================================
Q20. Find customers who have never been assigned any loan using NOT EXISTS.
===============================================================================

Business Requirement
--------------------
The marketing team wants to identify customers who have never received a loan.
These customers can be targeted for new loan campaigns and promotional offers.

Approach
--------
Use the NOT EXISTS operator to return customers who do not have any matching
loan record in the LOAN_MASTER table.

SQL Query
---------*/

SELECT 
     CUSTOMERNAME
FROM CUSTOMER_MASTER AS C
WHERE NOT EXISTS (SELECT 1
                  FROM LOAN_MASTER AS L
                  WHERE C.CIF_NO = L.CIF_NO);


/*Explanation
-------------
• NOT EXISTS returns customers without matching loan records.
• The correlated subquery compares customers using CIF_NO.
• Only customers with no loans are displayed.

Business Insight
----------------
This report helps the business identify potential customers for loan
acquisition campaigns and supports customer growth strategies.

=============================================================================*/


/*=============================================================================
Q21. Extract the day, month, and year from every loan's disbursal date.
===============================================================================

Business Requirement
--------------------
The business requires separate day, month, and year values from loan disbursal
dates for trend analysis, monthly reporting, and seasonal business insights.

Approach
--------
Use the EXTRACT() function to retrieve the individual date components from the
loan disbursal date.

SQL Query
---------*/

SELECT 
     LOAN_ID,
     DISBURSAL_DATE,
     EXTRACT(DAY FROM DISBURSAL_DATE) AS DAY,
     EXTRACT(MONTH FROM DISBURSAL_DATE) AS MONTH,
     EXTRACT(YEAR FROM DISBURSAL_DATE) AS YEAR
FROM LOAN_MASTER;

/*Explanation
-------------
• EXTRACT(DAY) returns the day of the month.
• EXTRACT(MONTH) returns the month.
• EXTRACT(YEAR) returns the year.
• Each component is displayed as a separate column.

Business Insight
----------------
Breaking dates into individual components supports monthly, quarterly, and
yearly loan trend analysis and improves business reporting.

=============================================================================*/


/*=============================================================================
Q22. Find all loans whose EMI end date falls within the current calendar year.
===============================================================================

Business Requirement
--------------------
The operations team wants to identify loans whose repayment schedule ends
during the current calendar year. This helps in planning customer retention,
loan renewal, and closure activities.

Approach
--------
Compare the year of the EMI end date with the current system year using the
EXTRACT() function.

SQL Query
---------*/

SELECT
     LOAN_ID,
     EMI_END_DATE
FROM LOAN_MASTER
WHERE EXTRACT(YEAR FROM EMI_END_DATE) = EXTRACT(YEAR FROM CURRENT_DATE);

/*Explanation
-------------
• CURRENT_DATE returns today's system date.
• EXTRACT(YEAR) compares only the year portion.
• Loans ending in the current year are returned.

Business Insight
----------------
The report helps identify loans approaching maturity, allowing the business
to proactively engage customers for renewals or additional financial products.

=============================================================================*/


/*=============================================================================
Q23. Calculate each customer's current age using their date of birth.
===============================================================================

Business Requirement
--------------------
The business wants to calculate the current age of every customer for customer
profiling, eligibility verification, and demographic analysis.

Approach
--------
Calculate the difference between the current date and the customer's date of
birth, then extract the number of completed years.

SQL Query
---------*/

SELECT 
     CIF_NO,
     DOB,
     EXTRACT(YEAR FROM AGE(CURRENT_DATE,DOB)) AS AGE
FROM CUSTOMER_MASTER;

/*Explanation
-------------
• AGE() calculates the difference between the current date and the customer's
  date of birth.
• EXTRACT(YEAR) retrieves the completed years.
• The result represents the customer's current age.

Business Insight
----------------
Customer age is an important factor in eligibility checks, product
recommendations, demographic segmentation, and risk assessment.

=============================================================================*/


/*=============================================================================
Q24. Find customer names that begin with a vowel.
===============================================================================

Business Requirement
--------------------
The marketing team wants to identify customers whose names begin with a vowel.
This information can be useful for customer segmentation, personalized
marketing campaigns, and data quality analysis.

Approach
--------
Filter customer names using pattern matching to return only those names that
start with A, E, I, O, or U.

SQL Query
---------*/

SELECT
     CUSTOMERNAME
FROM CUSTOMER_MASTER
WHERE UPPER(LEFT(CUSTOMERNAME,1)) IN ('A','E','I','O','U');

/*Explanation
-------------
• UPPER() converts customer names to uppercase for case-insensitive matching.
• LIKE identifies names starting with each vowel.
• OR combines all vowel conditions.

Business Insight
----------------
This query demonstrates the use of string functions and pattern matching,
which are commonly used in customer segmentation and data validation.

=============================================================================*/


/*=============================================================================
Q25. Identify loans where the principal outstanding is NULL or zero and
classify each case.
===============================================================================

Business Requirement
--------------------
The finance team wants to identify loans with missing or zero principal
outstanding amounts. This helps detect incomplete records, fully repaid loans,
or potential data quality issues.

Approach
--------
Use a CASE expression to classify each loan based on the value of
PRINCIPAL_OUTSTANDING.

SQL Query
---------*/

SELECT 
     LOAN_ID,
     PRINCIPAL_OUTSTANDING,
     CASE 
        WHEN PRINCIPAL_OUTSTANDING IS NULL THEN 'MISSING_VALUE'
        WHEN PRINCIPAL_OUTSTANDING = 0 THEN 'ZERO_OUTSTANDING'
     END AS PRINCIPAL_OUTSTANDING_REMARKS
FROM LOAN_MASTER
WHERE PRINCIPAL_OUTSTANDING IS NULL OR PRINCIPAL_OUTSTANDING = 0;

/*Explanation
-------------
• IS NULL identifies missing outstanding values.
• CASE classifies each loan into appropriate categories.
• Loans with values greater than zero are marked as ACTIVE OUTSTANDING.

Business Insight
----------------
This report helps finance teams improve data quality and monitor loans that
are fully settled or require further investigation.

=============================================================================*/


/*=============================================================================
Q26. Display "Not Assigned" whenever a loan has no assigned collection agent.
===============================================================================

Business Requirement
--------------------
The collections department wants reports without blank collection agent names.
Whenever an agent has not yet been assigned, the report should clearly display
"Not Assigned."

Approach
--------
Use COALESCE() to replace NULL collection agent names with the text
'Not Assigned'.

SQL Query
---------*/

SELECT 
     L.LOAN_ID,
     COALESCE(CA.AGENT_NAME,'NOT ASSIGNED') AS AGENT_NAME
FROM LOAN_MASTER AS L
LEFT JOIN COLLECTION_DETAILS AS C
ON L.LOAN_ID = C.LOAN_ID
LEFT JOIN COLLECTION_AGENT_MASTER AS CA
ON C.AGENT_ID = CA.AGENT_ID
ORDER BY L.LOAN_ID;

/*Explanation
-------------
• COALESCE() returns the first non-null value.
• If the collection agent is NULL, 'Not Assigned' is displayed.
• Otherwise, the assigned agent's name is shown.

Business Insight
----------------
Replacing NULL values improves report readability and enables managers to
quickly identify loans awaiting collection agent assignment.

=============================================================================*/


/*=============================================================================
Q27. Find customers whose monthly income is above the average income of
customers in the same city.
===============================================================================

Business Requirement
--------------------
The business wants to identify high-income customers within each city.
This information supports premium customer segmentation, targeted marketing,
and cross-selling opportunities.

Approach
--------
Use a correlated subquery to compare each customer's monthly income with the
average income of customers living in the same city.

SQL Query
---------*/

SELECT 
     CUSTOMERNAME,
     CITY,
     MONTHLY_INCOME
FROM CUSTOMER_MASTER AS C1
WHERE MONTHLY_INCOME > (SELECT 
			     AVG(MONTHLY_INCOME)
                        FROM CUSTOMER_MASTER AS C2
                        WHERE C1.CITY = C2.CITY);

/*Explanation
-------------
• The correlated subquery calculates the average income for each city.
• Each customer's income is compared against the average of their city.
• Only customers earning above their city's average are returned.

Business Insight
----------------
The report helps identify premium customers who may be suitable for exclusive
banking services, investment products, or higher credit limits.

=============================================================================*/


/*=============================================================================
Q28. Find the second-highest financed loan amount.
===============================================================================

Business Requirement
--------------------
Management wants to identify the second-highest financed loan amount for
portfolio analysis and high-value lending review.

Approach
--------
Use a subquery to exclude the maximum financed amount, then retrieve the
highest value from the remaining records.

SQL Query
---------*/

SELECT 
     AMOUNT_FIN
FROM (SELECT 
	   AMOUNT_FIN,
           DENSE_RANK() OVER(ORDER BY AMOUNT_FIN DESC) AS lOAN_RANK 
      FROM LOAN_MASTER) AS T
WHERE lOAN_RANK = 2;

/*Explanation
-------------
• The inner query returns the highest financed amount.
• The outer query excludes that value.
• MAX() then returns the next highest financed amount.

Business Insight
----------------
This analysis helps management identify high-value lending beyond the single
largest loan and is commonly used in portfolio ranking and business reporting.

=============================================================================*/


/*=============================================================================
Q29. Find products that have never been used in any loan.
===============================================================================

Business Requirement
--------------------
The product management team wants to identify loan products that have never
been utilized by customers. This helps evaluate product performance, identify
unused offerings, and make informed decisions regarding product improvement or
discontinuation.

Approach
--------
Use the subquery to compare the PRODUCT_MASTER table with the
LOAN_MASTER table and return only those products that do not have any
corresponding loan records.

SQL Query
---------*/

SELECT 
     RODUCTFLAG,
     PRODUCT_NAME
FROM PRODUCT_MASTER
WHERE PRODUCTFLAG NOT IN (SELECT
			       PRODUCTFLAG
                          FROM LOAN_MASTER
                          GROUP BY PRODUCTFLAG);


Business Insight
----------------
This report highlights unused loan products, enabling management to review
their relevance, redesign product features, or discontinue products with
little or no customer demand.

=============================================================================*/


/*=============================================================================
Q30. Find branches that have at least one loan with DPD greater than 90.
===============================================================================

Business Requirement
--------------------
The collections and risk management teams want to identify branches that have
highly delinquent loans (DPD greater than 90 days). This helps prioritize
collection efforts and monitor branch-level credit risk.


SQL Query
---------*/

SELECT 
     BRANCH_NAME
FROM BRANCH_MASTER AS B
WHERE EXISTS (SELECT 1
              FROM LOAN_MASTER AS L
              WHERE B.BRANCH_ID = L.BRANCH_ID AND L.DPD > 90);



Business Insight
----------------
Branches appearing in this report require immediate attention, as they contain
high-risk loans that may significantly impact the bank's collection efficiency
and portfolio quality.

=============================================================================*/


/*=============================================================================
Q31. Find loan officers whose total loan disbursement is below the average
disbursement of all officers.
===============================================================================

Business Requirement
--------------------
Management wants to identify loan officers whose total loan disbursement is
below the organization's average. This supports performance evaluation,
training initiatives, and workload analysis.

Approach
--------
Calculate the total disbursement for each loan officer using GROUP BY.
Compare each officer's total disbursement with the average total
disbursement calculated using a subquery.

SQL Query
---------*/

SELECT
     EMP_NAME,
     SUM(AMOUNT_FIN) AS TOTAL_AMOUNT_FIN
FROM LOAN_OFFICER_MASTER AS LO
LEFT JOIN LOAN_MASTER AS L
ON LO.EMPID = L.EMPID
GROUP BY LO.EMPID,EMP_NAME
HAVING SUM(AMOUNT_FIN) <   (SELECT 
                                 AVG(TOTAL_AMOUNT_FIN)
			    FROM
				(SELECT
				      EMP_NAME,
				      SUM(AMOUNT_FIN) AS TOTAL_AMOUNT_FIN
				 FROM LOAN_OFFICER_MASTER AS LO
				 LEFT JOIN LOAN_MASTER AS L
				 ON LO.EMPID = L.EMPID
				 GROUP BY LO.EMPID,EMP_NAME) AS S);

/*Explanation
-------------
• GROUP BY calculates the total financed amount for each loan officer.
• The subquery computes the average total disbursement across all officers.
• HAVING filters officers whose total disbursement is below that average.

Business Insight
----------------
This report helps management identify officers who may require additional
business opportunities, training, or performance support to improve loan
disbursement and achieve organizational targets.

=============================================================================*/

## Common Table Expressions (CTEs)

/*=============================================================================
Q32. Calculate each branch's total outstanding portfolio and rank the branches
accordingly.
===============================================================================

Business Requirement
--------------------
The management team wants to evaluate the outstanding loan portfolio across all
branches and rank them based on their total outstanding amount. This helps
identify branches managing the largest loan portfolios and supports portfolio
performance analysis.

Approach
--------
Use a Common Table Expression (CTE) to calculate the total outstanding amount
for each branch. Then apply the RANK() window function to rank branches from
highest to lowest outstanding portfolio.

SQL Query
---------*/

WITH BRANCH_OUTSTANDING AS (
	SELECT
	     B.BRANCH_NAME,
	     SUM(L.PRINCIPAL_OUTSTANDING) AS PRINCIPAL_OUTSTANDING
	FROM BRANCH_MASTER AS B
	LEFT JOIN LOAN_MASTER AS L
	ON B.BRANCH_ID = L.BRANCH_ID
	GROUP BY B.BRANCH_NAME
)

SELECT 
     BRANCH_NAME,
     PRINCIPAL_OUTSTANDING,
     DENSE_RANK() OVER(ORDER BY PRINCIPAL_OUTSTANDING DESC) AS OUTSTANDING_RANK,
FROM BRANCH_OUTSTANDING;

/*Explanation
-------------
• The CTE calculates the total outstanding amount for every branch.
• SUM() aggregates the principal outstanding values.
• RANK() assigns rankings based on the total outstanding portfolio.
• Branches with equal outstanding values receive the same rank.

Business Insight
----------------
This report helps management identify branches with the highest outstanding
loan exposure, enabling better portfolio monitoring, resource allocation,
and credit risk management.

=============================================================================*/


/*=============================================================================
Q33. Identify customers whose total repayments received exceed their scheduled
EMI amount.
===============================================================================

Business Requirement
--------------------
The finance team wants to identify customers who have paid more than their
scheduled EMI amount. This helps detect advance payments, excess collections,
and repayment trends.


SQL Query
---------*/

WITH TOTAL_EMI_SCHEDULE AS (
		SELECT 
		     LOAN_ID,
	       	     SUM(PRINCIPAL_COMP)+SUM(INTEREST_COMP) AS EMI_AMT
	        FROM REPAYMENT_SCHEDULE
		GROUP BY LOAN_ID
		ORDER BY LOAN_ID),
TOTAL_EMI_RECEIVED AS (
		SELECT 
		     LOAN_ID,
		     SUM(AMT_RECEIVED) AS AMT_RECEIVED
	        FROM REPAYMENT_ACTUAL
		GROUP BY LOAN_ID
		ORDER BY LOAN_ID)

SELECT
     A.LOAN_ID,
     C.CUSTOMERNAME,
     S.EMI_AMT,
     A.AMT_RECEIVED
FROM TOTAL_EMI_RECEIVED AS A
LEFT JOIN TOTAL_EMI_SCHEDULE AS S
ON A.LOAN_ID = S.LOAN_ID
LEFT JOIN LOAN_MASTER AS L
ON A.LOAN_ID = L.LOAN_ID
LEFT JOIN CUSTOMER_MASTER AS C
ON L.CIF_NO = C.CIF_NO
WHERE A.AMT_RECEIVED > S.EMI_AMT
ORDER BY A.LOAN_ID;


Business Insight
----------------
This report helps identify customers making advance or excess payments,
which may indicate financially strong customers and supports repayment
behavior analysis.

=============================================================================*/


/*=============================================================================
Q34. Calculate quarterly loan disbursement counts and compare each quarter
with the previous quarter.
===============================================================================

Business Requirement
--------------------
The business wants to analyze loan disbursement trends across quarters and
measure growth or decline compared with the previous quarter. This helps
management evaluate seasonal business performance and lending trends.

Approach
--------
Group loan disbursements by year and quarter. Use the LAG() window function
to retrieve the previous quarter's disbursement count for comparison.

SQL Query
---------*/

WITH QUARTER_LOAN_COUNT AS (
		SELECT
		     DIS_YEAR,
		     QUARTER,
		     COUNT(LOAN_ID) AS CNT_LOAN
		FROM (SELECT 
			   LOAN_ID,
			   EXTRACT(YEAR FROM DISBURSAL_DATE) AS DIS_YEAR,
			   CASE
			      WHEN EXTRACT(MONTH FROM DISBURSAL_DATE) IN (1,2,3) THEN 'Q1'
			      WHEN EXTRACT(MONTH FROM DISBURSAL_DATE) IN (4,5,6) THEN 'Q2'
			      WHEN EXTRACT(MONTH FROM DISBURSAL_DATE) IN (7,8,9) THEN 'Q3'
		              WHEN EXTRACT(MONTH FROM DISBURSAL_DATE) IN (10,11,12) THEN 'Q4'
			      ELSE NULL
			   END AS QUARTER
		       FROM LOAN_MASTER)
		       GROUP BY DIS_YEAR,QUARTER
		       ORDER BY DIS_YEAR,QUARTER ASC
)

SELECT 
     DIS_YEAR,
     QUARTER,
     CNT_LOAN,
     LAG(CNT_LOAN) OVER(ORDER BY DIS_YEAR,QUARTER ASC) AS PREVIOUS_QUARTER_COUNT,
     (CNT_LOAN) - (LAG(CNT_LOAN) OVER(ORDER BY DIS_YEAR,QUARTER ASC)) AS COUNT_DIFF
FROM QUARTER_LOAN_COUNT;

/*Explanation
-------------
• The CTE calculates loan disbursement counts for each quarter.
• LAG() retrieves the previous quarter's loan count.
• Results are ordered chronologically for proper quarter-over-quarter
  comparison.

Business Insight
----------------
Quarter-over-quarter analysis helps management identify seasonal lending
patterns, evaluate business growth, and make informed strategic decisions
for future loan campaigns.

=============================================================================*/


## Window Functions

/*=============================================================================
Q35. Assign a row number to every loan within each branch to identify the
earliest loan.
===============================================================================

Business Requirement
--------------------
The business wants to identify the earliest loan booked in each branch. This
helps analyze branch-wise lending history, identify the first customer served,
and perform historical portfolio analysis.

Approach
--------
Use the ROW_NUMBER() window function to assign a sequential number to every
loan within each branch based on the loan disbursal date.

SQL Query
---------*/

SELECT	
     LOAN_ID,
     BRANCH_ID,
     DISBURSAL_DATE
FROM (SELECT 
	LOAN_ID,
	BRANCH_ID,
	DISBURSAL_DATE,
	ROW_NUMBER () OVER(PARTITION BY BRANCH_ID ORDER BY DISBURSAL_DATE,LOAN_ID ASC) AS BRANCH_WISE_ROW
FROM LOAN_MASTER) AS T
WHERE BRANCH_WISE_ROW = 1;

/*Explanation
-------------
• PARTITION BY creates separate groups for each branch.
• ORDER BY sorts loans based on disbursal date.
• ROW_NUMBER() assigns sequential numbers starting from 1.
• The loan with BRANCH_WISE_ROW = 1 represents the earliest loan in that branch.

Business Insight
----------------
This report helps understand branch lending history and identify the first
loan disbursed in each branch for historical reporting and auditing.

=============================================================================*/


/*=============================================================================
Q36. Identify the Top 3 loan officers by total loan disbursement within each
branch.
===============================================================================

Business Requirement
--------------------
Management wants to identify the highest-performing loan officers in each
branch based on total loan disbursement. This supports performance evaluation,
recognition programs, and workload analysis.

Approach
--------
Calculate each officer's total disbursement by branch and use the RANK()
window function to rank officers within every branch.

SQL Query
---------*/

SELECT
     EMP_NAME,
     BRANCH_ID,
     TOTAL_AMT_FIN
FROM(SELECT 
	LO.EMP_NAME,
	L.BRANCH_ID,
	SUM(L.AMOUNT_FIN) AS TOTAL_AMT_FIN,
	RANK() OVER(PARTITION BY L.BRANCH_ID ORDER BY SUM(L.AMOUNT_FIN) DESC) AS TOP_RANK
FROM LOAN_MASTER AS L
LEFT JOIN LOAN_OFFICER_MASTER AS LO
ON L.EMPID = LO.EMPID
GROUP BY L.BRANCH_ID,LO.EMP_NAME) AS T
WHERE TOP_RANK <= 3;


Business Insight
----------------
This report identifies the best-performing loan officers across branches and
supports performance management, incentive planning, and business reviews.

=============================================================================*/


/*=============================================================================
Q37. Rank collection agents based on total recovery amount using DENSE_RANK.
===============================================================================

Business Requirement
--------------------
The collections department wants to rank collection agents based on the total
amount recovered. This helps evaluate collection performance and recognize
top-performing agents.

Approach
--------
Aggregate the recovery amount for each collection agent and use DENSE_RANK()
to assign rankings based on recovery performance.

SQL Query
---------*/

SELECT 
     CA.AGENT_NAME,
     SUM(C.RECOVERY_AMOUNT) AS RECOVERY_AMOUNT,
     DENSE_RANK() OVER(ORDER BY SUM(C.RECOVERY_AMOUNT)DESC) AS AMT_RANK
FROM COLLECTION_DETAILS AS C
LEFT JOIN COLLECTION_AGENT_MASTER AS CA
ON C.AGENT_ID = CA.AGENT_ID
GROUP BY CA.AGENT_NAME;

/*Explanation
-------------
• SUM() calculates each agent's total recovery amount.
• DENSE_RANK() ranks agents without skipping rank numbers.
• Agents with equal recovery amounts receive the same rank.

Business Insight
----------------
This report helps management evaluate collection efficiency, recognize
high-performing agents, and identify opportunities for coaching and training.

=============================================================================*/


/*=============================================================================
Q38. Find the next EMI amount for every repayment schedule using LEAD.
===============================================================================

Business Requirement
--------------------
The finance team wants to compare the current EMI amount with the next
scheduled EMI. This helps analyze repayment trends and identify changes in EMI
amounts over time.

Approach
--------
Use the LEAD() window function to retrieve the next EMI amount within each
loan's repayment schedule.

SQL Query
---------*/

SELECT 
     LOAN_ID,
     DUE_DATE,
     (PRINCIPAL_COMP+INTEREST_COMP) AS EMI_AMT,
     LEAD(PRINCIPAL_COMP+INTEREST_COMP) OVER(PARTITION BY LOAN_ID ORDER BY DUE_DATE ASC) AS NEXT_EMI_AMT
FROM REPAYMENT_SCHEDULE;

/*Explanation
-------------
• PARTITION BY groups repayment schedules by loan.
• ORDER BY arranges EMIs chronologically.
• LEAD() retrieves the next EMI amount without using a self join.

Business Insight
----------------
This report helps monitor repayment schedules, identify EMI changes, and
support financial planning for customers.

=============================================================================*/


/*=============================================================================
Q39. Calculate the running total of loan disbursement amount across the
portfolio.
===============================================================================

Business Requirement
--------------------
Management wants to monitor the cumulative loan disbursement amount over time.
This helps analyze business growth and lending trends.

Approach
--------
Use the SUM() window function to calculate a cumulative total ordered by loan
disbursal date.

SQL Query
---------*/

SELECT
     LOAN_ID,
     DISBURSAL_DATE,
     AMOUNT_FIN,
     SUM(AMOUNT_FIN)OVER(ORDER BY DISBURSAL_DATE,LOAN_ID ASC) AS RUNNING_TOTAL
FROM LOAN_MASTER;

/*Explanation
-------------
• SUM() OVER() calculates the cumulative total.
• ORDER BY determines the running sequence.
• Each row displays the total loan amount disbursed up to that point.

Business Insight
----------------
Running totals help management visualize portfolio growth and monitor lending
performance over time.

=============================================================================*/


/*=============================================================================
Q40. Calculate the moving average of monthly collections.
===============================================================================

Business Requirement
--------------------
The finance team wants to analyze monthly collection trends using a moving
average. This helps smooth short-term fluctuations and identify long-term
collection patterns.

Approach
--------
Aggregate collection amounts by month and use the AVG() window function with a
rolling window to calculate the moving average.

SQL Query
---------*/

WITH TOTAL_MONTHLY_COLLECTION AS (
   SELECT 
	EXTRACT(YEAR FROM FOLLOWUP_DATE) AS YEAR,
	EXTRACT(MONTH FROM FOLLOWUP_DATE) AS MONTH,
	(LEFT(TO_CHAR(FOLLOWUP_DATE,'MONTH'),3)||' '||EXTRACT(YEAR FROM FOLLOWUP_DATE)) AS CURRENT_MONTH,
	SUM(RECOVERY_AMOUNT) AS TOTAL_AMT
   FROM COLLECTION_DETAILS
   GROUP BY CURRENT_MONTH,YEAR,MONTH
   ORDER BY YEAR,MONTH ASC
)

SELECT 
     CURRENT_MONTH,
     TOTAL_AMT,
     ROUND(AVG(TOTAL_AMT) OVER(ORDER BY YEAR, MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS RUNNING_AVG
FROM TOTAL_MONTHLY_COLLECTION;

/*Explanation
-------------
• The CTE calculates total collections for each month.
• AVG() OVER() computes a rolling three-month average.
• ROWS BETWEEN 2 PRECEDING AND CURRENT ROW creates the moving window.

Business Insight
----------------
Moving averages help management identify collection trends, reduce the impact
of monthly fluctuations, and make better forecasting and planning decisions.

=============================================================================*/