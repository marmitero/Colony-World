package auth

import (
	"encoding/hex"
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"time"
	"unicode"
	"unicode/utf8"
)

var ErrCharacterInvalid = errors.New("invalid character fields")
var ErrSlotOccupied = errors.New("slot occupied")
var ErrNameTaken = errors.New("character name taken")
var ErrCharacterMissing = errors.New("character not found")
var ErrDeletionPending = errors.New("character pending deletion")

const DeleteDelay = 72 * time.Hour

type Appearance struct {
	Body   string `json:"body"`
	Outfit string `json:"outfit"`
}
type ItemStack struct {
	ItemID   string `json:"item_id"`
	Quantity int    `json:"quantity"`
}
type Character struct {
	ID         string      `json:"id"`
	Slot       int         `json:"slot"`
	Name       string      `json:"name"`
	Appearance Appearance  `json:"appearance"`
	Level      int         `json:"level"`
	City       string      `json:"city"`
	Gold       int         `json:"gold"`
	Inventory  []ItemStack `json:"inventory"`
	CreatedAt  time.Time   `json:"created_at"`
	DeleteAt   *time.Time  `json:"delete_at,omitempty"`
}
type Roster struct {
	Slots      [5]*Character `json:"slots"`
	SelectedID string        `json:"selected_id"`
}
type CharacterInput struct {
	Slot       int        `json:"slot"`
	Name       string     `json:"name"`
	Appearance Appearance `json:"appearance"`
}
type charDisk struct {
	Version int               `json:"version"`
	Rosters map[string]Roster `json:"rosters"`
}

func validAppearance(a Appearance) bool {
	return (a.Body == "standard" || a.Body == "sturdy") && (a.Outfit == "earth" || a.Outfit == "forest" || a.Outfit == "ocean")
}
func validName(n string) bool {
	if n != strings.TrimSpace(n) || utf8.RuneCountInString(n) < 3 || utf8.RuneCountInString(n) > 20 {
		return false
	}
	for i, r := range n {
		if !unicode.IsLetter(r) && !(i > 0 && (unicode.IsDigit(r) || r == '-')) {
			return false
		}
	}
	return true
}
func (s *Service) charPath() string { return filepath.Join(filepath.Dir(s.path), "characters-v1.json") }
func (s *Service) loadCharacters() error {
	b, e := os.ReadFile(s.charPath())
	if errors.Is(e, os.ErrNotExist) {
		return nil
	}
	if e != nil {
		return e
	}
	var d charDisk
	if json.Unmarshal(b, &d) != nil || d.Version != 1 || d.Rosters == nil {
		return errors.New("invalid character store; preserve file and restore backup")
	}
	owners := map[string]bool{}
	for _, a := range s.accounts {
		owners[a.Account.ID] = true
	}
	names := map[string]bool{}
	ids := map[string]bool{}
	for owner, r := range d.Rosters {
		if !owners[owner] {
			return errors.New("invalid roster owner")
		}
		selected := r.SelectedID == ""
		for i, c := range r.Slots {
			if c == nil {
				continue
			}
			key := strings.ToLower(c.Name)
			if c.Slot != i+1 || c.ID == "" || ids[c.ID] || names[key] || !validName(c.Name) || !validAppearance(c.Appearance) {
				return errors.New("invalid character record")
			}
			ids[c.ID] = true
			names[key] = true
			if c.ID == r.SelectedID && c.DeleteAt == nil {
				selected = true
			}
		}
		if !selected {
			return errors.New("invalid selected character")
		}
	}
	s.characters = d.Rosters
	return nil
}
func (s *Service) writeRosters(m map[string]Roster) error {
	b, e := json.MarshalIndent(charDisk{1, m}, "", "  ")
	if e != nil {
		return e
	}
	f, e := os.CreateTemp(filepath.Dir(s.path), ".characters-*.tmp")
	if e != nil {
		return e
	}
	name := f.Name()
	defer os.Remove(name)
	if _, e = f.Write(b); e == nil {
		e = f.Sync()
	}
	if ce := f.Close(); e == nil {
		e = ce
	}
	if e != nil {
		return e
	}
	if e = os.Rename(name, s.charPath()); e != nil {
		return e
	}
	s.characters = m
	return nil
}
func (s *Service) copyRosters() map[string]Roster {
	m := make(map[string]Roster, len(s.characters)+1)
	for k, v := range s.characters {
		m[k] = v
	}
	return m
}
func (s *Service) expireRosters() error {
	m := s.copyRosters()
	changed := false
	for k, r := range m {
		for i, c := range r.Slots {
			if c != nil && c.DeleteAt != nil && !s.now().Before(*c.DeleteAt) {
				r.Slots[i] = nil
				if r.SelectedID == c.ID {
					r.SelectedID = ""
				}
				changed = true
			}
		}
		m[k] = r
	}
	if changed {
		return s.writeRosters(m)
	}
	return nil
}
func (s *Service) Characters(token string) (Roster, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	a, e := s.meLocked(token)
	if e != nil {
		return Roster{}, e
	}
	if e = s.expireRosters(); e != nil {
		return Roster{}, e
	}
	return s.characters[a.ID], nil
}
func (s *Service) CreateCharacter(token string, in CharacterInput) (Roster, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	a, e := s.meLocked(token)
	if e != nil {
		return Roster{}, e
	}
	if in.Slot < 1 || in.Slot > 5 || !validName(in.Name) || !validAppearance(in.Appearance) {
		return Roster{}, ErrCharacterInvalid
	}
	if e = s.expireRosters(); e != nil {
		return Roster{}, e
	}
	r := s.characters[a.ID]
	if r.Slots[in.Slot-1] != nil {
		return Roster{}, ErrSlotOccupied
	}
	for _, ro := range s.characters {
		for _, c := range ro.Slots {
			if c != nil && strings.EqualFold(c.Name, in.Name) {
				return Roster{}, ErrNameTaken
			}
		}
	}
	b, e := random(16)
	if e != nil {
		return Roster{}, e
	}
	b[6] = (b[6] & 15) | 64
	b[8] = (b[8] & 63) | 128
	h := hex.EncodeToString(b)
	id := h[:8] + "-" + h[8:12] + "-" + h[12:16] + "-" + h[16:20] + "-" + h[20:]
	r.Slots[in.Slot-1] = &Character{ID: id, Slot: in.Slot, Name: in.Name, Appearance: in.Appearance, Level: 1, City: "Bravamar", Gold: 0, Inventory: []ItemStack{{"tool_wood_pickaxe", 1}, {"tool_wood_axe", 1}, {"weapon_wood_sword", 1}, {"potion_health", 2}}, CreatedAt: s.now().UTC()}
	m := s.copyRosters()
	m[a.ID] = r
	if e = s.writeRosters(m); e != nil {
		return Roster{}, e
	}
	return r, nil
}
func (s *Service) ChangeCharacter(token, id, action string) (Roster, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	a, e := s.meLocked(token)
	if e != nil {
		return Roster{}, e
	}
	if e = s.expireRosters(); e != nil {
		return Roster{}, e
	}
	r := s.characters[a.ID]
	for i, c := range r.Slots {
		if c == nil || c.ID != id {
			continue
		}
		v := *c
		switch action {
		case "select":
			if c.DeleteAt != nil {
				return Roster{}, ErrDeletionPending
			}
			r.SelectedID = c.ID
		case "delete":
			if c.DeleteAt == nil {
				t := s.now().Add(DeleteDelay).UTC()
				v.DeleteAt = &t
			}
			if r.SelectedID == c.ID {
				r.SelectedID = ""
			}
		case "cancel_delete":
			v.DeleteAt = nil
		default:
			return Roster{}, ErrCharacterInvalid
		}
		r.Slots[i] = &v
		m := s.copyRosters()
		m[a.ID] = r
		if e = s.writeRosters(m); e != nil {
			return Roster{}, e
		}
		return r, nil
	}
	return Roster{}, ErrCharacterMissing
}
