package world

import (
	"math"
	"testing"
	"time"
)

func TestMovementAndBoundaries(t *testing.T) {
	s := New()
	now := time.Now()
	s.now = func() time.Time { return now }
	p := s.State("fixture")
	if !s.geom.Walkable(p.X, p.Z) || p.Z != 13.8 {
		t.Fatal(p)
	}
	now = now.Add(100 * time.Millisecond)
	p, e := s.Move("fixture", Input{DZ: -1})
	if e != nil || math.Abs(p.Z-13.35) > .00001 {
		t.Fatal(p, e)
	}
	now = now.Add(100 * time.Millisecond)
	p, e = s.Move("fixture", Input{DZ: -1, Run: true})
	if e != nil || math.Abs(p.Z-12.75) > .00001 {
		t.Fatal(p, e)
	}
	if _, e = s.Move("fixture", Input{DX: 2}); e != ErrInput {
		t.Fatal(e)
	}
	// Repeated real-time movement cannot cross shore or solid footprints.
	for i := 0; i < 80; i++ {
		now = now.Add(100 * time.Millisecond)
		p, e = s.Move("fixture", Input{DZ: 1, Run: true})
		if e != nil || !s.geom.Walkable(p.X, p.Z) {
			t.Fatal(p, e)
		}
	}
	if p.Z > 29 {
		t.Fatal("shore not respected", p)
	}
	for _, b := range s.geom.Boxes {
		if s.geom.Walkable(b.X, b.Z) {
			t.Fatal("solid center walkable", b.ID)
		}
	}
	if s.geom.Walkable(55, 0) || s.geom.Walkable(0, 50) {
		t.Fatal("invalid bounds")
	}
	if s.State("other").Z != 13.8 {
		t.Fatal("state leaked")
	}
}
func TestMovementRate(t *testing.T) {
	s := New()
	now := time.Now()
	s.now = func() time.Time { return now }
	p := s.State("x")
	now = now.Add(time.Second)
	q, e := s.Move("x", Input{DX: 1, Run: true})
	if e != nil || math.Hypot(q.X-p.X, q.Z-p.Z) > .961 {
		t.Fatal(q, e)
	}
	r, e := s.Move("x", Input{DX: 1, Run: true})
	if e != nil || r != q {
		t.Fatal("burst moved", r, e)
	}
}

func TestSolidCollisionStopsMovement(t *testing.T) {
	s := New()
	now := time.Now()
	s.now = func() time.Time { return now }
	// Approach the guild hall from its southern side; its footprint is centered at (0,-23).
	start := entry{Position: Position{X: 0, Z: -16, Zone: "safe", CharacterID: "fixture"}, last: now}
	if !s.geom.Walkable(start.X, start.Z) {
		t.Fatal("fixture blocked")
	}
	s.states["fixture"] = start
	var p Position
	for i := 0; i < 40; i++ {
		now = now.Add(100 * time.Millisecond)
		var e error
		p, e = s.Move("fixture", Input{DZ: -1, Run: true})
		if e != nil || !s.geom.Walkable(p.X, p.Z) {
			t.Fatal(p, e)
		}
	}
	if p.Z < -18 || p.Z >= -16 {
		t.Fatal("guild collision failed", p)
	}
}
