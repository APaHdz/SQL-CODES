----Crea función a través de un Query la cúal recibe parametros y devuelve resultado de consulta.

/*CREATE*/ALTER FUNCTION F_consultaA(
@FechaInicio date,
@FechaFin	 date
)
RETURNS TABLE
AS
RETURN(
SELECT 
CR.*, 
P.CurrentAgencyId,
VC1.Valor Acercamiento,
VC2.Valor Modo,
PD.Producto

FROM dbEst.Est.Contacto_Recuperación CR

LEFT JOIN (
SELECT
idCuenta, 
batchdate, 
FechaRecepción, 
CurrentAgencyId

FROM dbCol.Y.Producto_1 )P ON CR.idCuenta COLLATE DATABASE_DEFAULT = P.idCuenta COLLATE DATABASE_DEFAULT

LEFT JOIN dbCollection..ValoresCatálogo VC1 ON CR.idAcercamiento = VC1.idValor
LEFT JOIN dbCollection..ValoresCatálogo VC2 ON CR.idModo = VC2.idValor
LEFT JOIN dbCollection..Productos PD ON CR.idProducto = PD.idProducto

Where CR.idCartera = 11
and FechaPago between @FechaInicio and @FechaFin

)
-- Usando función
select * from F_consultaA('2022-02-01','2022-02-28')