#!/bin/bash

# =====================================================
# Script de Backup Mejorado para Base de Datos
# =====================================================
# Este script crea backups automáticos de la base de datos
# con encriptación y rotación de archivos
# =====================================================

# Configuración
DB_HOST="${DB_HOST:-localhost}"
DB_NAME="${DB_NAME:-login_db}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-123456789}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
ENCRYPT="${ENCRYPT:-false}"
ENCRYPT_PASSWORD="${ENCRYPT_PASSWORD:-}"

# Crear directorio de backups si no existe
mkdir -p "$BACKUP_DIR"

# Nombre del archivo de backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_${DB_NAME}_${TIMESTAMP}.sql"
COMPRESSED_FILE="${BACKUP_FILE}.gz"
ENCRYPTED_FILE="${COMPRESSED_FILE}.enc"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Iniciando backup de base de datos${NC}"
echo -e "${GREEN}========================================${NC}"
echo "Base de datos: $DB_NAME"
echo "Host: $DB_HOST"
echo "Fecha: $(date)"
echo ""

# Crear backup
echo -e "${YELLOW}Creando backup...${NC}"
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --quick \
    --lock-tables=false \
    "$DB_NAME" > "$BACKUP_FILE" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup SQL creado: $BACKUP_FILE${NC}"
    
    # Comprimir
    echo -e "${YELLOW}Comprimiendo backup...${NC}"
    gzip -f "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Backup comprimido: $COMPRESSED_FILE${NC}"
        
        # Encriptar si está habilitado
        if [ "$ENCRYPT" = "true" ] && [ -n "$ENCRYPT_PASSWORD" ]; then
            echo -e "${YELLOW}Encriptando backup...${NC}"
            openssl enc -aes-256-cbc -salt -in "$COMPRESSED_FILE" -out "$ENCRYPTED_FILE" -pass pass:"$ENCRYPT_PASSWORD" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Backup encriptado: $ENCRYPTED_FILE${NC}"
                rm -f "$COMPRESSED_FILE"
                FINAL_FILE="$ENCRYPTED_FILE"
            else
                echo -e "${RED}✗ Error al encriptar backup${NC}"
                FINAL_FILE="$COMPRESSED_FILE"
            fi
        else
            FINAL_FILE="$COMPRESSED_FILE"
        fi
        
        # Obtener tamaño del archivo
        FILE_SIZE=$(du -h "$FINAL_FILE" | cut -f1)
        echo -e "${GREEN}✓ Tamaño del backup: $FILE_SIZE${NC}"
        
        # Limpiar backups antiguos
        echo -e "${YELLOW}Limpiando backups antiguos (más de $RETENTION_DAYS días)...${NC}"
        find "$BACKUP_DIR" -name "backup_${DB_NAME}_*.sql.gz*" -type f -mtime +$RETENTION_DAYS -delete
        echo -e "${GREEN}✓ Limpieza completada${NC}"
        
        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}Backup completado exitosamente${NC}"
        echo -e "${GREEN}Archivo: $FINAL_FILE${NC}"
        echo -e "${GREEN}========================================${NC}"
        exit 0
    else
        echo -e "${RED}✗ Error al comprimir backup${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Error al crear backup${NC}"
    exit 1
fi

