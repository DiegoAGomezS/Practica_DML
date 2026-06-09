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

-- Creación de tabla TDepartamento
CREATE TABLE TDepartamento (
    nDepartamentoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreDepartamento NVARCHAR(255) NOT NULL UNIQUE
);

-- Creación de tabla TCargo
CREATE TABLE TCargo (
    nCargoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreCargo NVARCHAR(255) NOT NULL UNIQUE
);

-- Creación de tabla TEmpleado
CREATE TABLE TEmpleado (
    nEmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    cNIF NVARCHAR(255) UNIQUE,
    cNombre NVARCHAR(255),
    cApellido NVARCHAR(255),
    nDepartamentoID INT,
    nCargoID INT,
    dFechaContratacion DATE DEFAULT GETDATE(),
    nSalario DECIMAL(18, 2) CHECK (nSalario > 300),
    FOREIGN KEY (nDepartamentoID) REFERENCES TDepartamento(nDepartamentoID),
    FOREIGN KEY (nCargoID) REFERENCES TCargo(nCargoID)
);

-- Creación de tabla TProyecto
CREATE TABLE TProyecto (
    nProyectoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreProyecto NVARCHAR(255) NOT NULL,
    dFechaInicio DATE NOT NULL,
    dFechaFin DATE
);

-- Creación de tabla intermedia TEmpleadoProyecto
CREATE TABLE TEmpleadoProyecto (
    nEmpleadoID INT,
    nProyectoID INT,
    PRIMARY KEY (nEmpleadoID, nProyectoID),
    FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
    FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);

/* 
Parte II. Modificación de Estructuras (ALTER)
16. Agregar columna cEmail a TEmpleado.
17. Agregar columna cTelefono.
18. Modificar longitud de cNombre a 100 caracteres.
19. Modificar longitud de cApellido a 100 caracteres.
20. Agregar columna cDireccion.
21. Agregar columna nEdad.
22. Crear restricción CHECK para edades entre 18 y 65 años.
23. Agregar restricción UNIQUE al correo electrónico.
24. Agregar columna bActivo tipo BIT con valor por defecto 1.
25. Eliminar la columna cDireccion.
26. Cambiar el tipo de dato de teléfono a VARCHAR(20).
27. Agregar columna cGenero.
28. Agregar restricción CHECK para que el género solo permita M o F.
29. Agregar columna dFechaNacimiento.
30. Crear una nueva tabla llamada TSucursal.
*/

-- Modificación de estructuras

-- Columnas agregadas a la tabla TEmpleado
ALTER Table TEmpleado
ADD cEmail varchar(255) UNIQUE,
    cTelefono varchar(255),
    cDireccion varchar(255),
    nEdad INT CHECK (nEdad >= 18 AND nEdad <= 65),
    bActivo BIT DEFAULT 1,
    cGenero CHAR(1) CHECK (cGenero IN ('M', 'F')),
    dFechaNacimiento DATE;

-- Modificación de longitud de columnas
ALTER table TEmpleado
ALTER COLUMN cNombre NVARCHAR(100);

Alter table TEmpleado
ALTER COLUMN cApellido NVARCHAR(100);

ALTER table TEmpleado
ALTER COLUMN cTelefono VARCHAR(20);

-- Eliminación de columna
ALTER table TEmpleado
DROP COLUMN cDireccion;

-- Creación de tabla TSucursal
CREATE TABLE TSucursal (
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal NVARCHAR(255) NOT NULL UNIQUE,
    cDireccionSucursal NVARCHAR(255) NOT NULL
);

/* Parte III. Inserción de Datos (INSERT)
31. Insertar 5 departamentos diferentes.
32. Insertar 5 cargos diferentes.
33. Insertar 10 empleados.
34. Insertar 3 proyectos.
35. Asignar empleados a proyectos.
36. Insertar un empleado utilizando el valor por defecto de fecha.
37. Insertar un empleado con correo electrónico.
38. Insertar un empleado sin indicar estado activo.
39. Insertar registros usando múltiples VALUES.
40. Intentar insertar un salario negativo y analizar el error.*/

