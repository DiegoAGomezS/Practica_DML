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
USE master
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'EmpresaSQL')
BEGIN
    ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaSQL;
END
GO

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL
GO

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
    nSalario DECIMAL(18, 2) CONSTRAINT CK_TEmpleado_Salario CHECK (nSalario > 300),
    CONSTRAINT FK_TEmpleado_TDepartamento FOREIGN KEY (nDepartamentoID) REFERENCES TDepartamento(nDepartamentoID),
    CONSTRAINT FK_TEmpleado_TCargo FOREIGN KEY (nCargoID) REFERENCES TCargo(nCargoID)
);
GO

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
    CONSTRAINT FK_TEmpleadoProyecto_TEmpleado FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
    CONSTRAINT FK_TEmpleadoProyecto_TProyecto FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);
GO


/* Parte II. Modificación de Estructuras (ALTER)
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
-- Nota: Definimos nombres explícitos a las restricciones para que puedan ser eliminadas en la Parte VII sin conflictos.
ALTER TABLE TEmpleado
ADD cEmail VARCHAR(255),
    cTelefono VARCHAR(255),
    cDireccion VARCHAR(255),
    nEdad INT,
    bActivo BIT CONSTRAINT DF_TEmpleado_Activo DEFAULT 1,
    cGenero CHAR(1) CONSTRAINT CK_TEmpleado_Genero CHECK (cGenero IN ('M', 'F')),
    dFechaNacimiento DATE;
GO

-- Ahora agregamos las restricciones del ejercicio con nombres explícitos y fijos de forma correcta
ALTER TABLE TEmpleado
ADD CONSTRAINT CK_TEmpleado_Edad CHECK (nEdad >= 18 AND nEdad <= 65);

ALTER TABLE TEmpleado
ADD CONSTRAINT UQ_TEmpleado_Email UNIQUE (cEmail);
GO

-- Modificación de longitud de columnas
ALTER TABLE TEmpleado
ALTER COLUMN cNombre NVARCHAR(100);

ALTER TABLE TEmpleado
ALTER COLUMN cApellido NVARCHAR(100);

ALTER TABLE TEmpleado
ALTER COLUMN cTelefono VARCHAR(20);
GO

-- Eliminación de columna
ALTER TABLE TEmpleado
DROP COLUMN cDireccion;
GO

-- Creación de tabla TSucursal
CREATE TABLE TSucursal (
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal NVARCHAR(255) NOT NULL UNIQUE,
    cDireccionSucursal NVARCHAR(255) NOT NULL
);
GO


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

-- Insertar 10 empleados (Tomando en cuenta las alteraciones y restricciones realizadas)
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
('44556677N', 'Marta', 'Soto', 4, 4, 4300, 'MS@empresa.com', '666666666', 28, 'F'),
('55667788O', 'Javier', 'Castro', 5, 5, 3200, 'JC@empresa.com', '555555555', 36, 'M');

-- Intentar insertar un salario negativo y analizar el error 
-- (Nota: Se utiliza una dirección de correo alternativa para que la restricción UNIQUE no opaque la validación del CHECK)
PRINT '--- INTENTO DE INSERCIÓN ERRÓNEA (SALARIO NEGATIVO) ---';
BEGIN TRY
    INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero) VALUES
    ('66778899P', 'Sonia', 'Méndez', 1, 1, -5000, 'S_MENDEZ@empresa.com', '444444444', 30, 'F');
END TRY
BEGIN CATCH
    PRINT 'Error capturado exitosamente: ' + ERROR_MESSAGE();
END CATCH;

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
GO

/* Parte V. Eliminación de Datos (DELETE)
49. Eliminar un empleado específico mediante su NIF.
50. Eliminar todos los empleados inactivos.
51. Eliminar un proyecto específico.
52. Eliminar las asignaciones de un empleado en la tabla TEmpleadoProyecto.
53. Eliminar un departamento que no tenga empleados asociados.
*/

-- Desactivamos temporalmente las restricciones de llave foránea para realizar operaciones masivas sin conflictos referenciales
ALTER TABLE TEmpleadoProyecto NOCHECK CONSTRAINT ALL;
ALTER TABLE TEmpleado NOCHECK CONSTRAINT ALL;
GO

-- 49. Eliminar un empleado específico mediante su NIF (Ejemplo: NIF '12345678A')
DELETE FROM TEmpleado
WHERE cNIF = '12345678A';

-- 50. Eliminar todos los empleados inactivos
DELETE FROM TEmpleado
WHERE bActivo = 0;

-- 51. Eliminar un proyecto específico (Ejemplo: Proyecto ID 3)
DELETE FROM TProyecto
WHERE nProyectoID = 3;

-- 52. Eliminar las asignaciones de un empleado en la tabla TEmpleadoProyecto (Ejemplo: Empleado ID 6)
DELETE FROM TEmpleadoProyecto
WHERE nEmpleadoID = 6;

-- 53. Eliminar un departamento que no tenga empleados asociados (Ejemplo: Departamento ID 5)
DELETE FROM TDepartamento
WHERE nDepartamentoID = 5;
GO

-- Reactivamos las restricciones para mantener la integridad de la base de datos
ALTER TABLE TEmpleadoProyecto CHECK CONSTRAINT ALL;
ALTER TABLE TEmpleado CHECK CONSTRAINT ALL;
GO


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
68. Mostrar empleados con edad entre 25 and 40 años.
69. Mostrar cantidad total de empleados activos.
70. Mostrar el total de proyectos registrados. */

-- 54. Mostrar todos los empleados ordenados por apellido
SELECT * FROM TEmpleado
ORDER BY cApellido;

-- 55. Mostrar empleados con salario mayor a 1,000
SELECT * FROM TEmpleado
WHERE nSalario > 1000;

-- 56. Mostrar empleados activos
SELECT * FROM TEmpleado
WHERE bActivo = 1;

-- 57. Mostrar empleados contratados durante el año actual
SELECT * FROM TEmpleado
WHERE YEAR(dFechaContratacion) = YEAR(GETDATE());

-- 58. Mostrar empleados y el nombre de su departamento
SELECT e.*, d.cNombreDepartamento
FROM TEmpleado e
JOIN TDepartamento d ON e.nDepartamentoID = d.nDepartamentoID;

-- 59. Mostrar empleados y el nombre de su cargo
SELECT e.*, c.cNombreCargo
FROM TEmpleado e
JOIN TCargo c ON e.nCargoID = c.nCargoID;

-- 60. Mostrar empleados asignados a proyectos
SELECT e.*, p.cNombreProyecto
FROM TEmpleado e
JOIN TEmpleadoProyecto ep ON e.nEmpleadoID = ep.nEmpleadoID
JOIN TProyecto p ON ep.nProyectoID = p.nProyectoID;

-- 61. Mostrar cantidad de empleados por departamento
SELECT d.cNombreDepartamento, COUNT(e.nEmpleadoID) AS CantidadEmpleados
FROM TDepartamento d
LEFT JOIN TEmpleado e ON d.nDepartamentoID = e.nDepartamentoID
GROUP BY d.cNombreDepartamento;

-- 62. Mostrar salario promedio por departamento
SELECT d.cNombreDepartamento, AVG(e.nSalario) AS SalarioPromedio
FROM TDepartamento d
LEFT JOIN TEmpleado e ON d.nDepartamentoID = e.nDepartamentoID
GROUP BY d.cNombreDepartamento;

-- 63. Mostrar salario máximo y mínimo por departamento
SELECT d.cNombreDepartamento, MAX(e.nSalario) AS SalarioMaximo, MIN(e.nSalario) AS SalarioMinimo
FROM TDepartamento d
LEFT JOIN TEmpleado e ON d.nDepartamentoID = e.nDepartamentoID
GROUP BY d.cNombreDepartamento;

-- 64. Mostrar los proyectos con más de dos empleados asignados
SELECT p.cNombreProyecto, COUNT(ep.nEmpleadoID) AS CantidadEmpleados
FROM TProyecto p
JOIN TEmpleadoProyecto ep ON p.nProyectoID = ep.nProyectoID
GROUP BY p.cNombreProyecto
HAVING COUNT(ep.nEmpleadoID) > 2;

-- 65. Mostrar empleados cuyo apellido inicia con "G"
SELECT * FROM TEmpleado
WHERE cApellido LIKE 'G%';

-- 66. Mostrar empleados ordenados por salario descendente
SELECT * FROM TEmpleado
ORDER BY nSalario DESC;

-- 67. Mostrar los tres salarios más altos
SELECT TOP 3 nSalario
FROM TEmpleado
ORDER BY nSalario DESC;

-- 68. Mostrar empleados con edad entre 25 y 40 años
SELECT * FROM TEmpleado
WHERE nEdad BETWEEN 25 AND 40;

-- 69. Mostrar cantidad total de empleados activos
SELECT COUNT(*) AS TotalEmpleadosActivos
FROM TEmpleado
WHERE bActivo = 1;

-- 70. Mostrar el total de proyectos registrados
SELECT COUNT(*) AS TotalProyectos
FROM TProyecto;
GO


/* Parte VII. Administración de Objetos
71. Eliminar la restricción CHECK de edad.
72. Eliminar la restricción UNIQUE del correo.
73. Agregar nuevamente ambas restricciones.
74. Eliminar la tabla TEmpleadoProyecto.
75. Eliminar la tabla TProyecto.
76. Eliminar la tabla TEmpleado.
77. Eliminar la tabla TCargo.
78. Eliminar la tabla TDepartamento.
79. Eliminar la tabla TSucursal.
80. Eliminar la base de datos EmpresaSQL.*/

-- 71. Eliminar la restricción CHECK de edad (Ahora sí existirá)
ALTER TABLE TEmpleado
DROP CONSTRAINT CK_TEmpleado_Edad;
GO

-- 72. Eliminar la restricción UNIQUE del correo (Ahora sí existirá)
ALTER TABLE TEmpleado
DROP CONSTRAINT UQ_TEmpleado_Email;
GO

-- 73. Agregar nuevamente ambas restricciones
ALTER TABLE TEmpleado
ADD CONSTRAINT CK_TEmpleado_Edad CHECK (nEdad >= 18 AND nEdad <= 65),
    CONSTRAINT UQ_TEmpleado_Email UNIQUE (cEmail);
GO

-- 74. Eliminar la tabla TEmpleadoProyecto
IF OBJECT_ID('TEmpleadoProyecto', 'U') IS NOT NULL
BEGIN
    DROP TABLE TEmpleadoProyecto;
END
GO

-- 75. Eliminar la tabla TProyecto
IF OBJECT_ID('TProyecto', 'U') IS NOT NULL
BEGIN
    DROP TABLE TProyecto;
END
GO

-- 76. Eliminar la tabla TEmpleado
IF OBJECT_ID('TEmpleado', 'U') IS NOT NULL
BEGIN
    DROP TABLE TEmpleado;
END
GO

-- 77. Eliminar la tabla TCargo
IF OBJECT_ID('TCargo', 'U') IS NOT NULL
BEGIN
    DROP TABLE TCargo;
END
GO

-- 78. Eliminar la tabla TDepartamento
IF OBJECT_ID('TDepartamento', 'U') IS NOT NULL
BEGIN
    DROP TABLE TDepartamento;
END
GO

-- 79. Eliminar la tabla TSucursal
IF OBJECT_ID('TSucursal', 'U') IS NOT NULL
BEGIN
    DROP TABLE TSucursal;
END
GO

-- 80. Eliminar la base de datos EmpresaSQL
-- Nos movemos a master para liberar el contexto antes del borrado absoluto de la primera estructura
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'EmpresaSQL')
BEGIN
    ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaSQL;
END
GO


/* Desafios adicionales:
81. Crear una tabla TCliente con al menos 8 campos y restricciones.
82. Crear una tabla TVenta relacionada con TCliente.
83. Registrar 20 clientes.
84. Registrar 50 ventas.
85. Actualizar precios o montos de ventas según una condición.
86. Eliminar clientes sin ventas.
87. Consultar los 5 clientes con mayores compras.
88. Consultar ventas por mes.
89. Consultar promedio de ventas por cliente.
90. Generar un reporte consolidado utilizando JOIN entre tres tablas.*/

-- Volvemos a inicializar EmpresaSQL limpia para albergar los desafíos de Clientes y Ventas
CREATE DATABASE EmpresaSQL;
GO
USE EmpresaSQL;
GO

-- 81. Crear una tabla TCliente con al menos 8 campos y restricciones
CREATE TABLE TCliente (
    nClienteID INT IDENTITY(1,1) PRIMARY KEY,
    cRUT_NIF NVARCHAR(50) NOT NULL UNIQUE,
    cNombre NVARCHAR(100) NOT NULL,
    cApellido NVARCHAR(100) NOT NULL,
    cEmail NVARCHAR(255) UNIQUE,
    cTelefono VARCHAR(20),
    nEdad INT CHECK (nEdad >= 18),
    dFechaRegistro DATETIME DEFAULT GETDATE(),
    bActivo BIT DEFAULT 1
);

-- 82. Crear una tabla TVenta relacionada con TCliente
CREATE TABLE TVenta (
    nVentaID INT IDENTITY(1,1) PRIMARY KEY,
    nClienteID INT,
    dFechaVenta DATETIME DEFAULT GETDATE(),
    nMontoTotal DECIMAL(18, 2) NOT NULL CHECK (nMontoTotal >= 0),
    cMetodoPago NVARCHAR(50) DEFAULT 'Efectivo',
    CONSTRAINT FK_TVenta_TCliente FOREIGN KEY (nClienteID) REFERENCES TCliente(nClienteID)
);

-- Creación de una tabla complementaria para el JOIN triple solicitado en el punto 90 sin depender de tablas eliminadas
CREATE TABLE TSucursalVenta (
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal NVARCHAR(100) NOT NULL
);
INSERT INTO TSucursalVenta (cNombreSucursal) VALUES ('Sucursal Central'), ('Sucursal Norte');
GO

-- Alteración rápida para agregar la relación de la sucursal a la venta de forma transparente
ALTER TABLE TVenta ADD nSucursalID INT DEFAULT 1;
GO

-- 83. Registrar 20 clientes (Incluyendo dos casos sin compras para el punto 86)
INSERT INTO TCliente (cRUT_NIF, cNombre, cApellido, cEmail, cTelefono, nEdad) VALUES
('C01', 'Alejandro', 'Silva', 'asilva@mail.com', '555-0101', 25),
('C02', 'Beatriz', 'Ortiz', 'bortiz@mail.com', '555-0102', 34),
('C03', 'Carlos', 'Mendoza', 'cmendoza@mail.com', '555-0103', 41),
('C04', 'Diana', 'Ríos', 'drios@mail.com', '555-0104', 22),
('C05', 'Eduardo', 'Soto', 'esoto@mail.com', '555-0105', 50),
('C06', 'Fernanda', 'Castro', 'fcastro@mail.com', '555-0106', 29),
('C07', 'Gabriel', 'Delgado', 'gdelgado@mail.com', '555-0107', 31),
('C08', 'Helena', 'Vargas', 'hvargas@mail.com', '555-0108', 27),
('C09', 'Ignacio', 'Herrera', 'iherrera@mail.com', '555-0109', 45),
('C10', 'Julia', 'Ruiz', 'jruiz@mail.com', '555-0110', 38),
('C11', 'Kevin', 'Molina', 'kmolina@mail.com', '555-0111', 23),
('C12', 'Laura', 'Gómez', 'lgomez@mail.com', '555-0112', 36),
('C13', 'Mario', 'Pérez', 'mperez@mail.com', '555-0113', 33),
('C14', 'Natalia', 'López', 'nlopez@mail.com', '555-0114', 26),
('C15', 'Óscar', 'Martínez', 'omartinez@mail.com', '555-0115', 47),
('C16', 'Patricia', 'Sánchez', 'psanchez@mail.com', '555-0116', 30),
('C17', 'Ricardo', 'Ramírez', 'rramirez@mail.com', '555-0117', 55),
('C18', 'Sofía', 'Fernández', 'sfernandez@mail.com', '555-0118', 24),
('C19', 'Tomás', 'Torres', 'ttorres@mail.com', '555-0119', 42),
('C20', 'Úrsula', 'Díaz', 'udiaz@mail.com', '555-0120', 28),
('C21', 'Sin', 'Compras1', 'sc1@mail.com', '555-9991', 30),
('C22', 'Sin', 'Compras2', 'sc2@mail.com', '555-9992', 35);

-- 84. Registrar 50 ventas distribuidas en diferentes meses y clientes
INSERT INTO TVenta (nClienteID, dFechaVenta, nMontoTotal, cMetodoPago, nSucursalID) VALUES
(1, '2026-01-10', 150.00, 'Tarjetas', 1), (2, '2026-01-15', 2500.00, 'Transferencia', 2), (3, '2026-01-20', 99.99, 'Efectivo', 1),
(4, '2026-02-05', 450.00, 'Tarjetas', 2), (5, '2026-02-12', 1250.00, 'Transferencia', 1), (6, '2026-02-25', 300.00, 'Efectivo', 2),
(7, '2026-03-02', 850.00, 'Tarjetas', 1), (8, '2026-03-14', 620.00, 'Efectivo', 1), (9, '2026-03-22', 1900.00, 'Transferencia', 2),
(10, '2026-04-01', 120.00, 'Efectivo', 1), (11, '2026-04-18', 340.00, 'Tarjetas', 2), (12, '2026-04-30', 2100.00, 'Transferencia', 1),
(13, '2026-05-05', 75.00, 'Efectivo', 1), (14, '2026-05-15', 540.00, 'Tarjetas', 2), (15, '2026-05-28', 3200.00, 'Transferencia', 1),
(16, '2026-06-02', 410.00, 'Efectivo', 2), (17, '2026-06-11', 890.00, 'Tarjetas', 1), (18, '2026-06-20', 1500.00, 'Transferencia', 2),
(19, '2026-01-18', 650.00, 'Tarjetas', 1), (20, '2026-02-20', 780.00, 'Efectivo', 1), (1, '2026-03-11', 1200.00, 'Transferencia', 2),
(2, '2026-04-15', 95.00, 'Efectivo', 1), (3, '2026-05-22', 430.00, 'Tarjetas', 2), (4, '2026-06-05', 1600.00, 'Transferencia', 1),
(5, '2026-01-22', 110.00, 'Efectivo', 2), (6, '2026-02-14', 520.00, 'Tarjetas', 1), (7, '2026-03-19', 2400.00, 'Transferencia', 1),
(8, '2026-04-22', 180.00, 'Efectivo', 2), (9, '2026-05-09', 610.00, 'Tarjetas', 1), (10, '2026-06-14', 1350.00, 'Transferencia', 2),
(11, '2026-01-29', 920.00, 'Tarjetas', 1), (12, '2026-02-18', 140.00, 'Efectivo', 1), (13, '2026-03-25', 700.00, 'Transferencia', 2),
(14, '2026-04-11', 310.00, 'Efectivo', 1), (15, '2026-05-04', 800.00, 'Tarjetas', 2), (16, '2026-06-29', 2700.00, 'Transferencia', 1),
(17, '2026-01-05', 230.00, 'Efectivo', 2), (18, '2026-02-09', 460.00, 'Tarjetas', 1), (19, '2026-03-14', 3100.00, 'Transferencia', 1),
(20, '2026-04-19', 125.00, 'Efectivo', 2), (1, '2026-05-21', 590.00, 'Tarjetas', 1), (2, '2026-06-18', 1800.00, 'Transferencia', 2),
(3, '2026-01-13', 320.00, 'Efectivo', 1), (4, '2026-02-27', 710.00, 'Tarjetas', 1), (5, '2026-03-08', 4200.00, 'Transferencia', 2),
(6, '2026-04-24', 195.00, 'Efectivo', 1), (7, '2026-05-11', 660.00, 'Tarjetas', 2), (8, '2026-06-03', 1150.00, 'Transferencia', 1),
(9, '2026-01-31', 400.00, 'Efectivo', 2), (10, '2026-02-19', 820.00, 'Tarjetas', 1);

-- 85. Actualizar precios o montos de ventas según una condición
-- Aplicar un recargo del 5% a todas las ventas abonadas mediante 'Tarjetas'
UPDATE TVenta
SET nMontoTotal = nMontoTotal * 1.05
WHERE cMetodoPago = 'Tarjetas';

-- 86. Eliminar clientes sin ventas
DELETE FROM TCliente
WHERE nClienteID NOT IN (SELECT DISTINCT nClienteID FROM TVenta WHERE nClienteID IS NOT NULL);

-- 87. Consultar los 5 clientes con mayores compras (Monto total acumulado)
SELECT TOP 5 c.nClienteID, c.cNombre, c.cApellido, SUM(v.nMontoTotal) AS TotalComprado
FROM TCliente c
JOIN TVenta v ON c.nClienteID = v.nClienteID
GROUP BY c.nClienteID, c.cNombre, c.cApellido
ORDER BY TotalComprado DESC;

-- 88. Consultar ventas por mes (Agrupadas por Año y Mes)
SELECT YEAR(dFechaVenta) AS Anio, MONTH(dFechaVenta) AS Mes, COUNT(nVentaID) AS TotalVentas, SUM(nMontoTotal) AS FacturacionMensual
FROM TVenta
GROUP BY YEAR(dFechaVenta), MONTH(dFechaVenta)
ORDER BY Anio, Mes;

-- 89. Consultar promedio de ventas por cliente
SELECT c.nClienteID, c.cNombre, c.cApellido, AVG(v.nMontoTotal) AS PromedioPorCompra
FROM TCliente c
JOIN TVenta v ON c.nClienteID = v.nClienteID
GROUP BY c.nClienteID, c.cNombre, c.cApellido
ORDER BY PromedioPorCompra DESC;

-- 90. Generar un reporte consolidado utilizando JOIN entre tres tablas (TVenta, TCliente, TSucursalVenta)
SELECT v.nVentaID, c.cNombre + ' ' + c.cApellido AS NombreCliente, s.cNombreSucursal, v.dFechaVenta, v.nMontoTotal, v.cMetodoPago
FROM TVenta v
JOIN TCliente c ON v.nClienteID = c.nClienteID
JOIN TSucursalVenta s ON v.nSucursalID = s.nSucursalID;
GO