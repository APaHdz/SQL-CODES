--Las Tablas temporales empiezan # y sólo están disponibles en tu sesión, si queremos que este disponibles para otras sesiones de manera global deben empezar con ##.
--Cuando se cierra sesión las tablas se eliminan automáticamente aunque se recomienda eliminar la tabla cuando se termina el proceso.
--Las tablas variables se crean en la bd tempdb.
--Las tablas variables ejecutan por proceso, además que tienen menos bloqueos a nivel de base de datos
--Se recomiensa solo usar tablas temporales locales#

---tablas temporales
SELECT * FROM UsuarioSource

CREATE TABLE #UsuarioSourceTemp
(Código int, Nombre varchar(100))

INSERT INTO #UsuarioSourceTemp
SELECT Código, Nombre FROM UsuarioSource

SELECT * FROM #UsuarioSourceTemp

drop table #UsuarioSourceTemp



--- tablas variables SE ELIMINA automaticamente, no necesitan drop
DECLARE  @UsuarioSourceTemp2
TABLE(Código int, Nombre varchar(100))

INSERT INTO @UsuarioSourceTemp2
SELECT Código, Nombre FROM UsuarioSource

SELECT * FROM @UsuarioSourceTemp2

