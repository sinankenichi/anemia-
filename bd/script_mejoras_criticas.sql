-- =====================================================
-- Script de Mejoras Críticas - Base de Datos
-- =====================================================
-- Este script implementa mejoras críticas para optimización
-- y funcionalidad de la base de datos
-- =====================================================
-- Fecha: 2025-01-27
-- Versión: 1.0.0
-- =====================================================

USE login_db;

-- =====================================================
-- 1. ÍNDICES COMPUESTOS
-- =====================================================

-- Índice compuesto para usuarios (email + activo)
CREATE INDEX IF NOT EXISTS idx_usuarios_email_activo 
ON usuarios(usu_email, activo);

-- Índice compuesto para notificaciones
CREATE INDEX IF NOT EXISTS idx_notificaciones_usuario_leida 
ON notificaciones(usu_id, leida, fecha_creacion DESC);

-- Índice compuesto para test_conocimiento
CREATE INDEX IF NOT EXISTS idx_test_conocimiento_usuario_fecha 
ON test_conocimiento(usu_id, fecha_creacion DESC);

-- Índice compuesto para encuesta_satisfaccion
CREATE INDEX IF NOT EXISTS idx_encuesta_usuario_fecha 
ON encuesta_satisfaccion(usu_id, fecha_creacion DESC);

-- Índice compuesto para juego_alimentos
CREATE INDEX IF NOT EXISTS idx_juego_alimentos_usuario_fecha 
ON juego_alimentos(usu_id, fecha_creacion DESC);

-- Índice compuesto para juego_combinaciones
CREATE INDEX IF NOT EXISTS idx_juego_combinaciones_usuario_fecha 
ON juego_combinaciones(usu_id, fecha_creacion DESC);

-- Índice compuesto para auditoria
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario_fecha 
ON auditoria(usu_id, fecha_creacion DESC);

-- Índice compuesto para consentimientos
CREATE INDEX IF NOT EXISTS idx_consentimientos_usuario_aceptado 
ON consentimientos(usu_id, aceptado, fecha_aceptacion DESC);

-- Índice compuesto para mensajes_soporte
CREATE INDEX IF NOT EXISTS idx_mensajes_soporte_usuario_fecha 
ON mensajes_soporte(usu_id, fecha_creacion DESC);

-- =====================================================
-- 2. CAMPOS DE TIMESTAMP DE ACTUALIZACIÓN
-- =====================================================

-- Agregar fecha_actualizacion a usuarios si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'usuarios' 
    AND COLUMN_NAME = 'fecha_actualizacion'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE usuarios ADD COLUMN fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_registro',
    'SELECT ''Campo fecha_actualizacion ya existe en usuarios'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar fecha_actualizacion a cuestionarios si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'cuestionarios' 
    AND COLUMN_NAME = 'fecha_actualizacion'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE cuestionarios ADD COLUMN fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion',
    'SELECT ''Campo fecha_actualizacion ya existe en cuestionarios'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar fecha_actualizacion a test_conocimiento si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'test_conocimiento' 
    AND COLUMN_NAME = 'fecha_actualizacion'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE test_conocimiento ADD COLUMN fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion',
    'SELECT ''Campo fecha_actualizacion ya existe en test_conocimiento'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar fecha_actualizacion a encuesta_satisfaccion si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'encuesta_satisfaccion' 
    AND COLUMN_NAME = 'fecha_actualizacion'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE encuesta_satisfaccion ADD COLUMN fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion',
    'SELECT ''Campo fecha_actualizacion ya existe en encuesta_satisfaccion'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar fecha_actualizacion a juego_alimentos si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'juego_alimentos' 
    AND COLUMN_NAME = 'fecha_actualizacion'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE juego_alimentos ADD COLUMN fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion',
    'SELECT ''Campo fecha_actualizacion ya existe en juego_alimentos'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Agregar fecha_actualizacion a juego_combinaciones si no existe
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'login_db' 
    AND TABLE_NAME = 'juego_combinaciones' 
    AND COLUMN_NAME = 'fecha_actualizacion'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE juego_combinaciones ADD COLUMN fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion',
    'SELECT ''Campo fecha_actualizacion ya existe en juego_combinaciones'' AS mensaje'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =====================================================
-- 3. VISTAS (VIEWS) PARA CONSULTAS FRECUENTES
-- =====================================================

-- Vista de resumen de usuario
DROP VIEW IF EXISTS vista_resumen_usuario;
CREATE VIEW vista_resumen_usuario AS
SELECT 
    u.usu_id,
    u.usu_nombres,
    u.usu_apellidos,
    u.usu_email,
    u.fecha_registro,
    u.activo,
    COUNT(DISTINCT c.cuestionario_id) AS total_cuestionarios,
    COUNT(DISTINCT t.test_id) AS total_tests,
    COUNT(DISTINCT e.encuesta_id) AS total_encuestas,
    COALESCE(AVG(t.score), 0) AS promedio_test,
    COALESCE(AVG(e.score), 0) AS promedio_encuesta,
    MAX(c.fecha_creacion) AS ultimo_cuestionario,
    MAX(t.fecha_creacion) AS ultimo_test,
    MAX(e.fecha_creacion) AS ultima_encuesta,
    (SELECT COUNT(*) FROM notificaciones WHERE usu_id = u.usu_id AND leida = 0) AS notificaciones_no_leidas
FROM usuarios u
LEFT JOIN cuestionarios c ON u.usu_id = c.usu_id
LEFT JOIN test_conocimiento t ON u.usu_id = t.usu_id
LEFT JOIN encuesta_satisfaccion e ON u.usu_id = e.usu_id
GROUP BY u.usu_id, u.usu_nombres, u.usu_apellidos, u.usu_email, u.fecha_registro, u.activo;

-- Vista de estadísticas de juegos por usuario
DROP VIEW IF EXISTS vista_estadisticas_juegos;
CREATE VIEW vista_estadisticas_juegos AS
SELECT 
    u.usu_id,
    u.usu_nombres,
    u.usu_apellidos,
    COUNT(DISTINCT ja.juego_id) AS total_partidas_alimentos,
    COALESCE(AVG(ja.score), 0) AS promedio_score_alimentos,
    COALESCE(MAX(ja.score), 0) AS mejor_score_alimentos,
    COUNT(DISTINCT jc.juego_id) AS total_partidas_combinaciones,
    COALESCE(AVG(jc.score), 0) AS promedio_score_combinaciones,
    COALESCE(MAX(jc.score), 0) AS mejor_score_combinaciones,
    MAX(ja.fecha_creacion) AS ultima_partida_alimentos,
    MAX(jc.fecha_creacion) AS ultima_partida_combinaciones
FROM usuarios u
LEFT JOIN juego_alimentos ja ON u.usu_id = ja.usu_id
LEFT JOIN juego_combinaciones jc ON u.usu_id = jc.usu_id
GROUP BY u.usu_id, u.usu_nombres, u.usu_apellidos;

-- Vista de actividad reciente del usuario
DROP VIEW IF EXISTS vista_actividad_reciente;
CREATE VIEW vista_actividad_reciente AS
SELECT 
    usu_id,
    'cuestionario' AS tipo_actividad,
    cuestionario_id AS actividad_id,
    fecha_creacion AS fecha
FROM cuestionarios
UNION ALL
SELECT 
    usu_id,
    'test_conocimiento' AS tipo_actividad,
    test_id AS actividad_id,
    fecha_creacion AS fecha
FROM test_conocimiento
UNION ALL
SELECT 
    usu_id,
    'encuesta' AS tipo_actividad,
    encuesta_id AS actividad_id,
    fecha_creacion AS fecha
FROM encuesta_satisfaccion
UNION ALL
SELECT 
    usu_id,
    'juego_alimentos' AS tipo_actividad,
    juego_id AS actividad_id,
    fecha_creacion AS fecha
FROM juego_alimentos
UNION ALL
SELECT 
    usu_id,
    'juego_combinaciones' AS tipo_actividad,
    juego_id AS actividad_id,
    fecha_creacion AS fecha
FROM juego_combinaciones
ORDER BY fecha DESC;

-- Vista de consentimientos activos
DROP VIEW IF EXISTS vista_consentimientos_activos AS
SELECT 
    c.*,
    u.usu_nombres,
    u.usu_apellidos,
    u.usu_email
FROM consentimientos c
INNER JOIN usuarios u ON c.usu_id = u.usu_id
WHERE c.aceptado = TRUE
ORDER BY c.fecha_aceptacion DESC;

-- =====================================================
-- 4. TRIGGERS PARA AUDITORÍA AUTOMÁTICA
-- =====================================================

-- Eliminar triggers existentes si existen
DROP TRIGGER IF EXISTS trg_usuarios_insert;
DROP TRIGGER IF EXISTS trg_usuarios_update;
DROP TRIGGER IF EXISTS trg_usuarios_delete;

-- Trigger para INSERT en usuarios
DELIMITER //
CREATE TRIGGER trg_usuarios_insert
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (
        usu_id, 
        ip_address,
        action_type, 
        description, 
        details
    )
    VALUES (
        NEW.usu_id, 
        NULL, -- Se llenará desde la aplicación
        'REGISTRO_EXITOSO', 
        CONCAT('Usuario registrado: ', NEW.usu_email),
        JSON_OBJECT(
            'email', NEW.usu_email,
            'nombres', NEW.usu_nombres,
            'apellidos', NEW.usu_apellidos,
            'tipo_usuario', NEW.tipo_usuario
        )
    );
END //
DELIMITER ;

-- Trigger para UPDATE en usuarios
DELIMITER //
CREATE TRIGGER trg_usuarios_update
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    -- Solo registrar si hay cambios significativos
    IF OLD.usu_email != NEW.usu_email 
       OR OLD.activo != NEW.activo 
       OR OLD.tipo_usuario != NEW.tipo_usuario THEN
        
        INSERT INTO auditoria (
            usu_id, 
            ip_address,
            action_type, 
            description, 
            details
        )
        VALUES (
            NEW.usu_id, 
            NULL,
            'USUARIO_ACTUALIZADO', 
            CONCAT('Usuario actualizado: ', NEW.usu_email),
            JSON_OBJECT(
                'email_anterior', OLD.usu_email,
                'email_nuevo', NEW.usu_email,
                'activo_anterior', OLD.activo,
                'activo_nuevo', NEW.activo,
                'tipo_anterior', OLD.tipo_usuario,
                'tipo_nuevo', NEW.tipo_usuario
            )
        );
    END IF;
END //
DELIMITER ;

-- Trigger para DELETE en usuarios (soft delete)
DELIMITER //
CREATE TRIGGER trg_usuarios_delete
AFTER DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (
        usu_id, 
        ip_address,
        action_type, 
        description, 
        details
    )
    VALUES (
        OLD.usu_id, 
        NULL,
        'USUARIO_ELIMINADO', 
        CONCAT('Usuario eliminado: ', OLD.usu_email),
        JSON_OBJECT(
            'email', OLD.usu_email,
            'nombres', OLD.usu_nombres,
            'apellidos', OLD.usu_apellidos
        )
    );
END //
DELIMITER ;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

-- Verificar índices creados
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLUMNS
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'login_db'
  AND INDEX_NAME LIKE 'idx_%'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;

-- Verificar vistas creadas
SELECT TABLE_NAME, VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'login_db';

-- Verificar triggers creados
SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = 'login_db';

SELECT '✅ Mejoras críticas de base de datos aplicadas exitosamente' AS resultado;

