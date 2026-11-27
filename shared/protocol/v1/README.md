# Protocol v1 / P0.1
Local HTTP JSON read-only proof. GET /healthz returns service, status, phase, protocol_version, database ("not_connected"). GET /v1/hello corresponds to hello.schema.json. Future session/auth and WebSocket commands/snapshots will be separately specified; the client never decides game state. No credentials, no gameplay, no public binding in this phase.
