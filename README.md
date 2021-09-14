En este repositorio se encuentran códigos realizados en Microsoft SQL Server Manangement Studio los cuales ayudan a eficientizar 
el trabajo en una empresa de cobranza especializada.

- ## edad-por-RFC
Este código obtiene la edad de los titulares de las cuentas mediante su RFC.


- ## Folios1
La aplicación construida en C# consulta este Query, el cual genera un folio para cada promesa de pago realizada en el día.
Dicho folio toma en cuenta la siguiente letra consecutiva, la cuenta, marca y modelo de los autos vendidos a crédito y los inserta en una tabla para llevar el historico y así evitar duplicados.



- ## LimpiezaDeArchivos
El cliente envía un archivo csv el cual contiene email, domicilios y teléfonos de sus usuarios. Dichos datos estan separados por diversos delimitadores (/,*,-,~, =) y sin espacios. Esta consulta ordena los datos de cada usuario quitando duplicados y delimitadores, distribuyendo en diferentes columnas los diferentes teléfonos, correos y domicilios. Devolviendonos así un archivo de excel limpio y útil.

![image](https://user-images.githubusercontent.com/60297250/133327144-e2563bc2-6cda-4112-8223-bca18fe47d3d.png)
![image](https://user-images.githubusercontent.com/60297250/133327679-6027fa54-e07b-46a3-b1e1-8baa1b7bf5ac.png)




-## Reporte Monitor
Este código nos agrupa y muestra por día conteos de diferentes datos como el número de ejecutivos telefónicos activos, el número de teléfonos disponibles, cuantos teléfonos se pueden gestionar según sus características, etc. Este resumen ayuda a los tomadores de decisiones a visualizar más fácilmente, el estado historico de sus medios de producción y así poder planear mejor la operación futura.
![image](https://user-images.githubusercontent.com/60297250/133321121-c7d0cd85-a505-48c3-8816-8a426a23a7d2.png)
