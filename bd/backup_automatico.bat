@echo off
REM =====================================================
REM Script de Respaldo Automatizado de Base de Datos (Windows)
REM =====================================================
REM Este script realiza respaldos automáticos de la base de datos
REM y los almacena con fecha y hora en el directorio de backups
REM =====================================================

REM Configuración
set DB_HOST=localhost
set DB_USER=root
set DB_PASSWORD=123456789
set DB_NAME=login_db
set BACKUP_DIR=backups
set DATE=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set DATE=%DATE: =0%
set BACKUP_FILE=%BACKUP_DIR%\backup_%DB_NAME%_%DATE%.sql
set RETENTION_DAYS=30

REM Crear directorio de backups si no existe
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo [%date% %time%] Iniciando respaldo de la base de datos: %DB_NAME%
echo [%date% %time%] Archivo de respaldo: %BACKUP_FILE%

REM Realizar respaldo
mysqldump -h %DB_HOST% -u %DB_USER% -p%DB_PASSWORD% --single-transaction --routines --triggers --events %DB_NAME% > "%BACKUP_FILE%"

REM Verificar si el respaldo fue exitoso
if %errorlevel% equ 0 (
    echo [%date% %time%] Respaldo completado exitosamente
    echo [%date% %time%] Archivo: %BACKUP_FILE%
    
    REM Limpiar backups antiguos (Windows)
    forfiles /p "%BACKUP_DIR%" /m backup_%DB_NAME%_*.sql /d -%RETENTION_DAYS% /c "cmd /c del @path" 2>nul
    
    exit /b 0
) else (
    echo [%date% %time%] Error al realizar el respaldo
    if exist "%BACKUP_FILE%" del "%BACKUP_FILE%"
    exit /b 1
)

