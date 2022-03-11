-- Comando CONSTRAINT mantiene el control sobre tablas denegando modificaciones a las mismas según 
--las especificaciones que se impongan 

---Si es nulo agrega 0 en la columna puntos
ALTER TABLE UsuarioSource
ADD CONSTRAINT c_UsuarioSource_Puntos DEFAULT((0)) FOR puntos

insert UsuarioSource 
VALUES(7,'Carlos Alvarez', '10')


--No permite que se repita el Nombre, es único
ALTER TABLE UsuarioSource
ADD CONSTRAINT c_UsuarioSource_Nombre UNIQUE (Nombre)

--Valida la información que existe en la tabla que sea mayor a 0 y que no sea un nombre igual
ALTER TABLE UsuarioSource
ADD CONSTRAINT c_UsuarioSource_Valida CHECK (puntos >= 0 and Nombre != 'María Solis')

insert UsuarioSource 
VALUES(7,'María Solís', 10)
