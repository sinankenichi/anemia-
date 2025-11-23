@echo off
REM =====================================================
REM Script de Backup Mejorado para Base de Datos (Windows)
REM =====================================================
REM Este script crea backups automáticos de la base de datos
REM con compresión y rotación de archivos
REM =====================================================

REM Configuración
set DB_HOST=localhost
set DB_NAME=login_db
set DB_USER=root
set DB_PASSWORD=123456789
set BACKUP_DIR=backups
set RETENTION_DAYS=30

REM Crear directorio de backups si no existe
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Nombre del archivo de backup
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
set mytime=%mytime: =0%
set TIMESTAMP=%mydate%_%mytime%
set BACKUP_FILE=%BACKUP_DIR%\backup_%DB_NAME%_%TIMESTAMP%.sql

echo ========================================
echo Iniciando backup de base de datos
echo ========================================
echo Base de datos: %DB_NAME%
echo Host: %DB_HOST%
echo Fecha: %DATE% %TIME%
echo.

REM Crear backup
echo Creando backup...
mysqldump -h %DB_HOST% -u %DB_USER% -p%DB_PASSWORD% --single-transaction --routines --triggers --events --quick --lock-tables=false %DB_NAME% > "%BACKUP_FILE%" 2>nul

if %ERRORLEVEL% EQU 0 (
    echo [OK] Backup SQL creado: %BACKUP_FILE%
    
    REM Comprimir con 7-Zip si está disponible, sino usar PowerShell
    where 7z >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo Comprimiendo backup con 7-Zip...
        7z a -tgzip "%BACKUP_FILE%.gz" "%BACKUP_FILE%" >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            del "%BACKUP_FILE%"
            set FINAL_FILE=%BACKUP_FILE%.gz
            echo [OK] Backup comprimido: %FINAL_FILE%
        ) else (
            echo [ERROR] Error al comprimir backup
            set FINAL_FILE=%BACKUP_FILE%
        )
    ) else (
        echo [INFO] 7-Zip no encontrado, usando PowerShell para comprimir...
        powershell -Command "Compress-Archive -Path '%BACKUP_FILE%' -DestinationPath '%BACKUP_FILE%.zip' -Force" >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            del "%BACKUP_FILE%"
            set FINAL_FILE=%BACKUP_FILE%.zip
            echo [OK] Backup comprimido: %FINAL_FILE%
        ) else (
            echo [WARNING] No se pudo comprimir, manteniendo archivo SQL
            set FINAL_FILE=%BACKUP_FILE%
        )
    )
    
    REM Limpiar backups antiguos
    echo Limpiando backups antiguos (mas de %RETENTION_DAYS% dias)...
    forfiles /p "%BACKUP_DIR%" /m "backup_%DB_NAME%_*.sql*" /d -%RETENTION_DAYS% /c "cmd /c del @path" >nul 2>nul
    echo [OK] Limpieza completada
    
    echo.
    echo ========================================
    echo Backup completado exitosamente
    echo Archivo: %FINAL_FILE%
    echo ========================================
    exit /b 0
) else (
    echo [ERROR] Error al crear backup
    exit /b 1
)

