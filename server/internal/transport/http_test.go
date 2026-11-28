package transport

import (
	"colony.world/server/internal/auth"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestAPILifecycle(t *testing.T) {
	s, e := auth.Open(t.TempDir())
	if e != nil {
		t.Fatal(e)
	}
	h := NewHandler(s)
	call := func(method, path, body, token string, status int) *httptest.ResponseRecorder {
		t.Helper()
		r := httptest.NewRequest(method, path, strings.NewReader(body))
		r.Header.Set("Content-Type", "application/json")
		if token != "" {
			r.Header.Set("Authorization", "Bearer "+token)
		}
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		if w.Code != status {
			t.Fatalf("%s %s: %d %s", method, path, w.Code, w.Body.String())
		}
		return w
	}
	w := call("GET", "/healthz", "", "", 200)
	var health Health
	if json.Unmarshal(w.Body.Bytes(), &health) != nil || health.Database != "local_file" || health.Phase != "P0.4" {
		t.Fatal(w.Body.String())
	}
	call("GET", "/v1/hello", "", "", 200)
	cred := `{"email":"fixture@example.test","password":"fixture-only-1234"}`
	call("POST", "/v1/auth/register", cred, "", 201)
	call("POST", "/v1/auth/register", cred, "", 409)
	call("POST", "/v1/auth/login", `{"email":"fixture@example.test","password":"wrong-password-123"}`, "", 400)
	w = call("POST", "/v1/auth/login", cred, "", 200)
	var l auth.Login
	if json.Unmarshal(w.Body.Bytes(), &l) != nil || l.Token == "" {
		t.Fatal("login")
	}
	call("GET", "/v1/auth/me", "", l.Token, 200)
	call("POST", "/v1/auth/logout", "", l.Token, 204)
	call("GET", "/v1/auth/me", "", l.Token, 401)
	call("POST", "/v1/auth/login", `{"email":"x","password":"x","extra":true}`, "", 400)
	call("GET", "/missing", "", "", 404)
	call("POST", "/healthz", "", "", 405)
	r := httptest.NewRequest(http.MethodPost, "/v1/auth/login", strings.NewReader(cred))
	r.Header.Set("Origin", "https://example.test")
	w = httptest.NewRecorder()
	h.ServeHTTP(w, r)
	if w.Code != 403 {
		t.Fatal(w.Code)
	}
}
