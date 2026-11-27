package transport

import (
	"encoding/json"
	"net/http"
)

const ProtocolVersion = 1
const Phase = "P0.1"

type Health struct {
	Service         string `json:"service"`
	Status          string `json:"status"`
	Phase           string `json:"phase"`
	ProtocolVersion int    `json:"protocol_version"`
	Database        string `json:"database"`
}

func NewHandler() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		write(w, Health{"colony-world", "ok", Phase, ProtocolVersion, "not_connected"})
	})
	mux.HandleFunc("GET /v1/hello", func(w http.ResponseWriter, r *http.Request) {
		write(w, map[string]any{"service": "colony-world", "phase": Phase, "protocol_version": ProtocolVersion, "world": "Bravamar", "mode": "foundation", "gameplay": false})
	})
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("Cache-Control", "no-store")
		mux.ServeHTTP(w, r)
	})
}

func write(w http.ResponseWriter, body any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	_ = json.NewEncoder(w).Encode(body)
}
