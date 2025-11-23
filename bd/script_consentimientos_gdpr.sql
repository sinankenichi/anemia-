-- =====================================================
-- Script para crear tabla de consentimientos GDPR
-- =====================================================
-- Este script crea la tabla de consentimientos para
-- cumplir con GDPR, CCPA y LGPD
-- =====================================================

USE login_db;

-- =====================================================
-- TABLA: consentimientos
-- =====================================================
CREATE TABLE IF NOT EXISTS consentimientos (
    consentimiento_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL COMMENT 'ID del usuario',
    tipo_consentimiento ENUM(
        'privacidad',
        'terminos',
        'marketing',
        'analytics',
        'datos_salud',
        'compartir_datos'
    ) NOT NULL COMMENT 'Tipo de consentimiento',
    consentido TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Si el usuario ha dado su consentimiento',
    version_politica VARCHAR(50) NOT NULL COMMENT 'Versión de la política aceptada',
    ip_address VARCHAR(45) NULL COMMENT 'IP desde donde se dio el consentimiento',
    user_agent TEXT NULL COMMENT 'User agent del dispositivo',
    fecha_consentimiento DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del consentimiento',
    fecha_revocacion DATETIME NULL COMMENT 'Fecha de revocación del consentimiento (si aplica)',
    metodo_consentimiento ENUM('app', 'web', 'email', 'telefono') DEFAULT 'app' COMMENT 'Método utilizado para obtener consentimiento',
    INDEX idx_usuario (usu_id),
    INDEX idx_tipo (tipo_consentimiento),
    INDEX idx_fecha (fecha_consentimiento),
    INDEX idx_usuario_tipo (usu_id, tipo_consentimiento),
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: registro_procesamiento_datos (GDPR Art. 30)
-- =====================================================
CREATE TABLE IF NOT EXISTS registro_procesamiento_datos (
    registro_id INT PRIMARY KEY AUTO_INCREMENT,
    categoria_datos VARCHAR(100) NOT NULL COMMENT 'Categoría de datos procesados',
    proposito_procesamiento TEXT NOT NULL COMMENT 'Propósito del procesamiento',
    base_legal VARCHAR(100) NOT NULL COMMENT 'Base legal (consentimiento, contrato, obligación legal, etc.)',
    categorias_sujetos VARCHAR(255) NULL COMMENT 'Categorías de sujetos de datos',
    categorias_destinatarios VARCHAR(255) NULL COMMENT 'Categorías de destinatarios',
    transferencias_internacionales TINYINT(1) DEFAULT 0 COMMENT 'Si hay transferencias internacionales',
    plazos_conservacion VARCHAR(255) NULL COMMENT 'Plazos de conservación de datos',
    medidas_seguridad TEXT NULL COMMENT 'Medidas de seguridad implementadas',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_categoria (categoria_datos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: brechas_seguridad (GDPR Art. 33)
-- =====================================================
CREATE TABLE IF NOT EXISTS brechas_seguridad (
    brecha_id INT PRIMARY KEY AUTO_INCREMENT,
    fecha_deteccion DATETIME NOT NULL COMMENT 'Fecha en que se detectó la brecha',
    fecha_notificacion DATETIME NULL COMMENT 'Fecha en que se notificó a la autoridad',
    tipo_brecha ENUM('confidencialidad', 'integridad', 'disponibilidad') NOT NULL,
    descripcion TEXT NOT NULL COMMENT 'Descripción de la brecha',
    datos_afectados TEXT NULL COMMENT 'Categorías de datos afectados',
    numero_afectados INT NULL COMMENT 'Número aproximado de sujetos afectados',
    consecuencias TEXT NULL COMMENT 'Consecuencias de la brecha',
    medidas_mitigacion TEXT NULL COMMENT 'Medidas tomadas para mitigar la brecha',
    notificado_autoridad TINYINT(1) DEFAULT 0 COMMENT 'Si se notificó a la autoridad supervisora',
    notificado_afectados TINYINT(1) DEFAULT 0 COMMENT 'Si se notificó a los afectados',
    fecha_cierre DATETIME NULL COMMENT 'Fecha de cierre/resolución de la brecha',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_fecha_deteccion (fecha_deteccion),
    INDEX idx_tipo (tipo_brecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- DATOS INICIALES: Registro de actividades de procesamiento
-- =====================================================
INSERT IGNORE INTO registro_procesamiento_datos (
    categoria_datos,
    proposito_procesamiento,
    base_legal,
    categorias_sujetos,
    categorias_destinatarios,
    transferencias_internacionales,
    plazos_conservacion,
    medidas_seguridad
) VALUES (
    'Datos de identificación personal',
    'Registro y autenticación de usuarios, gestión de cuentas',
    'Consentimiento del interesado',
    'Usuarios de la aplicación',
    'Personal autorizado de la organización',
    0,
    'Mientras la cuenta esté activa + 3 años después de inactividad',
    'Encriptación de contraseñas, autenticación JWT, acceso restringido'
),
(
    'Datos de salud y evaluaciones',
    'Proporcionar servicios educativos sobre anemia y nutrición, generar reportes de progreso',
    'Consentimiento explícito del interesado',
    'Usuarios de la aplicación',
    'Personal autorizado de la organización, administradores',
    0,
    'Mientras la cuenta esté activa + 5 años después de inactividad',
    'Encriptación en tránsito (HTTPS), acceso restringido, logging de auditoría'
),
(
    'Datos de uso y analytics',
    'Mejorar la aplicación, análisis de uso, optimización de servicios',
    'Interés legítimo',
    'Usuarios de la aplicación',
    'Equipo de desarrollo y análisis',
    0,
    '2 años',
    'Anonimización cuando sea posible, acceso restringido'
);

-- =====================================================
-- VISTA: Consentimientos activos por usuario
-- =====================================================
CREATE OR REPLACE VIEW vista_consentimientos_activos AS
SELECT 
    c.consentimiento_id,
    c.usu_id,
    u.usu_email,
    c.tipo_consentimiento,
    c.consentido,
    c.version_politica,
    c.fecha_consentimiento,
    c.fecha_revocacion,
    CASE 
        WHEN c.fecha_revocacion IS NULL AND c.consentido = 1 THEN 'Activo'
        WHEN c.fecha_revocacion IS NOT NULL THEN 'Revocado'
        ELSE 'No consentido'
    END AS estado
FROM consentimientos c
INNER JOIN usuarios u ON c.usu_id = u.usu_id
WHERE c.fecha_revocacion IS NULL OR c.consentido = 1
ORDER BY c.fecha_consentimiento DESC;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
SELECT 'Tabla consentimientos creada exitosamente' AS mensaje;
SELECT 'Tabla registro_procesamiento_datos creada exitosamente' AS mensaje;
SELECT 'Tabla brechas_seguridad creada exitosamente' AS mensaje;
SELECT COUNT(*) AS total_registros_procesamiento FROM registro_procesamiento_datos;

