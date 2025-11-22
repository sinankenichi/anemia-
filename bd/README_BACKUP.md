# 📦 Sistema de Respaldo Automatizado de Base de Datos

## 📋 Descripción

Este sistema permite realizar respaldos automáticos de la base de datos `login_db` con las siguientes características:

- ✅ Respaldo completo de la base de datos
- ✅ Compresión automática (Linux/Mac)
- ✅ Limpieza automática de backups antiguos
- ✅ Registro de operaciones
- ✅ Scripts para Windows y Linux/Mac

## 🚀 Uso Manual

### Linux/Mac:
```bash
chmod +x backup_automatico.sh
./backup_automatico.sh
```

### Windows:
```cmd
backup_automatico.bat
```

## ⏰ Configuración de Tareas Programadas

### Windows (Task Scheduler):

1. Abrir "Programador de tareas"
2. Crear tarea básica
3. Nombre: "Respaldo BD Login"
4. Disparador: Diario a las 2:00 AM
5. Acción: Iniciar programa
6. Programa: `C:\ruta\al\script\backup_automatico.bat`

### Linux (Cron):

```bash
# Editar crontab
crontab -e

# Agregar línea para respaldo diario a las 2:00 AM
0 2 * * * /ruta/completa/al/script/backup_automatico.sh >> /var/log/db_backup.log 2>&1
```

### Mac (LaunchAgent):

Crear archivo `~/Library/LaunchAgents/com.salud.dbbackup.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.salud.dbbackup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/ruta/completa/al/script/backup_automatico.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
```

Luego ejecutar:
```bash
launchctl load ~/Library/LaunchAgents/com.salud.dbbackup.plist
```

## 📁 Estructura de Backups

Los backups se guardan en el directorio `backups/` con el formato:
- `backup_login_db_YYYYMMDD_HHMMSS.sql` (Linux/Mac: también `.sql.gz`)

## ⚙️ Configuración

Editar las variables al inicio de cada script:

```bash
DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD="tu_contraseña"
DB_NAME="login_db"
RETENTION_DAYS=30  # Días que se mantienen los backups
```

## 🔄 Restaurar un Backup

### Linux/Mac:
```bash
gunzip < backups/backup_login_db_20250109_020000.sql.gz | mysql -u root -p login_db
```

### Windows:
```cmd
mysql -u root -p login_db < backups\backup_login_db_20250109_020000.sql
```

## 📊 Monitoreo

Los logs se muestran en la consola. Para guardar logs en archivo:

```bash
./backup_automatico.sh >> /var/log/db_backup.log 2>&1
```

## ⚠️ Notas Importantes

1. **Seguridad**: Los scripts contienen credenciales en texto plano. Para producción, usar variables de entorno o archivos de configuración seguros.

2. **Permisos**: Asegurarse de que el usuario que ejecuta el script tenga permisos para:
   - Escribir en el directorio de backups
   - Acceder a MySQL con las credenciales especificadas

3. **Espacio en disco**: Monitorear el espacio disponible, especialmente si se mantienen muchos backups.

4. **Pruebas**: Probar la restauración de backups periódicamente para asegurar que funcionan correctamente.

