SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @FechaIni DATE = '2021-09-01'
DECLARE @FechaFin DATE = '2021-09-12'




SELECT
ERA.DIA,
ERA.Fecha,
ERA.HC,
ERA.INVENTARIO,
ERA.GESTIONABLE,
(CONVERT(FLOAT,ERA.GESTIONABLE)/ERA.Inventario) *100 '%',
SUM(ACC.GESTIONADO) GESTIONADO,
(SUM(ACC.GESTIONADO)/ERA.GESTIONABLE) '%.',
SUM(ACC.ACCIONES) ACCIONES,
SUM(ACC.CONTACTO) CONTACTO,
SUM(ACC.CONTACTO)/ SUM(ACC.GESTIONADO) '.%',
SUM(ACC.PROMESAS) PROMESAS,
SUM(ACC.PROMESAS)/SUM(ACC.CONTACTO) '-%',
SUM(ACC.ACCIONES)/ERA.HC 'CTA X FTE',
SUM(ACC.PROMESAS)/ERA.HC 'PP X FTE'



FROM


(
SELECT 

GESTIONADO.Fecha,
GESTIONADO.Ct,
CASE WHEN #GestTot IS NOT NULL THEN 1 ELSE 0 END GESTIONADO,
iSNULL(GESTIONADO.#GestTot,0) ACCIONES,
GESTIONADO.#Cont CONTACTO,
GESTIONADO.#Prom PROMESAS


FROM
(
SELECT 
GESTIONABLES.Fecha,
GESTIONABLES.Ct,
GEST.#GestTot,
GEST.#Cont,
GEST.#Prom


FROM
(
SELECT
Fecha,
Ct

from dbEst.Temp.Hibryc H WITH (NOLOCK)
left join dbC..VC VC WITH (NOLOCK) on H.Status = vc.Valor
left join dbC..RC RC WITH (NOLOCK) on VC.Valor = RC.Valor1
left join dbC..VC VC2 WITH (NOLOCK) on RC.Valor2 = VC2.Valor
where Wallet = 4
AND Item = 1**
AND Cta = 1
--AND VC2.Valor != 'Tratado'
--AND VC2.Valor != 'Aclarado'
--AND CAST(H.total_deudor as money) >= 25000
GROUP BY 
Fecha,
Ct

) GESTIONABLES

LEFT JOIN (

SELECT 
FECHA,
Ct,
COUNT(Ct) AS '#GestTot',
SUM(CASE WHEN Enlace= 11**THEN 1 ELSE 0 END) #Cont,
SUM(CASE WHEN Tool IS NOT NULL AND Enlace= 11**AND Tool != 29 THEN 1 ELSE 0 END) #Prom
FROM dbEst.Temp.HibriGes
GROUP BY 
FECHA,
Ct

) GEST ON GESTIONABLES.Ct = GEST.Ct and GESTIONABLES.Fecha = GEST.FECHA


) GESTIONADO
) ACC


LEFT JOIN (

SELECT 
CASE 
WHEN DíaSemana = 4 THEN 'J'
WHEN DíaSemana = 5 THEN 'V'
WHEN DíaSemana = 6 THEN 'S'
WHEN DíaSemana = 7 THEN 'D'
WHEN DíaSemana = 1 THEN 'L'
WHEN DíaSemana = 2 THEN 'M'
WHEN DíaSemana = 3 THEN 'M'
ELSE '' END 'DIA',
A.FECHA,
E.HC,
B.Inventario, 
T.GESTIONABLE

FROM 
dbHistory.dbo.Fechas A
left join (select count(a.Ejeuni)HC, a.FECHA from (
 SELECT ROW_NUMBER() OVER ( PARTITION BY A.Ct,A.FECHA order by A.FECHA asc )f, 
 A.FECHA , A.Ct, A.Segundo, C.Ejeuni
FROM 
 dbC.dbo.Gesttel  A WITH (NOLOCK)
 left join dbC.dbo.ct B WITH (NOLOCK)
 ON b.Ct = A.Ct and
 B.Wallet = A.Wallet 
 left join dbEst.Temp.HibriGes C on
 A.Ct = C.Ct 
 and A.Wallet = C.Wallet
 and a.FECHA = C.FECHA
 where B.Item = 133
AND  A.Wallet = 4 
AND B.Sal >= 24000.99
AND C.GesUDia = 1 
 group by A.FECHA, A.Ct, A.Segundo, C.Ejeuni,A.idEjecutivo )A
 WHERE a.f = 1 and a.Ejeuni = 1
 group by  a.FECHA
) E ON A.FECHA = E.FECHA

LEFT JOIN 
(SELECT 
COUNT(Cta)'Inventario',
Fecha  
FROM dbEst.Temp.Hibryc WITH (NOLOCK)
WHERE Cta = 1 and Item = 133
group by fecha
) B
ON B.Fecha = A.Fecha
LEFT JOIN (
SELECT
COUNT(Cta) 'GESTIONABLE',
Fecha
from dbEst.Temp.Hibryc H WITH (NOLOCK)
left join dbC..VC VC WITH (NOLOCK) on H.Status = vc.Valor
left join dbC..RC RC WITH (NOLOCK) on VC.Valor = RC.Valor1
left join dbC..VC VC2 WITH (NOLOCK) on RC.Valor2 = VC2.Valor
where Wallet = 4
AND Item = 133
AND Cta = 1
AND VC2.Valor != 'Tratado'
AND VC2.Valor != 'Aclarado'
AND H.total_deudor >= '24000.99'
GROUP BY Fecha)T
ON T.Fecha = A.Fecha


) ERA ON ERA.Fecha = ACC.Fecha 

WHERE ERA.FECHA  BETWEEN @FechaIni AND @FechaFin

GROUP BY
ACC.Fecha, ERA.DIA, ERA.HC, ERA.Inventario,ERA.Fecha, ERA.GESTIONABLE

ORDER BY 
ACC.Fecha