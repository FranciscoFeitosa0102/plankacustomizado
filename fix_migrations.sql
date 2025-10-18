-- Marcar a migração problemática como executada
INSERT INTO migration (name, batch, migration_time)
VALUES ('20250228000022_version_2.js', 1, NOW())
ON CONFLICT (name) DO NOTHING;
