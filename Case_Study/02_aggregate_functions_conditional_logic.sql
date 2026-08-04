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

