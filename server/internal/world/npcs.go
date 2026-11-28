package world

import (
	_ "embed"
	"encoding/json"
	"math"
)

//go:embed npcs.json
var npcData []byte

type NPC struct {
	ID     string  `json:"id"`
	Name   string  `json:"name"`
	Role   string  `json:"role"`
	X      float64 `json:"x"`
	Z      float64 `json:"z"`
	Color  string  `json:"color"`
	Bio    string  `json:"bio"`
	Dialog string  `json:"dialog"`
	Asset  string  `json:"asset"`
}

const InteractionDistance = 2.8

func NPCByID(id string) (NPC, bool) {
	var list []NPC
	if json.Unmarshal(npcData, &list) != nil {
		return NPC{}, false
	}
	for _, n := range list {
		if n.ID == id {
			return n, true
		}
	}
	return NPC{}, false
}
func (s *Service) NearNPC(character string, n NPC) bool {
	p := s.State(character)
	return p.Map == "bravamar" && math.Hypot(p.X-n.X, p.Z-n.Z) <= InteractionDistance
}
