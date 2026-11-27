# P00 — Matriz de cobertura do GDD

Data: 27/11/2026. Estado: auditoria de conteúdo e homologação **amostral**. Candidato = arquivo localizado; não implica rig compatível, licença independente de terceiros, qualidade visual ou aprovação de uso. A lista de nomes e caminhos está em asset_catalog.csv. A quantidade é por stem por pack; nomes repetidos entre packs podem ser variantes ou duplicatas.

## A01–A30 (referência direta ao inventário do GDD)

| ID | Candidatos confirmados | Lacuna / decisão |
|---|---|---|
| A01 | Q01 seis corpos/roupas completas (Monk, Ranger, Cleric, Rogue, Warrior, Wizard); Q02 humano; Q21 mannequin feminino | Modularidade real, 2 corpos neutros, rostos, cabelos e rig unificado ainda precisam produção; separar acessórios e não vincular aparência ao equipamento. Monk é referência visual, não classe fixa. |
| A02 | Q01 + Q02 humano | 48 identidades por variações de rosto/roupa/texture; não reutilizar 6 modelos sem diferenciação. |
| A03 | Q04 4, Q19 21, Q07/Q18 fauna | Ver matriz abaixo; faltam espécies, 24 variantes e retarget. |
| A04 | Q04 Dragon; Q19 Cyclops, Yeti, Tree, Cthulhu, YellowDragon, Demon | 10 bosses próprios faltam; criar silhueta, fases, clipes e VFX únicos. Não usar um mob simplesmente ampliado. |
| A05 | Q07 Cow, Horse, Pig, Sheep; Q19 Chicken | Cabra, coelho, pato e juvenis; clipes de comer/descansar e sela pendentes. |
| A06 | Q18 Fish1–3, Shark, Manta ray, Dolphin, Whale | 3 peixes iniciais, variedades regionais e enguia/coral ainda faltam; não usar espécies marinhas inadequadas. |
| A07 | Q03 106 modelos variados, Q22 24 armas, Q12 Axe_Bronze/Sword_Bronze/Pickaxe_Bronze | 5 tiers por família; besta e grimório utilizável, armas de madeira e ícones faltantes; adaptar materiais, não variar avatar. |
| A08 | Q03 Armor_Black/Golden/Leather/Metal/Metal2, rings, necklace, glove | 85 ícones de equipamentos, não 85 malhas vestíveis; render padronizado, ícones faltantes. |
| A09 | Q12 Axe/Pickaxe; Q22 Scythe/Hammer; Q17 Axe/Knife/Shovel; Q05 Well, Q03 poções | Varas, enxadas, regadores, kits alquimia e tiers T1–T5; ferramenta inicial de madeira é lacuna P0. |
| A10 | Q03 Bone, FishBone, Mineral, Crystals, Coin, Gold_Ingots, Skulls, etc.; Q14 alimentos; Q08 culturas; Q12 props | Catalogar IDs econômicos e render ícone original por item; faltam minerais específicos, essências, couro e refinados. |
| A11 | Q11 árvores/rochas, Q05 Rock_1–3, Q03 Mineral/Crystal, Q08 plantas | Modelos exauridos, nós de minério regional, brotos e hitbox/interação; não confundir pedra decorativa com nó colhível. |
| A12 | Q11 68 modelos Standard, Q08 gramas/flores/cogumelos, Q05 rochas | Q11 tem somente 68/116 da versão comercial; adaptar paleta, LOD, impostores/instancing; não assumir todos os 77 slots cobertos. |
| A13 | Q13 módulos e texturas, Q06 pisos, Q11 rochas e caminhos, Q05 caminhos | Materiais de chão e transições originais; água, neve/gelo, lava e solo arado shader/mesh próprios. |
| A14 | Q13 176 módulos Standard, Q06 48, Q11 natureza | Terreno navegável, desníveis, ponte, costa, cachoeira, cavernas, transições; composições originais. |
| A15 | Q05 44 modelos (inclui 10 prédios), Q13 176 | Adaptação modular e quatro paletas, grid, encaixes e pivôs. Neve/deserto/porto personalizados. |
| A16 | Q05 House_1–4, Inn, Blacksmith, Mill, Sawmill, Stable, Bell_Tower, Well, MarketStand | Loja, prefeitura, guilda, armazém, porto, estaleiro, arena e observatório serão composições. |
| A17 | Q06 48 módulos (arch, wall, floor, prop, door, stairs etc.) | 5 paletas e salas de boss únicas; colisão, navmesh e armadilhas independentes. |
| A18 | Q12 94, Q15 24, Q16 123, Q05 crates/fences/benches | Q15/Q16 incluem itens modernos: excluir eletrodomésticos, sofás modernos e banheiro contemporâneo; selecionar por coerência. |
| A19 | Q05 Blacksmith/Sawmill/Mill/Cauldron/Well; Q12 Anvil; Q17 pot/pan | 11 estações com 3 estados de tier; preparar artes de fundição, alquimia, tecelagem, estaleiro, irrigação; animações de operação. |
| A20 | Q05 Stable/Hay/Fence/Well; Q08 culturas; Q07 fauna; Q13 wood fences | Galinheiro, silo, estufa, comedouro, ninho, cisterna, irrigação devem ser compostos/criados. |
| A21 | Q08 102 variantes de cultura | Só algumas das 14 espécies do GDD constam; ver tabela. Diferenciar estágios 1–4 e Crop colhido. |
| A22 | Q05 Cart, Q07 Horse, Q09 Boat/BoatWSail/Sail ship/Viking boat, Q17 Raft | Cargueiro adaptado, carroça/arreio, carga/dano; rejeitar CruiseShip e Lifeboat modernos. |
| A23 | Q14 103 modelos (inclui comida moderna); Q03 poções, Q05 Cauldron | Receitas medievais (ensopado, chá, vinho etc.) e modelos por efeito; excluir hambúrguer, latas e modernos. |
| A24 | Q05/Q06/Q12/Q13 props, Q03 itens, Q17 fogueira/tocha | Sinalização, guias, marcos e objetos específicos de cada bioma. |
| A25 | K01 143 stems, K02 104 stems, U01 108 | UI original; recolor 9-slice; 24 telas, fluxos e acessibilidade ainda não implementados. |
| A26 | Q03 renders PNG, U01 icons, K01/K02 | Renderizar overlays de tier/status, skills, professions, mapas; catálogo de 300+ IDs precisa ser produzido, não usar ícones pequenos sem ajuste. |
| A27 | nenhum pack específico de VFX homologado | 40 prefabs originais; partículas, mesh/atlas, telegráfos e teleporte. |
| A28 | S01 96 nomes de áudio, S02 80, K02 6 | Mapeamento por evento, superfícies e espécies, edição de loop e lacunas; nenhum áudio ainda aprovado por escuta. |
| A29 | M02–M08, M07 contém 3 faixas (9 candidatos no total) | 30 cues, motivo principal, trilhas por região e bosses; música compartilhada onde coerente. |
| A30 | render real de assets P00 | Marca Colony World original, login/seleção cinematográficos, loading, cards e identidade visual ainda a produzir. |

## Criaturas — 36 famílias previstas

Legenda: **E** candidato explicitamente nomeado; **A** candidato adaptável (não equivale à espécie); **L** lacuna. Nenhum E é homologado automaticamente. Q19 é mais chibi e só deve entrar quando a proporção não prejudicar leitura.

| Família GDD | Estado | Origem / ação |
|---|---|---|
| Gosma | E | Q04 Slime (piloto) |
| Coelho | L | modelar quadrúpede pequeno |
| Lobo | L | rig quadrúpede, cauda e ataques |
| Besouro | L | modelar invertebrado |
| Javali | A | Q07/Q19 Pig; presas e proporção própria |
| Bandido | A | Q01 humano, aparência não associada à classe |
| Vespa | A | Q19 Bee; modelar ferrão e telegráfo |
| Kobold | L | humanoide pequeno próprio |
| Escorpião | L | rig multiarticulado |
| Morcego | E | Q04 Bat ou Q19 Bat |
| Golem | L | rig e peças de rocha |
| Aranha | L | rig de oito patas |
| Urso | A | Q19 Panda; refazer proporção/pelagem |
| Dríade | L | humanoide vegetal original |
| Sapo | L | rig salto |
| Espectro | A | Q19 Ghost; paleta e silhueta adulta |
| Crocodilo | L | rig cauda e mandíbula |
| Lodo | A | Q04 Slime; espécie visual distinta e habilidade |
| Caranguejo | E | Q19 Crab |
| Pirata | A | Q01 humano; vestimenta original |
| Harpia | L | voo + humanoide |
| Enguia | L | rig serpentino aquático |
| Orc | L | humanoide robusto |
| Lagarto | L | quadrúpede/reptiliano |
| Abutre | L | ave com voo |
| Yeti | E | Q19 Yeti (avaliar proporções) |
| Elemental | L | modelar variantes e rig/VFX |
| Serpente | L | rig serpentino |
| Sentinela | A | Q04 Skeleton ou Q19 Cyclops como base de rig; design próprio |
| Djinn | L | silhueta e VFX próprios |
| Treant | A | Q19 Tree; humanoide arbóreo |
| Feiticeiro | A | Q01 Wizard, visual inimigo original |
| Mariposa | L | rig voo independente |
| Dragão | E | Q04 Dragon ou Q19 YellowDragon |
| Guardião | A | base humanoide ou golem novo; design original |
| Revenante | A | Q04 Skeleton; identidade e clipes próprios |

O esqueleto do piloto oferece referência de combate distinta, mas não substitui automaticamente qualquer família do GDD. Veado é fauna adicional. O foco P0 é gosma, lobo jovem, besouro e coelho do Bosque; **três dos quatro exigem criação**. Antes do P0 de combate completo, criar esses três modelos e seus clipes básicos. Também deixar árvore, minério cobre e erva disponíveis na mesma escala.

## Cultivos

| Cultivo | Evidência / solução |
|---|---|
| Trigo | Wheat_1–4 e Wheat_Crop (colhido); estágio 4 no piloto |
| Milho | Corn_1–4, Crop, Harvested |
| Cenoura | Carrot_1–4, Crop |
| Batata | lacuna; não confundir Beet com batata |
| Couve | lacuna; Lettuce pode servir de proxy, não de asset final |
| Abóbora | Pumpkin_1–4, Crop, Harvested |
| Maçã | Apple_1–4, Crop, Harvested |
| Uva | lacuna de videira (Q14 pode fornecer fruto, não planta) |
| Lúpulo | lacuna |
| Algodão | lacuna |
| Erva medicinal | adaptar Grass/Flower sem reutilizar exatamente a silhueta de erva genérica |
| Pimenta | lacuna cultivo |
| Flor lunar | criar original por variante de flor |
| Aloé | adaptar Cactus apenas como proxy, modelar folhas próprias |

## Ordem de fechamento das lacunas

1. P0: avatar neutro e animações de caminhada/ataque/coleta, coelho/lobo/besouro, picareta/machado/espada de madeira, minério cobre e estado exaurido, erva, UI inicial.
2. P1: residência vazia, construção modular, estações, modelos ausentes de cultivo/animais, mercado, ícones de T1/T2.
3. P2/P3: espécies e bosses regionais, navegação, estação avançada, cultivos e itens T3–T5, VFX, música e UI completas.
4. Aprovação por lote: manifesto de derivação + cena + clipes + validação de engine, sem importação indiscriminada dos 1028 candidatos.
