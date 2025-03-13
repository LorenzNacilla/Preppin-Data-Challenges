WITH CTE AS (
SELECT *
FROM PD2023_WK06_DSB_CUSTOMER_SURVEY
UNPIVOT(VALUE FOR INTERFACE IN 
    (MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION,
    MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE,
    ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND,
    ONLINE_INTERFACE___OVERALL_RATING))
),

--Unpivoting so that it turns the columns to rows first

CTE_2 AS (
SELECT
    CUSTOMER_ID,
    SPLIT_PART(INTERFACE, '___', 1) AS INTERFACE,
    SPLIT_PART(INTERFACE, '___', 2) AS INTERFACE_2,
    VALUE
FROM CTE
WHERE INTERFACE_2 NOT IN ('OVERALL_RATING')
),

--Splitting the column so that I have a column for whether it is mobile app 
--or online and the type of ease of access etc.

CTE_3 AS (
SELECT *
FROM CTE_2
PIVOT(MAX(VALUE) FOR INTERFACE IN ('MOBILE_APP', 'ONLINE_INTERFACE'))
    AS P (CUSTOMER_ID, INTERFACE_2, MOBILE_APP, ONLINE_INTERFACE)
),

--Pivoting the column that contains the mobile app or online interface strings as column headers 

CTE_4 AS (
SELECT
    CUSTOMER_ID,
    REPLACE(INTERFACE_2, '_', ' ') AS INTERFACE_2, --Getting rid of the underscore and replacing it with a space
    MOBILE_APP,
    ONLINE_INTERFACE,
    AVG(MOBILE_APP) OVER(PARTITION BY CUSTOMER_ID) AS AVG_MOBILE_APP_RATING, --Average mobile app rating
    AVG(ONLINE_INTERFACE) OVER(PARTITION BY CUSTOMER_ID) AS AVG_ONLINE_RATING, --Average online rating
    AVG_MOBILE_APP_RATING - AVG_ONLINE_RATING AS DIFFERENCE,
    CASE 
        WHEN DIFFERENCE >= 2 THEN 'Mobile App Superfan'
        WHEN DIFFERENCE >= 1 AND DIFFERENCE < 2 THEN 'Mobile App Fan'
        WHEN DIFFERENCE <= -2 THEN 'Online Interface Superfan'
        WHEN DIFFERENCE <= -1 AND DIFFERENCE > -2 THEN 'Online Interface Fan'
        ELSE 'Neutral'
    END AS PREFERENCE --Categorising the ratings based on the difference
FROM CTE_3
)

SELECT
    PREFERENCE AS "Preference",
    ROUND((COUNT(PREFERENCE)/(SELECT COUNT(*) FROM CTE_3))*100, 1) AS "% of Total" --Using a subquery to count the total rows from the previous cte
FROM CTE_4
GROUP BY PREFERENCE
;



