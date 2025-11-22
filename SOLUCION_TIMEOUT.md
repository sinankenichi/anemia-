# 🔧 Solución al Problema de Timeout

## ❌ Problema Identificado

Los logs muestran que la app Android está intentando conectarse pero recibe:
```
java.net.SocketTimeoutException: timeout
```

Esto significa que:
1. La app está enviando las peticiones correctamente ✅
2. Pero el servidor no está respondiendo ❌

## 🔍 Causa Raíz

El servidor Express estaba configurado para escuchar **solo en localhost** (`127.0.0.1`), lo que significa que:
- ✅ Funciona desde la misma máquina (localhost)
- ❌ **NO funciona desde otros dispositivos en la red** (como tu teléfono Android)

## ✅ Solución Aplicada

### Cambio en `api/Api/index.js`:

**Antes:**
```javascript
app.listen(PUERTO, async () => {
  // Solo escucha en localhost
});
```

**Después:**
```javascript
const HOST = "0.0.0.0"; // Escuchar en TODAS las interfaces de red
app.listen(PUERTO, HOST, async () => {
  // Ahora es accesible desde cualquier dispositivo en la red
});
```

### ¿Qué significa `0.0.0.0`?

- `localhost` o `127.0.0.1` = Solo accesible desde la misma computadora
- `0.0.0.0` = Accesible desde **cualquier dispositivo** en la red local

## 🚀 Pasos para Probar

### 1. Reiniciar la API

```bash
cd "api/Api"
node index.js
```

**Deberías ver:**
```
🚀 Servidor corriendo en:
   - Local: http://localhost:3000
   - Red: http://192.168.100.5:3000
   - Todas las interfaces: http://0.0.0.0:3000
✅ Conexión a base de datos verificada exitosamente
```

### 2. Verificar desde el Navegador

Abre en tu navegador (en la misma PC):
- `http://localhost:3000/health`

Deberías recibir:
```json
{
  "status": "ok",
  "database": "connected",
  "timestamp": "..."
}
```

### 3. Verificar desde el Teléfono Android

Ahora la app debería poder conectarse. Cuando hagas login o registro, deberías ver en los logs de la API:

```
📥 [2025-11-09T...] POST /login
   IP: ::ffff:192.168.100.X
   Body: {"correo":"test@test.com","contraseña":"123456"}
✅ Login exitoso para usuario: test@test.com
```

## 🔥 Verificar Firewall de Windows

Si aún no funciona, verifica que el firewall permita conexiones en el puerto 3000:

### Opción 1: Deshabilitar temporalmente el firewall (solo para probar)
1. Ve a: Configuración → Seguridad de Windows → Firewall
2. Desactiva temporalmente el firewall
3. Prueba de nuevo

### Opción 2: Permitir el puerto 3000 en el firewall
1. Abre PowerShell como Administrador
2. Ejecuta:
```powershell
New-NetFirewallRule -DisplayName "Node.js API" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
```

## 📱 Verificar IP en la App Android

Asegúrate de que la IP en `WebServices.kt` sea correcta:

```kotlin
const val BASE_URL = "http://192.168.100.5:3000"
```

Para encontrar tu IP:
```bash
# En Windows PowerShell o CMD:
ipconfig

# Busca "IPv4 Address" en tu adaptador de red activo
```

## 🐛 Si Aún No Funciona

### 1. Verifica que la API esté corriendo
- Deberías ver los logs cuando inicias `node index.js`
- Si no ves nada, hay un error en el código

### 2. Verifica la conexión de red
- Asegúrate de que tu PC y tu teléfono estén en la **misma red WiFi**
- No uses datos móviles en el teléfono

### 3. Prueba desde el navegador del teléfono
- Abre Chrome en tu teléfono
- Ve a: `http://192.168.100.5:3000/health`
- Si funciona aquí, la app también debería funcionar

### 4. Verifica los logs de la API
- Cuando la app intente conectarse, deberías ver logs en la consola de la API
- Si no ves ningún log, el problema es de red/firewall

## 📊 Logs Esperados

### Cuando la app se conecta correctamente:

**En la API:**
```
📥 [2025-11-09T16:14:20.300Z] POST /registro
   IP: ::ffff:192.168.100.123
   Body: {"apellidos":"asdsadad","contraseña":"123456","correo":"keni@gmail.com","nombres":"sdsad"}
✅ Usuario registrado exitosamente, ID: 2
```

**En la App Android:**
```
okhttp.OkHttpClient: --> POST http://192.168.100.5:3000/registro
okhttp.OkHttpClient: <-- 200 OK (tiempo de respuesta)
```

### Si hay timeout (problema de red):

**En la App Android:**
```
okhttp.OkHttpClient: --> POST http://192.168.100.5:3000/registro
okhttp.OkHttpClient: <-- HTTP FAILED: java.net.SocketTimeoutException: timeout
```

**En la API:**
- ❌ **NO deberías ver ningún log** (la petición nunca llegó al servidor)

## ✅ Checklist Final

- [ ] API reiniciada con los nuevos cambios
- [ ] API muestra la IP de red en los logs
- [ ] Firewall configurado para permitir puerto 3000
- [ ] PC y teléfono en la misma red WiFi
- [ ] IP correcta en `WebServices.kt`
- [ ] Prueba desde navegador del teléfono funciona
- [ ] Logs de la API muestran peticiones entrantes

---

**Fecha:** 2025-11-09
**Problema:** SocketTimeoutException
**Solución:** Cambiar `app.listen()` para escuchar en `0.0.0.0` en lugar de solo localhost

