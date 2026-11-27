# Protocol v1 / P0.2
Local HTTP JSON; server only listens on loopback. Browser-originated requests rejected. Never expose this dev service on public network.
- GET /healthz: service, status, phase, protocol_version, database="local_file"; not PostgreSQL.
- GET /v1/hello: hello.schema.json.
- POST /v1/auth/register: email/password, 201 account {id,email,created_at}.
- POST /v1/auth/login: email/password, 200 {account,token,expires_at}. Token stays in client memory.
- GET /v1/auth/me: Authorization: Bearer token, 200 account or 401.
- POST /v1/auth/logout: Authorization header, 204, invalidate session.
Request body JSON <=4096 bytes. Email normalized/validated; password 12–128 UTF-8 bytes (schema length is informational Unicode character count; backend bytes authoritative). Errors: invalid_request 400, invalid_credentials 400, account_unavailable 409, session_expired 401, rate_limited 429, invalid_content_type 415, internal_error 500, forbidden_origin 403. Login failure remains generic. API records no credentials or session tokens in logs. Sessions expire after 12h or 30min inactivity; one session per account. No session after restart.
Local store is development-only; PostgreSQL and TLS/public auth verification/recovery are production gates. No game-state write or character endpoints yet.

Default local base URL: http://127.0.0.1:3000.
