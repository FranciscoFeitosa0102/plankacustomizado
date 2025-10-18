@echo off

echo 🔧 Solução de Problemas - Docker Desktop
echo ========================================
echo.

REM Verificar se Docker Desktop está instalado
echo ℹ️  Verificando se Docker Desktop está instalado...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker não está instalado!
    echo.
    echo 📥 Para instalar o Docker Desktop:
    echo    1. Acesse: https://www.docker.com/products/docker-desktop/
    echo    2. Baixe o Docker Desktop para Windows
    echo    3. Execute o instalador
    echo    4. Reinicie o computador
    echo    5. Execute este script novamente
    echo.
    pause
    exit /b 1
)

echo ✅ Docker está instalado

REM Verificar se Docker Desktop está rodando
echo ℹ️  Verificando se Docker Desktop está rodando...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Desktop não está rodando!
    echo.
    echo 🚀 Para iniciar o Docker Desktop:
    echo    1. Procure por "Docker Desktop" no menu Iniciar
    echo    2. Clique para abrir o Docker Desktop
    echo    3. Aguarde o Docker inicializar (pode levar alguns minutos)
    echo    4. Verifique se o ícone do Docker na bandeja do sistema está verde
    echo    5. Execute este script novamente
    echo.
    echo 💡 Dica: O Docker Desktop precisa estar rodando para usar os containers
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop está rodando

REM Verificar se o WSL2 está configurado (se necessário)
echo ℹ️  Verificando configuração do WSL2...
wsl --status >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  WSL2 não está configurado
    echo.
    echo 📋 Para configurar o WSL2:
    echo    1. Abra o PowerShell como Administrador
    echo    2. Execute: wsl --install
    echo    3. Reinicie o computador
    echo    4. Configure o Docker Desktop para usar WSL2
    echo.
) else (
    echo ✅ WSL2 está configurado
)

REM Verificar recursos do sistema
echo ℹ️  Verificando recursos do sistema...
echo.
echo 📊 Recursos necessários:
echo    - RAM: Mínimo 4GB (Recomendado 8GB)
echo    - Espaço em disco: Mínimo 10GB livres
echo    - CPU: 2 cores (Recomendado 4 cores)
echo.

REM Verificar portas
echo ℹ️  Verificando se as portas estão livres...
netstat -an | findstr ":3000" >nul
if %errorlevel% equ 0 (
    echo ⚠️  Porta 3000 está em uso
)

netstat -an | findstr ":1337" >nul
if %errorlevel% equ 0 (
    echo ⚠️  Porta 1337 está em uso
)

netstat -an | findstr ":5432" >nul
if %errorlevel% equ 0 (
    echo ⚠️  Porta 5432 está em uso
)

netstat -an | findstr ":80" >nul
if %errorlevel% equ 0 (
    echo ⚠️  Porta 80 está em uso
)

echo.
echo ✅ Verificação concluída!
echo.
echo 🎯 Próximos passos:
echo    1. Se o Docker Desktop não estava rodando, inicie-o agora
echo    2. Aguarde o Docker inicializar completamente
echo    3. Execute: docker-setup.bat
echo.
pause
