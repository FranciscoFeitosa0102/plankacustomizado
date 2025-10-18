@echo off

echo 🛑 Parando sistema Planka personalizado...
echo.

REM Parar containers
docker-compose -f docker-compose.custom.yml down

echo ✅ Sistema parado com sucesso!
echo.
echo Para iniciar novamente, execute: docker-setup.bat
echo.
pause
