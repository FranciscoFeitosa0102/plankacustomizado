-- Adicionar campos que estão faltando na tabela user_account
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS phone TEXT;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS organization TEXT;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS terms_type TEXT;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS is_deactivated BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS language TEXT;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribed_to_own_cards BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribed_to_project BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribed_to_board BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS timezone TEXT;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribed_to_own_actions BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribed_to_own_comments BOOLEAN NOT NULL DEFAULT false;
