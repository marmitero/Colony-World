package transport

import (
	"colony.world/server/internal/auth"
	"colony.world/server/internal/world"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strings"
)

const ProtocolVersion = 1
const Phase = "P0.5"

type Health struct {
	Service         string `json:"service"`
	Status          string `json:"status"`
	Phase           string `json:"phase"`
	ProtocolVersion int    `json:"protocol_version"`
	Database        string `json:"database"`
}
type credentials struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func NewHandler(s *auth.Service) http.Handler {
	mux := http.NewServeMux()
	movement := world.New()
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		write(w, 200, Health{"colony-world", "ok", Phase, ProtocolVersion, "local_file"})
	})
	mux.HandleFunc("GET /v1/hello", func(w http.ResponseWriter, r *http.Request) {
		write(w, 200, map[string]any{"service": "colony-world", "phase": Phase, "protocol_version": ProtocolVersion, "world": "Bravamar", "mode": "movement", "gameplay": true})
	})
	mux.HandleFunc("POST /v1/auth/register", func(w http.ResponseWriter, r *http.Request) {
		var c credentials
		if !decode(w, r, &c) {
			return
		}
		a, err := s.Register(c.Email, c.Password)
		if err != nil {
			authError(w, err)
			return
		}
		write(w, 201, a)
	})
	mux.HandleFunc("POST /v1/auth/login", func(w http.ResponseWriter, r *http.Request) {
		var c credentials
		if !decode(w, r, &c) {
			return
		}
		a, err := s.Login(c.Email, c.Password)
		if err != nil {
			authError(w, err)
			return
		}
		write(w, 200, a)
	})
	mux.HandleFunc("GET /v1/auth/me", func(w http.ResponseWriter, r *http.Request) {
		a, err := s.Me(bearer(r))
		if err != nil {
			authError(w, err)
			return
		}
		write(w, 200, a)
	})
	mux.HandleFunc("POST /v1/auth/logout", func(w http.ResponseWriter, r *http.Request) {
		s.Logout(bearer(r))
		w.WriteHeader(204)
	})
	mux.HandleFunc("GET /v1/characters", func(w http.ResponseWriter, r *http.Request) {
		roster, e := s.Characters(bearer(r))
		if e != nil {
			authError(w, e)
			return
		}
		write(w, 200, roster)
	})
	mux.HandleFunc("POST /v1/characters", func(w http.ResponseWriter, r *http.Request) {
		var input auth.CharacterInput
		if !decode(w, r, &input) {
			return
		}
		roster, e := s.CreateCharacter(bearer(r), input)
		if e != nil {
			authError(w, e)
			return
		}
		write(w, 201, roster)
	})
	for _, action := range []string{"select", "delete", "cancel_delete"} {
		mux.HandleFunc("POST /v1/characters/{id}/"+action, func(w http.ResponseWriter, r *http.Request) {
			roster, e := s.ChangeCharacter(bearer(r), r.PathValue("id"), action)
			if e != nil {
				authError(w, e)
				return
			}
			write(w, 200, roster)
		})
	}
	mux.HandleFunc("POST /v1/characters/{id}/appearance", func(w http.ResponseWriter, r *http.Request) {
		var input auth.Appearance
		if !decode(w, r, &input) {
			return
		}
		roster, e := s.UpdateAppearance(bearer(r), r.PathValue("id"), input)
		if e != nil {
			authError(w, e)
			return
		}
		write(w, 200, roster)
	})
	mux.HandleFunc("GET /v1/world/state", func(w http.ResponseWriter, r *http.Request) {
		c, e := s.Selected(bearer(r))
		if e != nil {
			authError(w, e)
			return
		}
		write(w, 200, movement.State(c.ID))
	})
	mux.HandleFunc("POST /v1/world/move", func(w http.ResponseWriter, r *http.Request) {
		c, e := s.Selected(bearer(r))
		if e != nil {
			authError(w, e)
			return
		}
		var input world.Input
		if !decode(w, r, &input) {
			return
		}
		pos, e := movement.Move(c.ID, input)
		if e != nil {
			write(w, 400, map[string]string{"error": "invalid_movement"})
			return
		}
		write(w, 200, pos)
	})
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("Cache-Control", "no-store")
		// Native local client only; reject browser-originated requests.
		if r.Header.Get("Origin") != "" {
			write(w, 403, map[string]string{"error": "forbidden_origin"})
			return
		}
		mux.ServeHTTP(w, r)
	})
}
func decode(w http.ResponseWriter, r *http.Request, out any) bool {
	if !strings.HasPrefix(strings.ToLower(r.Header.Get("Content-Type")), "application/json") {
		write(w, 415, map[string]string{"error": "invalid_content_type"})
		return false
	}
	r.Body = http.MaxBytesReader(w, r.Body, 4096)
	d := json.NewDecoder(r.Body)
	d.DisallowUnknownFields()
	if d.Decode(out) != nil || d.Decode(new(any)) != io.EOF {
		write(w, 400, map[string]string{"error": "invalid_request"})
		return false
	}
	return true
}
func bearer(r *http.Request) string {
	t, ok := strings.CutPrefix(r.Header.Get("Authorization"), "Bearer ")
	if !ok || len(t) != 43 {
		return ""
	}
	return t
}
func authError(w http.ResponseWriter, err error) {
	status, code := 500, "internal_error"
	switch {
	case errors.Is(err, auth.ErrInvalid):
		status, code = 400, "invalid_credentials"
	case errors.Is(err, auth.ErrDuplicate):
		status, code = 409, "account_unavailable"
	case errors.Is(err, auth.ErrUnauthorized):
		status, code = 401, "session_expired"
	case errors.Is(err, auth.ErrCharacterInvalid):
		status, code = 400, "invalid_character"
	case errors.Is(err, auth.ErrSlotOccupied):
		status, code = 409, "slot_occupied"
	case errors.Is(err, auth.ErrNameTaken):
		status, code = 409, "name_taken"
	case errors.Is(err, auth.ErrCharacterMissing):
		status, code = 404, "character_missing"
	case errors.Is(err, auth.ErrDeletionPending):
		status, code = 409, "deletion_pending"
	case errors.Is(err, auth.ErrLimited):
		status, code = 429, "rate_limited"
	}
	write(w, status, map[string]string{"error": code})
}
func write(w http.ResponseWriter, status int, body any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(body)
}
