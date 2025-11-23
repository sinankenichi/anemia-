-- =====================================================
-- Script de Mejoras Importantes de Base de Datos
-- =====================================================
-- Este script implementa mejoras importantes:
-- 1. Índices full-text para búsquedas
-- 2. Procedimientos almacenados
-- 3. Índices adicionales para campos de fecha
-- 4. Tabla de configuración del sistema
-- =====================================================
-- Fecha: 2025-01-27
-- Versión: 1.0.0
-- =====================================================

USE login_db;

-- =====================================================
-- PARTE 1: ÍNDICES FULL-TEXT PARA BÚSQUEDAS
-- =====================================================

-- Índice full-text para búsqueda en usuarios (nombres, apellidos, email)
-- Nota: Solo funciona con tablas MyISAM o InnoDB con FULLTEXT habilitado
-- Si la tabla es InnoDB, verificar que el motor soporte FULLTEXT (MySQL 5.6+)

-- Verificar si el motor soporta FULLTEXT
SET @engine = (
    SELECT ENGINE 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'usuarios'
);

-- Si es InnoDB y MySQL >= 5.6, crear índice full-text
SET @mysql_version = (
    SELECT VERSION()
);

-- Crear índice full-text si es posible
SET @sql = CONCAT(
    'ALTER TABLE usuarios ADD FULLTEXT INDEX idx_fulltext_busqueda (usu_nombres, usu_apellidos, usu_email)'
);

-- Intentar crear (puede fallar si no está soportado)
SET @error = NULL;
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =====================================================
-- PARTE 2: ÍNDICES ADICIONALES PARA CAMPOS DE FECHA
-- =====================================================

-- Índices para consultas por rango de fechas
CREATE INDEX IF NOT EXISTS idx_cuestionarios_fecha ON cuestionarios(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_test_fecha ON test_conocimiento(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_encuesta_fecha ON encuesta_satisfaccion(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_juego_alimentos_fecha ON juego_alimentos(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_juego_combinaciones_fecha ON juego_combinaciones(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_notificaciones_fecha ON notificaciones(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_mensajes_soporte_fecha ON mensajes_soporte(fecha_creacion DESC);
CREATE INDEX IF NOT EXISTS idx_auditoria_fecha ON auditoria(timestamp DESC);

-- =====================================================
-- PARTE 3: TABLA DE CONFIGURACIÓN DEL SISTEMA
-- =====================================================

CREATE TABLE IF NOT EXISTS configuracion_sistema (
    config_id INT PRIMARY KEY AUTO_INCREMENT,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT,
    tipo VARCHAR(50) DEFAULT 'string' COMMENT 'string, number, boolean, json',
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_clave (clave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Datos iniciales de configuración
INSERT INTO configuracion_sistema (clave, valor, tipo, descripcion) VALUES
('version_app', '1.0.0', 'string', 'Versión actual de la aplicación'),
('mantenimiento_activo', 'false', 'boolean', 'Indica si el sistema está en mantenimiento'),
('limite_intentos_login', '5', 'number', 'Número máximo de intentos de login permitidos'),
('tiempo_expiracion_token', '24', 'number', 'Horas de expiración del token JWT'),
('rate_limit_login', '5', 'number', 'Número máximo de intentos de login por ventana de tiempo'),
('rate_limit_window_ms', '900000', 'number', 'Ventana de tiempo para rate limiting en milisegundos (15 minutos)'),
('backup_automatico', 'true', 'boolean', 'Indica si los backups automáticos están activos'),
('retention_days', '30', 'number', 'Días de retención de backups'),
('email_notificaciones', 'true', 'boolean', 'Indica si se envían notificaciones por email')
ON DUPLICATE KEY UPDATE 
    valor = VALUES(valor),
    descripcion = VALUES(descripcion);

-- =====================================================
-- PARTE 4: PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- Procedimiento para obtener estadísticas de usuario
DROP PROCEDURE IF EXISTS obtener_estadisticas_usuario;
DELIMITER //
CREATE PROCEDURE obtener_estadisticas_usuario(IN p_usu_id INT)
BEGIN
    SELECT 
        u.usu_id,
        u.usu_nombres,
        u.usu_apellidos,
        u.usu_email,
        u.fecha_registro,
        (SELECT COUNT(*) FROM cuestionarios WHERE usu_id = p_usu_id) AS total_cuestionarios,
        (SELECT COUNT(*) FROM test_conocimiento WHERE usu_id = p_usu_id) AS total_tests,
        (SELECT COUNT(*) FROM encuesta_satisfaccion WHERE usu_id = p_usu_id) AS total_encuestas,
        (SELECT AVG(score) FROM test_conocimiento WHERE usu_id = p_usu_id) AS promedio_test,
        (SELECT AVG(score) FROM encuesta_satisfaccion WHERE usu_id = p_usu_id) AS promedio_encuesta,
        (SELECT MAX(score) FROM juego_alimentos WHERE usu_id = p_usu_id) AS mejor_score_alimentos,
        (SELECT MAX(score) FROM juego_combinaciones WHERE usu_id = p_usu_id) AS mejor_score_combinaciones,
        (SELECT COUNT(*) FROM notificaciones WHERE usu_id = p_usu_id AND leida = 0) AS notificaciones_no_leidas,
        (SELECT MAX(fecha_creacion) FROM cuestionarios WHERE usu_id = p_usu_id) AS ultimo_cuestionario,
        (SELECT MAX(fecha_creacion) FROM test_conocimiento WHERE usu_id = p_usu_id) AS ultimo_test;
END //
DELIMITER ;

-- Procedimiento para obtener usuarios con filtros
DROP PROCEDURE IF EXISTS buscar_usuarios;
DELIMITER //
CREATE PROCEDURE buscar_usuarios(
    IN p_busqueda VARCHAR(255),
    IN p_tipo_usuario VARCHAR(10),
    IN p_activo TINYINT(1),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SET @sql = CONCAT(
        'SELECT * FROM usuarios WHERE 1=1'
    );
    
    IF p_busqueda IS NOT NULL AND p_busqueda != '' THEN
        SET @sql = CONCAT(@sql, 
            ' AND (usu_nombres LIKE ''%', p_busqueda, '%''',
            ' OR usu_apellidos LIKE ''%', p_busqueda, '%''',
            ' OR usu_email LIKE ''%', p_busqueda, '%'')'
        );
    END IF;
    
    IF p_tipo_usuario IS NOT NULL AND p_tipo_usuario != '' THEN
        SET @sql = CONCAT(@sql, ' AND tipo_usuario = ''', p_tipo_usuario, '''');
    END IF;
    
    IF p_activo IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND activo = ', p_activo);
    END IF;
    
    SET @sql = CONCAT(@sql, ' ORDER BY fecha_registro DESC');
    
    IF p_limit IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' LIMIT ', p_limit);
        IF p_offset IS NOT NULL THEN
            SET @sql = CONCAT(@sql, ' OFFSET ', p_offset);
        END IF;
    END IF;
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- Procedimiento para obtener configuración
DROP PROCEDURE IF EXISTS obtener_configuracion;
DELIMITER //
CREATE PROCEDURE obtener_configuracion(IN p_clave VARCHAR(100))
BEGIN
    IF p_clave IS NULL OR p_clave = '' THEN
        SELECT * FROM configuracion_sistema ORDER BY clave;
    ELSE
        SELECT * FROM configuracion_sistema WHERE clave = p_clave;
    END IF;
END //
DELIMITER ;

-- Procedimiento para actualizar configuración
DROP PROCEDURE IF EXISTS actualizar_configuracion;
DELIMITER //
CREATE PROCEDURE actualizar_configuracion(
    IN p_clave VARCHAR(100),
    IN p_valor TEXT
)
BEGIN
    INSERT INTO configuracion_sistema (clave, valor)
    VALUES (p_clave, p_valor)
    ON DUPLICATE KEY UPDATE 
        valor = p_valor,
        fecha_actualizacion = CURRENT_TIMESTAMP;
END //
DELIMITER ;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

-- Verificar tabla de configuración
SELECT 'Tabla configuracion_sistema:' AS VERIFICACION;
SELECT * FROM configuracion_sistema;

-- Verificar procedimientos
SELECT 
    ROUTINE_NAME AS PROCEDIMIENTO,
    ROUTINE_TYPE AS TIPO
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'login_db'
    AND ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;

-- Verificar índices de fecha
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'login_db'
    AND INDEX_NAME LIKE '%_fecha'
ORDER BY TABLE_NAME, INDEX_NAME;

SELECT '✅ Script de mejoras importantes de BD ejecutado correctamente' AS RESULTADO;

