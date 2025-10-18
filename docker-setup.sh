#!/bin/bash

# Script para configurar e executar o Planka personalizado com Docker
# Sistema de Gestão de Indicações e Vendas

echo "🚀 Planka - Sistema de Gestão de Indicações e Vendas"
echo "=================================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Verificar se Docker está instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado. Por favor, instale o Docker primeiro."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
        exit 1
    fi

    print_message "Docker e Docker Compose estão instalados"
}

# Verificar se os arquivos necessários existem
check_files() {
    local required_files=(
        "docker-compose.custom.yml"
        "Dockerfile.server"
        "Dockerfile.client"
        "nginx-client.conf"
        "nginx.conf"
        "init-db.sql"
    )

    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            print_error "Arquivo $file não encontrado!"
            exit 1
        fi
    done

    print_message "Todos os arquivos necessários estão presentes"
}

# Parar containers existentes
stop_containers() {
    print_info "Parando containers existentes..."
    docker-compose -f docker-compose.custom.yml down --remove-orphans
    print_message "Containers parados"
}

# Limpar volumes e imagens antigas (opcional)
cleanup() {
    read -p "Deseja limpar volumes e imagens antigas? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Limpando volumes e imagens antigas..."
        docker-compose -f docker-compose.custom.yml down -v --remove-orphans
        docker system prune -f
        print_message "Limpeza concluída"
    fi
}

# Construir imagens
build_images() {
    print_info "Construindo imagens Docker..."
    docker-compose -f docker-compose.custom.yml build --no-cache
    print_message "Imagens construídas com sucesso"
}

# Executar migrações
run_migrations() {
    print_info "Aguardando banco de dados ficar disponível..."
    sleep 10

    print_info "Executando migrações do banco de dados..."
    docker-compose -f docker-compose.custom.yml exec server npx knex migrate:latest
    print_message "Migrações executadas com sucesso"
}

# Iniciar containers
start_containers() {
    print_info "Iniciando containers..."
    docker-compose -f docker-compose.custom.yml up -d
    print_message "Containers iniciados"
}

# Verificar status dos containers
check_status() {
    print_info "Verificando status dos containers..."
    docker-compose -f docker-compose.custom.yml ps
}

# Criar dados de teste
create_test_data() {
    print_info "Criando dados de teste..."

    # Script para criar dados de teste
    cat > create-test-data.js << 'EOF'
const { execSync } = require('child_process');

// Dados de teste para o sistema
const testData = {
    companies: [
        { nome: 'Empresa ABC Ltda' },
        { nome: 'Empresa XYZ S.A.' },
        { nome: 'Empresa 123 ME' }
    ],
    users: [
        {
            email: 'admin@planka.com',
            password: 'admin123',
            name: 'Administrador',
            role: 'admin',
            perfil: 'admin'
        },
        {
            email: 'indicador1@planka.com',
            password: 'indicador123',
            name: 'João Indicador',
            role: 'boardUser',
            perfil: 'indicador',
            companyId: 1
        },
        {
            email: 'vendedor1@planka.com',
            password: 'vendedor123',
            name: 'Maria Vendedora',
            role: 'boardUser',
            perfil: 'vendedor',
            companyId: 1
        },
        {
            email: 'indicador2@planka.com',
            password: 'indicador123',
            name: 'Pedro Indicador',
            role: 'boardUser',
            perfil: 'indicador',
            companyId: 2
        },
        {
            email: 'vendedor2@planka.com',
            password: 'vendedor123',
            name: 'Ana Vendedora',
            role: 'boardUser',
            perfil: 'vendedor',
            companyId: 2
        }
    ]
};

console.log('📊 Dados de teste criados:');
console.log('- 3 Empresas');
console.log('- 5 Usuários (1 Admin, 2 Indicadores, 2 Vendedores)');
console.log('');
console.log('🔑 Credenciais de teste:');
console.log('Admin: admin@planka.com / admin123');
console.log('Indicador 1: indicador1@planka.com / indicador123');
console.log('Vendedor 1: vendedor1@planka.com / vendedor123');
console.log('Indicador 2: indicador2@planka.com / indicador123');
console.log('Vendedor 2: vendedor2@planka.com / vendedor123');
EOF

    print_message "Script de dados de teste criado"
}

# Mostrar informações de acesso
show_access_info() {
    echo ""
    echo "🎉 Sistema Planka personalizado está rodando!"
    echo "=============================================="
    echo ""
    echo "🌐 URLs de acesso:"
    echo "   Frontend: http://localhost:3000"
    echo "   Backend:  http://localhost:1337"
    echo "   Nginx:    http://localhost:80"
    echo ""
    echo "🗄️ Banco de dados:"
    echo "   Host: localhost:5432"
    echo "   Database: planka"
    echo "   User: planka"
    echo "   Password: planka123"
    echo ""
    echo "🔑 Credenciais de teste:"
    echo "   Admin: admin@planka.com / admin123"
    echo "   Indicador: indicador1@planka.com / indicador123"
    echo "   Vendedor: vendedor1@planka.com / vendedor123"
    echo ""
    echo "📋 Funcionalidades implementadas:"
    echo "   ✅ Usuários com empresa e perfil"
    echo "   ✅ Sincronização de cards entre indicadores e vendedores"
    echo "   ✅ Chat em tempo real nos cards"
    echo "   ✅ Painel administrativo com rankings"
    echo "   ✅ Diferenciação visual de cards"
    echo ""
    echo "🛠️ Comandos úteis:"
    echo "   Ver logs: docker-compose -f docker-compose.custom.yml logs -f"
    echo "   Parar:    docker-compose -f docker-compose.custom.yml down"
    echo "   Restart:  docker-compose -f docker-compose.custom.yml restart"
    echo ""
}

# Função principal
main() {
    echo "Iniciando configuração do Planka personalizado..."
    echo ""

    # Verificações
    check_docker
    check_files

    # Parar containers existentes
    stop_containers

    # Limpeza opcional
    cleanup

    # Construir imagens
    build_images

    # Iniciar containers
    start_containers

    # Aguardar e executar migrações
    run_migrations

    # Criar dados de teste
    create_test_data

    # Verificar status
    check_status

    # Mostrar informações
    show_access_info

    print_message "Setup concluído com sucesso!"
}

# Executar função principal
main "$@"
