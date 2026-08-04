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
     PRODUCTFLAG,
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

