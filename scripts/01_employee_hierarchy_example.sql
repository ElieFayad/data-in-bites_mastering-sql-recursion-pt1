USE DATABASE RECURSIVE_CTE;
USE SCHEMA RECURSIVE_CTE_DATA;

-- Recursive query to obtain how the hierarchy of employees
WITH 
    RECURSIVE EMPLOYEE_HIERARCHY AS (
        -- Anchor: Start with all employees who have no managers (top-level)
        SELECT
            EMPLOYEE_ID AS TOP_LEVEL_MANAGER,
            EMPLOYEE_ID,
            EMPLOYEE_ROLE,
            MANAGER_ID,
            -- Begin the hierarchy for each top-level manager. 
            -- Set the initial reporting hierarchy for each manager to just their own ID
            EMPLOYEE_ID::VARCHAR AS REPORTING_HIERARCHY,
            -- Additional technical column that indicates the recursion step. 
            -- It keeps track of how deep the recursion has gone
            0 AS RECURSION_LEVEL,
            -- Additional technical column that shows the path followed in the recusion step
            EMPLOYEE_ID::VARCHAR AS RECURSION_PATH
        FROM RECURSIVE_CTE_DATA.EXAMPLE_EMPLOYEE_01 
        WHERE MANAGER_ID IS NULL
        
        UNION ALL
        
        -- Recursive: Link each employee with their manager
        SELECT 
            EH.TOP_LEVEL_MANAGER,
            E.EMPLOYEE_ID,
            E.EMPLOYEE_ROLE,
            E.MANAGER_ID,
            -- Add the current employee's ID to the existing REPORTING_HIERARCHY of their manager, 
            -- effectively building the reporting chain
            E.EMPLOYEE_ID::VARCHAR || ' -> ' || EH.REPORTING_HIERARCHY AS REPORTING_HIERARCHY,
            EH.RECURSION_LEVEL + 1 AS RECURSION_LEVEL,
            EH.RECURSION_PATH || ' -> ' || E.EMPLOYEE_ID::VARCHAR AS RECURSION_PATH
        FROM 
            -- Join the employee with their manager
            -- The join is satisfied if the employee's manager is present in the previous recursion step
            RECURSIVE_CTE_DATA.EXAMPLE_EMPLOYEE_01  E
            INNER JOIN EMPLOYEE_HIERARCHY EH 
                ON E.MANAGER_ID = EH.EMPLOYEE_ID
)
SELECT *
FROM EMPLOYEE_HIERARCHY
ORDER BY TOP_LEVEL_MANAGER, EMPLOYEE_ID
;
