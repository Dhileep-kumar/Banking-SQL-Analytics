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
     DENSE_RANK() OVER(ORDER BY PRINCIPAL_OUTSTANDING DESC) AS OUTSTANDING_RANK
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


