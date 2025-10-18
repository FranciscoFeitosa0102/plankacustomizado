@echo off

echo 🚀 Iniciando Docker Desktop...
echo.

REM Tentar iniciar o Docker Desktop
echo ℹ️  Tentando iniciar o Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe" >nul 2>&1

if %errorlevel% neq 0 (
    echo ❌ Não foi possível iniciar o Docker Desktop automaticamente
    echo.
    echo 📋 Para iniciar manualmente:
    echo    1. Pressione Win + R
    echo    2. Digite: "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo    3. Pressione Enter
    echo.
    echo 💡 Ou procure por "Docker Desktop" no menu Iniciar
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop está sendo iniciado...
echo.
echo ⏳ Aguarde o Docker Desktop inicializar (pode levar alguns minutos)
echo.
echo 🔍 Verificando status...

REM Aguardar o Docker inicializar
:wait_loop
timeout /t 5 /nobreak >nul
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ⏳ Ainda inicializando...
    goto wait_loop
)

echo ✅ Docker Desktop está rodando!
echo.
echo 🎯 Agora você pode executar: docker-setup.bat
echo.
pause
