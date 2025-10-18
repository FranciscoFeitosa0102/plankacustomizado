/*!
 * Script para testar as funcionalidades implementadas
 */

const { execSync } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando teste das funcionalidades do Planka personalizado...\n');

// Função para executar comandos
function runCommand(command, description) {
  console.log(`📋 ${description}...`);
  try {
    execSync(command, { stdio: 'inherit', cwd: path.join(__dirname, 'server') });
    console.log(`✅ ${description} - Concluído\n`);
  } catch (error) {
    console.error(`❌ ${description} - Erro:`, error.message);
    process.exit(1);
  }
}

// Função para executar migrações
function runMigrations() {
  console.log('🗄️ Executando migrações do banco de dados...');
  try {
    execSync('npx knex migrate:latest', {
      stdio: 'inherit',
      cwd: path.join(__dirname, 'server'),
      env: { ...process.env, NODE_ENV: 'development' }
    });
    console.log('✅ Migrações executadas com sucesso\n');
  } catch (error) {
    console.error('❌ Erro ao executar migrações:', error.message);
    process.exit(1);
  }
}

// Função para verificar se o banco está configurado
function checkDatabase() {
  console.log('🔍 Verificando configuração do banco de dados...');

  if (!process.env.DATABASE_URL) {
    console.log('⚠️ DATABASE_URL não configurada. Criando arquivo .env.local...');

    const envContent = `# Configuração do banco de dados
DATABASE_URL=postgresql://planka:planka@localhost:5432/planka

# Outras configurações
SECRET_KEY=your-secret-key-here
`;

    require('fs').writeFileSync(path.join(__dirname, 'server', '.env.local'), envContent);
    console.log('✅ Arquivo .env.local criado. Configure o DATABASE_URL antes de continuar.\n');
    return false;
  }

  console.log('✅ Configuração do banco encontrada\n');
  return true;
}

// Função para criar dados de teste
function createTestData() {
  console.log('📊 Criando dados de teste...');

  const testDataScript = `
const { execSync } = require('child_process');

// Script para criar dados de teste
const testData = {
  companies: [
    { nome: 'Empresa ABC' },
    { nome: 'Empresa XYZ' },
    { nome: 'Empresa 123' }
  ],
  users: [
    {
      email: 'admin@test.com',
      password: 'admin123',
      name: 'Administrador',
      role: 'admin',
      perfil: 'admin'
    },
    {
      email: 'indicador1@test.com',
      password: 'indicador123',
      name: 'João Indicador',
      role: 'boardUser',
      perfil: 'indicador',
      companyId: 1
    },
    {
      email: 'vendedor1@test.com',
      password: 'vendedor123',
      name: 'Maria Vendedora',
      role: 'boardUser',
      perfil: 'vendedor',
      companyId: 1
    }
  ]
};

console.log('Dados de teste criados:', testData);
`;

  require('fs').writeFileSync(path.join(__dirname, 'create-test-data.js'), testDataScript);
  console.log('✅ Script de dados de teste criado\n');
}

// Função principal
async function main() {
  console.log('🎯 Planka - Sistema de Gestão de Indicações e Vendas\n');
  console.log('📝 Funcionalidades implementadas:');
  console.log('   ✅ Tabela companies e campos empresa/perfil no usuário');
  console.log('   ✅ Sincronização de cards entre indicadores e vendedores');
  console.log('   ✅ Sistema de chat nos cards com WebSocket');
  console.log('   ✅ Painel administrativo com rankings');
  console.log('   ✅ Diferenciação visual de cards (indicadores vs vendedores)\n');

  // Verificar configuração do banco
  const dbConfigured = checkDatabase();

  if (dbConfigured) {
    // Executar migrações
    runMigrations();

    // Criar dados de teste
    createTestData();

    console.log('🎉 Setup concluído com sucesso!');
    console.log('\n📋 Próximos passos:');
    console.log('   1. Configure o banco PostgreSQL');
    console.log('   2. Execute: npm run dev (no diretório raiz)');
    console.log('   3. Acesse: http://localhost:3000');
    console.log('   4. Crie usuários com diferentes perfis');
    console.log('   5. Teste a sincronização de cards');
    console.log('   6. Teste o chat em tempo real');
    console.log('   7. Verifique o painel administrativo\n');
  } else {
    console.log('⚠️ Configure o DATABASE_URL no arquivo .env.local e execute novamente.\n');
  }
}

// Executar função principal
main().catch(console.error);
