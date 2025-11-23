-- =====================================================
-- Script para crear tabla de auditoría
-- =====================================================
-- Este script crea la tabla de auditoría para registrar
-- todas las acciones importantes en el sistema
-- =====================================================

USE login_db;

-- =====================================================
-- TABLA: auditoria
-- =====================================================
CREATE TABLE IF NOT EXISTS auditoria (
    auditoria_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NULL COMMENT 'ID del usuario que realizó la acción (NULL si es sistema)',
    accion VARCHAR(100) NOT NULL COMMENT 'Tipo de acción: LOGIN, LOGOUT, CREATE, UPDATE, DELETE, etc.',
    tabla_afectada VARCHAR(100) NULL COMMENT 'Tabla afectada por la acción',
    registro_id INT NULL COMMENT 'ID del registro afectado',
    datos_anteriores JSON NULL COMMENT 'Datos antes de la modificación (para UPDATE/DELETE)',
    datos_nuevos JSON NULL COMMENT 'Datos después de la modificación (para CREATE/UPDATE)',
    ip_address VARCHAR(45) NULL COMMENT 'Dirección IP del cliente',
    user_agent TEXT NULL COMMENT 'User agent del cliente',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la acción',
    INDEX idx_usuario (usu_id),
    INDEX idx_accion (accion),
    INDEX idx_tabla (tabla_afectada),
    INDEX idx_fecha (fecha_creacion),
    INDEX idx_usuario_fecha (usu_id, fecha_creacion),
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- PROCEDIMIENTO ALMACENADO: Registrar auditoría
-- =====================================================
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS registrar_auditoria(
    IN p_usu_id INT,
    IN p_accion VARCHAR(100),
    IN p_tabla_afectada VARCHAR(100),
    IN p_registro_id INT,
    IN p_datos_anteriores JSON,
    IN p_datos_nuevos JSON,
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT
)
BEGIN
    INSERT INTO auditoria (
        usu_id,
        accion,
        tabla_afectada,
        registro_id,
        datos_anteriores,
        datos_nuevos,
        ip_address,
        user_agent
    ) VALUES (
        p_usu_id,
        p_accion,
        p_tabla_afectada,
        p_registro_id,
        p_datos_anteriores,
        p_datos_nuevos,
        p_ip_address,
        p_user_agent
    );
END //

DELIMITER ;

-- =====================================================
-- VISTA: Vista resumida de auditoría
-- =====================================================
CREATE OR REPLACE VIEW vista_auditoria_resumen AS
SELECT 
    a.auditoria_id,
    a.fecha_creacion,
    COALESCE(u.usu_nombres, 'Sistema') AS usuario_nombre,
    COALESCE(u.usu_email, 'N/A') AS usuario_email,
    a.accion,
    a.tabla_afectada,
    a.registro_id,
    a.ip_address
FROM auditoria a
LEFT JOIN usuarios u ON a.usu_id = u.usu_id
ORDER BY a.fecha_creacion DESC;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
SELECT 'Tabla auditoria creada exitosamente' AS mensaje;
SELECT COUNT(*) AS total_registros FROM auditoria;

