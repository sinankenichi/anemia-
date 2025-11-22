#!/bin/bash

# =====================================================
# Script de Respaldo Automatizado de Base de Datos
# =====================================================
# Este script realiza respaldos automáticos de la base de datos
# y los almacena con fecha y hora en el directorio de backups
# =====================================================

# Configuración
DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD="123456789"
DB_NAME="login_db"
BACKUP_DIR="./backups"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${DB_NAME}_${DATE}.sql"
RETENTION_DAYS=30  # Mantener backups por 30 días

# Crear directorio de backups si no existe
mkdir -p "$BACKUP_DIR"

# Función para log
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Función para limpiar backups antiguos
cleanup_old_backups() {
    log "Limpiando backups antiguos (más de $RETENTION_DAYS días)..."
    find "$BACKUP_DIR" -name "backup_${DB_NAME}_*.sql" -type f -mtime +$RETENTION_DAYS -delete
    log "Limpieza completada"
}

# Realizar respaldo
log "Iniciando respaldo de la base de datos: $DB_NAME"
log "Archivo de respaldo: $BACKUP_FILE"

# Ejecutar mysqldump
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    "$DB_NAME" > "$BACKUP_FILE"

# Verificar si el respaldo fue exitoso
if [ $? -eq 0 ]; then
    # Comprimir el respaldo
    log "Comprimiendo respaldo..."
    gzip "$BACKUP_FILE"
    BACKUP_FILE="${BACKUP_FILE}.gz"
    
    # Obtener tamaño del archivo
    FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log "✅ Respaldo completado exitosamente"
    log "   Archivo: $BACKUP_FILE"
    log "   Tamaño: $FILE_SIZE"
    
    # Limpiar backups antiguos
    cleanup_old_backups
    
    exit 0
else
    log "❌ Error al realizar el respaldo"
    # Eliminar archivo parcial si existe
    [ -f "$BACKUP_FILE" ] && rm "$BACKUP_FILE"
    exit 1
fi

