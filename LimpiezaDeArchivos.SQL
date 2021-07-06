USE [dbEst]
GO
/****** Object:  StoredProcedure [CART1].[1.1LimpiaArchivo]    Script Date: 02/07/2021 11:31:29 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Angel Pantoja>
-- Create date:     <24/11/2020>
-- Description:	<Procedimiento almacenado que limpia archivos 
--               separando y ordenando teléfonos,correos y domicilios
--               según sus características>
-- =============================================


ALTER PROCEDURE [CART1].[1.1LimpiaArchivo]

 @LO int 

 AS
BEGIN

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


if @LO = 1 
	
	begin
	

	SELECT  A.* ,
        ISNULL(B.Tel1, '') Tel1 ,
        ISNULL(B.Tel2, '') Tel2 ,
        ISNULL(B.Tel3, '') Tel3 ,
        ISNULL(B.Tel4, '') Tel4 ,
        ISNULL(B.Tel5, '') Tel5 ,
        ISNULL(B.Tel6, '') Tel6 ,
        ISNULL(B.Tel7, '') Tel7 ,
        ISNULL(B.Tel8, '') Tel8 ,
        ISNULL(B.Tel9, '') Tel9 ,
        ISNULL(B.Tel10, '') Tel10
 
FROM    dbEst.Temp.[Archivo1] A
        LEFT JOIN ( SELECT  P.idReg ,
                            MAX(CASE WHEN P.Rd = 1 THEN P.Telefono
                                     ELSE ''
                                END) Tel1 ,
                            MAX(CASE WHEN P.Rd = 2 THEN P.Telefono
                                     ELSE ''
                                END) Tel2 ,
                            MAX(CASE WHEN P.Rd = 3 THEN P.Telefono
                                     ELSE ''
                                END) Tel3 ,
                            MAX(CASE WHEN P.Rd = 4 THEN P.Telefono
                                     ELSE ''
                                END) Tel4 ,
                            MAX(CASE WHEN P.Rd = 5 THEN P.Telefono
                                     ELSE ''
                                END) Tel5 ,
                            MAX(CASE WHEN P.Rd = 6 THEN P.Telefono
                                     ELSE ''
                                END) Tel6 ,
                            MAX(CASE WHEN P.Rd = 7 THEN P.Telefono
                                     ELSE ''
                                END) Tel7 ,
                            MAX(CASE WHEN P.Rd = 8 THEN P.Telefono
                                     ELSE ''
                                END) Tel8 ,
                            MAX(CASE WHEN P.Rd = 9 THEN P.Telefono
                                     ELSE ''
                                END) Tel9 ,
                            MAX(CASE WHEN P.Rd = 10 THEN P.Telefono
                                     ELSE ''
                                END) Tel10
                    FROM    (SELECT DISTINCT
                                        T.idReg ,
                                        right(T.Telefono,10) Telefono ,
                                        ROW_NUMBER() OVER ( PARTITION BY T.idReg ORDER BY T.idReg ) Rd
                              FROM      ( SELECT    A.[idReg] ,
                                                    Split.a.value('.', 'VARCHAR(100)') AS Telefono
                                          FROM      ( SELECT    idReg ,
                                                                CAST ('<M>' + REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(REPLACE(REPLACE(DB.SoloNumeroEnteros(Tel), ', ',' '), ', ', ' '))), '  ', ','), ' ', ','), ',,', ','), ',', '</M><M>') + '</M>' AS XML) AS String
                                                      FROM      dbEst.Temp.[Archivo1]

                                                      WHERE     REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(REPLACE(REPLACE(DB.SoloNumeroEnteros(Tel), ', ', ' '), ', ', ' '))), '  ', ','), ' ', ','), ',,', ',') != '' 
                                                    ) AS A
                                                    CROSS APPLY String.nodes('/M') AS Split ( a )
                                        ) T

										WHERE     LEN(T.Telefono) >= 
										6)P

										 GROUP BY P.idReg
										 ) B ON A.idReg = B.idReg
										 END

										 IF @LO = 2 
										 BEGIN 

				




UPDATE dbEst.Temp.[Archivo2] SET
Tels = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(replace(isnull(Tels,'') + case when len(DB.SoloNumeroEnteros(isnull(Tels,'')))>=10 then '=' + DB.SoloNumeroEnteros(isnull(Mail,'')) else '' end,',','='),'//','='), '/','='),'OF.','='),'CEL.','='),'NEX.','='),'(',''),')',''),' ', ''),CHAR(10),''),CHAR(13),''),'=',',') ,
Mail = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(replace(Mail,',','='),'//','='), '/','='), '@hotmail.ef', '@hotmail.com'), '@mail.com', '@gmail.com'),'@gamil.com', '@gmail.com'), '@hotmail.co', '@hotmail.com'),'@ootlook.comes', '@outlook.com'), '@gmail.co', '@gmail.com'), '@putlook.es' , '@outlook.es'), '@hotmai.com','@hotmail.com'),'@ocloud.com','@icloud.com'),'@hotmial.com','@hotmail.com'), '@hotmaul.com', '@hotmail.com'), '@homatil.com', '@hotmail.com'),'@homail.com', '@hotmail.com')

-

 SELECT  A.* ,
        ISNULL(B.Tel1, '') Tel1 ,
        ISNULL(B.Tel2, '') Tel2 ,
        ISNULL(B.Tel3, '') Tel3 ,
        ISNULL(B.Tel4, '') Tel4 ,
        ISNULL(B.Tel5, '') Tel5 ,
        ISNULL(B.Tel6, '') Tel6 ,
        ISNULL(B.Tel7, '') Tel7 ,
        ISNULL(B.Tel8, '') Tel8 ,
        ISNULL(B.Tel9, '') Tel9 ,
        ISNULL(B.Tel10, '') Tel10,
        ISNULL(C.Correo1, '') Correo1 ,
        ISNULL(C.Correo2, '') Correo2 ,
        ISNULL(C.Correo3, '') Correo3 , 
        ISNULL(C.Correo4, '') Correo4 ,
        ISNULL(C.Correo5, '') Correo5 ,
        ISNULL(C.Correo6, '') Correo6 ,
        ISNULL(C.Correo7, '') Correo7 ,
        ISNULL(C.Correo8, '') Correo8 ,
        ISNULL(C.Correo9, '') Correo9 ,
        ISNULL(C.Correo10, '') Correo10
FROM    dbEst.Temp.[Archivo2] A
        LEFT JOIN ( SELECT  P.idReg ,
                            MAX(CASE WHEN P.Rd = 1 THEN P.Telefono
                                     ELSE ''
                                END) Tel1 ,
                            MAX(CASE WHEN P.Rd = 2 THEN P.Telefono
                                     ELSE ''
                                END) Tel2 ,
                            MAX(CASE WHEN P.Rd = 3 THEN P.Telefono
                                     ELSE ''
                                END) Tel3 ,
                            MAX(CASE WHEN P.Rd = 4 THEN P.Telefono
                                     ELSE ''
                                END) Tel4 ,
                            MAX(CASE WHEN P.Rd = 5 THEN P.Telefono
                                     ELSE ''
                                END) Tel5 ,
                            MAX(CASE WHEN P.Rd = 6 THEN P.Telefono
                                     ELSE ''
                                END) Tel6 ,
                            MAX(CASE WHEN P.Rd = 7 THEN P.Telefono
                                     ELSE ''
                                END) Tel7 ,
                            MAX(CASE WHEN P.Rd = 8 THEN P.Telefono
                                     ELSE ''
                                END) Tel8 ,
                            MAX(CASE WHEN P.Rd = 9 THEN P.Telefono
                                     ELSE ''
                                END) Tel9 ,
                            MAX(CASE WHEN P.Rd = 10 THEN P.Telefono
                                     ELSE ''
                                END) Tel10
                    FROM    (SELECT DISTINCT
                                        T.idReg ,
                                        right(T.Telefono,10) Telefono ,
                                        ROW_NUMBER() OVER ( PARTITION BY T.idReg ORDER BY T.idReg ) Rd
                              FROM      ( SELECT    A.[idReg] ,
                                                    Split.a.value('.', 'VARCHAR(100)') AS Telefono
                                          FROM      ( SELECT    idReg ,
                                                                CAST ('<M>' + REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(REPLACE(REPLACE(DB.SoloNumeroEnteros(Tels), ', ',' '), ', ', ' '))), '  ', ','), ' ', ','), ',,', ','), ',', '</M><M>') + '</M>' AS XML) AS String
                                                      FROM      dbEst.Temp.[Archivo]

                                                      WHERE     REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(REPLACE(REPLACE(DB.SoloNumeroEnteros(Tels), ', ', ' '), ', ', ' '))), '  ', ','), ' ', ','), ',,', ',') != '' 
													  --AND NUM_CRED='9100311883'
                                                    ) AS A
                                                    CROSS APPLY String.nodes('/M') AS Split ( a )
                                        ) T

										WHERE     LEN(T.Telefono) >= 
										6)P

										 GROUP BY P.idReg
										 ) B ON A.idReg = B.idReg

										 
										  LEFT JOIN ( SELECT  P.idReg ,
                            MAX(CASE WHEN P.Rd = 1 THEN P.Correo
                                     ELSE ''
                                END) Correo1 ,
                            MAX(CASE WHEN P.Rd = 2 THEN P.Correo
                                     ELSE ''
                                END) Correo2 ,
                            MAX(CASE WHEN P.Rd = 3 THEN P.Correo
                                     ELSE ''
                                END) Correo3 ,
                            MAX(CASE WHEN P.Rd = 4 THEN P.Correo
                                     ELSE ''
                                END) Correo4 ,
                            MAX(CASE WHEN P.Rd = 5 THEN P.Correo 
                                     ELSE ''
                                END) Correo5 ,
                            MAX(CASE WHEN P.Rd = 6 THEN P.Correo
                                     ELSE ''
                                END) Correo6 ,
                            MAX(CASE WHEN P.Rd = 7 THEN P.Correo
                                     ELSE ''
                                END) Correo7 ,
                            MAX(CASE WHEN P.Rd = 8 THEN P.Correo
                                     ELSE ''
                                END) Correo8 ,
                            MAX(CASE WHEN P.Rd = 9 THEN P.Correo
                                     ELSE ''
                                END) Correo9 ,
                            MAX(CASE WHEN P.Rd = 10 THEN P.Correo
                                     ELSE ''
                                END) Correo10
                    FROM    ( SELECT  DISTINCT
                                        E.idReg ,
                                        LOWER(replace(replace(replace(REPLACE(REPLACE(REPLACE(REPLACE(E.Email, '=', ''), ' ', ''), ':', ''), '..', ''),'<',''),'>',''),'//','')) Correo ,
                                        ROW_NUMBER() OVER ( PARTITION BY E.idReg ORDER BY E.idReg ) Rd
                              FROM      ( SELECT  DISTINCT
                                                    idReg ,
                                                    Mail ,
                                                    SUBSTRING('=' + replace(Mail,',EMAIL',' '), beginningOfEmail, endOfEmail - beginningOfEmail) AS Email
                                          FROM      dbEst.Temp.[Archivo2]

                                                    CROSS APPLY ( SELECT    pos
                                                                 FROM    DB.fnExtraeCorreo('=' + Mail, '@')
																        ) AS A ( pos )
                                                    CROSS APPLY ( SELECT    CHARINDEX('=', ISNULL('=' + Mail,'') + '=', pos)
                                                                ) AS B ( endOfEmail )
                                                    CROSS APPLY ( SELECT    pos - CHARINDEX('=', REVERSE(SUBSTRING('=' + Mail, 1, pos))) + 2
                                                                ) AS C ( beginningOfEmail )
                                        ) E
                            ) P
                    GROUP BY P.idReg
                  ) C ON A.idReg = C.idReg 


				  END

				  IF @LO = 3

				  BEGIN 

				  UPDATE dbEst.Temp.[Archivo3] SET RefeTelefono = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(RefeTelefono,',','='), '@gmai.com','@gmail.com'), '@ghotmail.com', '@hotmail.com'), '@gmaol.com' , '@gmail.com'),'@gamil.com', '@gmail.com'), '@gamail.com', '@gmail.com'),'@gmai.com','@gmail.com'),'@gotmail.com','@gmail.com'),'@gamil.com','@gmail.com'),'@gmzil.com','@gmail.com'), '@hotmailc.om', '@hotmail.com'),'@hotmail.comc','@hotmail.com'),'@hotmsil.com','@hotmail.com'),'@hotmai.com','@hotmail.com')
 
  SELECT  A.* ,
        ISNULL(B.Tel1, '') Tel1 ,
        ISNULL(B.Tel2, '') Tel2 ,
        ISNULL(B.Tel3, '') Tel3 ,
        ISNULL(B.Tel4, '') Tel4 ,
        ISNULL(B.Tel5, '') Tel5 ,
        ISNULL(B.Tel6, '') Tel6 ,
        ISNULL(B.Tel7, '') Tel7 ,
        ISNULL(B.Tel8, '') Tel8 ,
        ISNULL(B.Tel9, '') Tel9 ,
        ISNULL(B.Tel10, '') Tel10,
        ISNULL(C.Correo1, '') Correo1 ,
        ISNULL(C.Correo2, '') Correo2 ,
        ISNULL(C.Correo3, '') Correo3 ,
        ISNULL(C.Correo4, '') Correo4 ,
        ISNULL(C.Correo5, '') Correo5 ,
        ISNULL(C.Correo6, '') Correo6 ,
        ISNULL(C.Correo7, '') Correo7 ,
        ISNULL(C.Correo8, '') Correo8 ,
        ISNULL(C.Correo9, '') Correo9 ,
        ISNULL(C.Correo10, '') Correo10
FROM    dbEst.Temp.[Archivo3] A
        LEFT JOIN ( SELECT  P.idReg ,
                            MAX(CASE WHEN P.Rd = 1 THEN P.Telefono
                                     ELSE ''
                                END) Tel1 ,
                            MAX(CASE WHEN P.Rd = 2 THEN P.Telefono
                                     ELSE ''
                                END) Tel2 ,
                            MAX(CASE WHEN P.Rd = 3 THEN P.Telefono
                                     ELSE ''
                                END) Tel3 ,
                            MAX(CASE WHEN P.Rd = 4 THEN P.Telefono
                                     ELSE ''
                                END) Tel4 ,
                            MAX(CASE WHEN P.Rd = 5 THEN P.Telefono
                                     ELSE ''
                                END) Tel5 ,
                            MAX(CASE WHEN P.Rd = 6 THEN P.Telefono
                                     ELSE ''
                                END) Tel6 ,
                            MAX(CASE WHEN P.Rd = 7 THEN P.Telefono
                                     ELSE ''
                                END) Tel7 ,
                            MAX(CASE WHEN P.Rd = 8 THEN P.Telefono  
                                     ELSE ''
                                END) Tel8 ,
                            MAX(CASE WHEN P.Rd = 9 THEN P.Telefono
                                     ELSE ''
                                END) Tel9 ,
                            MAX(CASE WHEN P.Rd = 10 THEN P.Telefono
                                     ELSE ''
                                END) Tel10
                    FROM    (SELECT DISTINCT
                                        T.idReg ,
                                        right(T.Telefono,10) Telefono ,
                                        ROW_NUMBER() OVER ( PARTITION BY T.idReg ORDER BY T.idReg ) Rd
                              FROM      ( SELECT    A.[idReg] ,
                                                    Split.a.value('.', 'VARCHAR(100)') AS Telefono
                                          FROM      ( SELECT    idReg ,
                                                                CAST ('<M>' + REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(REPLACE(REPLACE(DB.SoloNumeroEnteros(RefeTelefono), '.', ' '), ',', ','))), '  ', ','), ' ', ','), ',,', ','), ',', '</M><M>') + '</M>' AS XML) AS String
                                                      FROM      dbEst.Temp.[Archivo3]
                                                      WHERE     REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(REPLACE(REPLACE(DB.SoloNumeroEnteros(RefeTelefono), '.', ' '), ',', ' '))), '  ', ','), ' ', ','), ',,', ',') != ''
                                                    ) AS A
                                                    CROSS APPLY String.nodes('/M') AS Split ( a )
                                        ) T

										WHERE     LEN(T.Telefono) >= 10)P

										 GROUP BY P.idReg
										 ) B ON A.idReg = B.idReg


										  LEFT JOIN ( SELECT  P.idReg ,
                            MAX(CASE WHEN P.Rd = 1 THEN P.Correo
                                     ELSE ''
                                END) Correo1 ,
                            MAX(CASE WHEN P.Rd = 2 THEN P.Correo
                                     ELSE ''
                                END) Correo2 ,
                            MAX(CASE WHEN P.Rd = 3 THEN P.Correo
                                     ELSE ''
                                END) Correo3 ,
                            MAX(CASE WHEN P.Rd = 4 THEN P.Correo
                                     ELSE ''
                                END) Correo4 ,
                            MAX(CASE WHEN P.Rd = 5 THEN P.Correo 
                                     ELSE ''
                                END) Correo5 ,
                            MAX(CASE WHEN P.Rd = 6 THEN P.Correo
                                     ELSE ''
                                END) Correo6 ,
                            MAX(CASE WHEN P.Rd = 7 THEN P.Correo
                                     ELSE ''
                                END) Correo7 ,
                            MAX(CASE WHEN P.Rd = 8 THEN P.Correo
                                     ELSE ''
                                END) Correo8 ,
                            MAX(CASE WHEN P.Rd = 9 THEN P.Correo
                                     ELSE ''
                                END) Correo9 ,
                            MAX(CASE WHEN P.Rd = 10 THEN P.Correo
                                     ELSE ''
                                END) Correo10
                    FROM    ( SELECT  DISTINCT
                                        E.idReg ,
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(E.Email, '=', ''), ' ', ''), ':', ''), '..', '')) Correo ,
                                        ROW_NUMBER() OVER ( PARTITION BY E.idReg ORDER BY E.idReg ) Rd
                              FROM      ( SELECT  DISTINCT
                                                    idReg ,
                                                    RefeTelefono ,
                                                    SUBSTRING('=' + replace(RefeTelefono,',EMAIL',' '), beginningOfEmail, endOfEmail - beginningOfEmail) AS Email
                                          FROM      dbEst.Temp.[Archivo3]

                                                    CROSS APPLY ( SELECT    pos
                                                                 FROM    DB.fnExtraeCorreo('=' + RefeTelefono, '@')
																        ) AS A ( pos )
                                                    CROSS APPLY ( SELECT    CHARINDEX('=', ISNULL('=' + RefeTelefono,'') + '=', pos)
                                                                ) AS B ( endOfEmail )
                                                    CROSS APPLY ( SELECT    pos - CHARINDEX('=', REVERSE(SUBSTRING('=' + RefeTelefono, 1, pos))) + 2
                                                                ) AS C ( beginningOfEmail )
                                        ) E
                            ) P
                    GROUP BY P.idReg
                  ) C ON A.idReg = C.idReg 

				  END 

				  IF EXISTS ( SELECT  1 FROM    dbEst.sys.tables WHERE   name = 'Archivo1' AND schema_id = 6 )
							DROP TABLE dbEst.Temp.Archivo1;

							
				  IF EXISTS ( SELECT  1 FROM    dbEst.sys.tables WHERE   name = 'Archivo2' AND schema_id = 6 )
							DROP TABLE dbEst.Temp.Archivo2;
							
				  IF EXISTS ( SELECT  1 FROM    dbEst.sys.tables WHERE   name = 'Archivo3' AND schema_id = 6 )
							DROP TABLE dbEst.Temp.Archivo3;

				  

				  END