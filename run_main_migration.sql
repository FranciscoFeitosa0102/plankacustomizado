-- Executar a migração principal manualmente (pulando extensões que já existem)

-- Criar tabela file_reference
CREATE TABLE IF NOT EXISTS file_reference (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  total INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS file_reference_total_index ON file_reference (total);

-- Criar tabela user_account
CREATE TABLE IF NOT EXISTS user_account (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  email TEXT NOT NULL,
  password TEXT,
  role TEXT NOT NULL,
  name TEXT,
  avatar_url TEXT,
  is_email_confirmed BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS user_account_email_unique ON user_account (email);
CREATE INDEX IF NOT EXISTS user_account_role_index ON user_account (role);
CREATE INDEX IF NOT EXISTS user_account_is_email_confirmed_index ON user_account (is_email_confirmed);

-- Criar tabela project
CREATE TABLE IF NOT EXISTS project (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  description TEXT,
  color TEXT,
  is_archived BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS project_is_archived_index ON project (is_archived);

-- Criar tabela project_manager
CREATE TABLE IF NOT EXISTS project_manager (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  project_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS project_manager_project_id_user_id_unique ON project_manager (project_id, user_id);
CREATE INDEX IF NOT EXISTS project_manager_project_id_index ON project_manager (project_id);
CREATE INDEX IF NOT EXISTS project_manager_user_id_index ON project_manager (user_id);

-- Criar tabela board
CREATE TABLE IF NOT EXISTS board (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  description TEXT,
  color TEXT,
  position REAL NOT NULL DEFAULT 0,
  is_archived BOOLEAN NOT NULL DEFAULT false,
  project_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS board_position_index ON board (position);
CREATE INDEX IF NOT EXISTS board_is_archived_index ON board (is_archived);
CREATE INDEX IF NOT EXISTS board_project_id_index ON board (project_id);

-- Criar tabela board_membership
CREATE TABLE IF NOT EXISTS board_membership (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  role TEXT NOT NULL,
  board_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS board_membership_board_id_user_id_unique ON board_membership (board_id, user_id);
CREATE INDEX IF NOT EXISTS board_membership_board_id_index ON board_membership (board_id);
CREATE INDEX IF NOT EXISTS board_membership_user_id_index ON board_membership (user_id);

-- Criar tabela list
CREATE TABLE IF NOT EXISTS list (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  position REAL NOT NULL DEFAULT 0,
  type TEXT NOT NULL DEFAULT 'OPENED',
  board_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS list_position_index ON list (position);
CREATE INDEX IF NOT EXISTS list_type_index ON list (type);
CREATE INDEX IF NOT EXISTS list_board_id_index ON list (board_id);

-- Criar tabela card
CREATE TABLE IF NOT EXISTS card (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  description TEXT,
  position REAL NOT NULL DEFAULT 0,
  due_date TIMESTAMP,
  is_due_completed BOOLEAN NOT NULL DEFAULT false,
  stopwatch JSONB NOT NULL DEFAULT '{}',
  is_archived BOOLEAN NOT NULL DEFAULT false,
  list_id BIGINT NOT NULL,
  board_id BIGINT NOT NULL,
  creator_user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS card_position_index ON card (position);
CREATE INDEX IF NOT EXISTS card_due_date_index ON card (due_date);
CREATE INDEX IF NOT EXISTS card_is_due_completed_index ON card (is_due_completed);
CREATE INDEX IF NOT EXISTS card_is_archived_index ON card (is_archived);
CREATE INDEX IF NOT EXISTS card_list_id_index ON card (list_id);
CREATE INDEX IF NOT EXISTS card_board_id_index ON card (board_id);
CREATE INDEX IF NOT EXISTS card_creator_user_id_index ON card (creator_user_id);

-- Criar tabela card_membership
CREATE TABLE IF NOT EXISTS card_membership (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  card_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS card_membership_card_id_user_id_unique ON card_membership (card_id, user_id);
CREATE INDEX IF NOT EXISTS card_membership_card_id_index ON card_membership (card_id);
CREATE INDEX IF NOT EXISTS card_membership_user_id_index ON card_membership (user_id);

-- Criar tabela label
CREATE TABLE IF NOT EXISTS label (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  color TEXT NOT NULL,
  board_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS label_board_id_index ON label (board_id);

-- Criar tabela card_label
CREATE TABLE IF NOT EXISTS card_label (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  card_id BIGINT NOT NULL,
  label_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS card_label_card_id_label_id_unique ON card_label (card_id, label_id);
CREATE INDEX IF NOT EXISTS card_label_card_id_index ON card_label (card_id);
CREATE INDEX IF NOT EXISTS card_label_label_id_index ON card_label (label_id);

-- Criar tabela attachment
CREATE TABLE IF NOT EXISTS attachment (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  card_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS attachment_card_id_index ON attachment (card_id);

-- Criar tabela comment
CREATE TABLE IF NOT EXISTS comment (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  text TEXT NOT NULL,
  card_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS comment_card_id_index ON comment (card_id);
CREATE INDEX IF NOT EXISTS comment_user_id_index ON comment (user_id);

-- Criar tabela action
CREATE TABLE IF NOT EXISTS action (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  card_id BIGINT,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS action_type_index ON action (type);
CREATE INDEX IF NOT EXISTS action_card_id_index ON action (card_id);
CREATE INDEX IF NOT EXISTS action_user_id_index ON action (user_id);

-- Criar tabela notification
CREATE TABLE IF NOT EXISTS notification (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  is_read BOOLEAN NOT NULL DEFAULT false,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS notification_type_index ON notification (type);
CREATE INDEX IF NOT EXISTS notification_is_read_index ON notification (is_read);
CREATE INDEX IF NOT EXISTS notification_user_id_index ON notification (user_id);

-- Criar tabela task_list
CREATE TABLE IF NOT EXISTS task_list (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  position REAL NOT NULL DEFAULT 0,
  card_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS task_list_position_index ON task_list (position);
CREATE INDEX IF NOT EXISTS task_list_card_id_index ON task_list (card_id);

-- Criar tabela task
CREATE TABLE IF NOT EXISTS task (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  position REAL NOT NULL DEFAULT 0,
  is_completed BOOLEAN NOT NULL DEFAULT false,
  task_list_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS task_position_index ON task (position);
CREATE INDEX IF NOT EXISTS task_is_completed_index ON task (is_completed);
CREATE INDEX IF NOT EXISTS task_task_list_id_index ON task (task_list_id);

-- Criar tabela webhook
CREATE TABLE IF NOT EXISTS webhook (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  url TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  board_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS webhook_type_index ON webhook (type);
CREATE INDEX IF NOT EXISTS webhook_board_id_index ON webhook (board_id);

-- Criar tabela custom_field_group
CREATE TABLE IF NOT EXISTS custom_field_group (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  position REAL NOT NULL DEFAULT 0,
  board_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS custom_field_group_position_index ON custom_field_group (position);
CREATE INDEX IF NOT EXISTS custom_field_group_board_id_index ON custom_field_group (board_id);

-- Criar tabela custom_field
CREATE TABLE IF NOT EXISTS custom_field (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  settings JSONB NOT NULL DEFAULT '{}',
  position REAL NOT NULL DEFAULT 0,
  custom_field_group_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS custom_field_type_index ON custom_field (type);
CREATE INDEX IF NOT EXISTS custom_field_position_index ON custom_field (position);
CREATE INDEX IF NOT EXISTS custom_field_custom_field_group_id_index ON custom_field (custom_field_group_id);

-- Criar tabela custom_field_value
CREATE TABLE IF NOT EXISTS custom_field_value (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  value JSONB NOT NULL DEFAULT '{}',
  custom_field_id BIGINT NOT NULL,
  card_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS custom_field_value_custom_field_id_card_id_unique ON custom_field_value (custom_field_id, card_id);
CREATE INDEX IF NOT EXISTS custom_field_value_custom_field_id_index ON custom_field_value (custom_field_id);
CREATE INDEX IF NOT EXISTS custom_field_value_card_id_index ON custom_field_value (card_id);

-- Criar tabela background_image
CREATE TABLE IF NOT EXISTS background_image (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  position REAL NOT NULL DEFAULT 0,
  board_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS background_image_position_index ON background_image (position);
CREATE INDEX IF NOT EXISTS background_image_board_id_index ON background_image (board_id);

-- Criar tabela notification_service
CREATE TABLE IF NOT EXISTS notification_service (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  board_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS notification_service_type_index ON notification_service (type);
CREATE INDEX IF NOT EXISTS notification_service_board_id_index ON notification_service (board_id);

-- Criar tabela legal_requirement
CREATE TABLE IF NOT EXISTS legal_requirement (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS legal_requirement_type_index ON legal_requirement (type);

-- Criar tabela storage_usage
CREATE TABLE IF NOT EXISTS storage_usage (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  type TEXT NOT NULL,
  size BIGINT NOT NULL DEFAULT 0,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS storage_usage_type_index ON storage_usage (type);

-- Criar tabela board_setting
CREATE TABLE IF NOT EXISTS board_setting (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  board_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS board_setting_type_board_id_unique ON board_setting (type, board_id);
CREATE INDEX IF NOT EXISTS board_setting_type_index ON board_setting (type);
CREATE INDEX IF NOT EXISTS board_setting_board_id_index ON board_setting (board_id);

-- Criar tabela smtp_configuration
CREATE TABLE IF NOT EXISTS smtp_configuration (
  id BIGINT PRIMARY KEY DEFAULT next_id(),
  host TEXT NOT NULL,
  port INTEGER NOT NULL,
  secure BOOLEAN NOT NULL DEFAULT false,
  username TEXT,
  password TEXT,
  from_email TEXT NOT NULL,
  from_name TEXT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Adicionar foreign keys
ALTER TABLE project_manager ADD CONSTRAINT project_manager_project_id_foreign FOREIGN KEY (project_id) REFERENCES project (id) ON DELETE CASCADE;
ALTER TABLE project_manager ADD CONSTRAINT project_manager_user_id_foreign FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE board ADD CONSTRAINT board_project_id_foreign FOREIGN KEY (project_id) REFERENCES project (id) ON DELETE CASCADE;

ALTER TABLE board_membership ADD CONSTRAINT board_membership_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;
ALTER TABLE board_membership ADD CONSTRAINT board_membership_user_id_foreign FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE list ADD CONSTRAINT list_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;

ALTER TABLE card ADD CONSTRAINT card_list_id_foreign FOREIGN KEY (list_id) REFERENCES list (id) ON DELETE CASCADE;
ALTER TABLE card ADD CONSTRAINT card_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;
ALTER TABLE card ADD CONSTRAINT card_creator_user_id_foreign FOREIGN KEY (creator_user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE card_membership ADD CONSTRAINT card_membership_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;
ALTER TABLE card_membership ADD CONSTRAINT card_membership_user_id_foreign FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE label ADD CONSTRAINT label_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;

ALTER TABLE card_label ADD CONSTRAINT card_label_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;
ALTER TABLE card_label ADD CONSTRAINT card_label_label_id_foreign FOREIGN KEY (label_id) REFERENCES label (id) ON DELETE CASCADE;

ALTER TABLE attachment ADD CONSTRAINT attachment_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;

ALTER TABLE comment ADD CONSTRAINT comment_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;
ALTER TABLE comment ADD CONSTRAINT comment_user_id_foreign FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE action ADD CONSTRAINT action_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;
ALTER TABLE action ADD CONSTRAINT action_user_id_foreign FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE notification ADD CONSTRAINT notification_user_id_foreign FOREIGN KEY (user_id) REFERENCES user_account (id) ON DELETE CASCADE;

ALTER TABLE task_list ADD CONSTRAINT task_list_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;

ALTER TABLE task ADD CONSTRAINT task_task_list_id_foreign FOREIGN KEY (task_list_id) REFERENCES task_list (id) ON DELETE CASCADE;

ALTER TABLE webhook ADD CONSTRAINT webhook_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;

ALTER TABLE custom_field_group ADD CONSTRAINT custom_field_group_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;

ALTER TABLE custom_field ADD CONSTRAINT custom_field_custom_field_group_id_foreign FOREIGN KEY (custom_field_group_id) REFERENCES custom_field_group (id) ON DELETE CASCADE;

ALTER TABLE custom_field_value ADD CONSTRAINT custom_field_value_custom_field_id_foreign FOREIGN KEY (custom_field_id) REFERENCES custom_field (id) ON DELETE CASCADE;
ALTER TABLE custom_field_value ADD CONSTRAINT custom_field_value_card_id_foreign FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE;

ALTER TABLE background_image ADD CONSTRAINT background_image_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;

ALTER TABLE notification_service ADD CONSTRAINT notification_service_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;

ALTER TABLE board_setting ADD CONSTRAINT board_setting_board_id_foreign FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE;
