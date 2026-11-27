BEGIN;
CREATE TABLE IF NOT EXISTS schema_migrations (
    version integer PRIMARY KEY,
    applied_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS accounts (
    id uuid PRIMARY KEY,
    auth_provider text NOT NULL,
    auth_subject text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(auth_provider, auth_subject)
);
CREATE TABLE IF NOT EXISTS characters (
    id uuid PRIMARY KEY,
    account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    slot smallint NOT NULL CHECK (slot BETWEEN 1 AND 5),
    name varchar(20) NOT NULL CHECK (char_length(name) BETWEEN 3 AND 20),
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(account_id, slot)
);
CREATE UNIQUE INDEX IF NOT EXISTS characters_name_casefold_unique ON characters(lower(name));
INSERT INTO schema_migrations(version) VALUES(1) ON CONFLICT DO NOTHING;
COMMIT;
