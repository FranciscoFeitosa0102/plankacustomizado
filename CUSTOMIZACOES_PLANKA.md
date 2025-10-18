# 🎯 Planka - Sistema de Gestão de Indicações e Vendas

## 📋 Resumo das Alterações

Este documento descreve todas as personalizações implementadas no projeto Planka para transformá-lo em um sistema de gestão de indicações e vendas integradas entre indicadores e vendedores.

## 🗄️ Alterações no Banco de Dados

### 1. Nova Tabela `company`
```sql
CREATE TABLE company (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  nome TEXT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### 2. Campos Adicionados na Tabela `user_account`
```sql
ALTER TABLE user_account ADD COLUMN company_id BIGINT;
ALTER TABLE user_account ADD COLUMN perfil TEXT NOT NULL DEFAULT 'vendedor';
ALTER TABLE user_account ADD FOREIGN KEY (company_id) REFERENCES company(id);
```

### 3. Campos Adicionados na Tabela `card`
```sql
ALTER TABLE card ADD COLUMN linked_card_id BIGINT;
ALTER TABLE card ADD COLUMN company_id BIGINT;
ALTER TABLE card ADD COLUMN numero TEXT;
ALTER TABLE card ADD COLUMN observacao TEXT;
ALTER TABLE card ADD COLUMN card_type TEXT NOT NULL DEFAULT 'indicacao';
ALTER TABLE card ADD FOREIGN KEY (linked_card_id) REFERENCES card(id);
ALTER TABLE card ADD FOREIGN KEY (company_id) REFERENCES company(id);
```

### 4. Nova Tabela `cards_chat`
```sql
CREATE TABLE cards_chat (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  card_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (card_id) REFERENCES card(id),
  FOREIGN KEY (user_id) REFERENCES user_account(id)
);
```

## 🔧 Alterações no Backend (Server)

### 1. Novos Modelos

#### `server/api/models/Company.js`
- Modelo para gerenciar empresas
- Relacionamento com usuários e cards

#### `server/api/models/CardsChat.js`
- Modelo para mensagens do chat dos cards
- Relacionamento com cards e usuários

### 2. Modelos Atualizados

#### `server/api/models/User.js`
- Adicionado campo `companyId` (relacionamento com Company)
- Adicionado campo `perfil` (vendedor, indicador, admin)
- Adicionado relacionamento com chat messages

#### `server/api/models/Card.js`
- Adicionados campos: `numero`, `observacao`, `cardType`, `linkedCardId`, `companyId`
- Adicionado relacionamento com Company e CardsChat

### 3. Novos Controladores

#### `server/api/controllers/CompanyController.js`
- CRUD completo para empresas
- Endpoints: GET, POST, PUT, DELETE /companies

#### `server/api/controllers/CardsChatController.js`
- Gerenciamento de mensagens do chat
- Endpoints: GET, POST /cards/:cardId/chat

#### `server/api/controllers/AdminController.js`
- Estatísticas de indicações
- Ranking dos melhores indicadores
- Endpoints: GET /admin/indicacoes/stats, GET /admin/indicacoes/top-indicadores

### 4. Helpers Atualizados

#### `server/api/helpers/cards/create-one.js`
- Lógica de sincronização de cards entre indicadores e vendedores
- Criação automática de cards espelhados

#### `server/api/helpers/cards/sync-card-with-company.js`
- Sincronização de cards entre usuários da mesma empresa
- Diferenciação entre cards de indicadores e vendedores

#### `server/api/helpers/cards/sync-card-movement.js`
- Sincronização de movimentação de cards vinculados
- Atualização em tempo real via WebSocket

### 5. Controladores Atualizados

#### `server/api/controllers/cards/create.js`
- Suporte aos novos campos: numero, observacao, cardType, companyId

#### `server/api/controllers/cards/update.js`
- Atualização dos novos campos
- Sincronização de movimentação

#### `server/api/controllers/users/create.js`
- Suporte aos campos companyId e perfil

#### `server/api/controllers/users/update.js`
- Atualização dos campos companyId e perfil

### 6. Rotas Adicionadas

```javascript
// Companies
'GET /companies': 'CompanyController.index',
'POST /companies': 'CompanyController.create',
'PUT /companies/:id': 'CompanyController.update',
'DELETE /companies/:id': 'CompanyController.destroy',

// CardsChat
'GET /cards/:cardId/chat': 'CardsChatController.index',
'POST /cards/:cardId/chat': 'CardsChatController.create',

// Admin
'GET /admin/indicacoes/stats': 'AdminController.getIndicacoesStats',
'GET /admin/indicacoes/top-indicadores': 'AdminController.getTopIndicadores',
```

## 🎨 Alterações no Frontend (Client)

### 1. Novos Componentes

#### `client/src/components/cards/CardChat/`
- `CardChatModal.jsx` - Modal de chat para cards
- `CardChatModal.module.scss` - Estilos do modal
- `index.js` - Export do componente

#### `client/src/components/admin/IndicacoesPanel/`
- `IndicacoesPanel.jsx` - Painel administrativo com rankings
- `IndicacoesPanel.module.scss` - Estilos do painel
- `index.js` - Export do componente

### 2. Componentes Atualizados

#### `client/src/components/cards/CardModal/ProjectContent.jsx`
- Adicionado botão de chat 💬
- Integração com modal de chat
- Estado para controlar abertura do modal

### 3. Actions (Redux)

#### `client/src/actions/cards-chat.js`
- Actions para gerenciar chat dos cards
- fetchCardChatMessages, createCardChatMessage, receiveCardChatMessage

#### `client/src/actions/admin.js`
- Actions para painel administrativo
- fetchIndicacoesStats, fetchTopIndicadores

### 4. Reducers (Redux)

#### `client/src/reducers/cards-chat.js`
- Estado do chat dos cards
- Gerenciamento de mensagens por card

#### `client/src/reducers/admin.js`
- Estado do painel administrativo
- Estatísticas e rankings

### 5. Selectors (Redux)

#### `client/src/selectors/cards-chat.js`
- Selectors para chat dos cards
- selectCardChatMessages, selectIsCardChatLoading, selectCardChatError

#### `client/src/selectors/admin.js`
- Selectors para painel administrativo
- selectIndicacoesStats, selectTopIndicadores

### 6. API (Frontend)

#### `client/src/api/cards-chat.js`
- API para chat dos cards
- getMessages, createMessage

#### `client/src/api/admin.js`
- API para painel administrativo
- getIndicacoesStats, getTopIndicadores

### 7. WebSocket

#### `client/src/sagas/core/watchers/socket.js`
- Handler para evento 'card-chat-message'
- Recebimento de mensagens em tempo real

## 🔄 Fluxo de Funcionamento

### 1. Criação de Cards por Indicadores
1. Indicador cria card com tipo "indicacao"
2. Sistema identifica vendedores da mesma empresa
3. Cria cards espelhados para cada vendedor
4. Cards são sincronizados em tempo real

### 2. Criação de Cards por Vendedores
1. Vendedor cria card com tipo "venda"
2. Sistema identifica indicadores da mesma empresa
3. Cria cards espelhados para cada indicador
4. Cards são sincronizados em tempo real

### 3. Movimentação de Cards
1. Usuário move card para nova lista
2. Sistema identifica card vinculado (linkedCardId)
3. Move card vinculado para lista correspondente
4. Atualização em tempo real via WebSocket

### 4. Chat nos Cards
1. Usuário clica no botão 💬 no card
2. Modal de chat é aberto
3. Mensagens são enviadas via API
4. WebSocket distribui mensagens em tempo real
5. Histórico é carregado automaticamente

### 5. Painel Administrativo
1. Admin acessa painel de indicações
2. Sistema calcula estatísticas em tempo real
3. Ranking dos melhores indicadores é exibido
4. Dados são atualizados automaticamente

## 🎯 Funcionalidades Implementadas

### ✅ Usuários
- [x] Campos empresa e perfil no modelo de usuário
- [x] Tabela companies com CRUD completo
- [x] Tela de administração com selects para empresa e perfil

### ✅ Cards (Indicações)
- [x] Sincronização automática entre indicadores e vendedores
- [x] Campos numero, observacao e empresa nos cards
- [x] Diferenciação visual entre cards de indicadores e vendedores
- [x] Movimentação sincronizada via linkedCardId

### ✅ Chat nos Cards
- [x] Botão 💬 em cada card
- [x] Modal com histórico de mensagens
- [x] Tabela cards_chat para persistência
- [x] WebSocket para atualizações em tempo real

### ✅ Painel Administrativo
- [x] Total de indicações
- [x] Total de indicações fechadas
- [x] Ranking dos 5 melhores indicadores
- [x] Estatísticas em tempo real

### ✅ Funcionalidades Adicionais
- [x] Vendedores podem criar cards
- [x] Sincronização bidirecional
- [x] Diferenciação visual de cards
- [x] Relacionamentos persistentes no banco

## 🚀 Como Executar

### Opção 1: Docker (Recomendado para Testes)

#### Windows
```bash
# Execute o script de configuração
docker-setup.bat
```

#### Linux/macOS
```bash
# Torne o script executável
chmod +x docker-setup.sh

# Execute o script de configuração
./docker-setup.sh
```

#### URLs de Acesso (Docker)
- Frontend: http://localhost:3000
- Backend: http://localhost:1337
- Nginx: http://localhost:80

#### Credenciais de Teste (Docker)
- Admin: admin@planka.com / admin123
- Indicador: indicador1@planka.com / indicador123
- Vendedor: vendedor1@planka.com / vendedor123

### Opção 2: Instalação Manual

#### 1. Configuração do Banco
```bash
# Configure o DATABASE_URL no arquivo .env.local
DATABASE_URL=postgresql://usuario:senha@localhost:5432/planka
```

#### 2. Executar Migrações
```bash
cd server
npx knex migrate:latest
```

#### 3. Iniciar Aplicação
```bash
npm run dev
```

#### 4. Acessar Sistema
- Frontend: http://localhost:3000
- Backend: http://localhost:1337

## 📊 Estrutura de Dados

### Perfis de Usuário
- `admin` - Administrador do sistema
- `indicador` - Usuário que faz indicações
- `vendedor` - Usuário que vende produtos/serviços

### Tipos de Card
- `indicacao` - Card criado por indicador
- `venda` - Card criado por vendedor

### Relacionamentos
- Usuário → Empresa (companyId)
- Card → Empresa (companyId)
- Card → Card Vinculado (linkedCardId)
- Card → Mensagens de Chat (cards_chat)

## 🔧 Arquivos Modificados

### Backend
- `server/db/migrations/20250101000000_add_companies_and_user_fields.js`
- `server/api/models/User.js`
- `server/api/models/Card.js`
- `server/api/models/Company.js` (novo)
- `server/api/models/CardsChat.js` (novo)
- `server/api/controllers/CompanyController.js` (novo)
- `server/api/controllers/CardsChatController.js` (novo)
- `server/api/controllers/AdminController.js` (novo)
- `server/api/controllers/cards/create.js`
- `server/api/controllers/cards/update.js`
- `server/api/controllers/users/create.js`
- `server/api/controllers/users/update.js`
- `server/api/helpers/cards/create-one.js`
- `server/api/helpers/cards/sync-card-with-company.js` (novo)
- `server/api/helpers/cards/sync-card-movement.js` (novo)
- `server/config/routes.js`

### Frontend
- `client/src/components/cards/CardChat/` (novo)
- `client/src/components/admin/IndicacoesPanel/` (novo)
- `client/src/components/cards/CardModal/ProjectContent.jsx`
- `client/src/actions/cards-chat.js` (novo)
- `client/src/actions/admin.js` (novo)
- `client/src/actions/index.js`
- `client/src/reducers/cards-chat.js` (novo)
- `client/src/reducers/admin.js` (novo)
- `client/src/reducers/index.js`
- `client/src/selectors/cards-chat.js` (novo)
- `client/src/selectors/admin.js` (novo)
- `client/src/selectors/index.js`
- `client/src/api/cards-chat.js` (novo)
- `client/src/api/admin.js` (novo)
- `client/src/api/index.js`
- `client/src/sagas/core/watchers/socket.js`

### Docker
- `docker-compose.custom.yml` (novo)
- `Dockerfile.server` (novo)
- `Dockerfile.client` (novo)
- `nginx.conf` (novo)
- `nginx-client.conf` (novo)
- `init-db.sql` (novo)
- `docker-setup.bat` (novo)
- `docker-setup.sh` (novo)
- `docker-stop.bat` (novo)
- `docker-logs.bat` (novo)
- `test-functionality.bat` (novo)
- `README-DOCKER.md` (novo)
- `.dockerignore` (novo)

## 🎉 Conclusão

O sistema Planka foi personalizado com sucesso para funcionar como um sistema de gestão de indicações e vendas. Todas as funcionalidades solicitadas foram implementadas:

1. ✅ Usuários com empresa e perfil
2. ✅ Sincronização de cards entre indicadores e vendedores
3. ✅ Chat em tempo real nos cards
4. ✅ Painel administrativo com rankings
5. ✅ Diferenciação visual de cards
6. ✅ WebSocket para atualizações em tempo real

O sistema está pronto para uso e pode ser testado localmente seguindo as instruções de execução.
