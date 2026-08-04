
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

/*Explanation
-------------
• The subquery totals AMOUNT_FIN per officer within each branch.
• RANK() OVER(PARTITION BY BRANCH_ID ORDER BY TOTAL_AMT_FIN DESC) ranks
  officers within their own branch, so rankings reset for every branch.
• Filtering TOP_RANK <= 3 keeps only the top 3 officers per branch.

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