package world

import (
	"testing"
	"time"
)

func TestForestTravel(t *testing.T) {
	s := New()
	now := time.Now()
	s.now = func() time.Time { return now }
	if _, e := s.Travel("a", "bosque"); e != ErrPortal {
		t.Fatal(e)
	}
	v := s.initial("a")
	v.X = -44
	v.Z = -3
	s.states["a"] = v
	p, e := s.Travel("a", "bosque")
	if e != nil || p.Map != "bosque" || p.Zone != "safe" || !s.forest.Walkable(p.X, p.Z) {
		t.Fatal(p, e)
	}
	n, _ := NPCByID("maia")
	if s.NearNPC("a", n) {
		t.Fatal("cross-map NPC")
	}
	if s.State("b").Map != "bravamar" {
		t.Fatal("map leak")
	}
	if _, e = s.Travel("a", "ferrugem"); e != ErrPortal {
		t.Fatal(e)
	}
	if s.forest.Walkable(-22.5, 22) || s.forest.Walkable(0, 46) {
		t.Fatal("forest bounds")
	}
	now = now.Add(time.Millisecond * 100)
	p, e = s.Move("a", Input{DX: 1})
	if e != nil || p.Map != "bosque" || p.X <= 39 {
		t.Fatal(p, e)
	}
	for i := 0; i < 8; i++ {
		now = now.Add(time.Millisecond * 100)
		p, e = s.Move("a", Input{DX: 1})
		if e != nil {
			t.Fatal(e)
		}
	}
	p, e = s.Travel("a", "bravamar")
	if e != nil || p.Map != "bravamar" || !s.geom.Walkable(p.X, p.Z) {
		t.Fatal(p, e)
	}
}
