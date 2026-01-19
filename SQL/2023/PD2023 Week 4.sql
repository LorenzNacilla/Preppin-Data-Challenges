--------------------------------------------------------------------------------------------------------------
WITH UNION_CTE AS(
SELECT 
    *,
    '01' AS "Month"
FROM PD2023_WK04_JANUARY

    UNION ALL

SELECT
    *,
    '02' AS "Month"
FROM PD2023_WK04_FEBRUARY

    UNION ALL

SELECT
    *,
    '03' AS "Month"
FROM PD2023_WK04_MARCH

    UNION ALL

SELECT
    *,
    '04' AS "Month"
FROM PD2023_WK04_APRIL

    UNION ALL

SELECT
    *,
    '05' AS "Month"
FROM PD2023_WK04_MAY

    UNION ALL

SELECT
    *,
    '06' AS "Month"
FROM PD2023_WK04_JUNE

    UNION ALL

SELECT
    *,
    '07' AS "Month"
FROM PD2023_WK04_JULY

    UNION ALL

SELECT
    *,
    '08' AS "Month"
FROM PD2023_WK04_AUGUST

    UNION ALL

SELECT
    *,
    '09' AS "Month"
FROM PD2023_WK04_SEPTEMBER

    UNION ALL

SELECT
    *,
    '10' AS "Month"
FROM PD2023_WK04_OCTOBER

    UNION ALL

SELECT
    *,
    '11' AS "Month"
FROM PD2023_WK04_NOVEMBER

    UNION ALL

SELECT
    *,
    '12' AS "Month"
FROM PD2023_WK04_DECEMBER
),

--Union all the monthly tables. Created a Month column with the respective month number as field values for each table
--------------------------------------------------------------------------------------------------------------

PIVOT_CTE AS(
SELECT
    ID,
    TO_DATE(CONCAT(TO_VARCHAR(JOINING_DAY),'/',"Month",'/','2023'),'DD/MM/YYYY') AS "Joining Date",
    DEMOGRAPHIC,
    VALUE
FROM UNION_CTE
),

/*Creating a CTE to create and store the joining date by concatenting the joining day, month field. Tried to do the pivot in this query but it was unable
to pick up joining day --> the error was an invalid identifier for it hence it needed to be stored first
*/
--------------------------------------------------------------------------------------------------------------

PIVOT_CTE2 AS(
SELECT
    ID,
    "Joining Date",
    ROW_NUMBER() OVER(PARTITION BY ID ORDER BY "Joining Date" ASC) AS R,
    "Account Type",
    DATE_OF_BIRTH::DATE AS "Date of Birth",
    "Ethnicity"
FROM PIVOT_CTE
PIVOT(MAX(VALUE) FOR DEMOGRAPHIC IN ('Account Type', 'Date of Birth', 'Ethnicity'))
    AS PIVOT(
    ID,
    "Joining Date",
    "Account Type",
    DATE_OF_BIRTH,
    "Ethnicity"
    )
)

/*Final CTE that does the pivoting using the new and stored joining date, and creating the row number for each ID ordered by the respective joining date so it
can be used as a WHERE clause to filter out duplicates
*/
--------------------------------------------------------------------------------------------------------------

SELECT 
    ID,
    "Joining Date",
    "Account Type",
    "Date of Birth",
    "Ethnicity"
FROM PIVOT_CTE2
WHERE R = 1
;

/*Getting the necessary fields where the row number is 1 only which rids the duplicates
--------------------------------------------------------------------------------------------------------------




