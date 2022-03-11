---Ejemplo de uso de comando Merge :
--Actualiza, Inserta y borra

MERGE UsuarioTarget AS TARGET
USING UsuarioSource AS SOURCE 
   ON (TARGET.Codigo = SOURCE.Codigo) 
--Cuandos los registros concuerdan por la llave
--se actualizan los registros si tienen alguna variación
 WHEN MATCHED AND (TARGET.Nombre <> SOURCE.Nombre 
			    OR TARGET.Puntos <> SOURCE.Puntos) THEN 
   UPDATE SET TARGET.Nombre = SOURCE.Nombre, 
              TARGET.Puntos = SOURCE.Puntos 
--Cuando los registros no concuerdan por la llave
--indica que es un dato nuevo, se inserta el registro
--en la tabla TARGET proveniente de la tabla SOURCE
 WHEN NOT MATCHED BY TARGET THEN 
   INSERT (Codigo, Nombre, Puntos) 
   VALUES (SOURCE.Codigo, SOURCE.Nombre, SOURCE.Puntos)
--Cuando el registro existe en TARGET y no existe en SOURCE
--se borra el registro en TARGET
 WHEN NOT MATCHED BY SOURCE THEN 
   DELETE;


   ------------
   --Ejemplo de procedimiento almacenado con Merge 
    /*CREATE OR */ALTER  PROCEDURE MerceUsuarioTarget
    @Codigo integer,
    @Nombre varchar(100),
    @Puntos integer
AS
BEGIN
    MERGE UsuarioTarget AS T
        USING (SELECT @Codigo, @Nombre, @Puntos) AS S 
					   (Codigo, Nombre, Puntos)
		ON (T.Código = S.Codigo)
    WHEN MATCHED THEN
        UPDATE SET T.Nombre = S.Nombre,
				   T.Puntos = S.Puntos
    WHEN NOT MATCHED THEN
        INSERT (Código, Nombre, Puntos)
        VALUES (S.Codigo, S.Nombre, S.Puntos) ;
END

GO 

select * from UsuarioTarget
exec MerceUsuarioTarget 2,'Angel Rojas', 12
select * from UsuarioTarget