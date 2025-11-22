-- Script para verificar que las notificaciones estén en la base de datos
USE login_db;

-- Verificar total de notificaciones
SELECT '=== VERIFICACIÓN DE NOTIFICACIONES ===' AS '';
SELECT 'Total notificaciones:' AS Tipo, COUNT(*) AS Cantidad FROM notificaciones;

-- Verificar notificaciones por tipo de usuario
SELECT '=== NOTIFICACIONES POR TIPO DE USUARIO ===' AS '';
SELECT 
    u.tipo_usuario,
    COUNT(n.notificacion_id) AS total_notificaciones,
    SUM(CASE WHEN n.leida = 0 THEN 1 ELSE 0 END) AS no_leidas
FROM usuarios u
LEFT JOIN notificaciones n ON u.usu_id = n.usu_id
GROUP BY u.tipo_usuario;

-- Verificar notificaciones del administrador
SELECT '=== NOTIFICACIONES DEL ADMINISTRADOR ===' AS '';
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

-- Verificar notificaciones de usuarios regulares (primeros 5)
SELECT '=== NOTIFICACIONES DE USUARIOS REGULARES (PRIMEROS 5) ===' AS '';
SELECT 
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
ORDER BY n.fecha_creacion DESC
LIMIT 10;

-- Verificar usuarios sin notificaciones
SELECT '=== USUARIOS SIN NOTIFICACIONES ===' AS '';
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

