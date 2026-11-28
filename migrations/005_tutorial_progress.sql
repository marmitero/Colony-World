BEGIN;
ALTER TABLE characters ADD COLUMN IF NOT EXISTS tutorial jsonb NOT NULL DEFAULT '{"phase":"not_started","visits":[],"land_deed_unlocked":false}'::jsonb;
INSERT INTO schema_migrations(version) VALUES(5) ON CONFLICT DO NOTHING;
COMMIT;
