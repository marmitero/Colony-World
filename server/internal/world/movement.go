package world

import (
	_ "embed"
	"encoding/json"
	"errors"
	"math"
	"sync"
	"time"
)

//go:embed collision.json
var collisionData []byte

//go:embed forest_collision.json
var forestData []byte

type Box struct {
	ID     string  `json:"id"`
	X      float64 `json:"x"`
	Z      float64 `json:"z"`
	HX     float64 `json:"hx"`
	HZ     float64 `json:"hz"`
	Height float64 `json:"height"`
	Rot    float64 `json:"rot"`
}
type Geometry struct {
	MaxZ    float64    `json:"max_z"`
	Version int        `json:"version"`
	Spawn   [2]float64 `json:"spawn"`
	Bounds  [3]float64 `json:"bounds"`
	Radius  float64    `json:"radius"`
	Arena   struct {
		Center [2]float64 `json:"center"`
		Radius float64    `json:"radius"`
	} `json:"arena"`
	Piers []Box `json:"piers"`
	Boxes []Box `json:"boxes"`
}
type Position struct {
	Map         string  `json:"map"`
	X           float64 `json:"x"`
	Z           float64 `json:"z"`
	Zone        string  `json:"zone"`
	CharacterID string  `json:"character_id"`
}
type Input struct {
	DX  float64 `json:"dx"`
	DZ  float64 `json:"dz"`
	Run bool    `json:"run"`
}
type entry struct {
	Position
	last time.Time
}
type Service struct {
	mu     sync.Mutex
	geom   Geometry
	forest Geometry
	states map[string]entry
	now    func() time.Time
}

var ErrInput = errors.New("invalid movement input")

func New() *Service {
	var g Geometry
	if e := json.Unmarshal(collisionData, &g); e != nil {
		panic(e)
	}
	var forest Geometry
	if e := json.Unmarshal(forestData, &forest); e != nil {
		panic(e)
	}
	return &Service{geom: g, forest: forest, states: map[string]entry{}, now: time.Now}
}
func (s *Service) initial(id string) entry {
	return entry{Position: Position{Map: "bravamar", X: s.geom.Spawn[0], Z: s.geom.Spawn[1], Zone: "safe", CharacterID: id}, last: s.now()}
}
func (s *Service) State(id string) Position {
	s.mu.Lock()
	defer s.mu.Unlock()
	v, ok := s.states[id]
	if !ok {
		v = s.initial(id)
		s.states[id] = v
	}
	return v.Position
}
func (s *Service) Move(id string, in Input) (Position, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if math.IsNaN(in.DX) || math.IsNaN(in.DZ) || math.IsInf(in.DX, 0) || math.IsInf(in.DZ, 0) || math.Hypot(in.DX, in.DZ) > 1.01 {
		return Position{}, ErrInput
	}
	v, ok := s.states[id]
	if !ok {
		v = s.initial(id)
	}
	g := s.geom
	if v.Map == "bosque" {
		g = s.forest
	}
	now := s.now()
	dt := math.Max(0, math.Min(.16, now.Sub(v.last).Seconds()))
	v.last = now
	speed := 4.5
	if in.Run {
		speed = 6
	}
	dx, dz := in.DX*dt*speed, in.DZ*dt*speed
	len := math.Hypot(dx, dz)
	steps := int(math.Ceil(len / .12))
	if steps < 1 {
		steps = 1
	}
	for i := 0; i < steps; i++ {
		nx, nz := v.X+dx/float64(steps), v.Z+dz/float64(steps)
		if g.Walkable(nx, nz) {
			v.X, v.Z = nx, nz
			continue
		}
		if g.Walkable(nx, v.Z) {
			v.X = nx
		}
		if g.Walkable(v.X, nz) {
			v.Z = nz
		}
	}
	v.Zone = "safe"
	if v.Map == "bravamar" && math.Hypot(v.X-g.Arena.Center[0], v.Z-g.Arena.Center[1]) <= g.Arena.Radius {
		v.Zone = "arena_future"
	}
	s.states[id] = v
	return v.Position, nil
}
func (g Geometry) Walkable(x, z float64) bool {
	r := g.Radius
	if x < g.Bounds[0] || x > g.Bounds[1] || z < g.Bounds[2] {
		return false
	}
	if g.MaxZ > 0 && z > g.MaxZ {
		return false
	}
	shore := 26.5 + 1.8*math.Sin(x*.12) + .9*math.Sin(x*.26+1.2)
	if g.MaxZ == 0 && z > shore-r {
		onPier := false
		for _, p := range g.Piers {
			if math.Abs(x-p.X) <= p.HX-r && math.Abs(z-p.Z) <= p.HZ-r {
				onPier = true
			}
		}
		if !onPier {
			return false
		}
	}
	for _, b := range g.Boxes {
		a := b.Rot * math.Pi / 180
		dx, dz := x-b.X, z-b.Z
		lx, lz := dx*math.Cos(a)-dz*math.Sin(a), dx*math.Sin(a)+dz*math.Cos(a)
		ox, oz := math.Max(0, math.Abs(lx)-b.HX), math.Max(0, math.Abs(lz)-b.HZ)
		if ox*ox+oz*oz < r*r {
			return false
		}
	}
	return true
}

var ErrPortal = errors.New("portal unavailable or too far")

func (s *Service) Travel(id, destination string) (Position, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	v, ok := s.states[id]
	if !ok {
		v = s.initial(id)
	}
	switch {
	case v.Map == "bravamar" && destination == "bosque" && math.Hypot(v.X+46, v.Z+3) <= 3:
		v.Map = "bosque"
		v.X = 39
		v.Z = 0
	case v.Map == "bosque" && destination == "bravamar" && math.Hypot(v.X-43, v.Z) <= 3:
		v.Map = "bravamar"
		v.X = -42
		v.Z = -3
	default:
		return v.Position, ErrPortal
	}
	v.Zone = "safe"
	v.last = s.now()
	s.states[id] = v
	return v.Position, nil
}
