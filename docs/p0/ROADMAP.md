# Roadmap P0 — Vertical Slice

P00 aprovada em 27/11/2026. Cada etapa exige código, teste, registro e aprovação antes da próxima. A P0.1 é a fundação técnica; não antecipar mecânicas das próximas etapas.

| Etapa | Entrega e critério |
|---|---|
| P0.1 ✅ aprovada | Fundação cliente/servidor/schema, conexão local e jogar.bat; smoke test |
| P0.2 ✅ aprovada | Tela inicial, autenticação e criação de conta; validação e sessão |
| P0.3 ✅ aprovada | Seleção/criação de até 5 personagens; limites persistentes |
| P0.4 ⏳ entregue | Vila Bravamar: direção artística original, NPCs e arena delimitada |
| P0.5 | Avatar, câmera e movimento; validação de estado |
| P0.6 | NPCs, diálogo e tutorial |
| P0.7 | Bosque do Orvalho; novos inimigos e recursos homologados |
| P0.8 | Combate, XP e atributos; regras autoritativas |
| P0.9 | Inventário, equipamentos e consumíveis |
| P0.10 | Coleta, ferramentas iniciais, nós e respawn |
| P0.11 | Desfiladeiro Ferrugem |
| P0.12 | Sincronização multiplayer e dois clientes |
| P0.13 | Persistência, transações e reconexão |
| P0.14 | HUD, som e polimento |
| P0.15 | Auditoria, regresso, build e demonstração completa |

O cliente Godot e o serviço Go permanecem separados. PostgreSQL é o estado durável. Não afirmar que há MMO até a conexão e persistência completas. Atualizar jogar.bat conforme cada fase.


