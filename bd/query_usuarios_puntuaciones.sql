-- =====================================================
-- Query: Lista de Usuarios con Edades y Puntuaciones
-- =====================================================
-- Muestra:
-- - Lista de 63 usuarios
-- - Edades calculadas desde fecha_nacimiento
-- - Puntuación del Pretest (test_conocimiento)
-- - Puntuación del Posttest (encuesta_satisfaccion)
-- =====================================================

SELECT TOP 63
    u.usu_id AS 'ID Usuario',
    u.usu_nombres + ' ' + u.usu_apellidos AS 'Nombre Completo',
    u.usu_email AS 'Correo Electrónico',
    u.fecha_nacimiento AS 'Fecha de Nacimiento',
    DATEDIFF(YEAR, u.fecha_nacimiento, GETDATE()) AS 'Edad',
    ISNULL(t.score, 0) AS 'Puntuación Pretest (Test Conocimiento)',
    ISNULL(e.score, 0) AS 'Puntuación Posttest (Encuesta Satisfacción)',
    CASE 
        WHEN t.score IS NULL AND e.score IS NULL THEN 'Sin evaluaciones'
        WHEN t.score IS NULL THEN 'Solo Posttest'
        WHEN e.score IS NULL THEN 'Solo Pretest'
        ELSE 'Completo'
    END AS 'Estado Evaluaciones',
    u.fecha_registro AS 'Fecha de Registro'
FROM usuarios u
LEFT JOIN (
    -- Obtener el último test de conocimiento (pretest) por usuario
    SELECT 
        usu_id,
        score,
        ROW_NUMBER() OVER (PARTITION BY usu_id ORDER BY fecha_creacion DESC) AS rn
    FROM test_conocimiento
) t ON u.usu_id = t.usu_id AND t.rn = 1
LEFT JOIN (
    -- Obtener la última encuesta de satisfacción (posttest) por usuario
    SELECT 
        usu_id,
        score,
        ROW_NUMBER() OVER (PARTITION BY usu_id ORDER BY fecha_creacion DESC) AS rn
    FROM encuesta_satisfaccion
) e ON u.usu_id = e.usu_id AND e.rn = 1
WHERE u.tipo_usuario = 'usuario'
ORDER BY u.usu_id;

-- =====================================================
-- Query Alternativa: Con más detalles de fechas
-- =====================================================
-- Si necesitas ver también las fechas de cuando se realizaron los tests:

/*
SELECT TOP 63
    u.usu_id AS 'ID Usuario',
    u.usu_nombres + ' ' + u.usu_apellidos AS 'Nombre Completo',
    u.usu_email AS 'Correo Electrónico',
    u.fecha_nacimiento AS 'Fecha de Nacimiento',
    DATEDIFF(YEAR, u.fecha_nacimiento, GETDATE()) AS 'Edad',
    ISNULL(t.score, 0) AS 'Puntuación Pretest',
    t.fecha_creacion AS 'Fecha Pretest',
    ISNULL(e.score, 0) AS 'Puntuación Posttest',
    e.fecha_creacion AS 'Fecha Posttest',
    u.fecha_registro AS 'Fecha de Registro'
FROM usuarios u
LEFT JOIN (
    SELECT 
        usu_id,
        score,
        fecha_creacion,
        ROW_NUMBER() OVER (PARTITION BY usu_id ORDER BY fecha_creacion DESC) AS rn
    FROM test_conocimiento
) t ON u.usu_id = t.usu_id AND t.rn = 1
LEFT JOIN (
    SELECT 
        usu_id,
        score,
        fecha_creacion,
        ROW_NUMBER() OVER (PARTITION BY usu_id ORDER BY fecha_creacion DESC) AS rn
    FROM encuesta_satisfaccion
) e ON u.usu_id = e.usu_id AND e.rn = 1
WHERE u.tipo_usuario = 'usuario'
ORDER BY u.usu_id;
*/

-- =====================================================
-- Query con Estadísticas Resumidas
-- =====================================================
-- Si necesitas un resumen estadístico:

/*
SELECT 
    COUNT(*) AS 'Total Usuarios',
    AVG(CAST(DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) AS FLOAT)) AS 'Edad Promedio',
    MIN(DATEDIFF(YEAR, fecha_nacimiento, GETDATE())) AS 'Edad Mínima',
    MAX(DATEDIFF(YEAR, fecha_nacimiento, GETDATE())) AS 'Edad Máxima',
    AVG(CAST(ISNULL(t.score, 0) AS FLOAT)) AS 'Promedio Pretest',
    AVG(CAST(ISNULL(e.score, 0) AS FLOAT)) AS 'Promedio Posttest',
    COUNT(t.score) AS 'Usuarios con Pretest',
    COUNT(e.score) AS 'Usuarios con Posttest'
FROM usuarios u
LEFT JOIN (
    SELECT 
        usu_id,
        score,
        ROW_NUMBER() OVER (PARTITION BY usu_id ORDER BY fecha_creacion DESC) AS rn
    FROM test_conocimiento
) t ON u.usu_id = t.usu_id AND t.rn = 1
LEFT JOIN (
    SELECT 
        usu_id,
        score,
        ROW_NUMBER() OVER (PARTITION BY usu_id ORDER BY fecha_creacion DESC) AS rn
    FROM encuesta_satisfaccion
) e ON u.usu_id = e.usu_id AND e.rn = 1
WHERE u.tipo_usuario = 'usuario';
*/

