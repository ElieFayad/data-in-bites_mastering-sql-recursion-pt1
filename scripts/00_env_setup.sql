CREATE DATABASE RECURSIVE_CTE;
CREATE SCHEMA RECURSIVE_CTE_DATA;
DROP SCHEMA PUBLIC;

-- create table and load data
USE DATABASE RECURSIVE_CTE;
USE SCHEMA RECURSIVE_CTE_DATA;

-- Create Employees table
CREATE OR REPLACE TABLE RECURSIVE_CTE_DATA.EXAMPLE_EMPLOYEE_01 (
    EMPLOYEE_ID NUMBER,
    EMPLOYEE_ROLE VARCHAR,
    MANAGER_ID NUMBER
);

INSERT OVERWRITE INTO RECURSIVE_CTE_DATA.EXAMPLE_EMPLOYEE_01 (
    EMPLOYEE_ID,
    EMPLOYEE_ROLE,
    MANAGER_ID
)
VALUES
    (1, 'Director of Engineering', NULL),
    (2, 'Engineering Manager', 1),
    (3, 'Product Manager', 1),
    (4, 'Software Engineer', 2),
    (5, 'Data Analyst', 2),
    (6, 'UX Designer', 3),
    (7, 'Intern 1', 4),
    (8, 'Intern 2', 4),

    (9, 'HR Director', NULL),
    (10, 'HR Employee', 9),
    (11, 'HR Intern', 9)
;

-- Check that data is inserted correctly
SELECT * FROM RECURSIVE_CTE_DATA.EXAMPLE_EMPLOYEE_01;
