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

