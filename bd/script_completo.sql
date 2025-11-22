-- =====================================================
-- Script Completo de Base de Datos para App de Salud
-- =====================================================
-- Este script crea TODAS las tablas necesarias para:
-- - Registro y Login de usuarios
-- - Recuperación de contraseña
-- - Cuestionarios de anemia vinculados a usuarios
-- - Test de Conocimiento y Prácticas sobre Anemia (con score)
-- - Encuesta de Satisfacción (con score)
-- =====================================================
-- Fecha: 2025-11-09
-- Versión: 2.0.0 (Incluye campos de score)
-- =====================================================

-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS login_db;
USE login_db;

-- =====================================================
-- TABLA: usuarios
-- =====================================================
-- Almacena información de usuarios (pacientes y administradores)
CREATE TABLE IF NOT EXISTS usuarios (
    usu_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_nombres VARCHAR(100) NOT NULL,
    usu_apellidos VARCHAR(100) NOT NULL,
    usu_email VARCHAR(255) NOT NULL UNIQUE,
    usu_password VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE COMMENT 'Fecha de nacimiento del usuario',
    tipo_usuario ENUM('usuario', 'admin') DEFAULT 'usuario' COMMENT 'Tipo de usuario: usuario normal o administrador',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo TINYINT(1) DEFAULT 1,
    INDEX idx_email (usu_email),
    INDEX idx_tipo_usuario (tipo_usuario),
    INDEX idx_fecha_nacimiento (fecha_nacimiento)
);

-- =====================================================
-- TABLA: tokens_recuperacion
-- =====================================================
-- Almacena tokens para recuperación de contraseña
CREATE TABLE IF NOT EXISTS tokens_recuperacion (
    token_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion DATETIME NOT NULL,
    usado TINYINT(1) DEFAULT 0,
    INDEX idx_token (token),
    INDEX idx_email (usu_email),
    FOREIGN KEY (usu_email) REFERENCES usuarios(usu_email) ON DELETE CASCADE
);

-- =====================================================
-- TABLA: cuestionarios
-- =====================================================
-- Almacena las respuestas del cuestionario de anemia
CREATE TABLE IF NOT EXISTS cuestionarios (
    cuestionario_id INT PRIMARY KEY AUTO_INCREMENT,
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
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id)
);

-- =====================================================
-- TABLA: test_conocimiento
-- =====================================================
-- Almacena las respuestas del Test de Conocimiento y Prácticas sobre Anemia
-- Incluye campo score para almacenar la puntuación total
CREATE TABLE IF NOT EXISTS test_conocimiento (
    test_id INT PRIMARY KEY AUTO_INCREMENT,
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
    score INT DEFAULT 0 COMMENT 'Puntuación total calculada automáticamente',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id),
    INDEX idx_score (score)
);

-- =====================================================
-- TABLA: encuesta_satisfaccion
-- =====================================================
-- Almacena las respuestas de la Encuesta de Satisfacción
-- Incluye campo score para almacenar la puntuación total
CREATE TABLE IF NOT EXISTS encuesta_satisfaccion (
    encuesta_id INT PRIMARY KEY AUTO_INCREMENT,
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
    score INT DEFAULT 0 COMMENT 'Puntuación total calculada automáticamente',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id),
    INDEX idx_score (score)
);

-- =====================================================
-- TABLA: juego_alimentos
-- =====================================================
-- Almacena los resultados del juego "¿Qué alimento es?"
-- Juego didáctico sobre identificación de alimentos ricos en hierro y vitamina C
CREATE TABLE IF NOT EXISTS juego_alimentos (
    juego_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL,
    respuestas_correctas INT DEFAULT 0 COMMENT 'Número de respuestas correctas',
    total_preguntas INT DEFAULT 10 COMMENT 'Total de preguntas del juego',
    score INT DEFAULT 0 COMMENT 'Puntuación total (respuestas_correctas * 10)',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id),
    INDEX idx_score (score)
);

-- =====================================================
-- TABLA: juego_combinaciones
-- =====================================================
-- Almacena los resultados del juego "Combina y Gana"
-- Juego didáctico de memoria para asociar alimentos con vitamina C
CREATE TABLE IF NOT EXISTS juego_combinaciones (
    juego_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL,
    combinaciones_correctas INT DEFAULT 0 COMMENT 'Número de combinaciones correctas',
    total_combinaciones INT DEFAULT 8 COMMENT 'Total de combinaciones del juego',
    tiempo_segundos INT DEFAULT 0 COMMENT 'Tiempo en segundos para completar el juego',
    score INT DEFAULT 0 COMMENT 'Puntuación total basada en combinaciones y tiempo',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id),
    INDEX idx_score (score)
);

-- =====================================================
-- TABLA: notificaciones
-- =====================================================
-- Almacena las notificaciones de usuarios y administradores
CREATE TABLE IF NOT EXISTS notificaciones (
    notificacion_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL,
    titulo VARCHAR(255) NOT NULL COMMENT 'Título de la notificación',
    mensaje TEXT NOT NULL COMMENT 'Mensaje de la notificación',
    tipo ENUM('info', 'success', 'warning', 'error', 'system') DEFAULT 'info' COMMENT 'Tipo de notificación',
    leida TINYINT(1) DEFAULT 0 COMMENT 'Indica si la notificación ha sido leída',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación de la notificación',
    fecha_leida DATETIME NULL COMMENT 'Fecha en que se marcó como leída',
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id),
    INDEX idx_leida (leida),
    INDEX idx_fecha_creacion (fecha_creacion)
);

-- =====================================================
-- DATOS DE PRUEBA: Notificaciones de ejemplo
-- =====================================================
-- Insertar notificaciones de prueba para usuarios existentes
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida)
SELECT 
    usu_id,
    'Bienvenido a la aplicación',
    'Gracias por registrarte. ¡Esperamos que disfrutes de todas las funcionalidades!',
    'success',
    0
FROM usuarios
WHERE tipo_usuario = 'usuario'
LIMIT 3;

INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida)
SELECT 
    usu_id,
    'Recordatorio importante',
    'No olvides completar tus evaluaciones diarias para mantener un seguimiento de tu salud.',
    'info',
    0
FROM usuarios
WHERE tipo_usuario = 'usuario'
LIMIT 3;

INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida)
SELECT 
    usu_id,
    'Nuevas funcionalidades disponibles',
    'Hemos agregado nuevas funciones a la aplicación. ¡Explóralas en el menú principal!',
    'system',
    0
FROM usuarios
WHERE tipo_usuario = 'admin'
LIMIT 1;

-- =====================================================
-- ACTUALIZACIÓN: Agregar campos si las tablas ya existen
-- =====================================================
-- Esto es para bases de datos que ya tienen las tablas sin estos campos
-- Si las tablas no existen, se crearán con los campos incluidos arriba

-- Agregar tipo_usuario a usuarios si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'usuarios' 
    AND COLUMN_NAME = 'tipo_usuario'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE usuarios ADD COLUMN tipo_usuario ENUM(''usuario'', ''admin'') DEFAULT ''usuario'' COMMENT ''Tipo de usuario: usuario normal o administrador'' AFTER usu_password',
    'SELECT ''Campo tipo_usuario ya existe en usuarios'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar fecha_nacimiento a usuarios si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'usuarios' 
    AND COLUMN_NAME = 'fecha_nacimiento'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE usuarios ADD COLUMN fecha_nacimiento DATE COMMENT ''Fecha de nacimiento del usuario'' AFTER usu_password',
    'SELECT ''Campo fecha_nacimiento ya existe en usuarios'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar score a test_conocimiento si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'test_conocimiento' 
    AND COLUMN_NAME = 'score'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE test_conocimiento ADD COLUMN score INT DEFAULT 0 COMMENT ''Puntuación total calculada automáticamente'' AFTER pregunta10',
    'SELECT ''Campo score ya existe en test_conocimiento'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar score a encuesta_satisfaccion si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'encuesta_satisfaccion' 
    AND COLUMN_NAME = 'score'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE encuesta_satisfaccion ADD COLUMN score INT DEFAULT 0 COMMENT ''Puntuación total calculada automáticamente'' AFTER pregunta10',
    'SELECT ''Campo score ya existe en encuesta_satisfaccion'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =====================================================
-- TABLA: mensajes_soporte
-- =====================================================
-- Almacena mensajes entre usuarios y administradores para soporte
CREATE TABLE IF NOT EXISTS mensajes_soporte (
    mensaje_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL COMMENT 'ID del usuario que envía el mensaje',
    admin_id INT NULL COMMENT 'ID del administrador que responde (NULL si es mensaje inicial)',
    mensaje_padre_id INT NULL COMMENT 'ID del mensaje al que responde (NULL si es mensaje inicial)',
    tipo_mensaje ENUM('consulta', 'experiencia', 'respuesta') DEFAULT 'consulta' COMMENT 'Tipo de mensaje',
    asunto VARCHAR(255) NULL COMMENT 'Asunto del mensaje',
    mensaje TEXT NOT NULL COMMENT 'Contenido del mensaje',
    leido TINYINT(1) DEFAULT 0 COMMENT 'Indica si el mensaje ha sido leído',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_leido DATETIME NULL,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES usuarios(usu_id) ON DELETE SET NULL,
    FOREIGN KEY (mensaje_padre_id) REFERENCES mensajes_soporte(mensaje_id) ON DELETE CASCADE,
    INDEX idx_usuario (usu_id),
    INDEX idx_admin (admin_id),
    INDEX idx_mensaje_padre (mensaje_padre_id),
    INDEX idx_tipo (tipo_mensaje),
    INDEX idx_fecha_creacion (fecha_creacion)
);

-- =====================================================
-- TABLA: central_telefonica
-- =====================================================
-- Almacena información de la central telefónica
CREATE TABLE IF NOT EXISTS central_telefonica (
    central_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la central o servicio',
    telefono VARCHAR(50) NOT NULL COMMENT 'Número de teléfono',
    horario_atencion VARCHAR(255) NOT NULL COMMENT 'Horario de atención (ej: Lunes a Viernes 8:00 - 18:00)',
    activo TINYINT(1) DEFAULT 1,
    orden INT DEFAULT 0 COMMENT 'Orden de visualización',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_activo (activo),
    INDEX idx_orden (orden)
);

-- Insertar datos iniciales de central telefónica (solo 2 números)
INSERT IGNORE INTO central_telefonica (nombre, telefono, horario_atencion, orden) VALUES
('Central de Soporte', '01-800-123-4567', 'Lunes a Viernes: 8:00 AM - 6:00 PM', 1),
('Línea de Emergencias', '0800-987-6543', '24 horas', 2);

-- =====================================================
-- DATOS DE PRUEBA (OPCIONAL)
-- =====================================================
-- NOTA: Los usuarios de prueba y administrador ahora se crean en datos_usuarios_realistas.sql
-- Este script solo crea la estructura de las tablas

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
-- Verificar que las tablas se crearon correctamente
SELECT 'Tabla usuarios:' as Tabla, COUNT(*) as Registros FROM usuarios;
SELECT 'Tabla tokens_recuperacion:' as Tabla, COUNT(*) as Registros FROM tokens_recuperacion;
SELECT 'Tabla cuestionarios:' as Tabla, COUNT(*) as Registros FROM cuestionarios;
SELECT 'Tabla test_conocimiento:' as Tabla, COUNT(*) as Registros FROM test_conocimiento;
SELECT 'Tabla encuesta_satisfaccion:' as Tabla, COUNT(*) as Registros FROM encuesta_satisfaccion;
SELECT 'Tabla juego_alimentos:' as Tabla, COUNT(*) as Registros FROM juego_alimentos;
SELECT 'Tabla juego_combinaciones:' as Tabla, COUNT(*) as Registros FROM juego_combinaciones;
SELECT 'Tabla notificaciones:' as Tabla, COUNT(*) as Registros FROM notificaciones;
SELECT 'Tabla mensajes_soporte:' as Tabla, COUNT(*) as Registros FROM mensajes_soporte;
SELECT 'Tabla central_telefonica:' as Tabla, COUNT(*) as Registros FROM central_telefonica;

-- Verificar estructura de tablas con scores
DESCRIBE test_conocimiento;
DESCRIBE encuesta_satisfaccion;

-- Mostrar usuarios de prueba
SELECT * FROM usuarios;

-- =====================================================
-- NOTAS IMPORTANTES
-- =====================================================
-- 1. El campo 'score' se calcula automáticamente por la API cuando se envían las encuestas
-- 2. Los scores se basan en las respuestas: valores numéricos (1-5) o texto convertido a puntos
-- 3. Para bases de datos existentes, el script detecta si el campo score existe antes de agregarlo
-- 4. Este script es idempotente: se puede ejecutar múltiples veces sin causar errores
-- =====================================================
