WITH SOURCE_TARGET_TABLES AS (
SELECT DISTINCT 
     C.TABLE_CATALOG, C.TABLE_NAME, C.TABLE_ID, C.TABLE_SCHEMA_ID,C.TABLE_CATALOG_ID
FROM 
    "SNOWFLAKE"."ACCOUNT_USAGE"."TABLES" C
WHERE 
    TABLE_TYPE = 'BASE TABLE' 
AND
    TABLE_SCHEMA = 'SAPRAW'
AND
    DELETED IS NULL
AND
    TABLE_NAME NOT IN('0CO_OM_CCA_9_DUMP','MY_DATE_DIMENSION') AND TABLE_NAME NOT LIKE '%CLONE%'
ORDER BY 
    C.TABLE_CATALOG
),

TARGET_TABLE_LOAD_DATES AS (
SELECT 
     S.TABLE_CATALOG,
     S.TABLE_NAME,
     DATE,
     cast(cast(year(DATE) as varchar(4))||right('0'|| cast(month(DATE) as varchar(2)),2)||right('0'|| cast(day(DATE) as varchar(2)),2) as integer) as intdate
FROM 
    "DEMO_DB"."ACCOUNT_USAGE_VIEWS"."DATE_DIMENSION" D
CROSS JOIN
    SOURCE_TARGET_TABLES S  
WHERE
    DATE BETWEEN DATEADD('days',-7,CURRENT_DATE) AND CURRENT_DATE 
),


COPY_HISTORY AS (  
SELECT DISTINCT
    D.TABLE_NAME,
    S.TABLE_CATALOG,
    S.TABLE_ID,
    D.FILE_NAME,
    D.STAGE_LOCATION,
    D.LAST_LOAD_TIME,
    DATE_PART('Hour',D.LAST_LOAD_TIME) As LAST_LOAD_HOUR,
    D.ROW_COUNT,
    D.ROW_PARSED,
    D.FILE_SIZE,
    D.FIRST_ERROR_MESSAGE,
    D.FIRST_ERROR_LINE_NUMBER,
    D.FIRST_ERROR_CHARACTER_POS,
    D.FIRST_ERROR_COLUMN_NAME,
    D.ERROR_COUNT,
    COALESCE(D.ERROR_LIMIT,1) AS ERROR_LIMIT,
    UPPER(D.STATUS) AS STATUS,
    S.TABLE_SCHEMA_ID,
    D.TABLE_SCHEMA_NAME,
    S.TABLE_CATALOG_ID,
    D.PIPE_CATALOG_NAME,
    D.PIPE_SCHEMA_NAME,
    D.PIPE_NAME,
    D.PIPE_RECEIVED_TIME  
FROM
  (
    SELECT
        TABLE_NAME,
        FILE_NAME,
        STAGE_LOCATION,
        LAST_LOAD_TIME,
        ROW_COUNT,
        ROW_PARSED,
        FILE_SIZE,
        FIRST_ERROR_MESSAGE,
        FIRST_ERROR_LINE_NUMBER,
        FIRST_ERROR_CHARACTER_POS,
        FIRST_ERROR_COLUMN_NAME,
        ERROR_COUNT,
        ERROR_LIMIT,
        STATUS,
        TABLE_SCHEMA_NAME,
        PIPE_CATALOG_NAME,
        PIPE_SCHEMA_NAME,
        PIPE_NAME,
        PIPE_RECEIVED_TIME
    FROM
        "SNOWFLAKE"."ACCOUNT_USAGE"."COPY_HISTORY"
    WHERE
        LAST_LOAD_TIME::DATE BETWEEN DATEADD('days',-7,CURRENT_DATE) AND CURRENT_DATE 
    UNION ALL
    SELECT 
        TABLE_NAME,
        FILE_NAME,
        STAGE_LOCATION,
        LAST_LOAD_TIME,
        ROW_COUNT,
        ROW_PARSED,
        FILE_SIZE,
        FIRST_ERROR_MESSAGE,
        FIRST_ERROR_LINE_NUMBER,
        FIRST_ERROR_CHARACTER_POS,
        FIRST_ERROR_COLUMN_NAME,
        ERROR_COUNT,
        ERROR_LIMIT,
        STATUS,
        TABLE_SCHEMA_NAME,
        PIPE_CATALOG_NAME,
        PIPE_SCHEMA_NAME,
        PIPE_NAME,
        PIPE_RECEIVED_TIME
    FROM
        SOURCE_SYSTEM_TEST.SAPRAW.VW_COPY_HISTORY_FUNCTIONS 
    UNION ALL
    SELECT 
        TABLE_NAME,
        FILE_NAME,
        STAGE_LOCATION,
        LAST_LOAD_TIME,
        ROW_COUNT,
        ROW_PARSED,
        FILE_SIZE,
        FIRST_ERROR_MESSAGE,
        FIRST_ERROR_LINE_NUMBER,
        FIRST_ERROR_CHARACTER_POS,
        FIRST_ERROR_COLUMN_NAME,
        ERROR_COUNT,
        ERROR_LIMIT,
        STATUS,
        TABLE_SCHEMA_NAME,
        PIPE_CATALOG_NAME,
        PIPE_SCHEMA_NAME,
        PIPE_NAME,
        PIPE_RECEIVED_TIME
    FROM
        SOURCE_SYSTEM.SAPRAW.VW_COPY_HISTORY_FUNCTIONS 
  )
  D
INNER JOIN
    SOURCE_TARGET_TABLES S ON D.TABLE_NAME = S.TABLE_NAME AND D.PIPE_CATALOG_NAME = S.TABLE_CATALOG --AND D.LAST_LOAD_TIME::DATE = T.DATE
)


SELECT
    E.TABLE_NAME,
    E.TABLE_CATALOG,
    E.DATE AS LOAD_DATE,
    E.intdate AS LOAD_INT_DATE,
    TABLE_ID,
    FILE_NAME,
    STAGE_LOCATION,
    LAST_LOAD_TIME,
    DATE_PART('Hour',LAST_LOAD_TIME) As LAST_LOAD_HOUR,
    ROW_COUNT,
    ROW_PARSED,
    FILE_SIZE,
    FIRST_ERROR_MESSAGE,
    FIRST_ERROR_LINE_NUMBER,
    FIRST_ERROR_CHARACTER_POS,
    FIRST_ERROR_COLUMN_NAME,
    ERROR_COUNT,
    ERROR_LIMIT,
    STATUS,
    TABLE_SCHEMA_ID,
    TABLE_SCHEMA_NAME,
    TABLE_CATALOG_ID,
    PIPE_CATALOG_NAME,
    PIPE_SCHEMA_NAME,
    PIPE_NAME,
    PIPE_RECEIVED_TIME
FROM
    TARGET_TABLE_LOAD_DATES E
LEFT JOIN
    COPY_HISTORY CH ON E.TABLE_NAME = CH.TABLE_NAME 
AND 
    E.TABLE_CATALOG = CH.TABLE_CATALOG
AND 
    E.DATE = LAST_LOAD_TIME::DATE
WHERE
    E.DATE BETWEEN DATEADD('days',-7,CURRENT_DATE) AND CURRENT_DATE 
ORDER BY
    E.DATE DESC, E.TABLE_CATALOG, E.TABLE_NAME ;