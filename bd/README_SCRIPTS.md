# 📚 Documentación de Scripts de Base de Datos

## 📄 Script Principal

### `script_completo.sql` ⭐ **USAR ESTE**

Este es el **único script que necesitas ejecutar**. Contiene:

✅ Creación de la base de datos `login_db`  
✅ Creación de todas las tablas:
   - `usuarios`
   - `tokens_recuperacion`
   - `cuestionarios`
   - `test_conocimiento` (con campo `score`)
   - `encuesta_satisfaccion` (con campo `score`)

✅ Actualización automática de tablas existentes (agrega `score` si no existe)  
✅ Datos de prueba  
✅ Verificaciones

**Características:**
- ✅ **Idempotente**: Se puede ejecutar múltiples veces sin errores
- ✅ **Compatible**: Funciona con bases de datos nuevas y existentes
- ✅ **Completo**: Incluye todos los campos necesarios desde el inicio

## 🚀 Cómo Usar

### Opción 1: Desde MySQL Workbench o phpMyAdmin

1. Abre el archivo `script_completo.sql`
2. Copia todo el contenido
3. Pégalo en tu cliente MySQL
4. Ejecuta el script

### Opción 2: Desde Línea de Comandos

```bash
mysql -u root -p < "bd/script_completo.sql"
```

O si ya tienes la base de datos:

```bash
mysql -u root -p login_db < "bd/script_completo.sql"
```

### Opción 3: Desde MySQL CLI

```sql
source bd/script_completo.sql;
```

## 📋 Scripts Antiguos (Ya no necesarios)

Los siguientes scripts están **deprecados** y ya están incluidos en `script_completo.sql`:

### ❌ `script_cuestionario.sql` (DEPRECADO)
- **No usar**: Este script crea la tabla `cuestionarios` sin el campo `usu_id`
- **Reemplazado por**: `script_completo.sql` que incluye la tabla correcta

### ❌ `script_agregar_scores.sql` (DEPRECADO)
- **No usar**: Este script solo agrega campos de score
- **Reemplazado por**: `script_completo.sql` que incluye los campos desde el inicio y los agrega automáticamente si no existen

## 🔍 Verificación

Después de ejecutar el script, verifica que todo esté correcto:

```sql
USE login_db;

-- Verificar tablas
SHOW TABLES;

-- Verificar estructura de test_conocimiento (debe tener campo score)
DESCRIBE test_conocimiento;

-- Verificar estructura de encuesta_satisfaccion (debe tener campo score)
DESCRIBE encuesta_satisfaccion;

-- Verificar datos de prueba
SELECT * FROM usuarios;
```

## 📊 Estructura de Tablas

### Tabla: usuarios
```sql
- usu_id (INT, PRIMARY KEY, AUTO_INCREMENT)
- usu_nombres (VARCHAR(100))
- usu_apellidos (VARCHAR(100))
- usu_email (VARCHAR(255), UNIQUE)
- usu_password (VARCHAR(255))
- fecha_registro (DATETIME)
- activo (TINYINT(1), DEFAULT 1)
```

### Tabla: test_conocimiento
```sql
- test_id (INT, PRIMARY KEY, AUTO_INCREMENT)
- usu_id (INT, FOREIGN KEY)
- pregunta1-10 (VARCHAR(255))
- score (INT, DEFAULT 0) ← Campo de puntuación
- fecha_creacion (DATETIME)
```

### Tabla: encuesta_satisfaccion
```sql
- encuesta_id (INT, PRIMARY KEY, AUTO_INCREMENT)
- usu_id (INT, FOREIGN KEY)
- pregunta1-10 (VARCHAR(255))
- score (INT, DEFAULT 0) ← Campo de puntuación
- fecha_creacion (DATETIME)
```

## ⚠️ Notas Importantes

1. **Solo usa `script_completo.sql`** - Es el único script necesario
2. **El script es seguro** - Se puede ejecutar múltiples veces
3. **Los scores se calculan automáticamente** - La API los calcula al guardar encuestas
4. **Datos de prueba incluidos** - Usuario: `test@test.com`, Contraseña: `123456`

## 🐛 Solución de Problemas

### Error: "Table already exists"
- ✅ **Normal**: El script usa `CREATE TABLE IF NOT EXISTS`, así que es seguro
- Si aparece este error, significa que las tablas ya existen y el script continúa normalmente

### Error: "Duplicate column name 'score'"
- ✅ **Normal**: El script detecta si el campo existe antes de agregarlo
- Si aparece este error, significa que el campo ya existe y el script continúa normalmente

### Error: "Unknown database 'login_db'"
- ✅ **Normal**: El script crea la base de datos automáticamente
- Si aparece este error, verifica que tengas permisos para crear bases de datos

## ✅ Checklist

- [ ] Script `script_completo.sql` ejecutado
- [ ] Base de datos `login_db` creada
- [ ] Todas las tablas creadas correctamente
- [ ] Campo `score` presente en `test_conocimiento`
- [ ] Campo `score` presente en `encuesta_satisfaccion`
- [ ] Usuario de prueba creado
- [ ] Verificaciones ejecutadas sin errores

---

**Última actualización:** 2025-11-09  
**Versión del script:** 2.0.0

