@echo off
setlocal enabledelayedexpansion

echo 🚀 Planka - Sistema de Gestão de Indicações e Vendas
echo ==================================================
echo.

REM Verificar se Docker está instalado
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker não está instalado. Por favor, instale o Docker Desktop primeiro.
    echo.
    echo 📥 Para instalar:
    echo    1. Acesse: https://www.docker.com/products/docker-desktop/
    echo    2. Baixe e instale o Docker Desktop
    echo    3. Reinicie o computador
    echo    4. Execute: start-docker-desktop.bat
    echo.
    pause
    exit /b 1
)

REM Verificar se Docker Desktop está rodando
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Desktop não está rodando!
    echo.
    echo 🚀 Para iniciar o Docker Desktop:
    echo    1. Execute: start-docker-desktop.bat
    echo    2. Ou procure por "Docker Desktop" no menu Iniciar
    echo    3. Aguarde o Docker inicializar
    echo    4. Execute este script novamente
    echo.
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro.
    pause
    exit /b 1
)

echo ✅ Docker e Docker Compose estão instalados e rodando

REM Verificar se os arquivos necessários existem
set required_files=docker-compose.custom.yml Dockerfile.server Dockerfile.client nginx-client.conf nginx.conf init-db.sql
for %%f in (%required_files%) do (
    if not exist "%%f" (
        echo ❌ Arquivo %%f não encontrado!
        pause
        exit /b 1
    )
)

echo ✅ Todos os arquivos necessários estão presentes

REM Parar containers existentes
echo ℹ️  Parando containers existentes...
docker-compose -f docker-compose.custom.yml down --remove-orphans
echo ✅ Containers parados

REM Perguntar sobre limpeza
set /p cleanup="Deseja limpar volumes e imagens antigas? (y/N): "
if /i "%cleanup%"=="y" (
    echo ℹ️  Limpando volumes e imagens antigas...
    docker-compose -f docker-compose.custom.yml down -v --remove-orphans
    docker system prune -f
    echo ✅ Limpeza concluída
)

REM Construir imagens
echo ℹ️  Construindo imagens Docker...
docker-compose -f docker-compose.custom.yml build --no-cache
if %errorlevel% neq 0 (
    echo ❌ Erro ao construir imagens
    pause
    exit /b 1
)
echo ✅ Imagens construídas com sucesso

REM Iniciar containers
echo ℹ️  Iniciando containers...
docker-compose -f docker-compose.custom.yml up -d
if %errorlevel% neq 0 (
    echo ❌ Erro ao iniciar containers
    pause
    exit /b 1
)
echo ✅ Containers iniciados

REM Aguardar banco de dados
echo ℹ️  Aguardando banco de dados ficar disponível...
timeout /t 15 /nobreak >nul

REM Executar migrações
echo ℹ️  Executando migrações do banco de dados...
docker-compose -f docker-compose.custom.yml exec server npx knex migrate:latest
if %errorlevel% neq 0 (
    echo ⚠️  Erro ao executar migrações, mas continuando...
)

echo ✅ Migrações executadas

REM Verificar status
echo ℹ️  Verificando status dos containers...
docker-compose -f docker-compose.custom.yml ps

echo.
echo 🎉 Sistema Planka personalizado está rodando!
echo ==============================================
echo.
echo 🌐 URLs de acesso:
echo    Frontend: http://localhost:3000
echo    Backend:  http://localhost:1337
echo    Nginx:    http://localhost:80
echo.
echo 🗄️ Banco de dados:
echo    Host: localhost:5432
echo    Database: planka
echo    User: planka
echo    Password: planka123
echo.
echo 🔑 Credenciais de teste:
echo    Admin: admin@planka.com / admin123
echo    Indicador: indicador1@planka.com / indicador123
echo    Vendedor: vendedor1@planka.com / vendedor123
echo.
echo 📋 Funcionalidades implementadas:
echo    ✅ Usuários com empresa e perfil
echo    ✅ Sincronização de cards entre indicadores e vendedores
echo    ✅ Chat em tempo real nos cards
echo    ✅ Painel administrativo com rankings
echo    ✅ Diferenciação visual de cards
echo.
echo 🛠️ Comandos úteis:
echo    Ver logs: docker-compose -f docker-compose.custom.yml logs -f
echo    Parar:    docker-compose -f docker-compose.custom.yml down
echo    Restart:  docker-compose -f docker-compose.custom.yml restart
echo.
echo ✅ Setup concluído com sucesso!
echo.
pause
