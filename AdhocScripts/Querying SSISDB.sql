use SSISDB

DECLARE @Loaddate DATETIME = CAST(GETDATE() AS DATE)


SELECT 
    q.*
FROM
    (SELECT em.*
     FROM SSISDB.catalog.event_messages em
     WHERE em.operation_id = (SELECT MAX(execution_id) 
                              FROM SSISDB.catalog.executions)
       AND event_name NOT LIKE '%Validate%') q
/* Put in whatever WHERE predicates you might like*/
WHERE event_name = 'OnError'
--WHERE package_name = 'MetapackDeliveryTrackingDownload.dtsx'
--AND
--	event_name LIKE '%OnError%'
--WHERE execution_path LIKE '%<some executable>%'
ORDER BY message_time DESC


SELECT
	 d.event_message_id
	,CAST(d.message_time AS Datetime) as message_time
	,d.event_name
    ,d.package_name
	,d.message
	,d.package_path
	,d.execution_path
FROM
(	SELECT 
		em.*
	FROM 
		SSISDB.catalog.event_messages em
	LEFT JOIN 
		SSISDB.catalog.executions E ON eM.operation_id = E.execution_id
	WHERE 
		EM.event_name NOT LIKE '%Validate%'
	and 
		EM.event_name = 'OnError'
	and
		cast(EM.message_time as date) = @loaddate
	--AND
	--	E.package_name = 'MetapackDeliveryTrackingDownload.dtsx'
) d
ORDER BY
	d.message_time desc
	



