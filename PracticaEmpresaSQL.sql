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

-- Insertar 5 departamentos diferentes
INSERT INTO TDepartamento (cNombreDepartamento) VALUES
('Recursos Humanos'),
('Tecnología'),
('Ventas'),
('Marketing'),
('Finanzas');

-- Insertar 5 cargos diferentes
INSERT INTO TCargo (cNombreCargo) VALUES
('Gerente'),
('Analista'),
('Desarrollador'),
('Vendedor'),
('Asistente');

-- Insertar 10 empleados (Tomando en cuanta las alteraciones y restriciones realizadas)
-- Formato de cEmail: "primera letra del nombre" + "apellido" + "@empresa.com"
INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero, dFechaNacimiento) VALUES
('12345678A', 'Juan', 'Pérez', 1, 1, 5000, 'JP@empresa.com', '123456789', 30, 'M', '1994-01-01'),
('23456789B', 'María', 'Gómez', 2, 2, 4000, 'MG@empresa.com', '987654321', 28, 'F', '1996-02-02'),
('34567890C', 'Carlos', 'López', 3, 3, 3500, 'CL@empresa.com', '555555555', 35, 'M', '1989-03-03'),
('45678901D', 'Ana', 'Martínez', 4, 4, 4500, 'AM@empresa.com', '444444444', 32, 'F', '1991-04-04'),
('56789012E', 'Luis', 'Sánchez', 5, 5, 3000, 'LS@empresa.com', '333333333', 40, 'M', '1983-05-05'),
('67890123F', 'Sofía', 'García', 1, 2, 3200, 'SG@empresa.com', '222222222', 27, 'F', '1997-06-06'),
('78901234G', 'Miguel', 'Rodríguez', 2, 3, 3700, 'MR@empresa.com', '111111111', 29, 'M', '1995-07-07'),
('89012345H', 'Laura', 'Fernández', 3, 4, 4200, 'LF@empresa.com', '666666666', 31, 'F', '1993-08-08'),
('90123456I', 'David', 'Gómez', 4, 5, 3100, 'DG@empresa.com', '777777777', 33, 'M', '1991-09-09'),
('01234567J', 'Elena', 'Díaz', 5, 1, 4800, 'ED@empresa.com', '888888888', 26, 'F', '1998-10-10');

-- Insertar 3 proyectos
INSERT INTO TProyecto (cNombreProyecto, dFechaInicio, dFechaFin) VALUES
('Proyecto Alpha', '2024-01-01', '2024-06-30'),
('Proyecto Beta', '2024-02-01', '2024-07-31'),
('Proyecto Gamma', '2024-03-01', '2024-08-31');

-- Asignar empleados a proyectos
INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 1),
(8, 2),
(9, 3),
(10, 1);

-- Insertar un empleado utilizando el valor por defecto de fecha
INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero) VALUES
('11223344K', 'Sergio', 'Molina', 1, 1, 5500, 'SM@empresa.com', '999999999', 34, 'M');

-- Insertar un empleado con correo electrónico
INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero) VALUES
('22334455L', 'Lucía', 'Vargas', 2, 2, 4500, 'LV@empresa.com', '888888888', 29, 'F');

-- Insertar un empleado sin indicar estado activo
INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero) VALUES
('33445566M', 'Andrés', 'Ruiz', 3, 3, 3800, 'AR@empresa.com', '777777777', 31, 'M');

-- Insertar registros usando múltiples VALUES
INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero) VALUES
('44556677N', 'Marta', 'Soto', 4, 4, 4300, 'MS@@empresa.com', '666666666', 28, 'F'),
('55667788O', 'Javier', 'Castro', 5, 5, 3200, 'JC@empresa.com', '555555555', 36, 'M');

-- Intentar insertar un salario negativo y analizar el error
INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero) VALUES
('66778899P', 'Sonia', 'Méndez', 1, 1, -5000, 'SM@empresa.com', '444444444', 30, 'F');

/* Analisis del error:
Al intentar insertar un salario negativo, se produce un error debido a la restricción CHECK que se estableció en la columna nSalario de la tabla TEmpleado. 
La restricción CHECK especifica que el valor del salario debe ser mayor que 300, por lo que al intentar insertar un valor negativo, se viola esta restricción 
y el sistema de gestión de bases de datos (DBMS) genera un error indicando que la inserción no cumple con las condiciones establecidas para esa columna. 
Esto garantiza la integridad de los datos y evita que se ingresen valores no válidos en la base de datos.
*/

/*Parte IV. Actualización de Datos (UPDATE)
41. Incrementar en 10% el salario de todos los empleados.
42. Incrementar en 20% el salario de los empleados de un departamento específico.
43. Actualizar el correo electrónico de un empleado.
44. Modificar el cargo de un empleado.
45. Cambiar el departamento de dos empleados.
46. Marcar como inactivos a los empleados con salario inferior a 500.
47. Actualizar la fecha de finalización de un proyecto.
48. Asignar un nuevo proyecto a un empleado.
*/ 

-- Incrementar en 10% el salario de todos los empleados
UPDATE TEmpleado
SET nSalario = nSalario * 1.10;

-- Incrementar en 20% el salario de los empleados de un departamento específico (Ejemplo: Departamento ID 1)
UPDATE TEmpleado
SET nSalario = nSalario * 1.20
WHERE nDepartamentoID = 1;

-- Actualizar el correo electrónico de un empleado (Ejemplo: Empleado ID 2)
UPDATE TEmpleado
SET cEmail = 'MaG@empresa.com'
WHERE nEmpleadoID = 2;

-- Modificar el cargo de un empleado (Ejemplo: Empleado ID 3, nuevo Cargo ID 4)
UPDATE TEmpleado
SET nCargoID = 4
WHERE nEmpleadoID = 3;

-- Cambiar el departamento de dos empleados (Ejemplo: Empleado ID 4 y 5, nuevo Departamento ID 2)
UPDATE TEmpleado
SET nDepartamentoID = 2
WHERE nEmpleadoID IN (4, 5);

-- Marcar como inactivos a los empleados con salario inferior a 500
UPDATE TEmpleado
SET bActivo = 0
WHERE nSalario < 500;

-- Actualizar la fecha de finalización de un proyecto (Ejemplo: Proyecto ID 1)
UPDATE TProyecto
SET dFechaFin = '2024-12-31'
WHERE nProyectoID = 1;

-- Asignar un nuevo proyecto a un empleado (Ejemplo: Empleado ID 6, Proyecto ID 2)
INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES
(6, 2);

/* Parte V. Eliminación de Datos (DELETE)
49. Eliminar un empleado específico mediante su NIF.
50. Eliminar todos los empleados inactivos.
51. Eliminar un proyecto específico.
52. Eliminar las asignaciones de un empleado en la tabla TEmpleadoProyecto.
53. Eliminar un departamento que no tenga empleados asociados.
*/

-- Eliminar un empleado específico mediante su NIF (Ejemplo: NIF '12345678A')
DELETE FROM TEmpleado
WHERE cNIF = '12345678A';

-- Eliminar todos los empleados inactivos
DELETE FROM TEmpleado
WHERE bActivo = 0;

-- Eliminar un proyecto específico (Ejemplo: Proyecto ID 3)
DELETE FROM TProyecto
WHERE nProyectoID = 3;

-- Eliminar las asignaciones de un empleado en la tabla TEmpleadoProyecto (Ejemplo: Empleado ID 6)
DELETE FROM TEmpleadoProyecto
WHERE nEmpleadoID = 6;

-- Eliminar un departamento que no tenga empleados asociados (Ejemplo: Departamento ID 5)
DELETE FROM TDepartamento
WHERE nDepartamentoID = 5

/* Parte VI. Consultas de Verificación
54. Mostrar todos los empleados ordenados por apellido.
55. Mostrar empleados con salario mayor a 1,000.
56. Mostrar empleados activos.
57. Mostrar empleados contratados durante el año actual.
58. Mostrar empleados y el nombre de su departamento.
59. Mostrar empleados y el nombre de su cargo.
60. Mostrar empleados asignados a proyectos.
61. Mostrar cantidad de empleados por departamento.
62. Mostrar salario promedio por departamento.
63. Mostrar salario máximo y mínimo por departamento.
64. Mostrar los proyectos con más de dos empleados asignados.
65. Mostrar empleados cuyo apellido inicia con "G".
66. Mostrar empleados ordenados por salario descendente.
67. Mostrar los tres salarios más altos.
68. Mostrar empleados con edad entre 25 y 40 años.
69. Mostrar cantidad total de empleados activos.
70. Mostrar el total de proyectos registrados. */

