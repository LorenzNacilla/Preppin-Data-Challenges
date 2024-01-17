WITH CTE AS(
SELECT
    MONTHNAME(TO_DATE(TRANSACTION_DATE, 'DD/MM/YYYY HH24:MI:SS')) AS "Transaction Date",
    SPLIT_PART(TRANSACTION_CODE, '-', 1) AS "Bank",
    SUM(VALUE) AS "Value",
    RANK() OVER( PARTITION BY "Transaction Date" ORDER BY "Value" DESC) 
        AS "Bank Rank per Month"
FROM PD2023_WK01
GROUP BY 
    "Transaction Date",
    "Bank"
),

CTE2 AS(
SELECT
    "Bank Rank per Month",
    AVG("Value") AS "Avg Transaction Value per Rank"
FROM CTE
GROUP BY 
    "Bank Rank per Month"
),

CTE3 AS(
SELECT 
    "Bank",
    AVG("Bank Rank per Month") AS "Avg Rank per Bank"
FROM CTE
GROUP BY 
    "Bank"
)
SELECT
    A.*,
    B."Avg Transaction Value per Rank",
    C."Avg Rank per Bank"
FROM CTE AS A
JOIN CTE2 AS B
    ON A."Bank Rank per Month" = B."Bank Rank per Month"
JOIN CTE3 AS C
    ON A."Bank" = C."Bank"
;



