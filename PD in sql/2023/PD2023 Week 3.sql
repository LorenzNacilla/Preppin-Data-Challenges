--unpivoting the quarters in the quarterly targets into one column 
-----------------------------------------------------------------------------------------------------------------------------
SELECT
    ONLINE_OR_IN_PERSON AS "Online or In-Person",
    CASE QUARTERS
        WHEN 'Q1' THEN '1'
        WHEN 'Q2' THEN '2'
        WHEN 'Q3' THEN '3'
        WHEN 'Q4' THEN '4'
    END AS "Quarter",
    TARGET AS "Quarterly Targets"
FROM PD2023_WK03_TARGETS
UNPIVOT(TARGET FOR QUARTERS IN (Q1, Q2, Q3, Q4)) AS UNPIVOT
;
-----------------------------------------------------------------------------------------------------------------------------

--cleaning/manipulating the input from week 1
SELECT
    CASE
        WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online'
        WHEN ONLINE_OR_IN_PERSON = 2 THEN 'In-Person'
    END AS "Online or In-Person",
    QUARTER(TO_DATE(TRANSACTION_DATE, 'DD/MM/YYYY HH24:MI:SS')) AS "Quarter",
    SUM(VALUE) AS "Value"
FROM PD2023_WK01
WHERE CONTAINS(TRANSACTION_CODE,'DSB')
GROUP BY
    "Online or In-Person",
    "Quarter"
;
-----------------------------------------------------------------------------------------------------------------------------

--the final output --> combining the two queries by making them into ctes and then joining based on online/in-person and quarter
WITH TARGETSCTE AS (
SELECT
    ONLINE_OR_IN_PERSON AS "Online or In-Person",
    CASE QUARTERS
        WHEN 'Q1' THEN '1'
        WHEN 'Q2' THEN '2'
        WHEN 'Q3' THEN '3'
        WHEN 'Q4' THEN '4'
    END AS "Quarter",
    TARGET AS "Quarterly Targets"
FROM PD2023_WK03_TARGETS
UNPIVOT(TARGET FOR QUARTERS IN (Q1, Q2, Q3, Q4)) AS UNPIVOT
),

TRANSACTIONSCTE AS (
SELECT
    CASE
        WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online'
        WHEN ONLINE_OR_IN_PERSON = 2 THEN 'In-Person'
    END AS "Online or In-Person",
    QUARTER(TO_DATE(TRANSACTION_DATE, 'DD/MM/YYYY HH24:MI:SS')) AS "Quarter",
    SUM(VALUE) AS "Value"
FROM PD2023_WK01
WHERE CONTAINS(TRANSACTION_CODE,'DSB')
GROUP BY
    "Online or In-Person",
    "Quarter"
)
SELECT
    TRANSACTIONSCTE."Online or In-Person",
    TRANSACTIONSCTE."Quarter",
    TRANSACTIONSCTE."Value",
    TARGETSCTE."Quarterly Targets",
    TRANSACTIONSCTE."Value" - TARGETSCTE."Quarterly Targets" AS "Variance to Target"
FROM TRANSACTIONSCTE
JOIN TARGETSCTE
    ON TRANSACTIONSCTE."Online or In-Person" = TARGETSCTE."Online or In-Person"
    AND TRANSACTIONSCTE."Quarter" = TARGETSCTE."Quarter"
;
-----------------------------------------------------------------------------------------------------------------------------


