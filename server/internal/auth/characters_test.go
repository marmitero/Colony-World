package auth

import (
	"errors"
	"fmt"
	"testing"
	"time"
)

func TestCharactersLifecycle(t *testing.T) {
	dir := t.TempDir()
	s, e := Open(dir)
	if e != nil {
		t.Fatal(e)
	}
	now := time.Now()
	s.now = func() time.Time { return now }
	p := "fixture-only-password-123"
	_, e = s.Register("first@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	_, e = s.Register("second@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	l, e := s.Login("first@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	other, e := s.Login("second@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	appearance := Appearance{"standard", "earth"}
	r, e := s.Characters(l.Token)
	if e != nil || r.Slots[0] != nil {
		t.Fatal(r, e)
	}
	for i := 1; i <= 5; i++ {
		r, e = s.CreateCharacter(l.Token, CharacterInput{i, fmt.Sprintf("Viajante%d", i), appearance})
		if e != nil {
			t.Fatal(e)
		}
	}
	id := r.Slots[0].ID
	if r.Slots[0].Level != 1 || r.Slots[0].Gold != 0 || len(r.Slots[0].Inventory) != 4 || r.Slots[0].Inventory[3].Quantity != 2 {
		t.Fatal(r)
	}
	if _, e = s.CreateCharacter(l.Token, CharacterInput{6, "Sixth", appearance}); !errors.Is(e, ErrCharacterInvalid) {
		t.Fatal(e)
	}
	if _, e = s.CreateCharacter(l.Token, CharacterInput{1, "Other", appearance}); !errors.Is(e, ErrSlotOccupied) {
		t.Fatal(e)
	}
	if _, e = s.CreateCharacter(other.Token, CharacterInput{1, "viajante1", appearance}); !errors.Is(e, ErrNameTaken) {
		t.Fatal(e)
	}
	if _, e = s.ChangeCharacter(other.Token, id, "select"); !errors.Is(e, ErrCharacterMissing) {
		t.Fatal(e)
	}
	if _, e = s.Characters(""); !errors.Is(e, ErrUnauthorized) {
		t.Fatal(e)
	}
	r, e = s.ChangeCharacter(l.Token, id, "select")
	if e != nil || r.SelectedID != id {
		t.Fatal(e)
	}
	r, e = s.ChangeCharacter(l.Token, id, "delete")
	if e != nil || r.SelectedID != "" || r.Slots[0].DeleteAt == nil {
		t.Fatal(e)
	}
	if _, e = s.ChangeCharacter(l.Token, id, "select"); !errors.Is(e, ErrDeletionPending) {
		t.Fatal(e)
	}
	r, e = s.ChangeCharacter(l.Token, id, "cancel_delete")
	if e != nil || r.Slots[0].DeleteAt != nil {
		t.Fatal(e)
	}
	r, e = s.ChangeCharacter(l.Token, id, "select")
	if e != nil {
		t.Fatal(e)
	}
	s, e = Open(dir)
	if e != nil {
		t.Fatal(e)
	}
	s.now = func() time.Time { return now }
	l, e = s.Login("first@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	r, e = s.Characters(l.Token)
	if e != nil || r.SelectedID != id || r.Slots[0].ID != id || r.Slots[4] == nil {
		t.Fatal(r, e)
	}
	_, e = s.ChangeCharacter(l.Token, id, "delete")
	if e != nil {
		t.Fatal(e)
	}
	now = now.Add(73 * time.Hour)
	l, e = s.Login("first@example.test", p)
	if e != nil {
		t.Fatal(e)
	}
	r, e = s.Characters(l.Token)
	if e != nil || r.Slots[0] != nil || r.Slots[1] == nil {
		t.Fatal(r, e)
	}
}
