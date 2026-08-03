# Banking SQL Analytics Case Study

## Project Overview

This project demonstrates SQL problem-solving skills using a simulated banking database. It consists of **40 real-world business questions** covering fundamental to advanced SQL concepts commonly used in Data Analytics and Banking domains.

The solutions include data retrieval, aggregation, joins, subqueries, Common Table Expressions (CTEs), window functions, date functions, string functions, and business-oriented analytical queries.

---

## Objectives

- Solve practical banking business problems using SQL.
- Demonstrate proficiency in SQL for Data Analytics.
- Apply SQL techniques to generate meaningful business insights.
---

## Database Modules

The project uses the following banking tables:

- CUSTOMER_MASTER
- LOAN_MASTER
- PRODUCT_MASTER
- BRANCH_MASTER
- LOAN_OFFICER_MASTER
- COLLECTION_AGENT_MASTER
- COLLECTION_DETAILS
- REPAYMENT_SCHEDULE
- REPAYMENT_ACTUAL

---

# Business Questions

## Basic SQL

### Q1.
Display the customer name, city, and monthly income for every customer.

### Q2.
List all loans with a rate of interest between 10% and 16%, ordered from lowest to highest.

### Q3.
Find the distinct designations held by loan officers across the organization.

### Q4.
Fetch the 15 oldest customer relationships based on the customer since date.

### Q5.
List all products along with their maximum permissible tenure in descending order.

### Q6.
Find all loans where the EMI overdue count is missing and replace it with zero using COALESCE.

### Q7.
Calculate the total number of loans booked.

### Q8.
Find the minimum and maximum financed loan amount across the portfolio.

### Q9.
Calculate the average Days Past Due (DPD) for all active loans.

### Q10.
Count the number of loans disbursed for each product.

---

# Aggregate Functions & Conditional Logic

### Q11.
Find products whose processing fee percentage is above the overall average processing fee.

### Q12.
Find branches having fewer than 10 active loans.

### Q13.
Classify every loan as **High Value** or **Standard** based on the financed amount.

### Q14.
Classify collection agents as **Experienced** or **New** based on their years of experience.

---

# SQL Joins

### Q15.
Display every loan along with the customer name and branch name.

### Q16.
List all customers along with their loans, including customers who have never taken a loan.

### Q17.
Identify loan officers who joined the organization in the same year.

### Q18.
Display loan ID, customer name, product name, branch name, and loan officer name using multi-table joins.

---

# EXISTS & Subqueries

### Q19.
Find customers who currently hold at least one active loan using EXISTS.

### Q20.
Find customers who have never been assigned any loan using NOT EXISTS.

### Q21.
Extract the day, month, and year from every loan's disbursal date.

### Q22.
Find all loans whose EMI end date falls within the current calendar year.

### Q23.
Calculate each customer's current age using their date of birth.

### Q24.
Find customer names that begin with a vowel.

### Q25.
Identify loans where the principal outstanding is NULL or zero and classify each case.

### Q26.
Display "Not Assigned" whenever a loan has no assigned collection agent.

### Q27.
Find customers whose monthly income is above the average income of customers in the same city.

### Q28.
Find the second-highest financed loan amount.

### Q29.
Find products that have never been used in any loan.

### Q30.
Find branches that have at least one loan with DPD greater than 90.

### Q31.
Find loan officers whose total loan disbursement is below the average disbursement of all officers.

---

# Common Table Expressions (CTEs)

### Q32.
Calculate each branch's total outstanding portfolio and rank the branches accordingly.

### Q33.
Identify customers whose total repayments received exceed their scheduled EMI amount.

### Q34.
Calculate quarterly loan disbursement counts and compare each quarter with the previous quarter.

---

# Window Functions

### Q35.
Assign a row number to every loan within each branch to identify the earliest loan.

### Q36.
Identify the Top 3 loan officers by total loan disbursement within each branch.

### Q37.
Rank collection agents based on total recovery amount using DENSE_RANK.

### Q38.
Find the next EMI amount for every repayment schedule using LEAD.

### Q39.
Calculate the running total of loan disbursement amount across the portfolio.

### Q40.
Calculate the moving average of monthly collections.

---

## SQL Concepts Covered

- SELECT
- WHERE
- ORDER BY
- DISTINCT
- Aggregate Functions
- GROUP BY
- HAVING
- CASE Expressions
- COALESCE
- INNER JOIN
- LEFT JOIN
- SELF JOIN
- EXISTS
- NOT EXISTS
- Correlated Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LEAD()
- LAG()
- Running Totals
- Moving Averages
- Date Functions
- String Functions

---

## Repository

The corresponding SQL solutions for all the above business questions are available in:

```text
Case_Study/sql_solutions.sql
```