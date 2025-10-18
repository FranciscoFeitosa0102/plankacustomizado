@echo off

echo 🧪 Testando funcionalidades do Planka personalizado...
echo.

REM Verificar se os containers estão rodando
echo ℹ️  Verificando se os containers estão rodando...
docker-compose -f docker-compose.custom.yml ps | findstr "Up" >nul
if %errorlevel% neq 0 (
    echo ❌ Containers não estão rodando. Execute docker-setup.bat primeiro.
    pause
    exit /b 1
)

echo ✅ Containers estão rodando

REM Testar conectividade do banco
echo ℹ️  Testando conectividade do banco de dados...
docker-compose -f docker-compose.custom.yml exec postgres pg_isready -U planka -d planka >nul
if %errorlevel% neq 0 (
    echo ❌ Banco de dados não está respondendo
    pause
    exit /b 1
)

echo ✅ Banco de dados está funcionando

REM Testar API do backend
echo ℹ️  Testando API do backend...
curl -s http://localhost:1337/api/bootstrap >nul
if %errorlevel% neq 0 (
    echo ❌ Backend não está respondendo
    pause
    exit /b 1
)

echo ✅ Backend está funcionando

REM Testar frontend
echo ℹ️  Testando frontend...
curl -s http://localhost:3000 >nul
if %errorlevel% neq 0 (
    echo ❌ Frontend não está respondendo
    pause
    exit /b 1
)

echo ✅ Frontend está funcionando

REM Verificar se as tabelas foram criadas
echo ℹ️  Verificando se as tabelas personalizadas foram criadas...
docker-compose -f docker-compose.custom.yml exec postgres psql -U planka -d planka -c "\dt" | findstr "company" >nul
if %errorlevel% neq 0 (
    echo ❌ Tabela 'company' não foi criada
    pause
    exit /b 1
)

docker-compose -f docker-compose.custom.yml exec postgres psql -U planka -d planka -c "\dt" | findstr "cards_chat" >nul
if %errorlevel% neq 0 (
    echo ❌ Tabela 'cards_chat' não foi criada
    pause
    exit /b 1
)

echo ✅ Tabelas personalizadas foram criadas

REM Verificar se as colunas foram adicionadas
echo ℹ️  Verificando se as colunas personalizadas foram adicionadas...
docker-compose -f docker-compose.custom.yml exec postgres psql -U planka -d planka -c "\d user_account" | findstr "company_id" >nul
if %errorlevel% neq 0 (
    echo ❌ Coluna 'company_id' não foi adicionada à tabela 'user_account'
    pause
    exit /b 1
)

docker-compose -f docker-compose.custom.yml exec postgres psql -U planka -d planka -c "\d user_account" | findstr "perfil" >nul
if %errorlevel% neq 0 (
    echo ❌ Coluna 'perfil' não foi adicionada à tabela 'user_account'
    pause
    exit /b 1
)

echo ✅ Colunas personalizadas foram adicionadas

echo.
echo 🎉 Todos os testes passaram com sucesso!
echo.
echo 📋 Funcionalidades verificadas:
echo    ✅ Containers rodando
echo    ✅ Banco de dados conectado
echo    ✅ Backend respondendo
echo    ✅ Frontend respondendo
echo    ✅ Tabelas personalizadas criadas
echo    ✅ Colunas personalizadas adicionadas
echo.
echo 🌐 Acesse o sistema em:
echo    Frontend: http://localhost:3000
echo    Backend:  http://localhost:1337
echo.
echo 🔑 Use as credenciais de teste para fazer login
echo.
pause
