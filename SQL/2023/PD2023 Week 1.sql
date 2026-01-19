--Output 1
SELECT
    SPLIT_PART(TRANSACTION_CODE, '-',1) AS Bank, --
    SUM(VALUE) AS VALUE
FROM PD2023_WK01
GROUP BY 
    Bank;

--Output 2
SELECT
    SPLIT_PART(TRANSACTION_CODE, '-',1) AS "Bank",
    CASE
        WHEN ONLINE_OR_IN_PERSON = 1 THEN 'Online'
        WHEN ONLINE_OR_IN_PERSON = 2 THEN 'In-Person'
    END AS "Online or In-Person",
    CASE TO_VARCHAR(DAYOFWEEK(TO_DATE(TRANSACTION_DATE, 'DD/MM/YYYY HH24:MI:SS'))+1) --MI = Minutes, 
    --There were some 0's when made into an integer so a +1 was needed
        WHEN '1' THEN 'Sunday'
        WHEN '2' THEN 'Monday'
        WHEN '3' THEN 'Tuesday'
        WHEN '4' THEN 'Wednesday'
        WHEN '5' THEN 'Thursday'
        WHEN '6' THEN 'Friday'
        WHEN '7' THEN 'Saturday'
    END AS "Transaction Date",
    SUM(VALUE) AS "Value"
FROM PD2023_WK01
GROUP BY
    "Bank",
    "Online or In-Person",
    "Transaction Date";

--Output 3
SELECT
    SPLIT_PART(TRANSACTION_CODE, '-',1) AS "Bank",
    TO_VARCHAR(CUSTOMER_CODE) AS "Customer Code",
    SUM(VALUE) AS "Value"
FROM PD2023_WK01
GROUP BY
    "Bank",
    "Customer Code";
