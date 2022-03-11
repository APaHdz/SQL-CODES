--Consulta que devuelve el output en formato JSON
--(Disponibles solo para SQL SERVER 2016 o más recientes)
SELECT codigo, 
	   nombre as 'usuario.nombre', 
	   puntos as 'usuario.puntos' 
  FROM usuariosource
FOR JSON PATH

--Consulta que devuelve el output en formato XML
SELECT * FROM UsuarioSource
FOR XML AUTO, ELEMENTS, ROOT('Usuarios')

SELECT * FROM UsuarioSource
FOR XML PATH('Usuarios'), ELEMENTS, ROOT('Usuarios')

