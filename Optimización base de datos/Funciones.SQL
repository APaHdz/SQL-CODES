--Crea funciones para utilizarlas en consultas más complejas con menos código
/*CREATE*/ALTER FUNCTION TOTAL(
@a int,
@b INT
)
RETURNS INT
AS
BEGIN

DECLARE @Total int

SELECT @Total= @a+@b

RETURN @Total

END

DECLARE @a INT = 3
DECLARE @b INT = 4
SELECT dbo.TOTAL(@a,@b) vendido
