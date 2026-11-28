BEGIN;
ALTER TABLE characters ADD COLUMN IF NOT EXISTS face text NOT NULL DEFAULT 'oval' CHECK (face IN ('oval','angular'));
ALTER TABLE characters ADD COLUMN IF NOT EXISTS skin text NOT NULL DEFAULT 'natural' CHECK (skin IN ('natural','warm','deep'));
ALTER TABLE characters ADD COLUMN IF NOT EXISTS hair text NOT NULL DEFAULT 'classic' CHECK (hair IN ('classic','short','swept'));
ALTER TABLE characters ADD COLUMN IF NOT EXISTS hair_color text NOT NULL DEFAULT 'brown' CHECK (hair_color IN ('brown','black','copper'));
INSERT INTO schema_migrations(version) VALUES(4) ON CONFLICT DO NOTHING;
COMMIT;
