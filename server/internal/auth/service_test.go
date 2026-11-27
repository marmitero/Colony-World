package auth

import (
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestPersistenceAndSession(t *testing.T) {
	dir := t.TempDir()
	s, err := Open(dir)
	if err != nil {
		t.Fatal(err)
	}
	password := "fixture-only-password-123"
	a, err := s.Register("Player@Example.test", password)
	if err != nil {
		t.Fatal(err)
	}
	if a.Email != "player@example.test" {
		t.Fatal(a)
	}
	b, err := os.ReadFile(filepath.Join(dir, "accounts-v1.json"))
	if err != nil || strings.Contains(string(b), password) {
		t.Fatal("bad persistence")
	}
	if _, e := s.Register("player@example.test", password); !errors.Is(e, ErrDuplicate) {
		t.Fatal(e)
	}
	if _, e := s.Register("second@example.test", password); e != nil {
		t.Fatal(e)
	}
	s, err = Open(dir)
	if err != nil {
		t.Fatal(err)
	}
	if _, e := s.Login(a.Email, "incorrect-password"); !errors.Is(e, ErrInvalid) {
		t.Fatal(e)
	}
	l, err := s.Login(a.Email, password)
	if err != nil || l.Token == "" {
		t.Fatal(err)
	}
	if got, e := s.Me(l.Token); e != nil || got.ID != a.ID {
		t.Fatal(got, e)
	}
	second, e := s.Login(a.Email, password)
	if e != nil {
		t.Fatal(e)
	}
	if _, e := s.Me(l.Token); !errors.Is(e, ErrUnauthorized) {
		t.Fatal("old session not revoked")
	}
	s.Logout(second.Token)
	if _, e := s.Me(second.Token); !errors.Is(e, ErrUnauthorized) {
		t.Fatal("logout failed")
	}
}
func TestExpirationAndRateLimit(t *testing.T) {
	s, e := Open(t.TempDir())
	if e != nil {
		t.Fatal(e)
	}
	now := time.Now()
	s.now = func() time.Time { return now }
	p := "fixture-only-password-123"
	_, e = s.Register("test@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	l, e := s.Login("test@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	now = now.Add(31 * time.Minute)
	if _, e = s.Me(l.Token); !errors.Is(e, ErrUnauthorized) {
		t.Fatal("idle not expired")
	}
	for i := 0; i < 12; i++ {
		_, e = s.Login("bad", "short")
		if !errors.Is(e, ErrInvalid) {
			t.Fatal(e)
		}
	}
	if _, e = s.Login("bad", "short"); !errors.Is(e, ErrLimited) {
		t.Fatal(e)
	}
}
