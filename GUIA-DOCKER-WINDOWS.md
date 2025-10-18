# 🐳 Guia Docker Desktop para Windows

## 🚨 Problema Identificado

O erro que você está vendo indica que o **Docker Desktop não está rodando** no Windows:

```
error during connect: Get "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/v1.51/containers/json?all=1&filters=%7B%22label%22%3A%7B%22com.docker.compose.config-hash%22%3Atrue%2C%22com.docker.compose.project%3Dplanka-master%22%3Atrue%7D%7D": open //./pipe/dockerDesktopLinuxEngine: O sistema não pode encontrar o arquivo especificado.
```

## 🔧 Soluções

### 1. **Iniciar o Docker Desktop**

#### Opção A: Script Automático
```bash
# Execute o script que criei para você
start-docker-desktop.bat
```

#### Opção B: Manual
1. Pressione `Win + R`
2. Digite: `"C:\Program Files\Docker\Docker\Docker Desktop.exe"`
3. Pressione Enter
4. Aguarde o Docker inicializar (pode levar alguns minutos)

#### Opção C: Menu Iniciar
1. Clique no botão Iniciar
2. Procure por "Docker Desktop"
3. Clique para abrir
4. Aguarde a inicialização

### 2. **Verificar se o Docker está Rodando**

Execute o script de diagnóstico:
```bash
docker-troubleshoot.bat
```

Ou verifique manualmente:
```bash
docker --version
docker info
```

### 3. **Aguardar a Inicialização Completa**

O Docker Desktop pode levar alguns minutos para inicializar completamente. Você saberá que está pronto quando:

- O ícone do Docker na bandeja do sistema estiver verde
- O comando `docker info` funcionar sem erros
- O Docker Desktop mostrar "Engine running" na interface

## 📋 Checklist de Verificação

### ✅ Pré-requisitos
- [ ] Docker Desktop instalado
- [ ] Docker Desktop rodando
- [ ] WSL2 configurado (se necessário)
- [ ] Pelo menos 4GB de RAM disponível
- [ ] Portas 80, 3000, 1337, 5432 livres

### ✅ Verificações
- [ ] `docker --version` funciona
- [ ] `docker info` funciona
- [ ] `docker-compose --version` funciona
- [ ] Docker Desktop mostra "Engine running"

## 🚀 Passos para Resolver

### Passo 1: Iniciar Docker Desktop
```bash
# Execute um destes comandos:
start-docker-desktop.bat
# OU
docker-troubleshoot.bat
```

### Passo 2: Aguardar Inicialização
- Aguarde o Docker Desktop inicializar completamente
- Verifique se o ícone na bandeja está verde
- Teste com: `docker info`

### Passo 3: Executar Setup
```bash
docker-setup.bat
```

## 🐛 Problemas Comuns

### 1. **Docker Desktop não inicia**
- Verifique se o WSL2 está instalado
- Reinicie o computador
- Execute como administrador

### 2. **Erro de permissão**
- Execute o PowerShell como administrador
- Verifique se o Hyper-V está habilitado

### 3. **Portas em uso**
- Feche outros serviços que usam as portas
- Use `netstat -an | findstr ":3000"` para verificar

### 4. **Recursos insuficientes**
- Feche outros programas
- Aumente a RAM alocada para o Docker
- Verifique o espaço em disco

## 🔍 Comandos de Diagnóstico

```bash
# Verificar versão do Docker
docker --version

# Verificar se está rodando
docker info

# Verificar containers
docker ps

# Verificar imagens
docker images

# Verificar portas em uso
netstat -an | findstr ":3000"
netstat -an | findstr ":1337"
netstat -an | findstr ":5432"
```

## 📞 Suporte

Se ainda tiver problemas:

1. **Execute o diagnóstico completo:**
   ```bash
   docker-troubleshoot.bat
   ```

2. **Verifique os logs do Docker Desktop:**
   - Abra o Docker Desktop
   - Vá em Settings > Troubleshoot
   - Clique em "Collect Logs"

3. **Reinstale o Docker Desktop:**
   - Desinstale completamente
   - Baixe a versão mais recente
   - Reinstale e reinicie

## 🎯 Próximos Passos

Após resolver o problema do Docker:

1. ✅ Inicie o Docker Desktop
2. ✅ Aguarde a inicialização completa
3. ✅ Execute: `docker-setup.bat`
4. ✅ Acesse: http://localhost:3000
5. ✅ Teste as funcionalidades

## 💡 Dicas

- **Sempre inicie o Docker Desktop antes de usar containers**
- **Aguarde a inicialização completa (ícone verde)**
- **Use os scripts que criei para facilitar o processo**
- **Verifique os recursos do sistema se houver problemas**

---

**Resumo:** O problema é que o Docker Desktop não está rodando. Inicie-o primeiro, aguarde a inicialização completa, e então execute o setup novamente.
