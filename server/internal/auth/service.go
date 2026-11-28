package auth

import (
	"crypto/pbkdf2"
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net/mail"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

const rounds = 600000
const sessionTTL = 12 * time.Hour
const idleTTL = 30 * time.Minute

var (
	ErrInvalid      = errors.New("invalid credentials or fields")
	ErrDuplicate    = errors.New("account unavailable")
	ErrUnauthorized = errors.New("session invalid or expired")
	ErrLimited      = errors.New("too many attempts")
)

type Account struct {
	ID        string    `json:"id"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"`
}
type record struct {
	Account    Account `json:"account"`
	Salt       string  `json:"salt"`
	Hash       string  `json:"hash"`
	Iterations int     `json:"iterations"`
}
type disk struct {
	Version  int               `json:"version"`
	Accounts map[string]record `json:"accounts"`
}
type session struct {
	Account  Account
	Expires  time.Time
	LastSeen time.Time
}
type Login struct {
	Account   Account   `json:"account"`
	Token     string    `json:"token"`
	ExpiresAt time.Time `json:"expires_at"`
}
type Service struct {
	mu         sync.Mutex
	path       string
	accounts   map[string]record
	sessions   map[[32]byte]session
	attempts   []time.Time
	now        func() time.Time
	characters map[string]Roster
}

func Open(dir string) (*Service, error) {
	if err := os.MkdirAll(dir, 0700); err != nil {
		return nil, err
	}
	s := &Service{path: filepath.Join(dir, "accounts-v1.json"), accounts: map[string]record{}, sessions: map[[32]byte]session{}, now: time.Now, characters: map[string]Roster{}}
	b, err := os.ReadFile(s.path)
	if errors.Is(err, os.ErrNotExist) {
		if _, charErr := os.Stat(s.charPath()); !errors.Is(charErr, os.ErrNotExist) {
			return nil, errors.New("account store missing; preserve character store and restore accounts")
		}
		return s, nil
	}
	if err != nil {
		return nil, err
	}
	var d disk
	if err = json.Unmarshal(b, &d); err != nil || d.Version != 1 || d.Accounts == nil {
		return nil, fmt.Errorf("invalid account store; preserve file and restore backup")
	}
	for email, r := range d.Accounts {
		salt, e1 := base64.RawStdEncoding.DecodeString(r.Salt)
		hash, e2 := base64.RawStdEncoding.DecodeString(r.Hash)
		if e1 != nil || e2 != nil || len(salt) != 16 || len(hash) != 32 || r.Iterations != rounds || r.Account.Email != email || r.Account.ID == "" {
			return nil, errors.New("invalid account record")
		}
	}
	s.accounts = d.Accounts
	if err := s.loadCharacters(); err != nil {
		return nil, err
	}
	return s, nil
}
func normalize(email string) (string, bool) {
	email = strings.ToLower(strings.TrimSpace(email))
	if len(email) > 254 || !strings.Contains(email, "@") {
		return "", false
	}
	a, err := mail.ParseAddress(email)
	return email, err == nil && a.Address == email && a.Name == ""
}
func validPassword(p string) bool { return len(p) >= 12 && len(p) <= 128 }
func derive(p string, salt []byte) ([]byte, error) {
	return pbkdf2.Key(sha256.New, p, salt, rounds, 32)
}
func random(n int) ([]byte, error) { b := make([]byte, n); _, err := rand.Read(b); return b, err }
func (s *Service) allow() bool {
	t := s.now()
	keep := s.attempts[:0]
	for _, a := range s.attempts {
		if t.Sub(a) < time.Minute {
			keep = append(keep, a)
		}
	}
	s.attempts = keep
	if len(keep) >= 12 {
		return false
	}
	s.attempts = append(s.attempts, t)
	return true
}
func (s *Service) persist(accounts map[string]record) error {
	b, err := json.MarshalIndent(disk{1, accounts}, "", "  ")
	if err != nil {
		return err
	}
	f, err := os.CreateTemp(filepath.Dir(s.path), ".accounts-*.tmp")
	if err != nil {
		return err
	}
	name := f.Name()
	defer os.Remove(name)
	if _, err = f.Write(b); err == nil {
		err = f.Sync()
	}
	if closeErr := f.Close(); err == nil {
		err = closeErr
	}
	if err != nil {
		return err
	}
	return os.Rename(name, s.path)
}
func (s *Service) Register(email, password string) (Account, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.allow() {
		return Account{}, ErrLimited
	}
	email, ok := normalize(email)
	if !ok || !validPassword(password) {
		return Account{}, ErrInvalid
	}
	if _, exists := s.accounts[email]; exists {
		return Account{}, ErrDuplicate
	}
	salt, err := random(16)
	if err != nil {
		return Account{}, err
	}
	hash, err := derive(password, salt)
	if err != nil {
		return Account{}, err
	}
	id, err := random(16)
	if err != nil {
		return Account{}, err
	}
	id[6] = (id[6] & 0x0f) | 0x40
	id[8] = (id[8] & 0x3f) | 0x80
	hexID := hex.EncodeToString(id)
	a := Account{hexID[:8] + "-" + hexID[8:12] + "-" + hexID[12:16] + "-" + hexID[16:20] + "-" + hexID[20:], email, s.now().UTC()}
	copyMap := make(map[string]record, len(s.accounts)+1)
	for k, v := range s.accounts {
		copyMap[k] = v
	}
	copyMap[email] = record{a, base64.RawStdEncoding.EncodeToString(salt), base64.RawStdEncoding.EncodeToString(hash), rounds}
	if err = s.persist(copyMap); err != nil {
		return Account{}, err
	}
	s.accounts = copyMap
	return a, nil
}
func (s *Service) Login(email, password string) (Login, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.allow() {
		return Login{}, ErrLimited
	}
	email, ok := normalize(email)
	if !ok || !validPassword(password) {
		return Login{}, ErrInvalid
	}
	r, exists := s.accounts[email]
	salt := make([]byte, 16)
	expected := make([]byte, 32)
	if exists {
		salt, _ = base64.RawStdEncoding.DecodeString(r.Salt)
		expected, _ = base64.RawStdEncoding.DecodeString(r.Hash)
	}
	got, err := derive(password, salt)
	if err != nil {
		return Login{}, err
	}
	if subtle.ConstantTimeCompare(got, expected) != 1 || !exists {
		return Login{}, ErrInvalid
	}
	b, err := random(32)
	if err != nil {
		return Login{}, err
	}
	token := base64.RawURLEncoding.EncodeToString(b)
	key := sha256.Sum256([]byte(token))
	now := s.now()
	for k, v := range s.sessions {
		if !now.Before(v.Expires) || now.Sub(v.LastSeen) >= idleTTL {
			delete(s.sessions, k)
		}
	}
	// Only one active session per account, matching the GDD.
	for k, v := range s.sessions {
		if v.Account.ID == r.Account.ID {
			delete(s.sessions, k)
		}
	}
	expires := now.Add(sessionTTL)
	s.sessions[key] = session{r.Account, expires, now}
	return Login{r.Account, token, expires.UTC()}, nil
}
func (s *Service) Me(token string) (Account, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.meLocked(token)
}
func (s *Service) meLocked(token string) (Account, error) {
	k := sha256.Sum256([]byte(token))
	v, ok := s.sessions[k]
	now := s.now()
	if !ok || !now.Before(v.Expires) || now.Sub(v.LastSeen) >= idleTTL {
		delete(s.sessions, k)
		return Account{}, ErrUnauthorized
	}
	v.LastSeen = now
	s.sessions[k] = v
	return v.Account, nil
}
func (s *Service) Logout(token string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	delete(s.sessions, sha256.Sum256([]byte(token)))
}
