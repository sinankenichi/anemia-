# 🎮 IMPLEMENTACIÓN DE JUEGOS DIDÁCTICOS

## 📅 Fecha: $(date)

Este documento detalla la implementación completa de dos juegos didácticos relacionados con el tema de anemia, hierro y vitamina C.

---

## ✅ RESUMEN DE IMPLEMENTACIÓN

Se han creado **dos juegos didácticos** completamente funcionales que se integran en la sección "Evalúa" y muestran sus puntajes en la pantalla de resultados.

---

## 🎯 JUEGO 1: "¿QUÉ ALIMENTO ES?"

### **Descripción:**
Juego de preguntas tipo quiz sobre alimentos ricos en hierro y vitamina C. El usuario debe responder 10 preguntas de opción múltiple.

### **Características:**
- ✅ 10 preguntas educativas sobre alimentos
- ✅ 4 opciones por pregunta
- ✅ Feedback visual inmediato (verde = correcto, rojo = incorrecto)
- ✅ Progreso visible durante el juego
- ✅ Cálculo automático de score (respuestas correctas × 10)
- ✅ Guardado automático de resultados en BD

### **Preguntas Incluidas:**
1. ¿Cuál de estos alimentos es rico en hierro? (Lentejas)
2. ¿Qué fruta es rica en vitamina C? (Limón)
3. ¿Cuál alimento ayuda a absorber mejor el hierro? (Tomate)
4. ¿Qué pescado es rico en hierro? (Anchoveta)
5. ¿Qué legumbre es rica en hierro? (Todas las anteriores)
6. ¿Qué cítrico es rico en vitamina C? (Mandarina)
7. ¿Cuál combinación favorece la absorción de hierro? (Lentejas + Limón)
8. ¿Qué parte del animal es rica en hierro? (Sangrecita)
9. ¿Qué verdura es rica en vitamina C? (Tomate)
10. ¿Cuál es la mejor combinación para prevenir anemia? (Sangrecita + Tomate)

### **Archivos Creados:**
- `android/app/src/main/java/com/ejemplo/salud/JuegoAlimentosActivity.kt`
- `android/app/src/main/res/layout/activity_juego_alimentos.xml`

---

## 🎯 JUEGO 2: "COMBINA Y GANA"

### **Descripción:**
Juego de memoria donde el usuario debe encontrar pares de alimentos que se combinan para favorecer la absorción de hierro. Grid de 4×4 con 16 tarjetas (8 pares).

### **Características:**
- ✅ Grid de 4×4 (16 tarjetas)
- ✅ 8 pares de combinaciones alimentarias
- ✅ Timer en tiempo real
- ✅ Feedback visual (verde = par encontrado)
- ✅ Score basado en combinaciones correctas y tiempo
- ✅ Guardado automático de resultados en BD

### **Pares de Combinaciones:**
1. Lentejas + Limón
2. Sangrecita + Tomate
3. Anchoveta + Mandarina
4. Garbanzos + Naranja
5. Hígado + Limón
6. Lentejas + Mandarina
7. Sangrecita + Limón
8. Anchoveta + Tomate

### **Cálculo de Score:**
- Combinaciones correctas × 15 puntos
- Bonus por velocidad: 30 - (tiempo_segundos / 10)
- Score máximo: 120 puntos (8 combinaciones × 15)

### **Archivos Creados:**
- `android/app/src/main/java/com/ejemplo/salud/JuegoCombinacionesActivity.kt`
- `android/app/src/main/res/layout/activity_juego_combinaciones.xml`

---

## 🗄️ BASE DE DATOS

### **Tablas Creadas:**

#### **1. juego_alimentos**
```sql
CREATE TABLE IF NOT EXISTS juego_alimentos (
    juego_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL,
    respuestas_correctas INT DEFAULT 0,
    total_preguntas INT DEFAULT 10,
    score INT DEFAULT 0,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE
);
```

#### **2. juego_combinaciones**
```sql
CREATE TABLE IF NOT EXISTS juego_combinaciones (
    juego_id INT PRIMARY KEY AUTO_INCREMENT,
    usu_id INT NOT NULL,
    combinaciones_correctas INT DEFAULT 0,
    total_combinaciones INT DEFAULT 8,
    tiempo_segundos INT DEFAULT 0,
    score INT DEFAULT 0,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usu_id) REFERENCES usuarios(usu_id) ON DELETE CASCADE
);
```

### **Archivos Modificados:**
- `bd/script_completo.sql` - Agregadas las dos nuevas tablas

---

## 🔌 API - ENDPOINTS

### **Endpoints Creados:**

#### **1. POST /juego-alimentos**
Guarda el resultado del juego "¿Qué alimento es?"

**Request:**
```json
{
  "usu_id": 1,
  "respuestas_correctas": 8,
  "total_preguntas": 10
}
```

**Response:**
```json
{
  "success": true,
  "message": "Resultado del juego guardado exitosamente",
  "juego_id": 1,
  "score": 80,
  "respuestas_correctas": 8,
  "total_preguntas": 10
}
```

#### **2. POST /juego-combinaciones**
Guarda el resultado del juego "Combina y Gana"

**Request:**
```json
{
  "usu_id": 1,
  "combinaciones_correctas": 6,
  "total_combinaciones": 8,
  "tiempo_segundos": 120
}
```

**Response:**
```json
{
  "success": true,
  "message": "Resultado del juego guardado exitosamente",
  "juego_id": 1,
  "score": 108,
  "combinaciones_correctas": 6,
  "total_combinaciones": 8,
  "tiempo_segundos": 120
}
```

#### **3. GET /resultados/:usu_id (Actualizado)**
Ahora incluye los resultados de los juegos:

**Response:**
```json
{
  "success": true,
  "usu_id": 1,
  "test_conocimiento": { ... },
  "encuesta_satisfaccion": { ... },
  "juego_alimentos": {
    "juego_id": 1,
    "score": 80,
    "respuestas_correctas": 8,
    "total_preguntas": 10,
    "completado": true
  },
  "juego_combinaciones": {
    "juego_id": 1,
    "score": 108,
    "combinaciones_correctas": 6,
    "total_combinaciones": 8,
    "tiempo_segundos": 120,
    "completado": true
  }
}
```

### **Archivos Modificados:**
- `api/Api/index.js` - Agregados endpoints POST y actualizado GET /resultados

---

## 📱 APP ANDROID

### **Modelos de Datos Creados:**
- `JuegoAlimentosRequest.kt` - Request para guardar resultado del juego 1
- `JuegoAlimentosResponse.kt` - Response del juego 1
- `JuegoCombinacionesRequest.kt` - Request para guardar resultado del juego 2
- `JuegoCombinacionesResponse.kt` - Response del juego 2

### **Modelos Actualizados:**
- `ResultadosResponse.kt` - Agregados `juego_alimentos` y `juego_combinaciones`

### **Activities Creadas:**
- `JuegoAlimentosActivity.kt` - Lógica del juego de preguntas
- `JuegoCombinacionesActivity.kt` - Lógica del juego de memoria

### **Layouts Creados:**
- `activity_juego_alimentos.xml` - UI del juego de preguntas
- `activity_juego_combinaciones.xml` - UI del juego de memoria (grid 4×4)

### **Activities Modificadas:**
- `EvaluaActivity.kt` - Agregada navegación a los dos juegos
- `ResultadosActivity.kt` - Agregada visualización de scores de juegos
- `WebServices.kt` - Agregados endpoints de los juegos

### **Layouts Modificados:**
- `activity_evalua.xml` - Agregados botones para los dos juegos
- `activity_resultados.xml` - Agregadas secciones para mostrar scores de juegos

### **AndroidManifest.xml:**
- Agregadas las dos nuevas Activities

---

## 🎨 DISEÑO Y UX

### **Estilo Visual:**
- ✅ Consistente con el diseño del proyecto
- ✅ Colores: Rosa (#FF4081) y Azul (#FF4285F4)
- ✅ Cards con esquinas redondeadas
- ✅ Feedback visual inmediato
- ✅ Animaciones suaves

### **Navegación:**
- ✅ Botón de retroceso en ambos juegos
- ✅ Navegación desde EvaluaActivity
- ✅ Integración con pantalla de resultados

---

## 📊 FUNCIONALIDADES

### **Juego 1 - ¿Qué alimento es?:**
- ✅ Preguntas secuenciales
- ✅ Feedback inmediato (verde/rojo)
- ✅ Progreso visible
- ✅ Guardado automático al finalizar
- ✅ Manejo de errores de red

### **Juego 2 - Combina y Gana:**
- ✅ Grid interactivo 4×4
- ✅ Timer en tiempo real
- ✅ Lógica de memoria (voltear tarjetas)
- ✅ Validación de pares
- ✅ Guardado automático al finalizar
- ✅ Manejo de errores de red

---

## ✅ VERIFICACIÓN

### **Base de Datos:**
- ✅ Tablas creadas correctamente
- ✅ Foreign keys configuradas
- ✅ Índices agregados para performance

### **API:**
- ✅ Endpoints funcionando
- ✅ Validación de datos
- ✅ Cálculo de scores
- ✅ Manejo de errores

### **App Android:**
- ✅ Sin errores de compilación
- ✅ Sin errores de linting
- ✅ Navegación funcional
- ✅ Integración completa con resultados

---

## 🎯 RESULTADOS

### **Pantalla de Resultados:**
Los scores de los juegos ahora se muestran en la pantalla de resultados junto con:
- Test de Conocimiento
- Encuesta de Satisfacción
- **Juego 1: ¿Qué alimento es?** (nuevo)
- **Juego 2: Combina y Gana** (nuevo)

### **Trofeo:**
El trofeo se muestra cuando **todas** las actividades están completadas:
- ✅ Test de Conocimiento
- ✅ Encuesta de Satisfacción
- ✅ Juego 1
- ✅ Juego 2

---

## 📝 NOTAS IMPORTANTES

1. **Scores:**
   - Juego 1: respuestas_correctas × 10
   - Juego 2: (combinaciones_correctas × 15) + bonus_tiempo

2. **Persistencia:**
   - Los resultados se guardan automáticamente al finalizar cada juego
   - Se almacenan en la BD vinculados al usuario

3. **Navegación:**
   - Los juegos están accesibles desde la pantalla "Evalúa"
   - Los resultados se muestran en la pantalla "Resultados"

4. **Educación:**
   - Ambos juegos enseñan sobre alimentos ricos en hierro y vitamina C
   - Refuerzan el aprendizaje de manera interactiva y divertida

---

**Implementación completada exitosamente.** ✅

