--Consultas que nos ayudan a monitorerar el estado de nuestra base de datos.

---Procedimientos almacenados creados en dbMaster
SELECT name
FROM sys.objects
WHERE type = 'P'
AND DATEDIFF(D,modify_date, GETDATE()) < 7

--- podemos ver los triggers creados o modificados
SELECT
o.name as [Trigger Name],
CASE WHEN o.type = 'TR' THEN 'SQL DML Trigger'
     WHEN o.type = 'TA' THEN 'DML Assembly Trigger' END
     AS [Trigger Type],
sc.name AS [Schema_Name],
OBJECT_NAME(parent_object_id) as [Table Name],
o.create_date [Trigger Create Date], 
o.modify_date [Trigger Modified Date] 
FROM sys.objects o
INNER JOIN sys.schemas sc ON o.schema_id = sc.schema_id
WHERE (type = 'TR' OR type = 'TA')
AND ( DATEDIFF(D,create_date, GETDATE()) < 7 OR
    DATEDIFF(D,modify_date, GETDATE()) < 7)


---Monitoreo de crecimiento
	EXEC sp_readerrorlog
---Registros de tablas
SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN
            ON sOBJ.object_id = sPTN.object_id
WHERE
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND index_id < 2 -- 0:Heap, 1:Clustered
GROUP BY 
      sOBJ.schema_id
      , sOBJ.name
ORDER BY [RowCount] desc