-- Criar usuário administrador
INSERT INTO user_account (
  id,
  email,
  name,
  password,
  role,
  is_email_confirmed,
  created_at,
  updated_at
) VALUES (
  next_id(),
  'admin@planka.com',
  'Administrador',
  '$2b$10$rQZ8vQZ8vQZ8vQZ8vQZ8vO', -- senha: admin123
  'admin',
  true,
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;
