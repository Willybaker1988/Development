MERGE INTO [NHS].[Mirror].[DimGeneralPracticeAddress] AS TGT
USING [NHS].[Transform].[DimGeneralPracticeAddress] AS SRC 
	ON TGT.[GPId] = SRC.[GPId]
--WHEN NOT MATCHED THEN NEW GPS FOUND IN TRANSFORM, THEREFORE INSERT NEW RECORDS INTO THE MIRROR TABLE.
WHEN NOT MATCHED THEN 
INSERT
(
     [GPId]
    ,[GeneralPracticePrimarySurgeryName]
    ,[GeneralPracticeSecondarySurgeryName]
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
    ,[PostCode]
	,[FileLogId]
)
VALUES
(
     SRC.[GPId]
    ,SRC.[GeneralPracticePrimarySurgeryName]
    ,SRC.[GeneralPracticeSecondarySurgeryName]
    ,SRC.[AddressLine1]
    ,SRC.[AddressLine2]
    ,SRC.[AddressLine3]
    ,SRC.[PostCode]
	,SRC.[FileLogId]
)
--WHEN A RECORD HAS BEEN MODIFIED IN TRANSFORM THEN UPDATE RECORD IN THE MIRROR TABLE.
WHEN MATCHED
			AND (
							tgt.[GeneralPracticePrimarySurgeryName] <> src.[GeneralPracticePrimarySurgeryName]						OR	tgt.[GeneralPracticeSecondarySurgeryName] <> src.[GeneralPracticeSecondarySurgeryName]						OR	tgt.[AddressLine1] <> src.[AddressLine1]						OR	tgt.[AddressLine2] <> src.[AddressLine2]						OR	tgt.[AddressLine3] <> src.[AddressLine3]						OR	tgt.[PostCode] <> src.[PostCode]						OR	tgt.[FileLogId] <> src.[FileLogId]				)
				THEN UPDATE SET
							tgt.[GeneralPracticePrimarySurgeryName] = src.[GeneralPracticePrimarySurgeryName]						,	tgt.[GeneralPracticeSecondarySurgeryName] = src.[GeneralPracticeSecondarySurgeryName]						,	tgt.[AddressLine1] = src.[AddressLine1]						,	tgt.[AddressLine2] = src.[AddressLine2]						,	tgt.[AddressLine3] = src.[AddressLine3]						,	tgt.[PostCode] = src.[PostCode]
						,  	tgt.[FileLogId] = src.[FileLogId]
OUTPUT
	 SRC.[GPId]
	,SRC.[GeneralPracticePrimarySurgeryName]
	,SRC.[GeneralPracticeSecondarySurgeryName]
	,SRC.[AddressLine1]
	,SRC.[AddressLine2]
	,SRC.[AddressLine3]
	,SRC.[PostCode]
	,$Action AS [MergeAction];
	


