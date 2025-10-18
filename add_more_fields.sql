-- Adicionar mais campos que estão faltando
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribe_to_own_cards BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribe_to_project BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribe_to_board BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribe_to_own_actions BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE user_account ADD COLUMN IF NOT EXISTS subscribe_to_own_comments BOOLEAN NOT NULL DEFAULT false;
