# 🏆 Implementación de Funcionalidad de Resultados

## 📋 Resumen

Se ha implementado la funcionalidad completa para mostrar los resultados de las encuestas con sus puntajes (scores) y un trofeo cuando ambas encuestas están completadas.

## ✅ Cambios Realizados

### 1. Base de Datos

**Archivo:** `bd/script_agregar_scores.sql`

- ✅ Agregado campo `score INT` a la tabla `test_conocimiento`
- ✅ Agregado campo `score INT` a la tabla `encuesta_satisfaccion`

**Para aplicar los cambios:**
```sql
-- Ejecutar en MySQL:
USE login_db;
ALTER TABLE test_conocimiento ADD COLUMN score INT DEFAULT 0 AFTER pregunta10;
ALTER TABLE encuesta_satisfaccion ADD COLUMN score INT DEFAULT 0 AFTER pregunta10;
```

O ejecutar el script completo:
```bash
mysql -u root -p login_db < "bd/script_agregar_scores.sql"
```

### 2. API (Node.js/Express)

**Archivo:** `api/Api/index.js`

#### Funcionalidades agregadas:

1. **Función `calcularScore(preguntas)`**
   - Calcula el score total basado en las respuestas
   - Soporta valores numéricos (1-5) y texto (siempre, frecuentemente, etc.)
   - Asigna puntos según el valor de cada respuesta

2. **Modificación de endpoints:**
   - `POST /test-conocimiento` - Ahora calcula y guarda el score automáticamente
   - `POST /encuesta-satisfaccion` - Ahora calcula y guarda el score automáticamente

3. **Nuevo endpoint:**
   - `GET /resultados/:usu_id` - Obtiene los resultados más recientes de ambas encuestas con sus scores

**Ejemplo de respuesta del endpoint `/resultados/:usu_id`:**
```json
{
  "success": true,
  "usu_id": 1,
  "test_conocimiento": {
    "test_id": 5,
    "score": 8,
    "fecha_creacion": "2025-11-09T16:20:00.000Z",
    "completado": true
  },
  "encuesta_satisfaccion": {
    "encuesta_id": 3,
    "score": 41,
    "fecha_creacion": "2025-11-09T16:25:00.000Z",
    "completado": true
  }
}
```

### 3. Android App

#### Archivos creados/modificados:

1. **`android/app/src/main/java/com/ejemplo/salud/model/ResultadosResponse.kt`** (NUEVO)
   - Modelo de datos para la respuesta del endpoint de resultados

2. **`android/app/src/main/java/com/ejemplo/salud/servicio/WebServices.kt`** (MODIFICADO)
   - Agregado método `obtenerResultados(usu_id: Int)`
   - Agregados imports necesarios (`GET`, `Path`)

3. **`android/app/src/main/java/com/ejemplo/salud/ResultadosActivity.kt`** (NUEVO)
   - Activity que muestra los resultados
   - Carga los datos desde la API
   - Muestra los scores de ambas encuestas
   - Muestra el trofeo cuando ambas encuestas están completadas

4. **`android/app/src/main/res/layout/activity_resultados.xml`** (NUEVO)
   - Layout con el diseño de resultados
   - Incluye:
     - Header con logo y perfil
     - Sección "RESULTADOS"
     - Sección "TEST DE CONOCIMIENTO Y PRÁCTICAS SOBRE ANEMIA" con score
     - Sección "ENCUESTA DE SATISFACCIÓN" con score
     - Imagen del trofeo
     - Barra de navegación inferior

5. **`android/app/src/main/java/com/ejemplo/salud/EvaluaActivity.kt`** (MODIFICADO)
   - Conectado el botón "RESULTADOS" con `ResultadosActivity`

6. **`android/app/src/main/AndroidManifest.xml`** (MODIFICADO)
   - Agregada `ResultadosActivity` al manifest

### 4. Recursos

**Imagen del trofeo:**
- La imagen `trofeo.jpg` debe copiarse manualmente desde `imagenes/trofeo.jpg` a `android/app/src/main/res/drawable/trofeo.jpg`

**Comando para copiar (Windows PowerShell):**
```powershell
Copy-Item "imagenes\trofeo.jpg" "android\app\src\main\res\drawable\trofeo.jpg"
```

## 🚀 Pasos para Implementar

### Paso 1: Actualizar Base de Datos

1. Abre MySQL Workbench o tu cliente MySQL
2. Ejecuta:
```sql
USE login_db;
ALTER TABLE test_conocimiento ADD COLUMN score INT DEFAULT 0 AFTER pregunta10;
ALTER TABLE encuesta_satisfaccion ADD COLUMN score INT DEFAULT 0 AFTER pregunta10;
```

### Paso 2: Reiniciar la API

```bash
cd "api/Api"
node index.js
```

Deberías ver que la API está funcionando correctamente.

### Paso 3: Copiar Imagen del Trofeo

Copia manualmente `imagenes/trofeo.jpg` a `android/app/src/main/res/drawable/trofeo.jpg`

### Paso 4: Compilar y Ejecutar la App

1. Abre el proyecto en Android Studio
2. Sincroniza Gradle
3. Compila y ejecuta la app

## 📱 Flujo de Usuario

1. Usuario completa el **Test de Conocimiento** → Se guarda con score calculado
2. Usuario completa la **Encuesta de Satisfacción** → Se guarda con score calculado
3. Usuario va a **Evalúa** → Toca **RESULTADOS**
4. Se muestra:
   - Score del Test de Conocimiento
   - Score de la Encuesta de Satisfacción
   - Trofeo (si ambas encuestas están completadas)

## 🔍 Cálculo de Scores

El sistema calcula los scores de la siguiente manera:

- **Valores numéricos (1-5):** Se suman directamente
- **Texto:**
  - "siempre", "muy bueno", "excelente" → 5 puntos
  - "frecuentemente", "bueno" → 4 puntos
  - "a veces", "regular" → 3 puntos
  - "rara vez", "malo" → 2 puntos
  - "nunca", "muy malo" → 1 punto
  - Cualquier otra respuesta → 1 punto

## 🐛 Solución de Problemas

### Si no se muestran los resultados:

1. **Verifica que las encuestas se hayan completado:**
   - Revisa en la BD que existan registros en `test_conocimiento` y `encuesta_satisfaccion`

2. **Verifica que los scores se hayan guardado:**
   ```sql
   SELECT test_id, score FROM test_conocimiento WHERE usu_id = 1 ORDER BY fecha_creacion DESC LIMIT 1;
   SELECT encuesta_id, score FROM encuesta_satisfaccion WHERE usu_id = 1 ORDER BY fecha_creacion DESC LIMIT 1;
   ```

3. **Verifica los logs de la API:**
   - Deberías ver: `✅ Resultados obtenidos: { testConocimiento: X, encuestaSatisfaccion: Y }`

4. **Verifica que la imagen del trofeo esté en drawable:**
   - Debe estar en: `android/app/src/main/res/drawable/trofeo.jpg`

### Si el trofeo no aparece:

- Verifica que ambas encuestas estén completadas (`completado: true`)
- Verifica que la imagen `trofeo.jpg` esté en la carpeta `drawable`

## 📊 Estructura de Datos

### Tabla: test_conocimiento
```sql
- test_id (INT, PRIMARY KEY)
- usu_id (INT, FOREIGN KEY)
- pregunta1-10 (VARCHAR)
- score (INT) ← NUEVO
- fecha_creacion (DATETIME)
```

### Tabla: encuesta_satisfaccion
```sql
- encuesta_id (INT, PRIMARY KEY)
- usu_id (INT, FOREIGN KEY)
- pregunta1-10 (VARCHAR)
- score (INT) ← NUEVO
- fecha_creacion (DATETIME)
```

## ✅ Checklist de Verificación

- [ ] Script SQL ejecutado en la BD
- [ ] Campos `score` agregados a las tablas
- [ ] API reiniciada con los nuevos cambios
- [ ] Imagen `trofeo.jpg` copiada a `drawable`
- [ ] App compilada sin errores
- [ ] ResultadosActivity agregada al AndroidManifest
- [ ] Botón "RESULTADOS" conectado correctamente
- [ ] Endpoint `/resultados/:usu_id` funciona correctamente
- [ ] Scores se calculan y guardan correctamente
- [ ] Trofeo aparece cuando ambas encuestas están completadas

---

**Fecha de implementación:** 2025-11-09
**Versión:** 1.0.0

