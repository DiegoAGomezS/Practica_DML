/*Parte I. Creación de Base de Datos y Tablas (DDL)
1. Crear una base de datos llamada EmpresaSQL.
2. Seleccionar la base de datos creada.
3. Crear una tabla llamada TDepartamento con los campos:
nDepartamentoID (PK, Identity)
cNombreDepartamento (Unique, Not Null)
4. Crear una tabla llamada TCargo con:
nCargoID (PK, Identity)
cNombreCargo (Unique, Not Null)
5. Crear una tabla llamada TEmpleado con:
nEmpleadoID (PK, Identity)
cNIF (Unique)
cNombre
cApellido
nDepartamentoID
nCargoID
dFechaContratacion
nSalario
6. Agregar restricción CHECK para que el salario sea mayor que 300.
7. Agregar restricción DEFAULT para la fecha de contratación.
8. Establecer llave foránea entre TEmpleado y TDepartamento.
9. Establecer llave foránea entre TEmpleado y TCargo.
10. Crear una tabla llamada TProyecto.
11. Definir clave primaria autoincremental para TProyecto.
12. Agregar campo nombre del proyecto obligatorio.
13. Agregar fecha de inicio obligatoria.
14. Agregar fecha de finalización.
15. Crear tabla intermedia TEmpleadoProyecto para relación muchos a muchos.
*/

-- Creación de la base de datos y tablas
use master
go

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'EmpresaSQL')
BEGIN
    ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaSQL;
END
GO

create EmpresaSQL
go

use EmpresaSQL
go

