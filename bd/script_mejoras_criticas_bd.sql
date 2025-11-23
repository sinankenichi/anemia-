-- =====================================================
-- Script de Mejoras Críticas de Base de Datos
-- =====================================================
-- Este script implementa todas las mejoras críticas:
-- 1. Índices compuestos
-- 2. Triggers de auditoría automática
-- 3. Vistas (Views) para consultas frecuentes
-- 4. Timestamps de actualización
-- =====================================================
-- Fecha: 2025-01-27
-- Versión: 1.0.0
-- =====================================================

USE login_db;

-- =====================================================
-- PARTE 1: ÍNDICES COMPUESTOS
-- =====================================================

-- Índice compuesto para usuarios (email + activo)
CREATE INDEX IF NOT EXISTS idx_usuarios_email_activo ON usuarios(usu_email, activo);

-- Índice compuesto para notificaciones (usuario + leida + fecha)
CREATE INDEX IF NOT EXISTS idx_notificaciones_usuario_leida ON notificaciones(usu_id, leida, fecha_creacion);

-- Índice compuesto para test_conocimiento (usuario + fecha)
CREATE INDEX IF NOT EXISTS idx_test_conocimiento_usuario_fecha ON test_conocimiento(usu_id, fecha_creacion DESC);

-- Índice compuesto para encuesta_satisfaccion (usuario + fecha)
CREATE INDEX IF NOT EXISTS idx_encuesta_usuario_fecha ON encuesta_satisfaccion(usu_id, fecha_creacion DESC);

-- Índice compuesto para juego_alimentos (usuario + fecha)
CREATE INDEX IF NOT EXISTS idx_juego_alimentos_usuario_fecha ON juego_alimentos(usu_id, fecha_creacion DESC);

-- Índice compuesto para juego_combinaciones (usuario + fecha)
CREATE INDEX IF NOT EXISTS idx_juego_combinaciones_usuario_fecha ON juego_combinaciones(usu_id, fecha_creacion DESC);

-- Índice compuesto para auditoria (usuario + fecha)
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario_fecha ON auditoria(usu_id, fecha_creacion DESC);

-- Índice compuesto para consentimientos (usuario + aceptado + fecha)
CREATE INDEX IF NOT EXISTS idx_consentimientos_usuario_aceptado ON consentimientos(usu_id, aceptado, fecha_aceptacion);

-- Índice compuesto para mensajes_soporte (usuario + tipo + fecha)
CREATE INDEX IF NOT EXISTS idx_mensajes_usuario_tipo_fecha ON mensajes_soporte(usu_id, tipo_mensaje, fecha_creacion DESC);

-- =====================================================
-- PARTE 2: TIMESTAMPS DE ACTUALIZACIÓN
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

-- =====================================================
-- PARTE 3: VISTAS (VIEWS) PARA CONSULTAS FRECUENTES
-- =====================================================

-- Vista de resumen de usuario
CREATE OR REPLACE VIEW vista_resumen_usuario AS
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
    COUNT(DISTINCT ja.juego_id) AS total_juegos_alimentos,
    COUNT(DISTINCT jc.juego_id) AS total_juegos_combinaciones,
    AVG(t.score) AS promedio_test,
    AVG(e.score) AS promedio_encuesta,
    MAX(ja.score) AS mejor_score_alimentos,
    MAX(jc.score) AS mejor_score_combinaciones,
    MAX(c.fecha_creacion) AS ultimo_cuestionario,
    MAX(t.fecha_creacion) AS ultimo_test,
    MAX(e.fecha_creacion) AS ultima_encuesta,
    (SELECT COUNT(*) FROM notificaciones WHERE usu_id = u.usu_id AND leida = 0) AS notificaciones_no_leidas
FROM usuarios u
LEFT JOIN cuestionarios c ON u.usu_id = c.usu_id
LEFT JOIN test_conocimiento t ON u.usu_id = t.usu_id
LEFT JOIN encuesta_satisfaccion e ON u.usu_id = e.usu_id
LEFT JOIN juego_alimentos ja ON u.usu_id = ja.usu_id
LEFT JOIN juego_combinaciones jc ON u.usu_id = jc.usu_id
GROUP BY u.usu_id, u.usu_nombres, u.usu_apellidos, u.usu_email, u.fecha_registro, u.activo;

-- Vista de estadísticas de juegos por usuario
CREATE OR REPLACE VIEW vista_estadisticas_juegos AS
SELECT 
    ja.usu_id,
    COUNT(DISTINCT ja.juego_id) AS total_partidas_alimentos,
    AVG(ja.score) AS promedio_score_alimentos,
    MAX(ja.score) AS mejor_score_alimentos,
    MIN(ja.score) AS peor_score_alimentos,
    AVG(ja.tiempo_segundos) AS promedio_tiempo_alimentos,
    COUNT(DISTINCT jc.juego_id) AS total_partidas_combinaciones,
    AVG(jc.score) AS promedio_score_combinaciones,
    MAX(jc.score) AS mejor_score_combinaciones,
    MIN(jc.score) AS peor_score_combinaciones,
    AVG(jc.tiempo_segundos) AS promedio_tiempo_combinaciones
FROM juego_alimentos ja
LEFT JOIN juego_combinaciones jc ON ja.usu_id = jc.usu_id
GROUP BY ja.usu_id;

-- Vista de consentimientos activos
CREATE OR REPLACE VIEW vista_consentimientos_activos AS
SELECT 
    c.consentimiento_id,
    c.usu_id,
    u.usu_nombres,
    u.usu_apellidos,
    u.usu_email,
    c.tipo_consentimiento,
    c.version,
    c.aceptado,
    c.fecha_aceptacion,
    c.fecha_revocacion,
    CASE 
        WHEN c.aceptado = 1 AND c.fecha_revocacion IS NULL THEN 'ACTIVO'
        WHEN c.aceptado = 0 OR c.fecha_revocacion IS NOT NULL THEN 'REVOCADO'
        ELSE 'DESCONOCIDO'
    END AS estado
FROM consentimientos c
INNER JOIN usuarios u ON c.usu_id = u.usu_id
WHERE c.aceptado = 1 AND c.fecha_revocacion IS NULL;

-- Vista de auditoría resumen (últimas acciones)
CREATE OR REPLACE VIEW vista_auditoria_resumen AS
SELECT 
    a.audit_id,
    a.usu_id,
    u.usu_nombres,
    u.usu_apellidos,
    a.action_type,
    a.description,
    a.ip_address,
    a.timestamp,
    DATE(a.timestamp) AS fecha,
    TIME(a.timestamp) AS hora
FROM auditoria a
LEFT JOIN usuarios u ON a.usu_id = u.usu_id
ORDER BY a.timestamp DESC;

-- =====================================================
-- PARTE 4: TRIGGERS DE AUDITORÍA AUTOMÁTICA
-- =====================================================

-- Eliminar triggers existentes si existen (para evitar errores)
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
        COALESCE(@user_ip, 'Sistema'),
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
    IF OLD.usu_email != NEW.usu_email OR 
       OLD.activo != NEW.activo OR 
       OLD.tipo_usuario != NEW.tipo_usuario THEN
        
        INSERT INTO auditoria (
            usu_id, 
            ip_address,
            action_type, 
            description, 
            details
        )
        VALUES (
            NEW.usu_id, 
            COALESCE(@user_ip, 'Sistema'),
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

-- Trigger para DELETE en usuarios
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
        COALESCE(@user_ip, 'Sistema'),
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
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLUMNAS
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'login_db'
    AND INDEX_NAME LIKE 'idx_%'
    AND INDEX_NAME NOT LIKE 'idx_usuario'
    AND INDEX_NAME NOT LIKE 'idx_email'
    AND INDEX_NAME NOT LIKE 'idx_score'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;

-- Verificar vistas creadas
SELECT TABLE_NAME AS VISTA
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'login_db'
ORDER BY TABLE_NAME;

-- Verificar triggers creados
SELECT TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = 'login_db'
ORDER BY TRIGGER_NAME;

-- Verificar campos de fecha_actualizacion
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    COLUMN_DEFAULT,
    EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'login_db'
    AND COLUMN_NAME = 'fecha_actualizacion'
ORDER BY TABLE_NAME;

SELECT '✅ Script de mejoras críticas de BD ejecutado correctamente' AS RESULTADO;

