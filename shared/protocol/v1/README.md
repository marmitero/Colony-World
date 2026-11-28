# Protocol v1 / P0.3
Local HTTP JSON; server only listens on loopback. Browser-originated requests rejected. Never expose this dev service on public network.
- GET /healthz: service, status, phase, protocol_version, database="local_file"; not PostgreSQL.
- GET /v1/hello: hello.schema.json.
- POST /v1/auth/register: email/password, 201 account {id,email,created_at}.
- POST /v1/auth/login: email/password, 200 {account,token,expires_at}. Token stays in client memory.
- GET /v1/auth/me: Authorization: Bearer token, 200 account or 401.
- POST /v1/auth/logout: Authorization header, 204, invalidate session.
Request body JSON <=4096 bytes. Email normalized/validated; password 12–128 UTF-8 bytes (schema length is informational Unicode character count; backend bytes authoritative). Errors: invalid_request 400, invalid_credentials 400, account_unavailable 409, session_expired 401, rate_limited 429, invalid_content_type 415, internal_error 500, forbidden_origin 403. Login failure remains generic. API records no credentials or session tokens in logs. Sessions expire after 12h or 30min inactivity; one session per account. No session after restart.
Local store is development-only; PostgreSQL and TLS/public auth verification/recovery are production gates. No gameplay commands yet; character endpoints below.

## P0.3 — personagens
GET /v1/characters retorna {"slots":[null,... cinco posições],"selected_id":""} para a conta autenticada. POST /v1/characters recebe slot integer 1–5, name, appearance {body: standard|sturdy,outfit: earth|forest|ocean}; 201 retorna roster atualizado. POST /v1/characters/{id}/select, /delete, /cancel_delete retornam roster atualizado (200). Todos exigem Bearer válido e propriedade; 401 sessão; 400 invalid_character; 409 slot_occupied, name_taken ou deletion_pending; 404 character_missing. Delete agenda 72 h, sem remoção imediata. O servidor cria os itens iniciais, nunca confia no cliente. GET /v1/hello agora phase P0.3 e mode character_selection; health P0.3 local_file. Porta 3000 preservada.

## P0.4 — world preview
Health/hello phase P0.4, hello mode world_preview. No new gameplay commands. Bravamar is art-only client-side inspection after authenticated character selection. Port 3000 preserved. Server authoritative movement, combat and zone enforcement are future phases.

