# 📊 Script de Datos Realistas para App de Salud

## 📋 Descripción

Este script crea datos de prueba realistas para la aplicación, incluyendo:

- ✅ **1 Administrador** con credenciales de acceso
- ✅ **20 Usuarios adolescentes** (10-16 años) con datos realistas
- ✅ **Todos los cuestionarios completados** para cada usuario
- ✅ **Todos los tests de conocimiento completados** con scores variados
- ✅ **Todas las encuestas de satisfacción completadas** con scores variados
- ✅ **Juegos completados** (alimentos y combinaciones) con múltiples intentos
- ✅ **Fechas realistas** simulando actividad de los últimos 2 días

## 🚀 Uso

### Ejecutar el Script

```bash
# Desde MySQL CLI
mysql -u root -p login_db < bd/datos_usuarios_realistas.sql

# O desde MySQL Workbench
# Abrir el archivo y ejecutarlo
```

### Credenciales del Administrador

- **Email:** `admin@inspirasalud.com`
- **Contraseña:** `admin123`

### Credenciales de Usuarios

Todos los usuarios tienen contraseñas en formato: `[nombre]123`

Ejemplos:
- `maria.gonzalez2024@gmail.com` → Contraseña: `maria123`
- `santiago.martinez14@hotmail.com` → Contraseña: `santiago123`
- `valentina.lopez2014@yahoo.com` → Contraseña: `valentina123`

## 👥 Usuarios Creados

### Distribución por Edad:
- **10-11 años (2014-2013):** 5 usuarios
- **12-13 años (2012-2011):** 5 usuarios
- **14-15 años (2010-2009):** 5 usuarios
- **15-16 años (2009-2008):** 5 usuarios

### Nombres Realistas:
Los usuarios tienen nombres y apellidos comunes en países de habla hispana:
- María González, Santiago Martínez, Valentina López
- Diego Hernández, Sofía Ramírez, Mateo Torres
- Isabella Flores, Sebastián Rivera, Camila Morales
- Y más...

### Correos Realistas:
Los correos electrónicos simulan direcciones reales de adolescentes:
- `maria.gonzalez2024@gmail.com`
- `santiago.martinez14@hotmail.com`
- `valentina.lopez2014@yahoo.com`
- `diego.hernandez13@gmail.com`
- Etc.

## 📊 Datos Incluidos por Usuario

Cada usuario tiene:

1. **Cuestionario de Anemia** (1 registro)
   - 10 preguntas con respuestas variadas y realistas
   - Fecha: distribuida en los últimos 2 días

2. **Test de Conocimiento** (1 registro)
   - 10 preguntas sobre anemia y nutrición
   - Score variado: 25-45 puntos
   - Fecha: distribuida en los últimos 2 días

3. **Encuesta de Satisfacción** (1 registro)
   - 10 preguntas con calificaciones 3-5
   - Score variado: 35-48 puntos
   - Fecha: distribuida en los últimos 2 días

4. **Juego de Alimentos** (1-2 registros)
   - Respuestas correctas: 6-10 de 10
   - Score: 60-100 puntos
   - Algunos usuarios tienen 2 intentos (simulando práctica)

5. **Juego de Combinaciones** (1-2 registros)
   - Combinaciones correctas: 5-8 de 8
   - Tiempo: 45-120 segundos
   - Score: 550-900 puntos
   - Algunos usuarios tienen 2 intentos

## ⏰ Simulación de Actividad

- **Fecha de registro:** Hace 2-3 días
- **Actividades:** Distribuidas en los últimos 2 días
- **Horas variadas:** Simula uso en diferentes momentos del día
- **Múltiples sesiones:** Algunos usuarios tienen múltiples intentos en juegos

## 📈 Variabilidad de Datos

Los datos están diseñados para parecer reales:

- **Scores variados:** No todos los usuarios tienen el mismo desempeño
- **Respuestas diversas:** Las respuestas varían según el usuario
- **Mejora con la práctica:** Algunos usuarios mejoran en segundos intentos
- **Fechas distribuidas:** Las actividades están distribuidas en diferentes momentos

## 🔍 Verificación

Después de ejecutar el script, puedes verificar los datos con:

```sql
-- Ver todos los usuarios
SELECT usu_id, usu_nombres, usu_apellidos, usu_email, 
       fecha_nacimiento, 
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad,
       fecha_registro
FROM usuarios 
WHERE tipo_usuario = 'usuario'
ORDER BY edad;

-- Ver estadísticas por usuario
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
GROUP BY u.usu_id, u.usu_nombres, u.usu_apellidos;

-- Ver scores promedio
SELECT 
    AVG(t.score) AS promedio_test_conocimiento,
    AVG(e.score) AS promedio_encuesta_satisfaccion,
    AVG(ja.score) AS promedio_juego_alimentos,
    AVG(jc.score) AS promedio_juego_combinaciones
FROM usuarios u
LEFT JOIN test_conocimiento t ON u.usu_id = t.usu_id
LEFT JOIN encuesta_satisfaccion e ON u.usu_id = e.usu_id
LEFT JOIN juego_alimentos ja ON u.usu_id = ja.usu_id
LEFT JOIN juego_combinaciones jc ON u.usu_id = jc.usu_id
WHERE u.tipo_usuario = 'usuario';
```

## ⚠️ Notas Importantes

1. **Contraseñas:** Todas las contraseñas están en texto plano. Para producción, usar el módulo de seguridad (`security.js`) para cifrarlas.

2. **Datos de prueba:** Estos datos son solo para desarrollo y pruebas. No usar en producción.

3. **Fechas:** Las fechas se generan dinámicamente usando `NOW()` y `DATE_SUB`, por lo que siempre reflejarán los últimos 2 días desde la ejecución.

4. **Idempotencia:** El script usa `INSERT IGNORE` para evitar duplicados si se ejecuta múltiples veces.

## 📝 Lista Completa de Usuarios

1. María González - 10 años - maria.gonzalez2024@gmail.com
2. Santiago Martínez - 10 años - santiago.martinez14@hotmail.com
3. Valentina López - 11 años - valentina.lopez2014@yahoo.com
4. Diego Hernández - 11 años - diego.hernandez13@gmail.com
5. Sofía Ramírez - 11 años - sofia.ramirez2013@outlook.com
6. Mateo Torres - 12 años - mateo.torres12@gmail.com
7. Isabella Flores - 12 años - isabella.flores2012@hotmail.com
8. Sebastián Rivera - 12 años - sebastian.rivera12@yahoo.com
9. Camila Morales - 13 años - camila.morales2011@gmail.com
10. Nicolás García - 13 años - nicolas.garcia11@outlook.com
11. Ana Sánchez - 14 años - ana.sanchez2010@gmail.com
12. Lucas Jiménez - 14 años - lucas.jimenez10@hotmail.com
13. Emma Díaz - 15 años - emma.diaz2009@yahoo.com
14. Daniel Moreno - 15 años - daniel.moreno09@gmail.com
15. Lucía Vargas - 15 años - lucia.vargas2009@outlook.com
16. Alejandro Castro - 15 años - alejandro.castro09@gmail.com
17. Paula Romero - 16 años - paula.romero2008@hotmail.com
18. Andrés Mendoza - 16 años - andres.mendoza08@yahoo.com
19. Fernanda Ortega - 16 años - fernanda.ortega2008@gmail.com
20. Javier Silva - 16 años - javier.silva08@outlook.com

---

**Última actualización:** 2025-01-09  
**Versión:** 1.0.0

