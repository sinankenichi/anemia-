# Instrucciones para Configurar API y Base de Datos

## 📋 Requisitos Previos

1. **MySQL** instalado y corriendo
2. **Node.js** instalado (versión 14 o superior)
3. **npm** instalado

## 🗄️ Configuración de Base de Datos

### Paso 1: Crear la Base de Datos

1. Abre MySQL (puedes usar MySQL Workbench, phpMyAdmin, o línea de comandos)
2. Ejecuta el script completo:

```bash
# Desde la línea de comandos de MySQL:
mysql -u root -p < "D:\Prototipos\prueba1\Prueba nueva noviembre\bd\script_completo.sql"
```

O copia y pega el contenido de `bd/script_completo.sql` en tu cliente MySQL.

### Paso 2: Verificar la Creación

El script creará:
- ✅ Base de datos `login_db`
- ✅ Tabla `usuarios` (nombres, apellidos, correo, contraseña)
- ✅ Tabla `tokens_recuperacion` (para recuperación de contraseña)
- ✅ Tabla `cuestionarios` (vinculada a usuarios)

### Paso 3: Configurar Credenciales

Si tu contraseña de MySQL no es `123456789`, edita el archivo:
- `api/Api/index.js` (línea 41) y cambia la contraseña

## 🚀 Configuración de la API

### Paso 1: Instalar Dependencias

```bash
cd "D:\Prototipos\prueba1\Prueba nueva noviembre\api\Api"
npm install
```

### Paso 2: Iniciar el Servidor

```bash
node index.js
```

O si tienes `nodemon` instalado:

```bash
npm run dev
```

Deberías ver:
```
Servidor corriendo en el puerto: 3000
Conexion exitosa a base de datos: login_db
```

## 📱 Configuración de la App Android

### Paso 1: Verificar IP del Servidor

1. Abre `android/app/src/main/java/com/ejemplo/salud/servicio/WebServices.kt`
2. Verifica que la IP en `BASE_URL` sea la IP de tu computadora en la red local
3. Para encontrar tu IP:
   - Windows: `ipconfig` en CMD
   - Busca "IPv4 Address" en la conexión activa

### Paso 2: Compilar y Ejecutar

1. Abre el proyecto en Android Studio
2. Sincroniza Gradle
3. Ejecuta la app en un dispositivo o emulador

## 🔄 Flujo Completo de la Aplicación

### 1. Registro de Usuario
- **Pantalla:** RegistroActivity
- **Endpoint:** `POST /registro`
- **Datos:** nombres, apellidos, correo, contraseña
- **Resultado:** Usuario creado y datos guardados localmente

### 2. Login
- **Pantalla:** LoginActivity
- **Endpoint:** `POST /login`
- **Datos:** correo, contraseña
- **Resultado:** Sesión iniciada, datos del usuario guardados

### 3. Recuperación de Contraseña
- **Pantalla 1:** ForgotPasswordActivity
  - **Endpoint:** `POST /forgot-password`
  - **Datos:** correo
  - **Resultado:** Token generado (en producción se enviaría por email)

- **Pantalla 2:** ChangePasswordActivity
  - **Endpoint:** `POST /change-password`
  - **Datos:** correo, nuevaContraseña, confirmarContraseña
  - **Resultado:** Contraseña actualizada

### 4. Cuestionario
- **Pantalla:** CuestionarioActivity
- **Endpoint:** `POST /cuestionario`
- **Datos:** usu_id, pregunta1-10
- **Resultado:** Cuestionario guardado vinculado al usuario

## 📊 Estructura de la Base de Datos

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

### Tabla: tokens_recuperacion
```sql
- token_id (INT, PRIMARY KEY, AUTO_INCREMENT)
- usu_email (VARCHAR(255))
- token (VARCHAR(255), UNIQUE)
- fecha_creacion (DATETIME)
- fecha_expiracion (DATETIME)
- usado (TINYINT(1), DEFAULT 0)
```

### Tabla: cuestionarios
```sql
- cuestionario_id (INT, PRIMARY KEY, AUTO_INCREMENT)
- usu_id (INT, FOREIGN KEY -> usuarios.usu_id)
- pregunta1-10 (VARCHAR(255))
- fecha_creacion (DATETIME)
```

## 🔧 Endpoints de la API

### POST /registro
Registra un nuevo usuario

**Request:**
```json
{
  "nombres": "Juan",
  "apellidos": "Pérez",
  "correo": "juan@example.com",
  "contraseña": "123456"
}
```

**Response:**
```json
{
  "message": "Usuario registrado exitosamente",
  "success": true,
  "user": {
    "id": 1,
    "nombres": "Juan",
    "apellidos": "Pérez",
    "correo": "juan@example.com"
  }
}
```

### POST /login
Inicia sesión

**Request:**
```json
{
  "correo": "juan@example.com",
  "contraseña": "123456"
}
```

**Response:**
```json
{
  "message": "Login exitoso",
  "success": true,
  "user": {
    "id": 1,
    "nombres": "Juan",
    "apellidos": "Pérez",
    "correo": "juan@example.com"
  }
}
```

### POST /forgot-password
Solicita recuperación de contraseña

**Request:**
```json
{
  "correo": "juan@example.com"
}
```

### POST /change-password
Cambia la contraseña

**Request:**
```json
{
  "correo": "juan@example.com",
  "nuevaContraseña": "nueva123",
  "confirmarContraseña": "nueva123"
}
```

### POST /cuestionario
Envía el cuestionario

**Request:**
```json
{
  "usu_id": 1,
  "pregunta1": "Respuesta 1",
  "pregunta2": "Respuesta 2",
  ...
  "pregunta10": "Respuesta 10"
}
```

## ⚠️ Notas Importantes

1. **Seguridad:** En producción, las contraseñas deben estar hasheadas (bcrypt, etc.)
2. **Tokens:** El sistema de tokens de recuperación está implementado pero en producción debe enviarse por email
3. **IP del Servidor:** Asegúrate de que la app y el servidor estén en la misma red WiFi
4. **Puerto:** El servidor corre en el puerto 3000, verifica que no esté en uso

## 🐛 Solución de Problemas

### Error: "No se puede conectar a la API"
- Verifica que la API esté corriendo
- Verifica la IP en WebServices.kt
- Verifica que el firewall permita conexiones en puerto 3000

### Error: "Error en el servidor"
- Revisa los logs de la API en la consola
- Verifica la conexión a MySQL
- Verifica que las tablas existan

### Error: "Usuario no encontrado"
- Verifica que el usuario esté registrado en la BD
- Verifica que el correo sea correcto

## ✅ Verificación Final

1. ✅ Base de datos creada y conectada
2. ✅ API corriendo en puerto 3000
3. ✅ App Android compilada y ejecutándose
4. ✅ IP del servidor configurada correctamente
5. ✅ Flujo completo funcionando:
   - Registro → Login → Cuestionario
   - Login → Forgot Password → Change Password

