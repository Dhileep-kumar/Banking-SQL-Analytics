/*==============================================================

                    BANKING SQL ANALYTICS PROJECT

Author      : Dhileep Kumar
Database    : PostgreSQL
File        : create_tables.sql

Description:
This script creates the relational database schema for a
banking loan management system. The schema consists of
10 normalized tables representing customers, loans,
products, branches, repayment schedules, collections,
loan officers, and NPA tracking.

==============================================================*/

/*--------------------------------------------------------------
BRANCH_MASTER
Purpose : Stores branch-level details (location, region) used to
          tie loans, loan officers, and collection agents to a
          specific branch for branch-wise reporting.
Design  : BRANCH_ID is the primary key since it's the natural
          unique identifier for a branch. All location fields are
          marked NOT NULL as every branch record must have a
          complete address for reporting purposes.
--------------------------------------------------------------*/
CREATE TABLE BRANCH_MASTER(
	BRANCH_ID INT NOT NULL,
	BRANCH_NAME VARCHAR(100) NOT NULL,
	CITY VARCHAR(50) NOT NULL,
	STATE VARCHAR(50) NOT NULL,
	REGION VARCHAR(50) NOT NULL,
	CONSTRAINT PK_BRANCH PRIMARY KEY (BRANCH_ID)
);

/*--------------------------------------------------------------
PRODUCT_MASTER
Purpose : Master list of loan products offered, along with their
          eligible interest rate range, tenure limit, and
          processing fee — used to price and classify loans.
Design  : PRODUCTFLAG is used as the primary key instead of a
          surrogate ID since it acts as the natural short code
          referenced by LOAN_MASTER. MIN_EFF/MAX_EFF define the
          allowed interest band for each product.
--------------------------------------------------------------*/
CREATE TABLE PRODUCT_MASTER(
	PRODUCTFLAG VARCHAR(20) NOT NULL,
	PRODUCT_NAME VARCHAR(50) NOT NULL,
	MIN_EFF DECIMAL(5,2) NOT NULL,
	MAX_EFF DECIMAL(5,2) NOT NULL,
	MAX_TENURE_MONTHS INT,
	PROCESSING_FEE_PCT DECIMAL(5,2),
	CONSTRAINT PK_PRODUCT PRIMARY KEY (PRODUCTFLAG)
);

/*--------------------------------------------------------------
CUSTOMER_MASTER
Purpose : Stores customer demographic and KYC details used for
          profiling, eligibility checks, and relationship tenure
          analysis (CUSTOMER_SINCE_DATE).
Design  : CIF_NO is the primary key, matching real banking systems
          where CIF (Customer Information File) number uniquely
          identifies a customer. CHECK constraints are added on
          GENDER, MOBILE length, and CREDIT_SCORE to enforce basic
          data quality at the schema level (CREDIT_SCORE allows -1
          to represent "no score available").
--------------------------------------------------------------*/
CREATE TABLE CUSTOMER_MASTER(
	CIF_NO INT NOT NULL,
	CUSTOMERNAME VARCHAR(70) NOT NULL,
	DOB DATE,
	GENDER CHAR(1) CHECK(GENDER IN('M','F')),
	PAN_NO VARCHAR (10),
	MOBILE VARCHAR(10) CHECK(LENGTH(MOBILE) = 10),
	CITY VARCHAR(20),
	STATE VARCHAR (20),
	OCCUPATIONTYPE VARCHAR(50),
	MONTHLY_INCOME DECIMAL(10,2),
	CREDIT_SCORE INT CHECK(CREDIT_SCORE = -1 OR (CREDIT_SCORE BETWEEN 300 AND 900)),
	CUSTOMER_SINCE_DATE DATE NOT NULL,
	CONSTRAINT PK_CUSTOMER PRIMARY KEY (CIF_NO)
);

/*--------------------------------------------------------------
LOAN_OFFICER_MASTER
Purpose : Stores loan officer details, used to track which officer
          originated each loan and to measure officer-wise
          performance (disbursement volume, tenure, etc.).
Design  : EMPID is the primary key. BRANCH_ID is a mandatory
          foreign key back to BRANCH_MASTER since every officer
          must be attached to exactly one branch.
--------------------------------------------------------------*/
CREATE TABLE LOAN_OFFICER_MASTER(
	EMPID INT NOT NULL,
	EMP_NAME VARCHAR(50) NOT NULL,
	DESIGNATION VARCHAR(50),
	EXPERIENCE_YEARS INT,
	BRANCH_ID INT NOT NULL,
	DOJ DATE NOT NULL,
	CONSTRAINT PK_LOANOFFICER PRIMARY KEY (EMPID),
	CONSTRAINT FK_LOANOFFICER FOREIGN KEY (BRANCH_ID) REFERENCES BRANCH_MASTER(BRANCH_ID)

);

/*--------------------------------------------------------------
COLLECTION_AGENT_MASTER
Purpose : Stores collection agent details used to track which
          agent is responsible for recovery efforts on delinquent
          loans, and to measure agent-wise recovery performance.
Design  : AGENT_ID is the primary key. BRANCH_ID links each agent
          to a branch, mirroring the same branch-attachment pattern
          used for loan officers.
--------------------------------------------------------------*/
CREATE TABLE COLLECTION_AGENT_MASTER(
	AGENT_ID INT NOT NULL,
	AGENT_NAME VARCHAR (50) NOT NULL,
	EXPERIENCE_YEAR INT,
	BRANCH_ID INT NOT NULL,
	CONSTRAINT PK_AGENT PRIMARY KEY (AGENT_ID),
	CONSTRAINT FK_AGENT FOREIGN KEY (BRANCH_ID) REFERENCES BRANCH_MASTER(BRANCH_ID)	
);



/*--------------------------------------------------------------
LOAN_MASTER
Purpose : Central fact table of the schema — one row per loan,
          holding disbursal details, status, interest rate,
          delinquency (DPD), and outstanding balance. Almost every
          analytical query in this project is built around this
          table.
Design  : LOAN_ID is the primary key. Four foreign keys
          (CIF_NO, PRODUCTFLAG, BRANCH_ID, EMPID) tie the loan back
          to its customer, product, branch, and originating officer,
          which is what enables the multi-table joins used in the
          business questions. CHECK constraints enforce that
          AMOUNT_FIN and RATE_OF_INTEREST are non-negative, DPD is
          never negative, and STATUS is restricted to ACTIVE/CLOSED.
--------------------------------------------------------------*/
CREATE TABLE LOAN_MASTER(
	LOAN_ID INT NOT NULL,
	CIF_NO INT NOT NULL,
	PRODUCTFLAG VARCHAR(20) NOT NULL,
	BRANCH_ID INT NOT NULL,
	EMPID INT NOT NULL,
	STATUS VARCHAR(10) CHECK (STATUS IN ('ACTIVE','CLOSED')),
	DISBURSAL_DATE DATE NOT NULL,
	EMI_END_DATE DATE NOT NULL,
	AMOUNT_FIN DECIMAL(15,2) NOT NULL CHECK(AMOUNT_FIN > 0),
	RATE_OF_INTEREST DECIMAL(5,2) CHECK(RATE_OF_INTEREST >= 0),
	DPD INT CHECK(DPD >= 0),
	EMI_OVERDUE INT,
	PRINCIPAL_OUTSTANDING DECIMAL(15,2) NOT NULL,
	CONSTRAINT PK_LOAN_MASTER PRIMARY KEY(LOAN_ID),
	CONSTRAINT FK_CIF_NO FOREIGN KEY(CIF_NO) REFERENCES CUSTOMER_MASTER(CIF_NO),
	CONSTRAINT FK_PRDFG FOREIGN KEY(PRODUCTFLAG) REFERENCES PRODUCT_MASTER(PRODUCTFLAG),
	CONSTRAINT FK_BH FOREIGN KEY(BRANCH_ID) REFERENCES BRANCH_MASTER(BRANCH_ID),
	CONSTRAINT FK_EMP FOREIGN KEY(EMPID) REFERENCES LOAN_OFFICER_MASTER(EMPID)
);


/*--------------------------------------------------------------
REPAYMENT_SCHEDULE
Purpose : Holds the planned/expected EMI schedule for each loan
          (due date, principal and interest components, expected
          outstanding balance) — used for LEAD/LAG and running-total
          style analysis of scheduled repayments.
Design  : SCHEDULE_ID is a surrogate primary key since a loan can
          have many schedule rows (one per EMI). LOAN_ID is a
          foreign key back to LOAN_MASTER. OUTSTANDING_BAL is
          constrained to be non-negative.
--------------------------------------------------------------*/
CREATE TABLE REPAYMENT_SCHEDULE(
	SCHEDULE_ID INT NOT NULL,
	LOAN_ID INT NOT NULL,
	EMI_NO INT,
	DUE_DATE DATE,
	PRINCIPAL_COMP DECIMAL(15,2),
	INTEREST_COMP DECIMAL(15,2),
	OUTSTANDING_BAL DECIMAL(15,2) CHECK(OUTSTANDING_BAL >= 0),
	CONSTRAINT PK_SCHEDULE PRIMARY KEY(SCHEDULE_ID),
	CONSTRAINT FK_RS_LOAN FOREIGN KEY(LOAN_ID) REFERENCES LOAN_MASTER(LOAN_ID)
);

/*--------------------------------------------------------------
REPAYMENT_ACTUAL
Purpose : Holds the actual payments received against a loan
          (amount, date, payment mode) — used to compare actual
          vs. scheduled repayment (e.g. Q33's overpayment analysis).
Design  : RECEIPT_ID is a surrogate primary key since a loan can
          have many receipts. LOAN_ID is a foreign key back to
          LOAN_MASTER. PAYMENT_MODE is restricted via CHECK to a
          fixed set of valid payment channels.
--------------------------------------------------------------*/
CREATE TABLE REPAYMENT_ACTUAL(
	RECEIPT_ID INT NOT NULL,
	LOAN_ID INT NOT NULL,
	EMI_NO INT,
	PAYMENT_DATE DATE,
	AMT_RECEIVED DECIMAL(15,2),
	PAYMENT_MODE VARCHAR(20) CHECK(PAYMENT_MODE IN ('CASH','UPI','NACH','CHEQUE','IMPS','NEFT')),
	CONSTRAINT PK_ACTUAL PRIMARY KEY(RECEIPT_ID),
	CONSTRAINT FK_RA_LOAN FOREIGN KEY(LOAN_ID) REFERENCES LOAN_MASTER(LOAN_ID)
);

/*--------------------------------------------------------------
COLLECTION_DETAILS
Purpose : Tracks collection/recovery follow-ups on delinquent
          loans — which DPD bucket the loan falls in, the assigned
          agent, recovery status, and amount recovered.
Design  : COLLECTION_ID is a surrogate primary key since a loan can
          have multiple follow-up records over time. LOAN_ID and
          AGENT_ID are foreign keys back to LOAN_MASTER and
          COLLECTION_AGENT_MASTER respectively. BUCKET and
          RECOVERY_STATUS are constrained to fixed value sets to
          keep collection reporting consistent.
--------------------------------------------------------------*/
CREATE TABLE COLLECTION_DETAILS(
	COLLECTION_ID INT NOT NULL,
	LOAN_ID INT NOT NULL,
	BUCKET VARCHAR(10) CHECK(BUCKET IN ('0-30','30-60','60-90','90+')),
	AGENT_ID INT NOT NULL,
	RECOVERY_STATUS VARCHAR(50) CHECK (RECOVERY_STATUS IN('PENDING','PARTIAL','RECOVERED','WRITE_OFF')),
	RECOVERY_AMOUNT DECIMAL(15,2) CHECK(RECOVERY_AMOUNT >= 0),
	FOLLOWUP_DATE DATE,
	CONSTRAINT PK_COLLECTION PRIMARY KEY(COLLECTION_ID),
	CONSTRAINT FK_COLLECTION_LOAN FOREIGN KEY(LOAN_ID) REFERENCES LOAN_MASTER(LOAN_ID),
	CONSTRAINT FK_AGENT_ID FOREIGN KEY(AGENT_ID) REFERENCES COLLECTION_AGENT_MASTER(AGENT_ID)
	
);

/*--------------------------------------------------------------
NPA_TRACKING
Purpose : Point-in-time snapshot of a loan's Non-Performing Asset
          (NPA) classification and provisioning amount, used for
          regulatory/risk reporting as of a given date.
Design  : NPA_ID is a surrogate primary key since a loan can have
          multiple NPA snapshots over time (one per AS_OF_DATE).
          LOAN_ID is a foreign key back to LOAN_MASTER.
          NPA_CATEGORY is constrained to a fixed set of
          classification values.
--------------------------------------------------------------*/
CREATE TABLE NPA_TRACKING(
	NPA_ID INT NOT NULL,
	LOAN_ID INT NOT NULL,
	AS_OF_DATE DATE,
	NPA_CATEGORY VARCHAR(10) CHECK(NPA_CATEGORY IN ('NPA','REGULAR','WRITE_OFF')),
	DPD_AS_OF_DATE INT,
	PROVISION_AMT DECIMAL(10,5),
	CONSTRAINT PK_NPA PRIMARY KEY(NPA_ID),
	CONSTRAINT FK_NPA_LOAN FOREIGN KEY(LOAN_ID) REFERENCES LOAN_MASTER(LOAN_ID)
);