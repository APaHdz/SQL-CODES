USE [dbEs]
GO
/****** Object:  StoredProcedure [CLNet].[1.0.NE]    Script Date: 01/07/2021 12:59:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Angel Pantoja>
-- Create date: <04/02/2021>
-- Description:	<Inserta información sobre las NE en CL.Net>
-- =============================================
ALTER PROCEDURE [CLNet].[1.0.NE]

 @idEje INT,
 @idCart INT,
 @idProduct INT, 
 @Fecha Date,
 @Fecha1 Date

 AS
 BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	--RETURN


-------------------------------------------------------INICIA CART1
if @idCart = 1 BEGIN 
DECLARE @Sql VARCHAR(MAX)

SET @Sql = '
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
UPDATE dbEs.Temp.NE SET Exp = dbEs.dbo.SoloNumeroEnteros(Exp)
ALTER TABLE dbEs.Temp.NE ALTER COLUMN Exp BIGINT
CREATE NONCLUSTERED INDEX idx_Exp ON dbEs.Temp.NE(Exp)
DELETE FROM dbEs.CLnet.NE WHERE [FechaNe] between  ''' + CONVERT(VARCHAR(10),@Fecha,112) + ''' and  ''' + CONVERT(VARCHAR(10),@Fecha1,112) + ''' and idCart = '+ RTRIM(LTRIM(STR(@idCart))) + ' ----and c.idProduct = '+ RTRIM(LTRIM(STR(@idProduct)))+'
INSERT INTO dbEs.CLnet.NE
SELECT  c.idCart ,
        c.idProduct ,
        c.idC ,
        c.Exp ,
        A.Herramienta ,
        A.[Num P] ,
        A.menosvalia ,
        CONVERT(DATE, A.[FechaNe], 112) FechaNe ,
        CONVERT(TIME(0), A.[FechaNe]) HoraNe ,
        A.[Cuota NE] ,
        CONVERT(DATE, DATEADD(MONTH, A.R - 1, A.[FechaNe])) FechaPa ,
        A.Suma SumaMonto ,
        GETDATE() Fecha_Insert ,
		' + CONVERT(VARCHAR(10),@idEje,112) + '
FROM    ( SELECT * FROM (
							SELECT    n.* ,
									  --dbEs.dbo.SoloNumeroEnteros(n.Exp) Exped ,
							          CAST([Cuota NE] AS MONEY) * 1.0 / CAST([Num P] AS INT) Suma ,
							          F.Fecha ,
							          DAY(F.Fecha) Dia ,
							          ROW_NUMBER() OVER ( PARTITION BY n.[FechaNe] ORDER BY F.Fecha ASC ) R
							FROM      dbEs.Temp.NE n
							          CROSS JOIN dbEs.dbo.Fechas F
							WHERE     F.Fecha BETWEEN DATEADD(MONTH, -12, GETDATE()) AND GETDATE()
						) X
		WHERE   X.R <= X.[Num P] 
        ) AS A
INNER JOIN [dbCol].[dbo].ct c WITH ( NOLOCK ) ON A.Exp = c.Exp and idCart = ' + RTRIM(LTRIM(STR(@idCart))) + '
'
--print (@Sql)
exec (@Sql)
END
-------------------------------------------------------TERMINA CART1


-------------------------------------------------------INICIA CART2,CART3,CART4

  if @idCart in (4,5,7) BEGIN 
  IF EXISTS ( SELECT  1
            FROM    dbEs.sys.tables
            WHERE   name = 'P_CLnet'
                    AND schema_id = 6 )
    DROP TABLE dbEs.Temp.P_CLnet;

DECLARE @SqlQuery VARCHAR(MAX)
DECLARE @Pa INT = 1
WHILE @Pa <= 60 BEGIN

 
SET @SqlQuery =  '
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
INSERT INTO dbEs.Temp.P_CLnet/**/                       
SELECT	
			
        Exp ,
	    convert(DATE,[FechaNe],112) FechaNE,
		convert(TIME(0),[FechaNe],112)  HoraNE,
        Herramienta ,
        [Cuota NE] ,
        [Num P] ,
        menosvalia , 
       convert(DATE, [FechaPa' + RTRIM(LTRIM(STR(@Pa))) + '],112) FechaPa ,
        [SumaMonto' + RTRIM(LTRIM(STR(@Pa))) + '] SumaMonto ,
        ' + RTRIM(LTRIM(STR(@Pa))) + ' [# Pago] ,
        MONTH([FechaPa' + RTRIM(LTRIM(STR(@Pa))) + ']) MesPago ,
        YEAR([FechaPa' + RTRIM(LTRIM(STR(@Pa))) + ']) AñoPago,
		GETDATE() Fecha_Insert
INTO dbEs.Temp.P_CLnet--
FROM dbEs.Temp.NE
WHERE [FechaPa' + RTRIM(LTRIM(STR(@Pa))) + '] IS NOT NULL 
'
SET @SqlQuery = CASE WHEN @Pa = 1 THEN REPLACE(@SqlQuery,'INSERT INTO dbEs.Temp.P_CLnet/**/','--INSERT INTO dbEs.Temp.P_CLnet/**/')
                                                               ELSE REPLACE(@SqlQuery,'INTO dbEs.Temp.P_CLnet--','--INTO dbEs.Temp.P_CLnet--')
                                         end      
SET @SqlQuery = case WHEN  @idcartera = 7 THEN REPLACE(@SqlQuery, '[FechaPa', '[FechaPla') else @SqlQuery end


SET @Pa = @Pa + 1



--PRINT (@SqlQuery)
EXEC (@SqlQuery)

END 

DECLARE @SQLQuery1 varchar (max)
SET @SQLQuery1 = '
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
UPDATE dbEs.Temp.P_CLnet SET Exp = dbEs.dbo.SoloNumeroEnteros(Exp)
ALTER TABLE dbEs.Temp.P_CLnet ALTER COLUMN Exp BIGINT
CREATE NONCLUSTERED INDEX idx_Exp ON dbEs.Temp.P_CLnet(Exp)
DELETE FROM dbEs.CLnet.NE WHERE [FechaNe] between  ''' + CONVERT(VARCHAR(10),@Fecha,112) + ''' and  ''' + CONVERT(VARCHAR(10),@Fecha1,112) + ''' and idCart = '+ RTRIM(LTRIM(STR(@idCart))) + ' ----and idProduct = '+ RTRIM(LTRIM(STR(@idProduct)))+'
INSERT INTO dbEs.CLnet.NE
SELECT  c.idCart ,
        c.idProduct ,
        c.idC ,
        c.Exp ,
		a.Herramienta ,
		a.[Num P] ,
        a.menosvalia ,
		a.[FechaNE] FechaNE ,
		a.[HoraNE] HoraNE,
		a.[Cuota NE] ,
		a.FechaPa ,
		a.SumaMonto ,
		GETDATE() Fecha_Insert,
		' + CONVERT(VARCHAR(10),@idEjecutivo,112) + '
FROM    dbEs.Temp.P_CLnet a
        INNER JOIN dbCol.dbo.ct c WITH ( NOLOCK ) ON a.Exp = c.Exp and idCart = ' + RTRIM(LTRIM(STR(@idCart))) + '



DROP TABLE dbEs.Temp.P_CLnet
'


SET @SqlQuery1 = CASE WHEN @idCart in (5,7) then replace(@SqlQuery1,'dbCol.dbo.ct','[111.111.0.111].dbCol.dbo.ct')
				WHEN @idCart in (1,4) then replace(@SqlQuery1,'dbCol.dbo.ct','dbCol.dbo.ct')
				WHEN @idCart in (31) then replace(@SqlQuery1,'dbCol.dbo.ct','[192.168.8.126].dbCol.dbo.ct')
			else @SqlQuery1 end


--TERMINAN CART2,CART3,CART4
EXEC (@SQLQuery1)
 
 END

 -------------------------------------------------------INICIA CART5
   if @idCart = 3 BEGIN 
  IF EXISTS ( SELECT  1
            FROM    dbEs.sys.tables
            WHERE   name = 'P_CLnet'
                    AND schema_id = 6 )
    DROP TABLE dbEs.Temp.P_CLnet;

DECLARE @SqlQuery2 VARCHAR(MAX)
DECLARE @Pa2 INT = 1


WHILE @Pa2 <= 60 BEGIN
SET @SqlQuery2 =  '
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
INSERT INTO dbEs.Temp.P_CLnet/**/                       
SELECT	''3'' idCart ,
        ''6'' idProduct ,
		[id Cuenta] idC ,
	    convert(DATE,[FechaNe],112) FechaNE,
		convert(TIME(0),[FechaNe],112)  HoraNE,
        Herramienta ,
        [Cuota NE] ,
        [Num P] ,
        ISNULL(menosvalia,0) menosvalia , 
       convert(DATE, [FechaPa' + RTRIM(LTRIM(STR(@Pa2))) + '],112) FechaPa ,
        [SumaMonto' + RTRIM(LTRIM(STR(@Pa2))) + '] SumaMonto ,
        ' + RTRIM(LTRIM(STR(@Pa2))) + ' [# Pago] ,
        MONTH([FechaPa' + RTRIM(LTRIM(STR(@Pa2))) + ']) MesPago ,
        YEAR([FechaPa' + RTRIM(LTRIM(STR(@Pa2))) + ']) AñoPago,
		GETDATE() Fecha_Insert
INTO dbEs.Temp.P_CLnet--
FROM dbEs.Temp.NE  
WHERE [FechaPa' + RTRIM(LTRIM(STR(@Pa2))) + '] IS NOT NULL 

 '
 SET @SqlQuery2 = CASE WHEN @Pa2 = 1 THEN REPLACE(@SqlQuery2,'INSERT INTO dbEs.Temp.P_CLnet/**/','--INSERT INTO dbEs.Temp.P_CLnet/**/')
                                                               ELSE REPLACE(@SqlQuery2,'INTO dbEs.Temp.P_CLnet--','--INTO dbEs.Temp.P_CLnet--')
                                         end  
 SET @Pa2 = @Pa2 + 1

--PRINT (@SqlQuery2)
EXEC (@SqlQuery2)

END 

DECLARE @SQLQuery12 varchar (max)
SET @SQLQuery12 = '
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DELETE FROM dbEs.CLnet.NE WHERE [FechaNe] between  ''' + CONVERT(VARCHAR(10),@Fecha,112) + ''' and  ''' + CONVERT(VARCHAR(10),@Fecha1,112) + ''' and idCart = '+ RTRIM(LTRIM(STR(@idCart))) + ' ----and idProduct = '+ RTRIM(LTRIM(STR(@idProduct)))+'
INSERT INTO dbEs.CLnet.NE

SELECT  ''3'' idCart ,
        ''6'' idProduct ,
        c.NumC idC ,
        c.[NumCtrl] Exp ,
		a.Herramienta ,
		a.[Num P] ,
        a.menosvalia ,
		a.[FechaNE] FechaNE ,
		a.[HoraNE] HoraNE,
		a.[Cuota NE] ,
		a.FechaPa ,
		a.SumaMonto ,
		GETDATE() Fecha_Insert,
		' + CONVERT(VARCHAR(10),@idEjecutivo,112) + '
FROM    dbEs.Temp.P_CLnet a
        inner JOIN dbEs.Temp.Asign c WITH ( NOLOCK ) ON c.NumC = a.[idC]

drop table dbEs.Temp.P_CLnet'



----SET @SQLQuery1= case when @idcartera = 5 then replace(@SqlQuery1,'c.idProduct', 'a.Producto')else @SQLQuery1 end
--print (@SQLQuery12)
exec (@SQLQuery12)
 
 END
 -------------------------------------------------------TERMINA CART5


END
