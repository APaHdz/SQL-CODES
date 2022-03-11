----------TRIGGER
---Es un procedimiento que se acciona según las operaciones (Insert,update, delete)
----------------------------------------------------------


---------------------------------------------------------
--Enviará el mensaje 'Se realizó un insert' despues de haber insertado datos a la tabla UsuarioTarget
----------------------------------------------------------

CREATE TRIGGER t_insert 
   ON  UsuarioTarget
   AFTER INSERT
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;

	select Código, Nombre, Puntos from inserted

	Print 'Se realizó un insert'

END

GO



-----------------------------
---Enviará el  mensaje 'Se realizó un update' despues de hacer update en la tabla UsuarioTarget
-----------------------------


CREATE TRIGGER t_update 
   ON  UsuarioTarget
   AFTER UPDATE
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;
	
	select Código, Nombre, Puntos from inserted
	
	Print 'Se realizó un update'

END
GO
--update UsuarioTarget set Nombre = 'Carlos Soto Soto' where Código = 7
-----------------------------
---Enviará el  mensaje 'Se realizó un DELETE' despues de hacer DELETE en la tabla UsuarioTarget
-----------------------------
CREATE TRIGGER t_delete 
   ON  UsuarioTarget
   AFTER DELETE
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;
	
	select Código, Nombre, Puntos from inserted
	
	Print 'Se realizó un DELETE'

END
GO
--DELETE FROM UsuarioTarget WHERE Código = 7
--------------------------------------------
--- TRIGGER Para uso administrativo
--------------------------------------------
ALTER /*OR CREATE*/ TRIGGER safety   
ON DATABASE   
FOR DROP_TABLE, ALTER_TABLE   
AS   
   PRINT 'No es permitido modificar la estructura de las tablas, comuníquese con el DBA.'   
   ROLLBACK;  
GO


ALTER TABLE UsuarioTarget
ALTER COLUMN Nombre VARCHAR(100)

---DESHABILITAR TRIGGER
DISABLE TRIGGER safety ON DATABASE