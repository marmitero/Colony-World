package auth

import (
	"errors"
	"testing"
)

func TestTutorialLifecycle(t *testing.T) {
	dir := t.TempDir()
	s, e := Open(dir)
	if e != nil {
		t.Fatal(e)
	}
	pass := "fixture-only-password-123"
	if _, e = s.Register("quest@example.test", pass); e != nil {
		t.Fatal(e)
	}
	l, e := s.Login("quest@example.test", pass)
	if e != nil {
		t.Fatal(e)
	}
	r, e := s.CreateCharacter(l.Token, CharacterInput{1, "Questador", Appearance{Body: "standard", Outfit: "earth"}})
	if e != nil {
		t.Fatal(e)
	}
	id := r.Slots[0].ID
	if _, e = s.ChangeCharacter(l.Token, id, "select"); e != nil {
		t.Fatal(e)
	}
	step := func(n, a, p string) {
		t.Helper()
		d, e := s.InteractTutorial(l.Token, id, n, a)
		if e != nil || d.Quest.Progress.Phase != p {
			t.Fatalf("%s %s expected %s: %+v %v", n, a, p, d, e)
		}
	}
	if _, e = s.InteractTutorial(l.Token, id, "maia", "complete"); !errors.Is(e, ErrTutorialAction) {
		t.Fatal(e)
	}
	step("maia", "talk", "not_started")
	step("maia", "accept", "arrival_visit")
	step("maia", "pause", "paused")
	step("oren", "talk", "paused")
	step("maia", "resume", "arrival_visit")
	step("oren", "talk", "arrival_return")
	step("maia", "complete", "orientation_offer")
	step("maia", "accept", "orientation_visits")
	for i, n := range professions {
		p := "orientation_visits"
		if i == 5 {
			p = "orientation_return"
		}
		step(n, "talk", p)
		step(n, "talk", p)
	}
	step("maia", "complete", "routes_offer")
	step("maia", "accept", "routes_visit")
	step("varo", "talk", "routes_return")
	step("maia", "complete", "complete")
	if _, e = s.InteractTutorial(l.Token, id, "maia", "complete"); !errors.Is(e, ErrTutorialAction) {
		t.Fatal(e)
	}
	s, e = Open(dir)
	if e != nil {
		t.Fatal(e)
	}
	l, e = s.Login("quest@example.test", pass)
	if e != nil {
		t.Fatal(e)
	}
	q, e := s.Tutorial(l.Token)
	if e != nil || q.Completed != 3 || !q.Progress.LandDeedUnlocked || len(q.Progress.Visits) != 6 {
		t.Fatal(q, e)
	}
	r, e = s.CreateCharacter(l.Token, CharacterInput{2, "OutroQuest", Appearance{Body: "standard", Outfit: "earth"}})
	if e != nil {
		t.Fatal(e)
	}
	if _, e = s.ChangeCharacter(l.Token, r.Slots[1].ID, "select"); e != nil {
		t.Fatal(e)
	}
	q, e = s.Tutorial(l.Token)
	if e != nil || q.Progress.Phase != "not_started" {
		t.Fatal(q, e)
	}
	if _, e = s.InteractTutorial(l.Token, id, "maia", "talk"); !errors.Is(e, ErrCharacterMissing) {
		t.Fatal(e)
	}
}
