# 🐳 Planka Personalizado - Configuração Docker

Este documento explica como executar o sistema Planka personalizado usando Docker para testes locais.

## 📋 Pré-requisitos

- Docker Desktop instalado
- Docker Compose instalado
- Pelo menos 4GB de RAM disponível
- Portas 80, 3000, 1337, 5432 e 6379 livres

## 🚀 Instalação Rápida

### Windows
```bash
# Execute o script de configuração
docker-setup.bat
```

### Linux/macOS
```bash
# Torne o script executável
chmod +x docker-setup.sh

# Execute o script de configuração
./docker-setup.sh
```

## 📁 Arquivos Docker Criados

### Configuração Principal
- `docker-compose.custom.yml` - Orquestração dos containers
- `Dockerfile.server` - Imagem do backend
- `Dockerfile.client` - Imagem do frontend
- `nginx.conf` - Configuração do proxy reverso
- `nginx-client.conf` - Configuração do nginx para frontend
- `init-db.sql` - Script de inicialização do banco

### Scripts de Gerenciamento
- `docker-setup.bat` / `docker-setup.sh` - Configuração completa
- `docker-stop.bat` - Parar o sistema
- `docker-logs.bat` - Visualizar logs

## 🏗️ Arquitetura dos Containers

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   PostgreSQL    │
│   (Nginx)       │◄──►│   (Node.js)     │◄──►│   (Database)    │
│   Port: 3000    │    │   Port: 1337    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     Redis       │
                    │   (Cache)       │
                    │   Port: 6379    │
                    └─────────────────┘
```

## 🌐 URLs de Acesso

Após a execução do setup:

- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:1337
- **Nginx (Proxy)**: http://localhost:80
- **Banco de Dados**: localhost:5432

## 🔑 Credenciais de Teste

O sistema cria automaticamente usuários de teste:

| Perfil | Email | Senha |
|--------|-------|-------|
| Admin | admin@planka.com | admin123 |
| Indicador 1 | indicador1@planka.com | indicador123 |
| Vendedor 1 | vendedor1@planka.com | vendedor123 |
| Indicador 2 | indicador2@planka.com | indicador123 |
| Vendedor 2 | vendedor2@planka.com | vendedor123 |

## 🗄️ Configuração do Banco

- **Host**: localhost:5432
- **Database**: planka
- **User**: planka
- **Password**: planka123

## 🛠️ Comandos Úteis

### Gerenciamento de Containers
```bash
# Iniciar sistema
docker-compose -f docker-compose.custom.yml up -d

# Parar sistema
docker-compose -f docker-compose.custom.yml down

# Reiniciar sistema
docker-compose -f docker-compose.custom.yml restart

# Ver status
docker-compose -f docker-compose.custom.yml ps
```

### Logs e Debugging
```bash
# Ver logs de todos os serviços
docker-compose -f docker-compose.custom.yml logs -f

# Ver logs de um serviço específico
docker-compose -f docker-compose.custom.yml logs -f server
docker-compose -f docker-compose.custom.yml logs -f client
docker-compose -f docker-compose.custom.yml logs -f postgres
```

### Banco de Dados
```bash
# Acessar banco de dados
docker-compose -f docker-compose.custom.yml exec postgres psql -U planka -d planka

# Executar migrações
docker-compose -f docker-compose.custom.yml exec server npx knex migrate:latest

# Fazer backup do banco
docker-compose -f docker-compose.custom.yml exec postgres pg_dump -U planka planka > backup.sql
```

### Limpeza
```bash
# Parar e remover containers
docker-compose -f docker-compose.custom.yml down

# Parar, remover containers e volumes
docker-compose -f docker-compose.custom.yml down -v

# Limpar imagens não utilizadas
docker system prune -f

# Limpeza completa (cuidado!)
docker system prune -a -f --volumes
```

## 🔧 Personalização

### Variáveis de Ambiente

Edite o arquivo `docker-compose.custom.yml` para personalizar:

```yaml
environment:
  NODE_ENV: production
  DATABASE_URL: postgresql://planka:planka123@postgres:5432/planka
  REDIS_URL: redis://redis:6379
  SECRET_KEY: your-secret-key-change-in-production
  BASE_URL: http://localhost:1337
  FRONTEND_URL: http://localhost:3000
```

### Portas

Para alterar as portas, modifique a seção `ports` em cada serviço:

```yaml
ports:
  - "8080:80"  # Frontend na porta 8080
  - "1338:1337"  # Backend na porta 1338
```

## 🐛 Solução de Problemas

### Container não inicia
```bash
# Verificar logs
docker-compose -f docker-compose.custom.yml logs [nome-do-serviço]

# Verificar se as portas estão livres
netstat -an | findstr :3000
netstat -an | findstr :1337
netstat -an | findstr :5432
```

### Banco de dados não conecta
```bash
# Verificar se o PostgreSQL está rodando
docker-compose -f docker-compose.custom.yml exec postgres pg_isready -U planka

# Verificar logs do banco
docker-compose -f docker-compose.custom.yml logs postgres
```

### Frontend não carrega
```bash
# Verificar se o build foi feito corretamente
docker-compose -f docker-compose.custom.yml logs client

# Reconstruir apenas o frontend
docker-compose -f docker-compose.custom.yml build --no-cache client
```

### WebSocket não funciona
- Verifique se o proxy do nginx está configurado corretamente
- Confirme se as portas 80 e 1337 estão acessíveis
- Verifique os logs do nginx e do servidor

## 📊 Monitoramento

### Recursos do Sistema
```bash
# Ver uso de recursos
docker stats

# Ver uso de espaço em disco
docker system df
```

### Health Checks
Os containers possuem health checks configurados:
- PostgreSQL: verifica se o banco está respondendo
- Redis: verifica se o cache está funcionando

## 🔄 Atualizações

Para atualizar o sistema:

1. Pare os containers:
```bash
docker-compose -f docker-compose.custom.yml down
```

2. Atualize o código fonte

3. Reconstrua as imagens:
```bash
docker-compose -f docker-compose.custom.yml build --no-cache
```

4. Inicie novamente:
```bash
docker-compose -f docker-compose.custom.yml up -d
```

## 📝 Notas Importantes

- Os dados do banco são persistidos no volume `postgres_data`
- Os uploads são salvos nos volumes `./server/private` e `./server/public`
- O sistema usa Redis para cache e sessões
- O nginx serve como proxy reverso para melhor performance

## 🆘 Suporte

Se encontrar problemas:

1. Verifique os logs dos containers
2. Confirme se todas as portas estão livres
3. Verifique se o Docker tem recursos suficientes
4. Consulte a documentação do Planka original

## 🎯 Próximos Passos

Após testar localmente:

1. Configure um domínio personalizado
2. Configure SSL/HTTPS
3. Configure backup automático do banco
4. Configure monitoramento
5. Deploy em produção na VPS
