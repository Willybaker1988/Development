--CREATE OR REPLACE DATABASE DATAWAREHOUSE_TEST;

CREATE OR REPLACE TABLE DIM_COST_CENTER AS
WITH CSKT_E AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_CSKT
WHERE
    SPRAS = 'E' 

)
,

CSKT_T AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_CSKT
WHERE
    SPRAS = 'U' 

),

CSKT_S AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_CSKT
WHERE
    SPRAS = 'V' 

)


SELECT
    A.KOKRS,
    A.KOSTL,
    A.ABTEI,
    A.AFUNK,
    A.ANRED,
    A.BKZER,
    A.BKZKP,
    A.BKZKS,
    A.BKZOB,
    A.BUKRS,
    A.CCKEY,
    A.NAME3,
    A.NAME4,
    A.NKOST,
    A.OBJNR,
    A.ORT01,
    A.ORT02,
    A.PFACH,
    A.PKZER,
    A.PKZKP,
    A.CPD_TEMPL,
    A.CPI_TEMPL,
    A.DATAB,
    A.DATBI,
    A.DATLT,
    A.DRNAM,
    A.ERSDA,
    A.ETYPE,
    A.FERC_IND,
    A.FUNC_AREA,
    A.FUNKT,
    A.GSBER,
    A.JV_JIBCL,
    A.JV_JIBSA,
    A.JV_OTYPE,
    A.KALSM,
    A.KAPPL,
    A.KHINR,
    A.KOMPL,
    A.KOSAR,
    A.KOSZSCHL,
    A.KVEWE,
    A.LAND1,
    A.LOGSYSTEM,
    A.MGEFL,
    A.NAME1,
    A.NAME2,
    A.SKI_TEMPL,
    --A.SPRAS,
    A.STAKZ,
    A.STRAS,
    A.TELBX,
    A.TELF1,
    A.TELF2,
    A.TELFX,
    A.TELTX,
    A.PKZKS,
    A.PRCTR,
    A.PSTL2,
    A.PSTLZ,
    A.RECID,
    A.REGIO,
    A.SCD_TEMPL,
    A.SCI_TEMPL,
    A.SKD_TEMPL,
    A.TELX1,
    A.TXJCD,
    A.USNAM,
    A.VERAK,
    A.VERAK_USER,
    A.VMETH,
    A.VNAME,
    A.WAERS,
    A.WERKS, 
    H.*,
    COALESCE(E.SPRAS,T.SPRAS, S.SPRAS) AS SPRAS,
    COALESCE(E.KTEXT,T.KTEXT, S.KTEXT) AS KTEXT,
    COALESCE(E.LTEXT,T.LTEXT, S.LTEXT) AS LTEXT
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_CSKS A
LEFT JOIN
    CSKT_T T ON T.CC_TEXT_KEY_NODENAME = A.CC_ATTR_KEY_NODENAME
LEFT JOIN
    CSKT_E E ON E.CC_TEXT_KEY_NODENAME = A.CC_ATTR_KEY_NODENAME
LEFT JOIN
    CSKT_S S ON S.CC_TEXT_KEY_NODENAME = A.CC_ATTR_KEY_NODENAME
LEFT JOIN
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0COSTCENTER_0101_HIER H ON A.CC_ATTR_KEY_NODENAME = H.NODENAME
;

CREATE OR REPLACE TABLE DIM_COST_ELEMENT AS
WITH VW_0COSTELMNT_TEXT_E AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0COSTELMNT_TEXT
WHERE
    LANGU = 'E' 

)
,

VW_0COSTELMNT_TEXT_T AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0COSTELMNT_TEXT
WHERE
    LANGU = 'U' 

)
,


VW_0COSTELMNT_TEXT_S AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0COSTELMNT_TEXT
WHERE
    LANGU = 'V' 

)

SELECT 
    A.*,
    H.*,
    COALESCE(E.LANGU,T.LANGU, S.LANGU) AS SPRAS,
    COALESCE(E.TXTSH,T.TXTSH, S.TXTSH) AS TXTSH,
    COALESCE(E.TXTMD,T.TXTMD, S.TXTMD) AS TXTMD
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0COSTELMNT_ATTR A
LEFT JOIN
    VW_0COSTELMNT_TEXT_T T ON T.CE_TEXT_KEY_NODENAME = A.CE_ATTR_KEY_NODENAME
LEFT JOIN
    VW_0COSTELMNT_TEXT_E E ON E.CE_TEXT_KEY_NODENAME = A.CE_ATTR_KEY_NODENAME
LEFT JOIN
    VW_0COSTELMNT_TEXT_S S ON S.CE_TEXT_KEY_NODENAME = A.CE_ATTR_KEY_NODENAME
LEFT JOIN
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0COSTELMNT_0102_HIER H ON A.CE_ATTR_KEY_NODENAME = H.NODENAME
;

CREATE OR REPLACE TABLE  DIM_PROFIT_CENTER AS 
WITH VW_0PROFIT_CTR_TEXT_E AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0PROFIT_CTR_TEXT
WHERE
    LANGU = 'E' 

)
,

VW_0PROFIT_CTR_TEXT_T AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0PROFIT_CTR_TEXT
WHERE
    LANGU = 'U' 

)
,

VW_0PROFIT_CTR_TEXT_S AS (
SELECT
    *
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0PROFIT_CTR_TEXT
WHERE
    LANGU = 'V' 

)

SELECT
    A.*,
    COALESCE(E.LANGU,T.LANGU, S.LANGU) AS SPRAS,
    COALESCE(E.TXTSH,T.TXTSH, S.TXTSH) AS TXTSH,
    COALESCE(E.TXTMD,T.TXTMD, S.TXTMD) AS TXTMD
FROM
    SOURCE_SYSTEM_TEST.SAPRAW.VW_0PROFIT_CTR_ATTR A
LEFT OUTER JOIN
    VW_0PROFIT_CTR_TEXT_T T ON T.PR_TEXT_KEY_NODENAME = A.PR_ATTR_KEY_NODENAME
LEFT OUTER JOIN
    VW_0PROFIT_CTR_TEXT_E E ON E.PR_TEXT_KEY_NODENAME = A.PR_ATTR_KEY_NODENAME
LEFT OUTER JOIN
    VW_0PROFIT_CTR_TEXT_E S ON S.PR_TEXT_KEY_NODENAME = A.PR_ATTR_KEY_NODENAME
;