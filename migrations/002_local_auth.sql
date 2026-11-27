BEGIN;
CREATE TABLE IF NOT EXISTS account_credentials (
    account_id uuid PRIMARY KEY REFERENCES accounts(id) ON DELETE CASCADE,
    normalized_email varchar(254) NOT NULL UNIQUE CHECK (normalized_email = lower(normalized_email)),
    password_salt bytea NOT NULL CHECK (octet_length(password_salt) = 16),
    password_hash bytea NOT NULL CHECK (octet_length(password_hash) = 32),
    password_iterations integer NOT NULL CHECK (password_iterations >= 600000),
    password_algorithm text NOT NULL CHECK (password_algorithm = 'pbkdf2-sha256'),
    created_at timestamptz NOT NULL DEFAULT now()
);
INSERT INTO schema_migrations(version) VALUES(2) ON CONFLICT DO NOTHING;
COMMIT;
