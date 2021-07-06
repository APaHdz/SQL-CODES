USE [dbEst]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Angel Pantoja>
-- Create date: <04/11/2020>
-- Description:	<Genera folios según las conciliaciones realizadas en el día >
-- =============================================
ALTER PROCEDURE [Cart1].[3.1.Folios]
	
	@FechaIni DATE ,
	@idc VARCHAR(20),
	@Proceso bit

AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	if @Proceso = 0 begin


SELECT  NEG.idc ,
        CASE WHEN LEN (P2.Prest) <20 then left (P2.Prest,8) +'00'+ right(P2.Prest,10) else P2.Prest end Prest,
        --PR.Producto ,
		'AFI' Producto ,
        NEG.Fecha_Insert ,
        NEG.Segundo_Insert ,
        NEG.SalNE ,
        NEG.SumaNeg ,
        (1-(NEG.SumaNeg/NEG.SalNE)) DescuentoCalc,
		NEG.SalNE - NEG.SumaNeg Suma_D,
        CAST(NEG.FechaAcordada AS VARCHAR(10)) FechaAcordada,
        NEG.Carta ,
        VC.Valor Estado ,
        CT.Nombre,
		FL.Ca ,
		P2.division ,
		P2.region,
		CONCAT (marca,', ',modelo,', ',desc_auto) tipo ,
		CorreoElectrónico,
		CASE WHEN P2.division = 'M' then 'Carlos'  
			 WHEN P2.region in('ATIZAPAN', 'ECATEPEC') then 'Carlos' else 'Néstor' 
		 end Sub_Banc,
		 CASE WHEN P2. estado = 'AG' THEN 'Aguascalientes'
		      WHEN P2. estado = 'BN' THEN 'Baja California Norte'
		      WHEN P2. estado = 'BS' THEN 'Baja California Sur'
		      WHEN P2. estado = 'CA' THEN 'Campeche'
		      WHEN P2. estado = 'CH' THEN 'Chihuahua'
		      WHEN P2. estado = 'CO' THEN 'Colima'
		      WHEN P2. estado = 'CS' THEN 'Chiapas'
		      WHEN P2. estado = 'CU' THEN 'Coahuila'
		      WHEN P2. estado = 'DF' THEN 'Ciudad de México'
		      WHEN P2. estado = 'DU' THEN 'Durango'
		      WHEN P2. estado = 'EM' THEN 'Estado de México'
		      WHEN P2. estado = 'GO' THEN 'Guerrero'
		      WHEN P2. estado = 'GU' THEN 'Guanajuato'
		      WHEN P2. estado = 'HI' THEN 'Hidalgo'
		      WHEN P2. estado = 'JA' THEN 'Jalisco'
		      WHEN P2. estado = 'MI' THEN 'Michoacán'
		      WHEN P2. estado = 'MO' THEN 'Morelos'
		      WHEN P2. estado = 'NA' THEN 'Nayarit'
		      WHEN P2. estado = 'NL' THEN 'Nuevo Leon'
		      WHEN P2. estado = 'OA' THEN 'Oaxaca'
		      WHEN P2. estado = 'PU' THEN 'Puebla'
		      WHEN P2. estado = 'QR' THEN 'Quintana Roo'
		      WHEN P2. estado = 'QU' THEN 'Querétaro'
		      WHEN P2. estado = 'SI' THEN 'Sinaloa'
		      WHEN P2. estado = 'SL' THEN 'San Luis Potosí'
		      WHEN P2. estado = 'SO' THEN 'Sonora'
		      WHEN P2. estado = 'TA' THEN 'Tabasco'
		      WHEN P2. estado = 'TL' THEN 'Tlaxcala'
		      WHEN P2. estado = 'TM' THEN 'Tamaulipas'
		      WHEN P2. estado = 'VE' THEN 'Veracruz'
		      WHEN P2. estado = 'YU' THEN 'Yucatán'
		      WHEN P2. estado = 'ZA' THEN 'Zacatecas'
		end EstadoRep
FROM    [1.1.7.24].dbCol.dbo.Neg NEG WITH ( NOLOCK )
        INNER JOIN [1.1.7.24].dbCol.dbo.Cas CT WITH ( NOLOCK ) ON NEG.idc = CT.idc
                                                                  AND NEG.idC = CT.idC
        INNER JOIN [1.1.7.24].dbCol.dbo.VC VC WITH ( NOLOCK ) ON NEG.idEstado = VC.idValor
        LEFT JOIN [1.1.7.24].dbCol.dbo.Prod PR WITH ( NOLOCK ) ON CT.idProd = PR.idProd
		LEFT JOIN [1.6.8.26].dbEst.Cart1.Folios FL ON NEG.idc COLLATE DATABASE_DEFAULT = FL.Ca COLLATE DATABASE_DEFAULT AND NEG.Fecha_Insert = FL.[Fecha de ]
        INNER JOIN [1.1.7.24].dbCol.y.Producto_4 P2 WITH ( NOLOCK ) ON NEG.idc = P2.idcuenta
WHERE   NEG.Fecha_Insert = @FechaIni
        AND NEG.idC = 7
		AND CT.idProd IN ( 4 )
		AND NEG.idc = @idc
		AND NEG.idEstado != 093
		AND NEG.Carta = 1

		end

		if @Proceso = 1
		begin	

		----------------------------------Tabla folios
		DECLARE @Res BIT

SET @Res = ( SELECT DISTINCT 1
             FROM   [1.6.8.26].dbEst.Cart1.Folios
             WHERE  Prest = ( 



                                 SELECT Prest
                                 FROM   [1.1.7.24].dbCol.Y.Producto_4
                                 WHERE  idcuenta = @idc
                               )
			AND YEAR([Fecha de emi]) = YEAR(@FechaIni)
           )
		    
IF @Res = 1
    SELECT  * ,
            FolioNumero FolioProxNumero ,
            CASE WHEN FolioLetra = 'A' THEN 'B'
                 WHEN FolioLetra = 'B' THEN 'C'
                 WHEN FolioLetra = 'C' THEN 'D'
                 WHEN FolioLetra = 'D' THEN 'E'
                 WHEN FolioLetra = 'E' THEN 'F'
                 WHEN FolioLetra = 'F' THEN 'G'
                 WHEN FolioLetra = 'G' THEN 'H'
                 WHEN FolioLetra = 'H' THEN 'I'
                 WHEN FolioLetra = 'I' THEN 'J'
                 WHEN FolioLetra = 'J' THEN 'K'
                 WHEN FolioLetra = 'K' THEN 'L'
                 WHEN FolioLetra = 'L' THEN 'M'
                 WHEN FolioLetra = 'M' THEN 'N'
                 WHEN FolioLetra = 'N' THEN 'Ñ'
                 WHEN FolioLetra = 'Ñ' THEN 'O'
                 WHEN FolioLetra = 'O' THEN 'P'
                 WHEN FolioLetra = 'P' THEN 'Q'
                 WHEN FolioLetra = 'Q' THEN 'R'
                 WHEN FolioLetra = 'R' THEN 'S'
                 WHEN FolioLetra = 'S' THEN 'T'
                 WHEN FolioLetra = 'T' THEN 'U'
                 WHEN FolioLetra = 'U' THEN 'V'
                 WHEN FolioLetra = 'V' THEN 'W'
                 WHEN FolioLetra = 'W' THEN 'X'
                 WHEN FolioLetra = 'X' THEN 'Y'
                 WHEN FolioLetra = 'Y' THEN 'Z'				 
                 ELSE 'Z'
            END FolioProxLetra
    FROM    [1.6.8.26].dbEst.Cart1.Folios
    WHERE   Prest = ( 

                         SELECT Prest
                         FROM   [1.1.7.24].dbCol.Y.Producto_4
                         WHERE  idcuenta = @idc
                       )
ORDER BY [Fecha de emi] DESC , Consecutivo DESC 
ELSE
    SELECT  ISNULL(MAX(FolioNumero),0) FolioNumero ,
            '' FolioLetra ,
            ISNULL(MAX(FolioNumero),0) + 1 FolioProxNumero ,
            'A' FolioProxLetra
    FROM    [1.6.8.26].dbEst.Cart1.Folios
	WHERE YEAR([Fecha de emi]) = YEAR(@FechaIni)


SELECT ISNULL(MAX(Consecutivo),0) + 1 Consecutivo
    FROM    [1.6.8.26].dbEst.Cart1.Folios
	WHERE YEAR([Fecha de emi]) = YEAR(@FechaIni)


END
END