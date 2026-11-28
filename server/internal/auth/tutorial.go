package auth

import (
	"errors"
	"reflect"
	"slices"
)

var ErrTutorialAction = errors.New("invalid tutorial action")

type TutorialProgress struct {
	Phase            string   `json:"phase"`
	ResumePhase      string   `json:"resume_phase,omitempty"`
	Visits           []string `json:"visits"`
	LandDeedUnlocked bool     `json:"land_deed_unlocked"`
}
type QuestView struct {
	Progress  TutorialProgress `json:"progress"`
	Title     string           `json:"title"`
	Objective string           `json:"objective"`
	Targets   []string         `json:"targets"`
	Completed int              `json:"completed"`
	Total     int              `json:"total"`
}
type Choice struct {
	Action string `json:"action"`
	Label  string `json:"label"`
}
type TutorialDialogue struct {
	Quest   QuestView `json:"quest"`
	Text    string    `json:"text"`
	Choices []Choice  `json:"choices"`
}

var professions = []string{"kael", "dara", "nilo", "tovan", "oren", "nara"}

func initialTutorial(p *TutorialProgress) TutorialProgress {
	if p == nil {
		return TutorialProgress{Phase: "not_started", Visits: []string{}}
	}
	v := *p
	v.Visits = append([]string{}, p.Visits...)
	return v
}
func view(p TutorialProgress) QuestView {
	q := QuestView{Progress: p, Targets: []string{}, Total: 3}
	switch p.Phase {
	case "not_started":
		q.Title = "Chegada a Bravamar"
		q.Objective = "Converse com Maia, no pavilhão ao norte da praça."
		q.Targets = []string{"maia"}
	case "arrival_visit":
		q.Title = "Chegada a Bravamar"
		q.Objective = "Converse com Oren, no mercado."
		q.Targets = []string{"oren"}
	case "arrival_return":
		q.Title = "Chegada a Bravamar"
		q.Objective = "Volte a Maia para registrar sua chegada."
		q.Targets = []string{"maia"}
	case "orientation_offer":
		q.Completed = 1
		q.Title = "Os seis caminhos"
		q.Objective = "Converse com Maia para aceitar a apresentação dos ofícios."
		q.Targets = []string{"maia"}
	case "orientation_visits":
		q.Completed = 1
		q.Title = "Os seis caminhos"
		q.Objective = "Conheça Kael, Dara, Nilo, Tovan, Oren e Nara (em qualquer ordem)."
		for _, id := range professions {
			if !slices.Contains(p.Visits, id) {
				q.Targets = append(q.Targets, id)
			}
		}
	case "orientation_return":
		q.Completed = 1
		q.Title = "Os seis caminhos"
		q.Objective = "Retorne a Maia após conhecer os seis ofícios."
		q.Targets = []string{"maia"}
	case "routes_offer":
		q.Completed = 2
		q.Title = "Além dos portões"
		q.Objective = "Converse com Maia para aceitar a orientação de viagem."
		q.Targets = []string{"maia"}
	case "routes_visit":
		q.Completed = 2
		q.Title = "Além dos portões"
		q.Objective = "Converse com Varo, na casa de viagens."
		q.Targets = []string{"varo"}
	case "routes_return":
		q.Completed = 2
		q.Title = "Além dos portões"
		q.Objective = "Volte a Maia para concluir a orientação."
		q.Targets = []string{"maia"}
	case "complete":
		q.Completed = 3
		q.Title = "Tutorial concluído"
		q.Objective = "Você está livre para explorar Bravamar. Próximas regiões serão liberadas depois."
	case "paused":
		q.Title = "Tutorial pausado"
		q.Objective = "Explore livremente. Converse com Maia para retomar."
		q.Targets = []string{"maia"}
		if p.ResumePhase != "paused" {
			q.Completed = view(TutorialProgress{Phase: p.ResumePhase, Visits: p.Visits}).Completed
		}
	}
	return q
}
func (s *Service) Tutorial(token string) (QuestView, error) {
	c, e := s.Selected(token)
	if e != nil {
		return QuestView{}, e
	}
	return view(initialTutorial(c.Tutorial)), nil
}
func (s *Service) InteractTutorial(token, character, npc, action string) (TutorialDialogue, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	a, e := s.meLocked(token)
	if e != nil {
		return TutorialDialogue{}, e
	}
	if e = s.expireRosters(); e != nil {
		return TutorialDialogue{}, e
	}
	r := s.characters[a.ID]
	if r.SelectedID != character {
		return TutorialDialogue{}, ErrCharacterMissing
	}
	index := -1
	var c *Character
	for i, v := range r.Slots {
		if v != nil && v.ID == character && v.DeleteAt == nil {
			index = i
			c = v
			break
		}
	}
	if index < 0 {
		return TutorialDialogue{}, ErrCharacterMissing
	}
	before := initialTutorial(c.Tutorial)
	p := initialTutorial(c.Tutorial)
	d := TutorialDialogue{Choices: []Choice{}}
	if action == "talk" {
		switch p.Phase {
		case "arrival_visit":
			if npc == "oren" {
				p.Phase = "arrival_return"
				d.Text = "Maia vai querer saber que você conheceu o mercado."
			}
		case "orientation_visits":
			if slices.Contains(professions, npc) && !slices.Contains(p.Visits, npc) {
				p.Visits = append(p.Visits, npc)
				d.Text = "Ofício conhecido. Continue sua visita pela cidade."
				if len(p.Visits) == len(professions) {
					p.Phase = "orientation_return"
					d.Text = "Você conheceu todos os ofícios. Volte a Maia."
				}
			}
		case "routes_visit":
			if npc == "varo" {
				p.Phase = "routes_return"
				d.Text = "Agora você conhece as duas rotas. Volte a Maia."
			}
		}
	} else {
		if npc != "maia" {
			return TutorialDialogue{}, ErrTutorialAction
		}
		switch action {
		case "accept":
			switch p.Phase {
			case "not_started":
				p.Phase = "arrival_visit"
			case "orientation_offer":
				p.Phase = "orientation_visits"
			case "routes_offer":
				p.Phase = "routes_visit"
			default:
				return TutorialDialogue{}, ErrTutorialAction
			}
		case "complete":
			switch p.Phase {
			case "arrival_return":
				p.Phase = "orientation_offer"
				p.LandDeedUnlocked = true
				d.Text = "Sua chegada está registrada. A elegibilidade à escritura foi liberada; seu terreno será disponibilizado na fase de residência."
			case "orientation_return":
				p.Phase = "routes_offer"
				d.Text = "Você conhece os seis caminhos. Não precisa escolher uma profissão fixa."
			case "routes_return":
				p.Phase = "complete"
				d.Text = "Bravamar agora é sua casa de partida. Escolha seu próprio caminho."
			default:
				return TutorialDialogue{}, ErrTutorialAction
			}
		case "pause":
			if p.Phase == "complete" || p.Phase == "paused" {
				return TutorialDialogue{}, ErrTutorialAction
			}
			p.ResumePhase = p.Phase
			p.Phase = "paused"
			d.Text = "Explore com calma. Estarei aqui quando quiser retomar."
		case "resume":
			if p.Phase != "paused" {
				return TutorialDialogue{}, ErrTutorialAction
			}
			p.Phase = p.ResumePhase
			p.ResumePhase = ""
		default:
			return TutorialDialogue{}, ErrTutorialAction
		}
	}
	if npc == "maia" {
		if d.Text == "" {
			d.Text = view(p).Objective
		}
		switch p.Phase {
		case "not_started", "orientation_offer", "routes_offer":
			d.Choices = append(d.Choices, Choice{"accept", "Aceitar missão"})
		case "arrival_return", "orientation_return", "routes_return":
			d.Choices = append(d.Choices, Choice{"complete", "Concluir missão"})
		case "paused":
			d.Choices = append(d.Choices, Choice{"resume", "Retomar tutorial"})
		}
		if p.Phase != "complete" && p.Phase != "paused" {
			d.Choices = append(d.Choices, Choice{"pause", "Explorar sem tutorial"})
		}
	}
	if !reflect.DeepEqual(before, p) {
		v := *c
		v.Tutorial = &p
		r.Slots[index] = &v
		m := s.copyRosters()
		m[a.ID] = r
		if e = s.writeRosters(m); e != nil {
			return TutorialDialogue{}, e
		}
	}
	d.Quest = view(p)
	return d, nil
}
