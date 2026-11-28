BEGIN;
ALTER TABLE characters ADD COLUMN IF NOT EXISTS body text NOT NULL DEFAULT 'standard' CHECK (body IN ('standard','sturdy'));
ALTER TABLE characters ADD COLUMN IF NOT EXISTS outfit text NOT NULL DEFAULT 'earth' CHECK (outfit IN ('earth','forest','ocean'));
ALTER TABLE characters ADD COLUMN IF NOT EXISTS level integer NOT NULL DEFAULT 1 CHECK (level >= 1);
ALTER TABLE characters ADD COLUMN IF NOT EXISTS city text NOT NULL DEFAULT 'Bravamar';
ALTER TABLE characters ADD COLUMN IF NOT EXISTS gold bigint NOT NULL DEFAULT 0 CHECK (gold >= 0);
ALTER TABLE characters ADD COLUMN IF NOT EXISTS delete_at timestamptz;
CREATE TABLE IF NOT EXISTS character_inventory (
    character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    item_id text NOT NULL,
    quantity integer NOT NULL CHECK(quantity > 0),
    PRIMARY KEY(character_id,item_id)
);
CREATE UNIQUE INDEX IF NOT EXISTS characters_owner_identity ON characters(account_id,id);
CREATE TABLE IF NOT EXISTS account_selected_character (
    account_id uuid PRIMARY KEY REFERENCES accounts(id) ON DELETE CASCADE,
    character_id uuid NOT NULL,
    FOREIGN KEY(account_id,character_id) REFERENCES characters(account_id,id) ON DELETE CASCADE
);
INSERT INTO schema_migrations(version) VALUES(3) ON CONFLICT DO NOTHING;
COMMIT;
