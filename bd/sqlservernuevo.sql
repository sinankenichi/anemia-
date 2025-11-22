-- =====================================================
-- Script Completo para SQL Server - App de Salud
-- =====================================================
-- Este script contiene:
-- 1. script_completo.sql - Estructura de base de datos
-- 2. datos_usuarios_realistas.sql - Datos de prueba
-- 3. verificar_notificaciones.sql - Consultas de verificación
-- =====================================================
-- Convertido de MySQL a SQL Server
-- Fecha: 2025-01-09
-- Versión: 2.0.0
-- =====================================================

-- =====================================================
-- PARTE 1: ESTRUCTURA DE BASE DE DATOS (script_completo.sql)
-- =====================================================

-- Crear base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'login_db')
BEGIN
    CREATE DATABASE login_db;
END
GO

USE login_db;
GO

-- =====================================================
-- TABLA: usuarios
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'usuarios')
BEGIN
    CREATE TABLE usuarios (
        usu_id INT PRIMARY KEY IDENTITY(1,1),
        usu_nombres VARCHAR(100) NOT NULL,
        usu_apellidos VARCHAR(100) NOT NULL,
        usu_email VARCHAR(255) NOT NULL UNIQUE,
        usu_password VARCHAR(255) NOT NULL,
        fecha_nacimiento DATE NULL,
        tipo_usuario VARCHAR(10) DEFAULT 'usuario' CHECK (tipo_usuario IN ('usuario', 'admin')),
        fecha_registro DATETIME DEFAULT GETDATE(),
        activo BIT DEFAULT 1
    );
    
    CREATE INDEX idx_email ON usuarios(usu_email);
    CREATE INDEX idx_tipo_usuario ON usuarios(tipo_usuario);
    CREATE INDEX idx_fecha_nacimiento ON usuarios(fecha_nacimiento);
END
GO

-- =====================================================
-- TABLA: tokens_recuperacion
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tokens_recuperacion')
BEGIN
    CREATE TABLE tokens_recuperacion (
        token_id INT PRIMARY KEY IDENTITY(1,1),
        usu_email VARCHAR(255) NOT NULL,
        token VARCHAR(255) NOT NULL UNIQUE,
        fecha_creacion DATETIME DEFAULT GETDATE(),
        fecha_expiracion DATETIME NOT NULL,
        usado BIT DEFAULT 0
    );
    
    CREATE INDEX idx_token ON tokens_recuperacion(token);
    CREATE INDEX idx_email ON tokens_recuperacion(usu_email);
    
    ALTER TABLE tokens_recuperacion
    ADD CONSTRAINT FK_tokens_usuarios_email
    FOREIGN KEY (usu_email) REFERENCES usuarios(usu_email) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: cuestionarios
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'cuestionarios')
BEGIN
    CREATE TABLE cuestionarios (
        cuestionario_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        pregunta1 VARCHAR(255) NOT NULL,
        pregunta2 VARCHAR(255) NOT NULL,
        pregunta3 VARCHAR(255) NOT NULL,
        pregunta4 VARCHAR(255) NOT NULL,
        pregunta5 VARCHAR(255) NOT NULL,
        pregunta6 VARCHAR(255) NOT NULL,
        pregunta7 VARCHAR(255) NOT NULL,
        pregunta8 VARCHAR(255) NOT NULL,
        pregunta9 VARCHAR(255) NOT NULL,
        pregunta10 VARCHAR(255) NOT NULL,
        fecha_creacion DATETIME DEFAULT GETDATE()
    );
    
    CREATE INDEX idx_usuario ON cuestionarios(usu_id);
    
    ALTER TABLE cuestionarios
    ADD CONSTRAINT FK_cuestionarios_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: test_conocimiento
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'test_conocimiento')
BEGIN
    CREATE TABLE test_conocimiento (
        test_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        pregunta1 VARCHAR(255) NOT NULL,
        pregunta2 VARCHAR(255) NOT NULL,
        pregunta3 VARCHAR(255) NOT NULL,
        pregunta4 VARCHAR(255) NOT NULL,
        pregunta5 VARCHAR(255) NOT NULL,
        pregunta6 VARCHAR(255) NOT NULL,
        pregunta7 VARCHAR(255) NOT NULL,
        pregunta8 VARCHAR(255) NOT NULL,
        pregunta9 VARCHAR(255) NOT NULL,
        pregunta10 VARCHAR(255) NOT NULL,
        score INT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE()
    );
    
    CREATE INDEX idx_usuario ON test_conocimiento(usu_id);
    CREATE INDEX idx_score ON test_conocimiento(score);
    
    ALTER TABLE test_conocimiento
    ADD CONSTRAINT FK_test_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: encuesta_satisfaccion
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'encuesta_satisfaccion')
BEGIN
    CREATE TABLE encuesta_satisfaccion (
        encuesta_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        pregunta1 VARCHAR(255) NOT NULL,
        pregunta2 VARCHAR(255) NOT NULL,
        pregunta3 VARCHAR(255) NOT NULL,
        pregunta4 VARCHAR(255) NOT NULL,
        pregunta5 VARCHAR(255) NOT NULL,
        pregunta6 VARCHAR(255) NOT NULL,
        pregunta7 VARCHAR(255) NOT NULL,
        pregunta8 VARCHAR(255) NOT NULL,
        pregunta9 VARCHAR(255) NOT NULL,
        pregunta10 VARCHAR(255) NOT NULL,
        score INT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE()
    );
    
    CREATE INDEX idx_usuario ON encuesta_satisfaccion(usu_id);
    CREATE INDEX idx_score ON encuesta_satisfaccion(score);
    
    ALTER TABLE encuesta_satisfaccion
    ADD CONSTRAINT FK_encuesta_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: juego_alimentos
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'juego_alimentos')
BEGIN
    CREATE TABLE juego_alimentos (
        juego_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        respuestas_correctas INT DEFAULT 0,
        total_preguntas INT DEFAULT 10,
        score INT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE()
    );
    
    CREATE INDEX idx_usuario ON juego_alimentos(usu_id);
    CREATE INDEX idx_score ON juego_alimentos(score);
    
    ALTER TABLE juego_alimentos
    ADD CONSTRAINT FK_juego_alimentos_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: juego_combinaciones
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'juego_combinaciones')
BEGIN
    CREATE TABLE juego_combinaciones (
        juego_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        combinaciones_correctas INT DEFAULT 0,
        total_combinaciones INT DEFAULT 8,
        tiempo_segundos INT DEFAULT 0,
        score INT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE()
    );
    
    CREATE INDEX idx_usuario ON juego_combinaciones(usu_id);
    CREATE INDEX idx_score ON juego_combinaciones(score);
    
    ALTER TABLE juego_combinaciones
    ADD CONSTRAINT FK_juego_combinaciones_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: notificaciones
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'notificaciones')
BEGIN
    CREATE TABLE notificaciones (
        notificacion_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        titulo VARCHAR(255) NOT NULL,
        mensaje TEXT NOT NULL,
        tipo VARCHAR(10) DEFAULT 'info' CHECK (tipo IN ('info', 'success', 'warning', 'error', 'system')),
        leida BIT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE(),
        fecha_leida DATETIME NULL
    );
    
    CREATE INDEX idx_usuario ON notificaciones(usu_id);
    CREATE INDEX idx_leida ON notificaciones(leida);
    CREATE INDEX idx_fecha_creacion ON notificaciones(fecha_creacion);
    
    ALTER TABLE notificaciones
    ADD CONSTRAINT FK_notificaciones_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
END
GO

-- =====================================================
-- TABLA: mensajes_soporte
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'mensajes_soporte')
BEGIN
    CREATE TABLE mensajes_soporte (
        mensaje_id INT PRIMARY KEY IDENTITY(1,1),
        usu_id INT NOT NULL,
        admin_id INT NULL,
        mensaje_padre_id INT NULL,
        tipo_mensaje VARCHAR(20) DEFAULT 'consulta' CHECK (tipo_mensaje IN ('consulta', 'experiencia', 'respuesta')),
        asunto VARCHAR(255) NULL,
        mensaje TEXT NOT NULL,
        leido BIT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE(),
        fecha_leido DATETIME NULL
    );
    
    CREATE INDEX idx_usuario ON mensajes_soporte(usu_id);
    CREATE INDEX idx_admin ON mensajes_soporte(admin_id);
    CREATE INDEX idx_mensaje_padre ON mensajes_soporte(mensaje_padre_id);
    CREATE INDEX idx_tipo ON mensajes_soporte(tipo_mensaje);
    CREATE INDEX idx_fecha_creacion ON mensajes_soporte(fecha_creacion);
    
    ALTER TABLE mensajes_soporte
    ADD CONSTRAINT FK_mensajes_usuarios
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE;
    
    ALTER TABLE mensajes_soporte
    ADD CONSTRAINT FK_mensajes_admin
    FOREIGN KEY (admin_id) REFERENCES usuarios(usu_id) ON DELETE NO ACTION;
    
    ALTER TABLE mensajes_soporte
    ADD CONSTRAINT FK_mensajes_padre
    FOREIGN KEY (mensaje_padre_id) REFERENCES mensajes_soporte(mensaje_id) ON DELETE NO ACTION;
END
GO

-- =====================================================
-- TABLA: central_telefonica
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'central_telefonica')
BEGIN
    CREATE TABLE central_telefonica (
        central_id INT PRIMARY KEY IDENTITY(1,1),
        nombre VARCHAR(255) NOT NULL,
        telefono VARCHAR(50) NOT NULL,
        horario_atencion VARCHAR(255) NOT NULL,
        activo BIT DEFAULT 1,
        orden INT DEFAULT 0,
        fecha_creacion DATETIME DEFAULT GETDATE()
    );
    
    CREATE INDEX idx_activo ON central_telefonica(activo);
    CREATE INDEX idx_orden ON central_telefonica(orden);
END
GO

-- =====================================================
-- ACTUALIZACIÓN: Agregar campos si las tablas ya existen
-- =====================================================

-- Agregar tipo_usuario a usuarios si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_SCHEMA = 'dbo' 
               AND TABLE_NAME = 'usuarios' 
               AND COLUMN_NAME = 'tipo_usuario')
BEGIN
    ALTER TABLE usuarios ADD tipo_usuario VARCHAR(10) DEFAULT 'usuario' 
    CHECK (tipo_usuario IN ('usuario', 'admin'));
END
GO

-- Agregar fecha_nacimiento a usuarios si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_SCHEMA = 'dbo' 
               AND TABLE_NAME = 'usuarios' 
               AND COLUMN_NAME = 'fecha_nacimiento')
BEGIN
    ALTER TABLE usuarios ADD fecha_nacimiento DATE NULL;
END
GO

-- Agregar score a test_conocimiento si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_SCHEMA = 'dbo' 
               AND TABLE_NAME = 'test_conocimiento' 
               AND COLUMN_NAME = 'score')
BEGIN
    ALTER TABLE test_conocimiento ADD score INT DEFAULT 0;
END
GO

-- Agregar score a encuesta_satisfaccion si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_SCHEMA = 'dbo' 
               AND TABLE_NAME = 'encuesta_satisfaccion' 
               AND COLUMN_NAME = 'score')
BEGIN
    ALTER TABLE encuesta_satisfaccion ADD score INT DEFAULT 0;
END
GO

-- Insertar datos iniciales de central telefónica
IF NOT EXISTS (SELECT * FROM central_telefonica WHERE nombre = 'Central de Soporte')
BEGIN
    INSERT INTO central_telefonica (nombre, telefono, horario_atencion, orden) VALUES
    ('Central de Soporte', '01-800-123-4567', 'Lunes a Viernes: 8:00 AM - 6:00 PM', 1),
    ('Línea de Emergencias', '0800-987-6543', '24 horas', 2);
END
GO

-- =====================================================
-- PARTE 2: DATOS DE USUARIOS REALISTAS (datos_usuarios_realistas.sql)
-- =====================================================

-- Limpiar datos existentes (eliminar usuarios de prueba)
DELETE FROM juego_combinaciones 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM juego_alimentos 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM encuesta_satisfaccion 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM test_conocimiento 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM cuestionarios 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM mensajes_soporte 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM notificaciones 
WHERE usu_id IN (
    SELECT usu_id FROM usuarios 
    WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')
);

DELETE FROM usuarios 
WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com');
GO

-- =====================================================
-- ADMINISTRADOR
-- =====================================================
IF NOT EXISTS (SELECT * FROM usuarios WHERE usu_email = 'admin@inspirasalud.com')
BEGIN
    INSERT INTO usuarios (usu_nombres, usu_apellidos, usu_email, usu_password, fecha_nacimiento, tipo_usuario, fecha_registro, activo)
    VALUES ('Carlos', 'Rodríguez', 'admin@inspirasalud.com', 'admin123', '1985-03-15', 'admin', DATEADD(DAY, -30, GETDATE()), 1);
END
GO

-- =====================================================
-- 63 USUARIOS ADOLESCENTES (10-16 AÑOS) CON DATOS REALISTAS
-- =====================================================

-- Usuarios de 10-11 años (2014-2013)
IF NOT EXISTS (SELECT * FROM usuarios WHERE usu_email = 'maria.gonzalez2024@gmail.com')
BEGIN
    INSERT INTO usuarios (usu_nombres, usu_apellidos, usu_email, usu_password, fecha_nacimiento, tipo_usuario, fecha_registro, activo) VALUES
    ('María', 'González', 'maria.gonzalez2024@gmail.com', 'maria123', '2014-05-12', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Santiago', 'Martínez', 'santiago.martinez14@hotmail.com', 'santiago123', '2014-08-23', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Valentina', 'López', 'valentina.lopez2014@yahoo.com', 'valentina123', '2013-11-07', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Diego', 'Hernández', 'diego.hernandez13@gmail.com', 'diego123', '2013-02-18', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Sofía', 'Ramírez', 'sofia.ramirez2013@outlook.com', 'sofia123', '2013-09-30', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Mateo', 'Torres', 'mateo.torres12@gmail.com', 'mateo123', '2012-04-15', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Isabella', 'Flores', 'isabella.flores2012@hotmail.com', 'isabella123', '2012-07-22', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Sebastián', 'Rivera', 'sebastian.rivera12@yahoo.com', 'sebastian123', '2012-10-08', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Camila', 'Morales', 'camila.morales2011@gmail.com', 'camila123', '2011-01-25', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Nicolás', 'García', 'nicolas.garcia11@outlook.com', 'nicolas123', '2011-06-14', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Ana', 'Sánchez', 'ana.sanchez2010@gmail.com', 'ana123', '2010-03-19', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Lucas', 'Jiménez', 'lucas.jimenez10@hotmail.com', 'lucas123', '2010-08-05', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Emma', 'Díaz', 'emma.diaz2009@yahoo.com', 'emma123', '2009-12-11', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Daniel', 'Moreno', 'daniel.moreno09@gmail.com', 'daniel123', '2009-05-28', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Lucía', 'Vargas', 'lucia.vargas2009@outlook.com', 'lucia123', '2009-09-16', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Alejandro', 'Castro', 'alejandro.castro09@gmail.com', 'alejandro123', '2009-02-03', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Paula', 'Romero', 'paula.romero2008@hotmail.com', 'paula123', '2008-11-20', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Andrés', 'Mendoza', 'andres.mendoza08@yahoo.com', 'andres123', '2008-07-09', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Fernanda', 'Ortega', 'fernanda.ortega2008@gmail.com', 'fernanda123', '2008-04-27', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Javier', 'Silva', 'javier.silva08@outlook.com', 'javier123', '2008-10-14', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Adriana', 'Fernández', 'adriana.fernandez2024@gmail.com', 'adriana123', '2014-01-18', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Carlos', 'Pérez', 'carlos.perez14@hotmail.com', 'carlos123', '2014-06-29', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Gabriela', 'Ruiz', 'gabriela.ruiz2014@yahoo.com', 'gabriela123', '2013-03-14', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Miguel', 'Álvarez', 'miguel.alvarez13@gmail.com', 'miguel123', '2013-09-25', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Laura', 'Gutiérrez', 'laura.gutierrez2013@outlook.com', 'laura123', '2013-12-08', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Roberto', 'Navarro', 'roberto.navarro12@gmail.com', 'roberto123', '2012-05-22', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Carmen', 'Delgado', 'carmen.delgado2012@hotmail.com', 'carmen123', '2012-08-11', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Fernando', 'Ortiz', 'fernando.ortiz12@yahoo.com', 'fernando123', '2012-11-03', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Patricia', 'Marín', 'patricia.marin2011@gmail.com', 'patricia123', '2011-02-17', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Ricardo', 'Soto', 'ricardo.soto11@outlook.com', 'ricardo123', '2011-07-30', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Monica', 'Vega', 'monica.vega2010@gmail.com', 'monica123', '2010-04-13', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Eduardo', 'Medina', 'eduardo.medina10@hotmail.com', 'eduardo123', '2010-09-26', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Claudia', 'Rojas', 'claudia.rojas2009@yahoo.com', 'claudia123', '2009-01-09', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Gustavo', 'Campos', 'gustavo.campos09@gmail.com', 'gustavo123', '2009-06-21', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Diana', 'Guerrero', 'diana.guerrero2009@outlook.com', 'diana123', '2009-10-04', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Raúl', 'Molina', 'raul.molina09@gmail.com', 'raul123', '2009-03-16', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Verónica', 'Herrera', 'veronica.herrera2008@hotmail.com', 'veronica123', '2008-12-28', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Óscar', 'Ramos', 'oscar.ramos08@yahoo.com', 'oscar123', '2008-08-07', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Natalia', 'Cruz', 'natalia.cruz2008@gmail.com', 'natalia123', '2008-05-19', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Héctor', 'Vásquez', 'hector.vasquez08@outlook.com', 'hector123', '2008-11-02', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Brenda', 'Salinas', 'brenda.salinas2024@gmail.com', 'brenda123', '2014-02-20', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Óscar', 'Contreras', 'oscar.contreras14@hotmail.com', 'oscar123', '2014-07-14', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Yamileth', 'Villanueva', 'yamileth.villanueva2014@yahoo.com', 'yamileth123', '2013-04-08', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Renato', 'Benítez', 'renato.benitez13@gmail.com', 'renato123', '2013-10-22', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Ximena', 'Aguilar', 'ximena.aguilar2013@outlook.com', 'ximena123', '2013-12-30', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Esteban', 'Cordero', 'esteban.cordero12@gmail.com', 'esteban123', '2012-06-11', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Jimena', 'Fuentes', 'jimena.fuentes2012@hotmail.com', 'jimena123', '2012-09-05', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Leonardo', 'Salazar', 'leonardo.salazar12@yahoo.com', 'leonardo123', '2012-11-18', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Regina', 'Paredes', 'regina.paredes2011@gmail.com', 'regina123', '2011-03-27', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Emiliano', 'Valdez', 'emiliano.valdez11@outlook.com', 'emiliano123', '2011-08-13', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Renata', 'Zamora', 'renata.zamora2010@gmail.com', 'renata123', '2010-05-19', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Maximiliano', 'Espinoza', 'maximiliano.espinoza10@hotmail.com', 'maximiliano123', '2010-10-02', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Abril', 'Mejía', 'abril.mejia2009@yahoo.com', 'abril123', '2009-02-15', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Dante', 'Carrillo', 'dante.carrillo09@gmail.com', 'dante123', '2009-07-08', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Zoe', 'Miranda', 'zoe.miranda2009@outlook.com', 'zoe123', '2009-11-25', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Thiago', 'Luna', 'thiago.luna09@gmail.com', 'thiago123', '2009-04-07', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Mía', 'Acosta', 'mia.acosta2008@hotmail.com', 'mia123', '2008-12-15', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Matías', 'Gallegos', 'matias.gallegos08@yahoo.com', 'matias123', '2008-09-03', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Olivia', 'Bustos', 'olivia.bustos2008@gmail.com', 'olivia123', '2008-06-21', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Ian', 'Montoya', 'ian.montoya08@outlook.com', 'ian123', '2008-10-09', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Amanda', 'Ríos', 'amanda.rios2008@gmail.com', 'amanda123', '2008-03-12', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Axel', 'Palacios', 'axel.palacios08@hotmail.com', 'axel123', '2008-08-28', 'usuario', DATEADD(DAY, -2, GETDATE()), 1),
    ('Luna', 'Villalobos', 'luna.villalobos2008@yahoo.com', 'luna123', '2008-01-17', 'usuario', DATEADD(DAY, -2, GETDATE()), 1);
END
GO

-- =====================================================
-- CUESTIONARIOS PARA TODOS LOS USUARIOS
-- =====================================================
INSERT INTO cuestionarios (usu_id, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5, pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Rara vez'
    END,
    CASE ((usu_id + 1) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Nunca'
    END,
    CASE ((usu_id + 2) % 4)
        WHEN 0 THEN 'A veces'
        WHEN 1 THEN 'Rara vez'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Nunca'
    END,
    CASE ((usu_id + 3) % 4)
        WHEN 0 THEN 'No he notado'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Sí, frecuentemente'
        ELSE 'No'
    END,
    CASE ((usu_id + 4) % 4)
        WHEN 0 THEN 'Todos los días'
        WHEN 1 THEN '3-4 veces por semana'
        WHEN 2 THEN '1-2 veces por semana'
        ELSE 'Rara vez'
    END,
    CASE ((usu_id + 5) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Nunca'
    END,
    CASE ((usu_id + 6) % 4)
        WHEN 0 THEN 'A veces'
        WHEN 1 THEN 'Frecuentemente'
        WHEN 2 THEN 'Rara vez'
        ELSE 'Nunca'
    END,
    CASE ((usu_id + 7) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Rara vez'
    END,
    CASE ((usu_id + 8) % 4)
        WHEN 0 THEN 'Sí'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'No he notado'
        ELSE 'No'
    END,
    CASE ((usu_id + 9) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente tengo problemas'
        ELSE 'Rara vez'
    END,
    DATEADD(HOUR, (usu_id % 12), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM cuestionarios WHERE cuestionarios.usu_id = usuarios.usu_id);
GO

-- =====================================================
-- TEST DE CONOCIMIENTO PARA TODOS LOS USUARIOS
-- =====================================================
INSERT INTO test_conocimiento (usu_id, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5, pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, score, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 3)
        WHEN 0 THEN 'Falta de hierro en la sangre'
        WHEN 1 THEN 'Baja cantidad de glóbulos rojos'
        ELSE 'Falta de vitamina C'
    END,
    CASE ((usu_id + 1) % 3)
        WHEN 0 THEN 'Lentejas y espinacas'
        WHEN 1 THEN 'Carne y pescado'
        ELSE 'Frutas cítricas'
    END,
    CASE ((usu_id + 2) % 2)
        WHEN 0 THEN 'Sí'
        ELSE 'No'
    END,
    CASE ((usu_id + 3) % 3)
        WHEN 0 THEN 'Cansancio'
        WHEN 1 THEN 'Palidez'
        ELSE 'Mareos'
    END,
    CASE ((usu_id + 4) % 3)
        WHEN 0 THEN 'Todos los días'
        WHEN 1 THEN '3-4 veces por semana'
        ELSE '1 vez por semana'
    END,
    CASE ((usu_id + 5) % 3)
        WHEN 0 THEN 'Naranja'
        WHEN 1 THEN 'Limón'
        ELSE 'Mandarina'
    END,
    CASE ((usu_id + 6) % 3)
        WHEN 0 THEN 'Transportar oxígeno'
        WHEN 1 THEN 'Fortalecer los huesos'
        ELSE 'Mejorar la vista'
    END,
    CASE ((usu_id + 7) % 2)
        WHEN 0 THEN 'Té o café inmediatamente después'
        WHEN 1 THEN 'Comer frutas'
        ELSE 'Beber agua'
    END,
    CASE ((usu_id + 8) % 3)
        WHEN 0 THEN 'Varias semanas'
        WHEN 1 THEN 'Unos días'
        ELSE 'Un año'
    END,
    CASE ((usu_id + 9) % 2)
        WHEN 0 THEN 'Sí'
        ELSE 'No'
    END,
    CASE 
        WHEN (usu_id % 5) = 0 THEN 45
        WHEN (usu_id % 5) = 1 THEN 38
        WHEN (usu_id % 5) = 2 THEN 32
        WHEN (usu_id % 5) = 3 THEN 28
        ELSE 25
    END,
    DATEADD(HOUR, ((usu_id % 12) + 2), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM test_conocimiento WHERE test_conocimiento.usu_id = usuarios.usu_id);
GO

-- =====================================================
-- ENCUESTA DE SATISFACCIÓN PARA TODOS LOS USUARIOS
-- =====================================================
INSERT INTO encuesta_satisfaccion (usu_id, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5, pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, score, fecha_creacion)
SELECT 
    usu_id,
    CAST(CASE (usu_id % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 1) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 2) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '3'
        ELSE '4'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 3) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 4) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 5) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 6) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 7) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '4'
        WHEN 3 THEN '5'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 8) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END AS VARCHAR(255)),
    CAST(CASE ((usu_id + 9) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '4'
        ELSE '4'
    END AS VARCHAR(255)),
    CASE 
        WHEN (usu_id % 5) = 0 THEN 48
        WHEN (usu_id % 5) = 1 THEN 42
        WHEN (usu_id % 5) = 2 THEN 45
        WHEN (usu_id % 5) = 3 THEN 40
        ELSE 35
    END,
    DATEADD(HOUR, ((usu_id % 12) + 4), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM encuesta_satisfaccion WHERE encuesta_satisfaccion.usu_id = usuarios.usu_id);
GO

-- =====================================================
-- JUEGO ALIMENTOS PARA TODOS LOS USUARIOS
-- =====================================================
INSERT INTO juego_alimentos (usu_id, respuestas_correctas, total_preguntas, score, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 5)
        WHEN 0 THEN 10
        WHEN 1 THEN 9
        WHEN 2 THEN 8
        WHEN 3 THEN 7
        ELSE 6
    END,
    10,
    CASE (usu_id % 5)
        WHEN 0 THEN 100
        WHEN 1 THEN 90
        WHEN 2 THEN 80
        WHEN 3 THEN 70
        ELSE 60
    END,
    DATEADD(HOUR, ((usu_id % 12) + 6), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM juego_alimentos WHERE juego_alimentos.usu_id = usuarios.usu_id);
GO

-- Segunda ronda del juego para algunos usuarios
INSERT INTO juego_alimentos (usu_id, respuestas_correctas, total_preguntas, score, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 5)
        WHEN 0 THEN 10
        WHEN 1 THEN 10
        WHEN 2 THEN 9
        WHEN 3 THEN 8
        ELSE 7
    END,
    10,
    CASE (usu_id % 5)
        WHEN 0 THEN 100
        WHEN 1 THEN 100
        WHEN 2 THEN 90
        WHEN 3 THEN 80
        ELSE 70
    END,
    DATEADD(HOUR, ((usu_id % 12) + 8), DATEADD(DAY, -(usu_id % 2), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1 AND (usu_id % 3) = 0
AND (SELECT COUNT(*) FROM juego_alimentos WHERE juego_alimentos.usu_id = usuarios.usu_id) = 1;
GO

-- =====================================================
-- JUEGO COMBINACIONES PARA TODOS LOS USUARIOS
-- =====================================================
INSERT INTO juego_combinaciones (usu_id, combinaciones_correctas, total_combinaciones, tiempo_segundos, score, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 4)
        WHEN 0 THEN 8
        WHEN 1 THEN 7
        WHEN 2 THEN 6
        ELSE 5
    END,
    8,
    CASE (usu_id % 4)
        WHEN 0 THEN 45 + (usu_id % 15)
        WHEN 1 THEN 60 + (usu_id % 20)
        WHEN 2 THEN 80 + (usu_id % 25)
        ELSE 100 + (usu_id % 20)
    END,
    CASE (usu_id % 4)
        WHEN 0 THEN 850 + (100 - (usu_id % 15))
        WHEN 1 THEN 750 + (80 - (usu_id % 20))
        WHEN 2 THEN 650 + (60 - (usu_id % 25))
        ELSE 550 + (40 - (usu_id % 20))
    END,
    DATEADD(HOUR, ((usu_id % 12) + 10), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM juego_combinaciones WHERE juego_combinaciones.usu_id = usuarios.usu_id);
GO

-- Segunda ronda del juego de combinaciones
INSERT INTO juego_combinaciones (usu_id, combinaciones_correctas, total_combinaciones, tiempo_segundos, score, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 4)
        WHEN 0 THEN 8
        WHEN 1 THEN 8
        WHEN 2 THEN 7
        ELSE 6
    END,
    8,
    CASE (usu_id % 4)
        WHEN 0 THEN 40 + (usu_id % 10)
        WHEN 1 THEN 50 + (usu_id % 15)
        WHEN 2 THEN 65 + (usu_id % 20)
        ELSE 85 + (usu_id % 15)
    END,
    CASE (usu_id % 4)
        WHEN 0 THEN 900 + (120 - (usu_id % 10))
        WHEN 1 THEN 850 + (100 - (usu_id % 15))
        WHEN 2 THEN 750 + (80 - (usu_id % 20))
        ELSE 650 + (60 - (usu_id % 15))
    END,
    DATEADD(HOUR, ((usu_id % 12) + 12), DATEADD(DAY, -(usu_id % 2), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1 AND (usu_id % 3) = 0
AND (SELECT COUNT(*) FROM juego_combinaciones WHERE juego_combinaciones.usu_id = usuarios.usu_id) = 1;
GO

-- =====================================================
-- NOTIFICACIONES PARA TODOS LOS USUARIOS
-- =====================================================
-- Notificaciones para usuarios regulares
INSERT INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    '¡Bienvenido a Inspira Salud!',
    'Gracias por unirte a nuestra comunidad. Aquí encontrarás información valiosa sobre salud y nutrición.',
    'success',
    CASE (usu_id % 3) WHEN 0 THEN 1 ELSE 0 END,
    DATEADD(HOUR, (usu_id % 12), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM notificaciones WHERE notificaciones.usu_id = usuarios.usu_id AND notificaciones.titulo = '¡Bienvenido a Inspira Salud!');
GO

-- Notificaciones para el administrador
DECLARE @admin_id INT;
SELECT @admin_id = usu_id FROM usuarios WHERE tipo_usuario = 'admin';

IF @admin_id IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM notificaciones WHERE usu_id = @admin_id AND titulo = 'Panel de Administración')
    BEGIN
        INSERT INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
        VALUES (@admin_id, 'Panel de Administración', 
                'Bienvenido al panel de administración. Puedes gestionar usuarios, ver estadísticas y responder mensajes de soporte.',
                'system', 0, DATEADD(HOUR, 8, DATEADD(DAY, -1, GETDATE())));
    END
    
    IF NOT EXISTS (SELECT 1 FROM notificaciones WHERE usu_id = @admin_id AND titulo = 'Nuevos mensajes de soporte')
    BEGIN
        INSERT INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
        VALUES (@admin_id, 'Nuevos mensajes de soporte',
                'Tienes nuevos mensajes de soporte de usuarios esperando respuesta. Revisa la sección de Ayuda.',
                'info', 0, DATEADD(HOUR, 10, DATEADD(DAY, -1, GETDATE())));
    END
END
GO

-- Notificaciones adicionales para usuarios
INSERT INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 4)
        WHEN 0 THEN 'Nuevo contenido disponible'
        WHEN 1 THEN 'Recordatorio: Completa tus evaluaciones'
        WHEN 2 THEN '¡Felicitaciones por tu progreso!'
        ELSE 'Consejo del día: Alimentación saludable'
    END,
    CASE (usu_id % 4)
        WHEN 0 THEN 'Hemos agregado nuevos videos educativos en la sección "Aprende". ¡Échales un vistazo!'
        WHEN 1 THEN 'No olvides completar tus cuestionarios y tests para mantener un seguimiento de tu salud.'
        WHEN 2 THEN 'Has completado varios juegos educativos. ¡Sigue así y aprende más sobre nutrición!'
        ELSE 'Recuerda incluir alimentos ricos en hierro y vitamina C en tu dieta diaria.'
    END,
    CASE (usu_id % 4)
        WHEN 0 THEN 'info'
        WHEN 1 THEN 'warning'
        WHEN 2 THEN 'success'
        ELSE 'info'
    END,
    CASE (usu_id % 5) WHEN 0 THEN 1 ELSE 0 END,
    DATEADD(HOUR, ((usu_id % 12) + 3), DATEADD(DAY, -(usu_id % 2), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;
GO

-- =====================================================
-- MENSAJES DE SOPORTE PARA TODOS LOS USUARIOS
-- =====================================================

-- Mensajes de Chat de Soporte (consulta)
INSERT INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
SELECT 
    usu_id,
    NULL,
    NULL,
    'consulta',
    CASE (usu_id % 5)
        WHEN 0 THEN '¿Cómo puedo mejorar mi puntuación en los juegos?'
        WHEN 1 THEN 'No entiendo cómo usar la sección de evaluaciones'
        WHEN 2 THEN '¿Puedo cambiar mi información personal?'
        WHEN 3 THEN 'Tengo dudas sobre los alimentos ricos en hierro'
        ELSE '¿Cómo funciona el sistema de notificaciones?'
    END,
    CASE (usu_id % 5)
        WHEN 0 THEN 'Hola, he estado jugando los juegos educativos pero mi puntuación no es muy alta. ¿Tienen algún consejo para mejorar? Me gustaría aprender más sobre los alimentos.' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Gracias de antemano.'
        WHEN 1 THEN 'Buenos días, soy nuevo en la aplicación y me gustaría saber cómo puedo completar las evaluaciones correctamente. ¿Hay alguna guía disponible?'
        WHEN 2 THEN 'Hola, necesito actualizar mi fecha de nacimiento porque la ingresé incorrectamente. ¿Cómo puedo hacerlo?'
        WHEN 3 THEN 'Tengo una pregunta sobre la alimentación. ¿Qué alimentos son los mejores para prevenir la anemia? Me gustaría saber más detalles.'
        ELSE 'Hola, recibí algunas notificaciones pero no estoy seguro de cómo funcionan. ¿Pueden explicarme cómo gestionarlas?'
    END,
    CASE (usu_id % 3) WHEN 0 THEN 1 ELSE 0 END,
    DATEADD(HOUR, ((usu_id % 12) + 2), DATEADD(DAY, -(1 + (usu_id % 2)), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM mensajes_soporte WHERE mensajes_soporte.usu_id = usuarios.usu_id AND mensajes_soporte.tipo_mensaje = 'consulta' AND mensajes_soporte.mensaje_padre_id IS NULL);
GO

-- Respuestas del administrador a algunos mensajes de consulta
DECLARE @admin_id_msg INT;
SELECT @admin_id_msg = usu_id FROM usuarios WHERE tipo_usuario = 'admin';

IF @admin_id_msg IS NOT NULL
BEGIN
    INSERT INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
    SELECT 
        ms.usu_id,
        @admin_id_msg,
        ms.mensaje_id,
        'respuesta',
        'Re: ' + ms.asunto,
        CASE (ms.usu_id % 5)
            WHEN 0 THEN 'Hola, gracias por tu consulta. Para mejorar tu puntuación te recomiendo practicar más con los juegos y revisar la sección "Aprende" donde encontrarás información valiosa sobre nutrición. ¡Sigue practicando!'
            WHEN 1 THEN 'Hola, bienvenido a la aplicación. Las evaluaciones son muy sencillas, solo debes responder las preguntas con honestidad. Puedes encontrarlas en la sección "Evalúa" del menú principal. ¡Éxitos!'
            WHEN 2 THEN 'Hola, puedes actualizar tu información personal desde la sección "Ajustes" > "Perfil". Si tienes algún problema, no dudes en contactarnos nuevamente.'
            WHEN 3 THEN 'Excelente pregunta. Los alimentos ricos en hierro incluyen carnes rojas, legumbres como lentejas, espinacas y frutos secos. Recuerda combinarlos con vitamina C para una mejor absorción. Revisa la sección "Aprende" para más información.'
            ELSE 'Hola, las notificaciones te mantienen informado sobre actualizaciones y recordatorios importantes. Puedes gestionarlas desde el icono de campana en la parte superior. ¡Esperamos que te sean útiles!'
        END,
        0,
        DATEADD(HOUR, ((ms.usu_id % 12) + 4), DATEADD(DAY, -(ms.usu_id % 2), GETDATE()))
    FROM mensajes_soporte ms
    WHERE ms.tipo_mensaje = 'consulta' AND ms.mensaje_padre_id IS NULL
    AND (ms.usu_id % 2) = 0
    AND NOT EXISTS (SELECT 1 FROM mensajes_soporte WHERE mensaje_padre_id = ms.mensaje_id);
END
GO

-- Mensajes de Comparte tu Experiencia
INSERT INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
SELECT 
    usu_id,
    NULL,
    NULL,
    'experiencia',
    NULL,
    CASE (usu_id % 6)
        WHEN 0 THEN '¡Hola! Quería compartirles que la aplicación me ha ayudado mucho a aprender sobre nutrición. Los juegos son muy divertidos y he mejorado mi conocimiento sobre alimentos ricos en hierro. ¡Gracias por esta herramienta tan útil!'
        WHEN 1 THEN 'Buenos días, llevo usando la app unos días y me encanta. Los videos educativos son muy claros y fáciles de entender. He aprendido cosas que no sabía sobre la anemia y cómo prevenirla. ¡Sigan así!'
        WHEN 2 THEN 'Quería decirles que la aplicación es excelente. Me gusta mucho la sección de juegos porque aprendo mientras me divierto. Mi familia también está interesada en usar la app. ¡Felicitaciones por el trabajo!'
        WHEN 3 THEN 'Hola, he estado usando la aplicación y me parece muy completa. Los cuestionarios me ayudan a entender mejor mi salud. Solo tengo una sugerencia: sería genial tener más juegos. ¡Gracias por todo!'
        WHEN 4 THEN '¡Excelente aplicación! Los consejos que dan son muy útiles y fáciles de seguir. He compartido la app con mis amigos porque creo que todos deberían conocer esta información. ¡Sigan con el buen trabajo!'
        ELSE 'Quería compartir mi experiencia positiva con la aplicación. Los tests de conocimiento son desafiantes pero educativos. He mejorado mucho mi comprensión sobre nutrición y salud. ¡Muy recomendada!'
    END,
    CASE (usu_id % 4) WHEN 0 THEN 1 ELSE 0 END,
    DATEADD(HOUR, ((usu_id % 12) + 5), DATEADD(DAY, -(usu_id % 2), GETDATE()))
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1
AND NOT EXISTS (SELECT 1 FROM mensajes_soporte WHERE mensajes_soporte.usu_id = usuarios.usu_id AND mensajes_soporte.tipo_mensaje = 'experiencia' AND mensajes_soporte.mensaje_padre_id IS NULL);
GO

-- =====================================================
-- PARTE 3: VERIFICACIÓN DE NOTIFICACIONES (verificar_notificaciones.sql)
-- =====================================================

-- Verificar total de notificaciones
PRINT '=== VERIFICACIÓN DE NOTIFICACIONES ===';
SELECT 'Total notificaciones:' AS Tipo, COUNT(*) AS Cantidad FROM notificaciones;

-- Verificar notificaciones por tipo de usuario
PRINT '=== NOTIFICACIONES POR TIPO DE USUARIO ===';
SELECT 
    u.tipo_usuario,
    COUNT(n.notificacion_id) AS total_notificaciones,
    SUM(CASE WHEN n.leida = 0 THEN 1 ELSE 0 END) AS no_leidas
FROM usuarios u
LEFT JOIN notificaciones n ON u.usu_id = n.usu_id
GROUP BY u.tipo_usuario;

-- Verificar notificaciones del administrador
PRINT '=== NOTIFICACIONES DEL ADMINISTRADOR ===';
SELECT 
    n.notificacion_id,
    n.titulo,
    n.tipo,
    n.leida,
    n.fecha_creacion,
    u.usu_email
FROM notificaciones n
INNER JOIN usuarios u ON n.usu_id = u.usu_id
WHERE u.tipo_usuario = 'admin'
ORDER BY n.fecha_creacion DESC;

-- Verificar notificaciones de usuarios regulares (primeros 10)
PRINT '=== NOTIFICACIONES DE USUARIOS REGULARES (PRIMEROS 10) ===';
SELECT TOP 10
    n.notificacion_id,
    n.titulo,
    n.tipo,
    n.leida,
    n.fecha_creacion,
    u.usu_email,
    u.usu_nombres,
    u.usu_apellidos
FROM notificaciones n
INNER JOIN usuarios u ON n.usu_id = u.usu_id
WHERE u.tipo_usuario = 'usuario'
ORDER BY n.fecha_creacion DESC;

-- Verificar usuarios sin notificaciones
PRINT '=== USUARIOS SIN NOTIFICACIONES ===';
SELECT 
    u.usu_id,
    u.usu_email,
    u.usu_nombres,
    u.usu_apellidos,
    u.tipo_usuario
FROM usuarios u
LEFT JOIN notificaciones n ON u.usu_id = n.usu_id
WHERE n.notificacion_id IS NULL
ORDER BY u.tipo_usuario, u.usu_id;

-- =====================================================
-- RESUMEN FINAL
-- =====================================================
PRINT '=== RESUMEN DE DATOS INSERTADOS ===';
SELECT 'Total usuarios:' AS Tipo, COUNT(*) AS Cantidad FROM usuarios WHERE tipo_usuario = 'usuario';
SELECT 'Total administradores:' AS Tipo, COUNT(*) AS Cantidad FROM usuarios WHERE tipo_usuario = 'admin';
SELECT 'Total cuestionarios:' AS Tipo, COUNT(*) AS Cantidad FROM cuestionarios;
SELECT 'Total tests de conocimiento:' AS Tipo, COUNT(*) AS Cantidad FROM test_conocimiento;
SELECT 'Total encuestas de satisfacción:' AS Tipo, COUNT(*) AS Cantidad FROM encuesta_satisfaccion;
SELECT 'Total juegos de alimentos:' AS Tipo, COUNT(*) AS Cantidad FROM juego_alimentos;
SELECT 'Total juegos de combinaciones:' AS Tipo, COUNT(*) AS Cantidad FROM juego_combinaciones;
SELECT 'Total notificaciones:' AS Tipo, COUNT(*) AS Cantidad FROM notificaciones;
SELECT 'Total mensajes de soporte:' AS Tipo, COUNT(*) AS Cantidad FROM mensajes_soporte;

-- =====================================================
-- NOTAS IMPORTANTES
-- =====================================================
-- 1. Este script está completamente convertido a SQL Server
-- 2. Todas las funciones de MySQL han sido reemplazadas por equivalentes de SQL Server:
--    - AUTO_INCREMENT -> IDENTITY(1,1)
--    - TINYINT(1) -> BIT
--    - ENUM -> VARCHAR con CHECK constraint
--    - NOW() -> GETDATE()
--    - DATE_SUB(NOW(), INTERVAL X DAY) -> DATEADD(DAY, -X, GETDATE())
--    - TIMESTAMPDIFF -> DATEDIFF
--    - INSERT IGNORE -> IF NOT EXISTS o verificaciones
--    - LIMIT -> TOP
-- 3. El script es idempotente: se puede ejecutar múltiples veces sin causar errores
-- 4. Todos los usuarios tienen contraseña: [nombre]123 (ej: maria123, santiago123)
-- =====================================================

