-- Crear la base de datos
CREATE DATABASE Parcial2Nattp;
GO

-- Crear el login si no existe
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'usrparcial2')
BEGIN
    CREATE LOGIN [usrparcial2] WITH PASSWORD = N'12345678',
        DEFAULT_DATABASE = [Parcial2Nattp],
        CHECK_EXPIRATION = OFF,
        CHECK_POLICY = ON;
END
GO

USE [Parcial2Nattp];
GO

-- Crear el usuario en la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usrparcial2')
BEGIN
    CREATE USER [usrparcial2] FOR LOGIN [usrparcial2];
END
GO

-- Agregar el usuario al rol db_owner si no está ya en él
IF NOT EXISTS (
    SELECT * FROM sys.database_role_members AS drm
    JOIN sys.database_principals AS dp ON drm.member_principal_id = dp.principal_id
    WHERE dp.name = 'usrparcial2' AND drm.role_principal_id = DATABASE_PRINCIPAL_ID('db_owner')
)
BEGIN
    ALTER ROLE [db_owner] ADD MEMBER [usrparcial2];
END
GO

-- Verificar y eliminar la tabla Serie si ya existe
IF OBJECT_ID('Serie', 'U') IS NOT NULL
    DROP TABLE Serie;
GO

-- Crear la tabla Serie
CREATE TABLE Serie (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo VARCHAR(250) NOT NULL,
    sinopsis VARCHAR(5000),
    director VARCHAR(100),
    episodios INT,
    fechaEstreno DATE,
    estado SMALLINT
);
GO

-- Verificar y eliminar el procedimiento paSerieListar si ya existe
IF OBJECT_ID('paSerieListar', 'P') IS NOT NULL
    DROP PROCEDURE paSerieListar;
GO

-- Crear el procedimiento paSerieListar
CREATE PROCEDURE paSerieListar @parametro NVARCHAR(100)
AS
BEGIN
    SELECT * FROM Serie
    WHERE estado <> -1 AND titulo LIKE '%' + REPLACE(@parametro, ' ', '%') + '%'
    ORDER BY titulo;
END;
GO

-- Ejecutar el procedimiento almacenado con un parámetro de prueba
EXEC paSerieListar 'El Hoyo';
GO

-- Insertar datos en la tabla Serie
INSERT INTO Serie (titulo, sinopsis, director, episodios, fechaEstreno, estado)
VALUES ('El Hoyo', 'Los prisioneros se alimentan desde una plataforma que desciende por un agujero, enfrentándose a la lucha por la supervivencia y la desesperación.', 'Galder Gaztelu-Urrutia', 1, '2019-11-08', 1);
GO

-- Consultar todos los datos de la tabla Serie donde el estado no sea -1
SELECT * FROM Serie WHERE estado <> -1;
GO
