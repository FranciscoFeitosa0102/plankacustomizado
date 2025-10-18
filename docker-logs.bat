@echo off

echo 📋 Visualizando logs do sistema Planka...
echo.

REM Mostrar logs de todos os serviços
docker-compose -f docker-compose.custom.yml logs -f

pause
