-- Script de inicialização do banco de dados
-- Este script é executado automaticamente quando o container PostgreSQL é criado

-- Criar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Criar usuário planka se não existir
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'planka') THEN
        CREATE ROLE planka LOGIN PASSWORD 'planka123';
    END IF;
END
$$;

-- Conceder privilégios
GRANT ALL PRIVILEGES ON DATABASE planka TO planka;
GRANT ALL PRIVILEGES ON SCHEMA public TO planka;

-- Comentário informativo
COMMENT ON DATABASE planka IS 'Banco de dados do Planka - Sistema de Gestão de Indicações e Vendas';
