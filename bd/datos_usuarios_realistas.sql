-- =====================================================
-- Script de Datos Realistas para App de Salud
-- =====================================================
-- Este script crea:
-- - 1 Administrador
-- - 20 Usuarios adolescentes (10-16 años) con datos realistas
-- - Todos los cuestionarios, tests, juegos y evaluaciones completados
-- - Simula actividad de los últimos 2 días
-- =====================================================

USE login_db;

-- =====================================================
-- LIMPIAR DATOS EXISTENTES (ELIMINAR USUARIOS DE PRUEBA)
-- =====================================================
-- Deshabilitar temporalmente el modo seguro para permitir DELETE
SET SQL_SAFE_UPDATES = 0;

-- Eliminar datos relacionados primero (por foreign keys)
-- Usando DELETE directo con WHERE en la clave primaria

DELETE FROM juego_combinaciones 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

DELETE FROM juego_alimentos 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

DELETE FROM encuesta_satisfaccion 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

DELETE FROM test_conocimiento 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

DELETE FROM cuestionarios 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

DELETE FROM mensajes_soporte 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

DELETE FROM notificaciones 
WHERE usu_id IN (
    SELECT usu_id FROM (SELECT usu_id FROM usuarios WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com')) AS temp
);

-- Eliminar usuarios de prueba
DELETE FROM usuarios 
WHERE usu_email IN ('test1@test.com', 'test2@test.com', 'test3@test.com', 'admin@admin.com');

-- Volver a habilitar el modo seguro
SET SQL_SAFE_UPDATES = 1;

-- =====================================================
-- ADMINISTRADOR
-- =====================================================
INSERT IGNORE INTO usuarios (usu_nombres, usu_apellidos, usu_email, usu_password, fecha_nacimiento, tipo_usuario, fecha_registro, activo)
VALUES 
('Carlos', 'Rodríguez', 'admin@inspirasalud.com', 'admin123', '1985-03-15', 'admin', DATE_SUB(NOW(), INTERVAL 30 DAY), 1);

-- =====================================================
-- 20 USUARIOS ADOLESCENTES (10-16 AÑOS) CON DATOS REALISTAS
-- =====================================================
-- Fechas de nacimiento: entre 2008 y 2014 (10-16 años en 2025)
-- Fechas de registro: hace 2-3 días para simular uso reciente

INSERT IGNORE INTO usuarios (usu_nombres, usu_apellidos, usu_email, usu_password, fecha_nacimiento, tipo_usuario, fecha_registro, activo) VALUES
-- Usuarios de 10-11 años (2014-2013)
('María', 'González', 'maria.gonzalez2024@gmail.com', 'maria123', '2014-05-12', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Santiago', 'Martínez', 'santiago.martinez14@hotmail.com', 'santiago123', '2014-08-23', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Valentina', 'López', 'valentina.lopez2014@yahoo.com', 'valentina123', '2013-11-07', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Diego', 'Hernández', 'diego.hernandez13@gmail.com', 'diego123', '2013-02-18', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Sofía', 'Ramírez', 'sofia.ramirez2013@outlook.com', 'sofia123', '2013-09-30', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 12-13 años (2012-2011)
('Mateo', 'Torres', 'mateo.torres12@gmail.com', 'mateo123', '2012-04-15', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Isabella', 'Flores', 'isabella.flores2012@hotmail.com', 'isabella123', '2012-07-22', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Sebastián', 'Rivera', 'sebastian.rivera12@yahoo.com', 'sebastian123', '2012-10-08', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Camila', 'Morales', 'camila.morales2011@gmail.com', 'camila123', '2011-01-25', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Nicolás', 'García', 'nicolas.garcia11@outlook.com', 'nicolas123', '2011-06-14', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 14-15 años (2010-2009)
('Ana', 'Sánchez', 'ana.sanchez2010@gmail.com', 'ana123', '2010-03-19', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Lucas', 'Jiménez', 'lucas.jimenez10@hotmail.com', 'lucas123', '2010-08-05', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Emma', 'Díaz', 'emma.diaz2009@yahoo.com', 'emma123', '2009-12-11', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Daniel', 'Moreno', 'daniel.moreno09@gmail.com', 'daniel123', '2009-05-28', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Lucía', 'Vargas', 'lucia.vargas2009@outlook.com', 'lucia123', '2009-09-16', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 15-16 años (2009-2008)
('Alejandro', 'Castro', 'alejandro.castro09@gmail.com', 'alejandro123', '2009-02-03', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Paula', 'Romero', 'paula.romero2008@hotmail.com', 'paula123', '2008-11-20', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Andrés', 'Mendoza', 'andres.mendoza08@yahoo.com', 'andres123', '2008-07-09', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Fernanda', 'Ortega', 'fernanda.ortega2008@gmail.com', 'fernanda123', '2008-04-27', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Javier', 'Silva', 'javier.silva08@outlook.com', 'javier123', '2008-10-14', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- =====================================================
-- 20 USUARIOS ADICIONALES (10-16 AÑOS) CON DATOS REALISTAS
-- =====================================================
-- Usuarios de 10-11 años (2014-2013)
('Adriana', 'Fernández', 'adriana.fernandez2024@gmail.com', 'adriana123', '2014-01-18', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Carlos', 'Pérez', 'carlos.perez14@hotmail.com', 'carlos123', '2014-06-29', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Gabriela', 'Ruiz', 'gabriela.ruiz2014@yahoo.com', 'gabriela123', '2013-03-14', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Miguel', 'Álvarez', 'miguel.alvarez13@gmail.com', 'miguel123', '2013-09-25', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Laura', 'Gutiérrez', 'laura.gutierrez2013@outlook.com', 'laura123', '2013-12-08', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 12-13 años (2012-2011)
('Roberto', 'Navarro', 'roberto.navarro12@gmail.com', 'roberto123', '2012-05-22', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Carmen', 'Delgado', 'carmen.delgado2012@hotmail.com', 'carmen123', '2012-08-11', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Fernando', 'Ortiz', 'fernando.ortiz12@yahoo.com', 'fernando123', '2012-11-03', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Patricia', 'Marín', 'patricia.marin2011@gmail.com', 'patricia123', '2011-02-17', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Ricardo', 'Soto', 'ricardo.soto11@outlook.com', 'ricardo123', '2011-07-30', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 14-15 años (2010-2009)
('Monica', 'Vega', 'monica.vega2010@gmail.com', 'monica123', '2010-04-13', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Eduardo', 'Medina', 'eduardo.medina10@hotmail.com', 'eduardo123', '2010-09-26', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Claudia', 'Rojas', 'claudia.rojas2009@yahoo.com', 'claudia123', '2009-01-09', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Gustavo', 'Campos', 'gustavo.campos09@gmail.com', 'gustavo123', '2009-06-21', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Diana', 'Guerrero', 'diana.guerrero2009@outlook.com', 'diana123', '2009-10-04', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 15-16 años (2009-2008)
('Raúl', 'Molina', 'raul.molina09@gmail.com', 'raul123', '2009-03-16', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Verónica', 'Herrera', 'veronica.herrera2008@hotmail.com', 'veronica123', '2008-12-28', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Óscar', 'Ramos', 'oscar.ramos08@yahoo.com', 'oscar123', '2008-08-07', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Natalia', 'Cruz', 'natalia.cruz2008@gmail.com', 'natalia123', '2008-05-19', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Héctor', 'Vásquez', 'hector.vasquez08@outlook.com', 'hector123', '2008-11-02', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- =====================================================
-- 23 USUARIOS ADICIONALES (10-16 AÑOS) - TOTAL 63 USUARIOS
-- =====================================================
-- Usuarios de 10-11 años (2014-2013)
('Brenda', 'Salinas', 'brenda.salinas2024@gmail.com', 'brenda123', '2014-02-20', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Óscar', 'Contreras', 'oscar.contreras14@hotmail.com', 'oscar123', '2014-07-14', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Yamileth', 'Villanueva', 'yamileth.villanueva2014@yahoo.com', 'yamileth123', '2013-04-08', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Renato', 'Benítez', 'renato.benitez13@gmail.com', 'renato123', '2013-10-22', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Ximena', 'Aguilar', 'ximena.aguilar2013@outlook.com', 'ximena123', '2013-12-30', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 12-13 años (2012-2011)
('Esteban', 'Cordero', 'esteban.cordero12@gmail.com', 'esteban123', '2012-06-11', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Jimena', 'Fuentes', 'jimena.fuentes2012@hotmail.com', 'jimena123', '2012-09-05', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Leonardo', 'Salazar', 'leonardo.salazar12@yahoo.com', 'leonardo123', '2012-11-18', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Regina', 'Paredes', 'regina.paredes2011@gmail.com', 'regina123', '2011-03-27', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Emiliano', 'Valdez', 'emiliano.valdez11@outlook.com', 'emiliano123', '2011-08-13', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 14-15 años (2010-2009)
('Renata', 'Zamora', 'renata.zamora2010@gmail.com', 'renata123', '2010-05-19', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Maximiliano', 'Espinoza', 'maximiliano.espinoza10@hotmail.com', 'maximiliano123', '2010-10-02', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Abril', 'Mejía', 'abril.mejia2009@yahoo.com', 'abril123', '2009-02-15', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Dante', 'Carrillo', 'dante.carrillo09@gmail.com', 'dante123', '2009-07-08', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Zoe', 'Miranda', 'zoe.miranda2009@outlook.com', 'zoe123', '2009-11-25', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),

-- Usuarios de 15-16 años (2009-2008)
('Thiago', 'Luna', 'thiago.luna09@gmail.com', 'thiago123', '2009-04-07', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Mía', 'Acosta', 'mia.acosta2008@hotmail.com', 'mia123', '2008-12-15', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Matías', 'Gallegos', 'matias.gallegos08@yahoo.com', 'matias123', '2008-09-03', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Olivia', 'Bustos', 'olivia.bustos2008@gmail.com', 'olivia123', '2008-06-21', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Ian', 'Montoya', 'ian.montoya08@outlook.com', 'ian123', '2008-10-09', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Amanda', 'Ríos', 'amanda.rios2008@gmail.com', 'amanda123', '2008-03-12', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Axel', 'Palacios', 'axel.palacios08@hotmail.com', 'axel123', '2008-08-28', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1),
('Luna', 'Villalobos', 'luna.villalobos2008@yahoo.com', 'luna123', '2008-01-17', 'usuario', DATE_SUB(NOW(), INTERVAL 2 DAY), 1);

-- =====================================================
-- FUNCIÓN AUXILIAR PARA GENERAR FECHAS ALEATORIAS EN LOS ÚLTIMOS 2 DÍAS
-- =====================================================
-- Usaremos DATE_SUB con intervalos variables para simular actividad

-- =====================================================
-- CUESTIONARIOS PARA TODOS LOS USUARIOS
-- =====================================================
-- Simulando respuestas realistas de adolescentes sobre síntomas de anemia

INSERT IGNORE INTO cuestionarios (usu_id, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5, pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, fecha_creacion)
SELECT 
    usu_id,
    -- Pregunta 1: ¿Te sientes cansado/a frecuentemente?
    CASE (usu_id % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Rara vez'
    END,
    -- Pregunta 2: ¿Tienes dificultad para concentrarte?
    CASE ((usu_id + 1) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Nunca'
    END,
    -- Pregunta 3: ¿Te sientes mareado/a al levantarte?
    CASE ((usu_id + 2) % 4)
        WHEN 0 THEN 'A veces'
        WHEN 1 THEN 'Rara vez'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Nunca'
    END,
    -- Pregunta 4: ¿Tienes palidez en la piel?
    CASE ((usu_id + 3) % 4)
        WHEN 0 THEN 'No he notado'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Sí, frecuentemente'
        ELSE 'No'
    END,
    -- Pregunta 5: ¿Consumes alimentos ricos en hierro?
    CASE ((usu_id + 4) % 4)
        WHEN 0 THEN 'Todos los días'
        WHEN 1 THEN '3-4 veces por semana'
        WHEN 2 THEN '1-2 veces por semana'
        ELSE 'Rara vez'
    END,
    -- Pregunta 6: ¿Consumes vitamina C con alimentos con hierro?
    CASE ((usu_id + 5) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Nunca'
    END,
    -- Pregunta 7: ¿Tienes dolores de cabeza frecuentes?
    CASE ((usu_id + 6) % 4)
        WHEN 0 THEN 'A veces'
        WHEN 1 THEN 'Frecuentemente'
        WHEN 2 THEN 'Rara vez'
        ELSE 'Nunca'
    END,
    -- Pregunta 8: ¿Te falta el aire al hacer ejercicio?
    CASE ((usu_id + 7) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente'
        ELSE 'Rara vez'
    END,
    -- Pregunta 9: ¿Tienes uñas quebradizas?
    CASE ((usu_id + 8) % 4)
        WHEN 0 THEN 'Sí'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'No he notado'
        ELSE 'No'
    END,
    -- Pregunta 10: ¿Duermes bien por las noches?
    CASE ((usu_id + 9) % 4)
        WHEN 0 THEN 'Siempre'
        WHEN 1 THEN 'A veces'
        WHEN 2 THEN 'Frecuentemente tengo problemas'
        ELSE 'Rara vez'
    END,
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL (usu_id % 12) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- =====================================================
-- TEST DE CONOCIMIENTO PARA TODOS LOS USUARIOS
-- =====================================================
-- Simulando respuestas variadas con scores calculados

INSERT IGNORE INTO test_conocimiento (usu_id, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5, pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, score, fecha_creacion)
SELECT 
    usu_id,
    -- Pregunta 1: ¿Qué es la anemia?
    CASE (usu_id % 3)
        WHEN 0 THEN 'Falta de hierro en la sangre'
        WHEN 1 THEN 'Baja cantidad de glóbulos rojos'
        ELSE 'Falta de vitamina C'
    END,
    -- Pregunta 2: ¿Qué alimentos son ricos en hierro?
    CASE ((usu_id + 1) % 3)
        WHEN 0 THEN 'Lentejas y espinacas'
        WHEN 1 THEN 'Carne y pescado'
        ELSE 'Frutas cítricas'
    END,
    -- Pregunta 3: ¿La vitamina C ayuda a absorber el hierro?
    CASE ((usu_id + 2) % 2)
        WHEN 0 THEN 'Sí'
        ELSE 'No'
    END,
    -- Pregunta 4: ¿Cuál es un síntoma de anemia?
    CASE ((usu_id + 3) % 3)
        WHEN 0 THEN 'Cansancio'
        WHEN 1 THEN 'Palidez'
        ELSE 'Mareos'
    END,
    -- Pregunta 5: ¿Cuántas veces a la semana debes comer alimentos con hierro?
    CASE ((usu_id + 4) % 3)
        WHEN 0 THEN 'Todos los días'
        WHEN 1 THEN '3-4 veces por semana'
        ELSE '1 vez por semana'
    END,
    -- Pregunta 6: ¿Qué fruta tiene mucha vitamina C?
    CASE ((usu_id + 5) % 3)
        WHEN 0 THEN 'Naranja'
        WHEN 1 THEN 'Limón'
        ELSE 'Mandarina'
    END,
    -- Pregunta 7: ¿El hierro es importante para?
    CASE ((usu_id + 6) % 3)
        WHEN 0 THEN 'Transportar oxígeno'
        WHEN 1 THEN 'Fortalecer los huesos'
        ELSE 'Mejorar la vista'
    END,
    -- Pregunta 8: ¿Qué debes evitar cuando comes alimentos con hierro?
    CASE ((usu_id + 7) % 2)
        WHEN 0 THEN 'Té o café inmediatamente después'
        WHEN 1 THEN 'Comer frutas'
        ELSE 'Beber agua'
    END,
    -- Pregunta 9: ¿Cuánto tiempo tarda el cuerpo en recuperarse de la anemia?
    CASE ((usu_id + 8) % 3)
        WHEN 0 THEN 'Varias semanas'
        WHEN 1 THEN 'Unos días'
        ELSE 'Un año'
    END,
    -- Pregunta 10: ¿Es importante comer variado para prevenir la anemia?
    CASE ((usu_id + 9) % 2)
        WHEN 0 THEN 'Sí'
        ELSE 'No'
    END,
    -- Score calculado: respuestas correctas valen 5 puntos, parciales 3, incorrectas 1
    CASE 
        WHEN (usu_id % 5) = 0 THEN 45  -- Excelente
        WHEN (usu_id % 5) = 1 THEN 38  -- Muy bueno
        WHEN (usu_id % 5) = 2 THEN 32  -- Bueno
        WHEN (usu_id % 5) = 3 THEN 28  -- Regular
        ELSE 25  -- Necesita mejorar
    END,
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL ((usu_id % 12) + 2) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- =====================================================
-- ENCUESTA DE SATISFACCIÓN PARA TODOS LOS USUARIOS
-- =====================================================

INSERT IGNORE INTO encuesta_satisfaccion (usu_id, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5, pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, score, fecha_creacion)
SELECT 
    usu_id,
    -- Pregunta 1: ¿Qué tan fácil es usar la aplicación?
    CASE (usu_id % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 2: ¿La información es clara?
    CASE ((usu_id + 1) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 3: ¿Los juegos son divertidos?
    CASE ((usu_id + 2) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '3'
        ELSE '4'
    END,
    -- Pregunta 4: ¿Aprendiste algo nuevo?
    CASE ((usu_id + 3) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 5: ¿Recomendarías la app a tus amigos?
    CASE ((usu_id + 4) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 6: ¿Los colores y diseño te gustan?
    CASE ((usu_id + 5) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 7: ¿Es fácil navegar por la app?
    CASE ((usu_id + 6) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 8: ¿Los videos son útiles?
    CASE ((usu_id + 7) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '4'
        WHEN 3 THEN '5'
        ELSE '3'
    END,
    -- Pregunta 9: ¿Te gustaría más contenido?
    CASE ((usu_id + 8) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '4'
        WHEN 2 THEN '5'
        WHEN 3 THEN '4'
        ELSE '3'
    END,
    -- Pregunta 10: ¿Calificación general?
    CASE ((usu_id + 9) % 5)
        WHEN 0 THEN '5'
        WHEN 1 THEN '5'
        WHEN 2 THEN '4'
        WHEN 3 THEN '4'
        ELSE '4'
    END,
    -- Score: suma de todas las respuestas (valores 3-5)
    CASE 
        WHEN (usu_id % 5) = 0 THEN 48  -- Excelente
        WHEN (usu_id % 5) = 1 THEN 42  -- Muy bueno
        WHEN (usu_id % 5) = 2 THEN 45  -- Excelente
        WHEN (usu_id % 5) = 3 THEN 40  -- Bueno
        ELSE 35  -- Regular
    END,
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL ((usu_id % 12) + 4) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- =====================================================
-- JUEGO ALIMENTOS PARA TODOS LOS USUARIOS
-- =====================================================
-- Simulando diferentes niveles de desempeño

INSERT IGNORE INTO juego_alimentos (usu_id, respuestas_correctas, total_preguntas, score, fecha_creacion)
SELECT 
    usu_id,
    -- Respuestas correctas variadas (6-10 de 10)
    CASE (usu_id % 5)
        WHEN 0 THEN 10
        WHEN 1 THEN 9
        WHEN 2 THEN 8
        WHEN 3 THEN 7
        ELSE 6
    END,
    10,
    -- Score = respuestas_correctas * 10
    CASE (usu_id % 5)
        WHEN 0 THEN 100
        WHEN 1 THEN 90
        WHEN 2 THEN 80
        WHEN 3 THEN 70
        ELSE 60
    END,
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL ((usu_id % 12) + 6) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- Segunda ronda del juego para algunos usuarios (simulando que jugaron varias veces)
INSERT IGNORE INTO juego_alimentos (usu_id, respuestas_correctas, total_preguntas, score, fecha_creacion)
SELECT 
    usu_id,
    -- Mejora en la segunda ronda
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
    DATE_SUB(NOW(), INTERVAL (usu_id % 2) DAY) + INTERVAL ((usu_id % 12) + 8) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1 AND (usu_id % 3) = 0;  -- Solo algunos usuarios jugaron dos veces

-- =====================================================
-- JUEGO COMBINACIONES PARA TODOS LOS USUARIOS
-- =====================================================

INSERT IGNORE INTO juego_combinaciones (usu_id, combinaciones_correctas, total_combinaciones, tiempo_segundos, score, fecha_creacion)
SELECT 
    usu_id,
    -- Combinaciones correctas (5-8 de 8)
    CASE (usu_id % 4)
        WHEN 0 THEN 8
        WHEN 1 THEN 7
        WHEN 2 THEN 6
        ELSE 5
    END,
    8,
    -- Tiempo variado (45-120 segundos)
    CASE (usu_id % 4)
        WHEN 0 THEN 45 + (usu_id % 15)
        WHEN 1 THEN 60 + (usu_id % 20)
        WHEN 2 THEN 80 + (usu_id % 25)
        ELSE 100 + (usu_id % 20)
    END,
    -- Score basado en combinaciones y tiempo (más combinaciones y menos tiempo = mayor score)
    CASE (usu_id % 4)
        WHEN 0 THEN 850 + (100 - (usu_id % 15))
        WHEN 1 THEN 750 + (80 - (usu_id % 20))
        WHEN 2 THEN 650 + (60 - (usu_id % 25))
        ELSE 550 + (40 - (usu_id % 20))
    END,
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL ((usu_id % 12) + 10) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- Segunda ronda del juego de combinaciones para algunos usuarios
INSERT IGNORE INTO juego_combinaciones (usu_id, combinaciones_correctas, total_combinaciones, tiempo_segundos, score, fecha_creacion)
SELECT 
    usu_id,
    -- Mejora en la segunda ronda
    CASE (usu_id % 4)
        WHEN 0 THEN 8
        WHEN 1 THEN 8
        WHEN 2 THEN 7
        ELSE 6
    END,
    8,
    -- Menos tiempo (mejor desempeño)
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
    DATE_SUB(NOW(), INTERVAL (usu_id % 2) DAY) + INTERVAL ((usu_id % 12) + 12) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1 AND (usu_id % 3) = 0;  -- Solo algunos usuarios jugaron dos veces

-- =====================================================
-- NOTIFICACIONES PARA TODOS LOS USUARIOS (INCLUYENDO ADMIN)
-- =====================================================
-- Al menos 2 notificaciones por usuario con diferentes tipos

-- Notificaciones para usuarios regulares
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    '¡Bienvenido a Inspira Salud!',
    'Gracias por unirte a nuestra comunidad. Aquí encontrarás información valiosa sobre salud y nutrición.',
    'success',
    CASE (usu_id % 3) WHEN 0 THEN 1 ELSE 0 END, -- Algunos usuarios han leído la notificación
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL ((usu_id % 12)) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- Notificaciones para el administrador
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    'Panel de Administración',
    'Bienvenido al panel de administración. Puedes gestionar usuarios, ver estadísticas y responder mensajes de soporte.',
    'system',
    0,
    DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 8 HOUR
FROM usuarios 
WHERE tipo_usuario = 'admin' LIMIT 1;

INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    'Nuevos mensajes de soporte',
    'Tienes nuevos mensajes de soporte de usuarios esperando respuesta. Revisa la sección de Ayuda.',
    'info',
    0,
    DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 10 HOUR
FROM usuarios 
WHERE tipo_usuario = 'admin' LIMIT 1;

INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
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
    CASE (usu_id % 5) WHEN 0 THEN 1 ELSE 0 END, -- Algunos usuarios han leído
    DATE_SUB(NOW(), INTERVAL (usu_id % 2) DAY) + INTERVAL ((usu_id % 12) + 3) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- Notificaciones adicionales para algunos usuarios (tercera notificación)
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    CASE (usu_id % 3)
        WHEN 0 THEN 'Actualización importante'
        WHEN 1 THEN 'Tu perfil está completo'
        ELSE 'Nuevas funciones disponibles'
    END,
    CASE (usu_id % 3)
        WHEN 0 THEN 'Hemos actualizado la aplicación con mejoras en el rendimiento y nuevas características.'
        WHEN 1 THEN 'Excelente trabajo completando tu perfil. Ahora puedes acceder a todas las funcionalidades.'
        ELSE 'Descubre las nuevas funciones en la sección de juegos y evaluaciones.'
    END,
    'system',
    0,
    DATE_SUB(NOW(), INTERVAL (usu_id % 2) DAY) + INTERVAL ((usu_id % 12) + 6) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1 AND (usu_id % 2) = 0; -- Solo la mitad de los usuarios

-- =====================================================
-- MENSAJES DE SOPORTE PARA TODOS LOS USUARIOS
-- =====================================================
-- Cada usuario debe enviar al menos 2 mensajes al administrador:
-- 1. Chat de Soporte (tipo_mensaje = 'consulta')
-- 2. Comparte tu Experiencia (tipo_mensaje = 'experiencia')

-- Obtener ID del administrador
SET @admin_id = (SELECT usu_id FROM usuarios WHERE tipo_usuario = 'admin' LIMIT 1);

-- Mensajes de Chat de Soporte (consulta)
INSERT IGNORE INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
SELECT 
    usu_id,
    NULL, -- Mensaje inicial del usuario, no tiene admin_id aún
    NULL, -- Mensaje inicial, no tiene padre
    'consulta',
    CASE (usu_id % 5)
        WHEN 0 THEN '¿Cómo puedo mejorar mi puntuación en los juegos?'
        WHEN 1 THEN 'No entiendo cómo usar la sección de evaluaciones'
        WHEN 2 THEN '¿Puedo cambiar mi información personal?'
        WHEN 3 THEN 'Tengo dudas sobre los alimentos ricos en hierro'
        ELSE '¿Cómo funciona el sistema de notificaciones?'
    END,
    CASE (usu_id % 5)
        WHEN 0 THEN CONCAT('Hola, he estado jugando los juegos educativos pero mi puntuación no es muy alta. ¿Tienen algún consejo para mejorar? Me gustaría aprender más sobre los alimentos.', CHAR(10), CHAR(10), 'Gracias de antemano.')
        WHEN 1 THEN CONCAT('Buenos días, soy nuevo en la aplicación y me gustaría saber cómo puedo completar las evaluaciones correctamente. ¿Hay alguna guía disponible?')
        WHEN 2 THEN CONCAT('Hola, necesito actualizar mi fecha de nacimiento porque la ingresé incorrectamente. ¿Cómo puedo hacerlo?')
        WHEN 3 THEN CONCAT('Tengo una pregunta sobre la alimentación. ¿Qué alimentos son los mejores para prevenir la anemia? Me gustaría saber más detalles.')
        ELSE CONCAT('Hola, recibí algunas notificaciones pero no estoy seguro de cómo funcionan. ¿Pueden explicarme cómo gestionarlas?')
    END,
    CASE (usu_id % 3) WHEN 0 THEN 1 ELSE 0 END, -- Algunos mensajes han sido leídos
    DATE_SUB(NOW(), INTERVAL (1 + (usu_id % 2)) DAY) + INTERVAL ((usu_id % 12) + 2) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- Respuestas del administrador a algunos mensajes de consulta
INSERT IGNORE INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
SELECT 
    ms.usu_id,
    @admin_id,
    ms.mensaje_id,
    'respuesta',
    CONCAT('Re: ', ms.asunto),
    CASE (ms.usu_id % 5)
        WHEN 0 THEN 'Hola, gracias por tu consulta. Para mejorar tu puntuación te recomiendo practicar más con los juegos y revisar la sección "Aprende" donde encontrarás información valiosa sobre nutrición. ¡Sigue practicando!'
        WHEN 1 THEN 'Hola, bienvenido a la aplicación. Las evaluaciones son muy sencillas, solo debes responder las preguntas con honestidad. Puedes encontrarlas en la sección "Evalúa" del menú principal. ¡Éxitos!'
        WHEN 2 THEN 'Hola, puedes actualizar tu información personal desde la sección "Ajustes" > "Perfil". Si tienes algún problema, no dudes en contactarnos nuevamente.'
        WHEN 3 THEN 'Excelente pregunta. Los alimentos ricos en hierro incluyen carnes rojas, legumbres como lentejas, espinacas y frutos secos. Recuerda combinarlos con vitamina C para una mejor absorción. Revisa la sección "Aprende" para más información.'
        ELSE 'Hola, las notificaciones te mantienen informado sobre actualizaciones y recordatorios importantes. Puedes gestionarlas desde el icono de campana en la parte superior. ¡Esperamos que te sean útiles!'
    END,
    0, -- Respuestas del admin generalmente no leídas por el usuario aún
    DATE_SUB(NOW(), INTERVAL (ms.usu_id % 2) DAY) + INTERVAL ((ms.usu_id % 12) + 4) HOUR
FROM mensajes_soporte ms
WHERE ms.tipo_mensaje = 'consulta' AND ms.mensaje_padre_id IS NULL
AND (ms.usu_id % 2) = 0; -- Respuesta a la mitad de las consultas

-- Mensajes de Comparte tu Experiencia
INSERT IGNORE INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
SELECT 
    usu_id,
    NULL, -- Mensaje inicial del usuario
    NULL, -- Mensaje inicial, no tiene padre
    'experiencia',
    NULL, -- Las experiencias no tienen asunto
    CASE (usu_id % 6)
        WHEN 0 THEN CONCAT('¡Hola! Quería compartirles que la aplicación me ha ayudado mucho a aprender sobre nutrición. Los juegos son muy divertidos y he mejorado mi conocimiento sobre alimentos ricos en hierro. ¡Gracias por esta herramienta tan útil!')
        WHEN 1 THEN CONCAT('Buenos días, llevo usando la app unos días y me encanta. Los videos educativos son muy claros y fáciles de entender. He aprendido cosas que no sabía sobre la anemia y cómo prevenirla. ¡Sigan así!')
        WHEN 2 THEN CONCAT('Quería decirles que la aplicación es excelente. Me gusta mucho la sección de juegos porque aprendo mientras me divierto. Mi familia también está interesada en usar la app. ¡Felicitaciones por el trabajo!')
        WHEN 3 THEN CONCAT('Hola, he estado usando la aplicación y me parece muy completa. Los cuestionarios me ayudan a entender mejor mi salud. Solo tengo una sugerencia: sería genial tener más juegos. ¡Gracias por todo!')
        WHEN 4 THEN CONCAT('¡Excelente aplicación! Los consejos que dan son muy útiles y fáciles de seguir. He compartido la app con mis amigos porque creo que todos deberían conocer esta información. ¡Sigan con el buen trabajo!')
        ELSE CONCAT('Quería compartir mi experiencia positiva con la aplicación. Los tests de conocimiento son desafiantes pero educativos. He mejorado mucho mi comprensión sobre nutrición y salud. ¡Muy recomendada!')
    END,
    CASE (usu_id % 4) WHEN 0 THEN 1 ELSE 0 END, -- Algunos mensajes han sido leídos
    DATE_SUB(NOW(), INTERVAL (usu_id % 2) DAY) + INTERVAL ((usu_id % 12) + 5) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

-- Respuestas del administrador a algunas experiencias
INSERT IGNORE INTO mensajes_soporte (usu_id, admin_id, mensaje_padre_id, tipo_mensaje, asunto, mensaje, leido, fecha_creacion)
SELECT 
    ms.usu_id,
    @admin_id,
    ms.mensaje_id,
    'respuesta',
    'Gracias por compartir tu experiencia',
    CASE (ms.usu_id % 6)
        WHEN 0 THEN '¡Qué alegría saber que la aplicación te está siendo útil! Nos encanta escuchar que los juegos te ayudan a aprender. Sigue explorando todas las funcionalidades. ¡Gracias por tu feedback positivo!'
        WHEN 1 THEN 'Muchas gracias por tus palabras. Nos alegra saber que los videos educativos son claros y útiles. Tu aprendizaje es nuestra mayor satisfacción. ¡Sigue así!'
        WHEN 2 THEN '¡Excelente! Nos emociona saber que disfrutas la aplicación y que incluso tu familia está interesada. Estamos trabajando en nuevas funcionalidades. ¡Gracias por compartir!'
        WHEN 3 THEN 'Gracias por tu feedback. Nos alegra saber que los cuestionarios te ayudan. Tu sugerencia sobre más juegos la tomaremos en cuenta para futuras actualizaciones. ¡Sigue usando la app!'
        WHEN 4 THEN '¡Qué maravilloso saber que compartes la aplicación con tus amigos! Eso nos motiva mucho. Gracias por ser parte de nuestra comunidad y por tu apoyo.'
        ELSE 'Gracias por compartir tu experiencia. Nos alegra saber que los tests te desafían y educan al mismo tiempo. Tu progreso es importante para nosotros. ¡Sigue aprendiendo!'
    END,
    0, -- Respuestas del admin generalmente no leídas por el usuario aún
    DATE_SUB(NOW(), INTERVAL (ms.usu_id % 2) DAY) + INTERVAL ((ms.usu_id % 12) + 7) HOUR
FROM mensajes_soporte ms
WHERE ms.tipo_mensaje = 'experiencia' AND ms.mensaje_padre_id IS NULL
AND (ms.usu_id % 3) = 0; -- Respuesta a un tercio de las experiencias

-- =====================================================
-- NOTIFICACIONES PARA EL ADMINISTRADOR (126 notificaciones)
-- =====================================================
-- Una notificación por cada mensaje enviado por los 63 usuarios (63 consultas + 63 experiencias = 126)

-- Notificaciones del administrador por cada consulta enviada (63 notificaciones)
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    @admin_id,
    CONCAT('Nueva consulta de soporte - ', ms.asunto),
    CONCAT('El usuario ha enviado una consulta: "', ms.asunto, '". Revisa el panel de administración para responder.'),
    'info',
    0,
    ms.fecha_creacion
FROM mensajes_soporte ms
WHERE ms.tipo_mensaje = 'consulta' AND ms.mensaje_padre_id IS NULL;

-- Notificaciones del administrador por cada experiencia compartida (63 notificaciones)
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    @admin_id,
    'Nueva experiencia compartida',
    CONCAT('Un usuario ha compartido su experiencia con la aplicación. Revisa el panel de administración en la sección de Ayuda.'),
    'info',
    0,
    ms.fecha_creacion
FROM mensajes_soporte ms
WHERE ms.tipo_mensaje = 'experiencia' AND ms.mensaje_padre_id IS NULL;

-- Notificaciones de eventos próximos y recordatorios (solo usuarios regulares)
INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    'Recordatorio: Completa tus evaluaciones semanales',
    'No olvides completar tus cuestionarios y tests de esta semana para mantener un seguimiento completo de tu salud.',
    'warning',
    0,
    DATE_SUB(NOW(), INTERVAL (usu_id % 3) DAY) + INTERVAL ((usu_id % 12) + 8) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1;

INSERT IGNORE INTO notificaciones (usu_id, titulo, mensaje, tipo, leida, fecha_creacion)
SELECT 
    usu_id,
    'Evento próximo: Taller de nutrición',
    'Te invitamos a participar en nuestro próximo taller virtual sobre alimentación saludable. ¡No te lo pierdas!',
    'info',
    0,
    DATE_SUB(NOW(), INTERVAL (usu_id % 2) DAY) + INTERVAL ((usu_id % 12) + 9) HOUR
FROM usuarios 
WHERE tipo_usuario = 'usuario' AND usu_id > 1 AND (usu_id % 2) = 0; -- Solo la mitad de los usuarios

-- =====================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- =====================================================

SELECT '=== RESUMEN DE DATOS INSERTADOS ===' AS '';
SELECT 'Total usuarios:' AS Tipo, COUNT(*) AS Cantidad FROM usuarios WHERE tipo_usuario = 'usuario';
SELECT 'Total administradores:' AS Tipo, COUNT(*) AS Cantidad FROM usuarios WHERE tipo_usuario = 'admin';
SELECT 'Total cuestionarios:' AS Tipo, COUNT(*) AS Cantidad FROM cuestionarios;
SELECT 'Total tests de conocimiento:' AS Tipo, COUNT(*) AS Cantidad FROM test_conocimiento;
SELECT 'Total encuestas de satisfacción:' AS Tipo, COUNT(*) AS Cantidad FROM encuesta_satisfaccion;
SELECT 'Total juegos de alimentos:' AS Tipo, COUNT(*) AS Cantidad FROM juego_alimentos;
SELECT 'Total juegos de combinaciones:' AS Tipo, COUNT(*) AS Cantidad FROM juego_combinaciones;
SELECT 'Total notificaciones:' AS Tipo, COUNT(*) AS Cantidad FROM notificaciones;
SELECT 'Total mensajes de soporte:' AS Tipo, COUNT(*) AS Cantidad FROM mensajes_soporte;

-- Mostrar algunos usuarios de ejemplo
SELECT '=== EJEMPLO DE USUARIOS ===' AS '';
SELECT usu_id, usu_nombres, usu_apellidos, usu_email, fecha_nacimiento, 
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad,
       fecha_registro
FROM usuarios 
WHERE tipo_usuario = 'usuario' 
ORDER BY usu_id 
LIMIT 5;

-- Mostrar estadísticas de actividad
SELECT '=== ESTADÍSTICAS DE ACTIVIDAD ===' AS '';
SELECT 
    u.usu_nombres,
    u.usu_apellidos,
    COUNT(DISTINCT c.cuestionario_id) AS cuestionarios,
    COUNT(DISTINCT t.test_id) AS tests,
    COUNT(DISTINCT e.encuesta_id) AS encuestas,
    COUNT(DISTINCT ja.juego_id) AS juegos_alimentos,
    COUNT(DISTINCT jc.juego_id) AS juegos_combinaciones
FROM usuarios u
LEFT JOIN cuestionarios c ON u.usu_id = c.usu_id
LEFT JOIN test_conocimiento t ON u.usu_id = t.usu_id
LEFT JOIN encuesta_satisfaccion e ON u.usu_id = e.usu_id
LEFT JOIN juego_alimentos ja ON u.usu_id = ja.usu_id
LEFT JOIN juego_combinaciones jc ON u.usu_id = jc.usu_id
WHERE u.tipo_usuario = 'usuario'
GROUP BY u.usu_id, u.usu_nombres, u.usu_apellidos
ORDER BY u.usu_id
LIMIT 10;

-- =====================================================
-- NOTAS
-- =====================================================
-- 1. Todos los usuarios tienen contraseña: [nombre]123 (ej: maria123, santiago123)
-- 2. Las fechas de registro simulan que llevan 2 días usando la app
-- 3. Las actividades están distribuidas en los últimos 2 días con horas variadas
-- 4. Los scores son variados para simular diferentes niveles de desempeño
-- 5. Algunos usuarios tienen múltiples intentos en los juegos (simulando práctica)
-- 6. Cada usuario tiene al menos 2 notificaciones:
--    - Notificación de bienvenida (tipo: success)
--    - Notificación variada (info, warning, success según usuario)
--    - Algunos usuarios tienen una tercera notificación (tipo: system)
-- 7. Cada usuario ha enviado 2 mensajes al administrador:
--    - 1 mensaje de Chat de Soporte (tipo_mensaje: 'consulta') con asunto variado
--    - 1 mensaje de Comparte tu Experiencia (tipo_mensaje: 'experiencia')
-- 8. El administrador ha respondido a algunos mensajes:
--    - Aproximadamente 50% de las consultas tienen respuesta
--    - Aproximadamente 33% de las experiencias tienen respuesta
-- =====================================================

