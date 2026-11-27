package transport

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealth(t *testing.T) {
	w := httptest.NewRecorder()
	NewHandler().ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/healthz", nil))
	var h Health
	if w.Code != 200 || json.Unmarshal(w.Body.Bytes(), &h) != nil || h.Service != "colony-world" || h.Status != "ok" || h.ProtocolVersion != 1 || h.Database != "not_connected" {
		t.Fatalf("unexpected health: %d %s", w.Code, w.Body.String())
	}
}
func TestHello(t *testing.T) {
	w := httptest.NewRecorder()
	NewHandler().ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/v1/hello", nil))
	var h map[string]any
	if w.Code != 200 || json.Unmarshal(w.Body.Bytes(), &h) != nil || h["gameplay"] != false || h["phase"] != "P0.1" {
		t.Fatalf("unexpected hello: %d %s", w.Code, w.Body.String())
	}
}
func TestReadOnlyRoutes(t *testing.T) {
	h := NewHandler()
	for _, v := range []struct {
		method, path string
		status       int
	}{{"POST", "/healthz", 405}, {"GET", "/missing", 404}} {
		w := httptest.NewRecorder()
		h.ServeHTTP(w, httptest.NewRequest(v.method, v.path, nil))
		if w.Code != v.status {
			t.Fatalf("%s: %d", v.path, w.Code)
		}
	}
}
