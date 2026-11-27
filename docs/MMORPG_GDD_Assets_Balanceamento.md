# PROJETO AUREVIA — Bíblia de desenvolvimento
**Versão 1.0 • 27/11/2026 • Nome provisório • Escopo de lançamento 1.0**

Este documento reúne três especificações independentes: GDD, inventário de arte e balanceamento. É uma proposta executável, não um jogo já implementado. Quantidades e valores são metas iniciais sujeitas a testes. As referências a Albion Online, Mu Online, WoW e Mir4 dizem respeito a conceitos de gameplay, não à reprodução de suas marcas, mapas, personagens, interfaces ou assets.

# DOCUMENTO 1 — GAME DESIGN DOCUMENT

## 1. Visão e pilares

MMORPG 3D de fantasia medieval estilizada, câmera elevada em perspectiva, mundo compartilhado e economia conduzida pelos jogadores. O protagonista chega a uma fronteira em reconstrução após a ruptura de antigas rotas comerciais. Não há classes fixas, facções obrigatórias ou profissão exclusiva. O jogador escolhe como viver; sua identidade nasce do tempo investido, relações, patrimônio e especialização.

- **Interdependência:** nenhuma profissão domina toda a cadeia com a mesma eficiência; todos podem aprender, mas especializar-se custa tempo e oportunidade.
- **Utilidade:** cada material obtido tem no mínimo duas saídas econômicas úteis, incluindo ao menos uma demanda recorrente. Itens de missão e cosméticos têm finalidade própria; não são lixo.
- **Liberdade:** combate, coleta, construção, fazenda, preparo ou comércio são caminhos completos, não atividades subsidiárias obrigatórias de combate.
- **Risco informado:** zonas seguras e de PvP claramente identificadas; arena livre sem inscrição; perigo maior recompensa maior, não acesso exclusivo a materiais essenciais.
- **Persistência e comunidade:** mercado regional, residência privada, contratos de trabalho, grupos, guildas, eventos globais.
- **Justiça:** nenhum poder, ouro, experiência, recurso, capacidade de trabalho ou vantagem comercial vendido por dinheiro real. Monetização proposta: cosméticos de aparência selecionados separadamente dos equipamentos, sem impacto de colisão ou legibilidade, e emotes. Não vender slots adicionais de personagens acima de cinco.

Público: jogadores de MMORPG, gestão, crafting e exploração; sessões de 15–120 minutos. PC primeiro, teclado e mouse; versão navegador é proposta opcional (não presumida como requisito). Câmera 45–60° inclinada, rotação opcional em passos, zoom limitado, leitura clara de ataques e silhuetas.

## 2. Fluxos e controles

| Ação | Controle padrão |
|---|---|
| Mover | WASD ou clique no chão configurável |
| Interagir/coletar | E ou clique contextual |
| Ataque básico | botão esquerdo sobre alvo |
| Habilidades | Q, R, F, 1, 2, 3 (6 slots) |
| Esquiva | espaço |
| Alvo seguinte | Tab |
| Inventário / personagem | I / C |
| Profissões / mapa | P / M |
| Amigos / guilda | O / G |
| Chat | Enter, Esc para fechar |
| Construção | B na residência, rotação R em modo construção |

Remapeamento, redução de movimento e flashes, modo daltônico, escala de UI, texto de combate opcional, volumes independentes, legendas. Movimento e ações não dependem de câmera cinematográfica. Input nunca permite atravessar paredes ou alcançar interações fora do alcance.

### 2.1 Entrada e identidade

Tela inicial original: porto antigo ao entardecer, barcos oscilando, bandeiras, luzes, partículas de poeira, câmera lenta, trilha orquestral em loop; botões entrar, criar conta, configurações, acessibilidade e créditos. Login verificado, recuperação de conta, aviso de manutenção e status do mundo. Após login: cinco pedestais/posições de personagens em salão de navegadores, pequenos loops de respiração, câmera sobre personagem selecionado, nome, nível, cidade e última conexão; slots vazios permitem criação. Criador: nome único por mundo (3–20 caracteres), corpo, rosto/cabelo, cor de pele, vestimenta base, prévia e confirmação. Nenhuma escolha altera atributos. Exclusão com confirmação e carência proposta de 72h; personagem não reaproveita itens por exclusão. Um personagem online por conta. Inventário, descoberta, residência e XP por personagem; bloqueios de eventos e limites anti-abuso por conta quando indicados.

### 2.2 Primeiros 30 minutos

Nascimento em Vila Bravamar, nível de combate 1, 0 ouro, 1 picareta de madeira, 1 machado de madeira, 1 espada de madeira, 2 poções de vida. Ferramentas iniciais vinculadas, não vendáveis; substituição básica gratuita se perdidas, sem duplicação. Anciã Maia ensina movimento, combate, coleta, preparo, construção e comércio com missões opcionais de introdução. Tutorial dá pequenos insumos, nunca equipamento de alto nível. Entrega da primeira tarefa libera escritura gratuita de terreno vazio. O jogador pode ignorar combate após uma introdução segura e iniciar carreira econômica. Progressão civil obtém acesso às cidades por reputação e nível de carreira, sem pontos de combate gratuitos.

## 3. Mundo e conteúdo

Mapa contínuo na percepção do jogador: regiões com fronteiras e transições curtas, streaming/instâncias sob carga, sem mapa procedural à deriva; mapas planejados à mão com rotas alternativas, cavernas, serras, pontos de interesse e atalhos. Travessia a pé sempre possível entre regiões terrestres desbloqueadas; navegação adiciona ilhas e frete. Cada zona tem rotas, pontos de coleta, inimigos de nicho, 1 acampamento seguro fora de zonas vermelhas, missões e marco de descoberta. Biomas possuem identidade visual, música e recursos próprios.

| ID / zona | Nível | Regra | Identidade, recursos, criaturas, marco |
|---|---:|---|---|
| C1 Bravamar | 1 | segura + arena | vila portuária, madeira clara, comércio central |
| Z1 Bosque do Orvalho | 1–5 | verde | pinho, cobre, erva; coelho, gosma, lobo jovem, besouro; moinho |
| Z2 Prado das Cercas | 5–9 | verde | fibra, argila, trigo; javali, lobo, bandido, vespa; fazenda abandonada |
| Z3 Desfiladeiro Ferrugem | 10–15 | verde | ferro, pedra, sal; kobold, escorpião, morcego, golem; mina |
| C2 Forjaponte | 10 | segura | cidade mineira, mercado metalúrgico |
| Z4 Mata de Âmbar | 16–20 | amarela | carvalho, resina, âmbar; aranha, urso, dríade, bandido; ruínas |
| Z5 Charco das Lanternas | 21–25 | amarela | juncos, fungos, estanho; sapo, espectro, crocodilo, lodo; santuário |
| C3 Porto Junco | 20 | segura | cais, estaleiro, mercado agrícola |
| Z6 Costa das Marés | 22–28 | verde | sal, peixe, algas, madeira flutuante; caranguejo, pirata, harpia, enguia; farol |
| Z7 Planalto Rubro | 26–32 | vermelha | prata, basalto, pimenta; orc, lagarto, abutre, golem; fortaleza |
| Z8 Serra Branca | 33–38 | amarela | prata, cedro, gelo mineral; lobo ártico, yeti, urso, elemental; observatório |
| C4 Vigília Alta | 35 | segura | fortaleza montanhosa e mercado de relíquias |
| Z9 Dunas de Vidro | 39–44 | vermelha | quartzo, ouro mineral, aloé; escorpião, serpente, sentinela, djinn; obelisco |
| Z10 Floresta Astral | 45–50 | amarela | madeira lunar, cristal, flor noturna; treant, sentinela, feiticeiro, mariposa; árvore antiga |
| Z11 Ilhas do Vento | 30–45 | amarela | coral, peixe raro, sal azul; pirata, harpia, crustáceo, elemental; porto insular |
| Z12 Fenda do Primeiro Sol | 48–50 | vermelha | cristal solar, obsidiana; dragão, guardião, revenante, elemental; portal global |

Conexões: Bravamar saída oeste → Bosque → Prado → Forjaponte; saída leste → Desfiladeiro → Forjaponte (placa de nível 10 e aviso, não impede exploração). Forjaponte → Mata → Charco → Porto Junco → Costa → Ilhas por barco/cais. Mata → Planalto → Serra → Vigília Alta → Dunas → Floresta → Fenda; Costa → Planalto; Ilhas → Floresta por rota marítima avançada. Bifurcações e atalhos mantêm comércio regional. Níveis recomendados não impedem caminhada, mas combate e recursos exigem competência. Zonas verdes são non-PvP.

### Cidades e NPCs

Bravamar: Anciã Maia (campanha), ferreiro Tovan (armas e reparo), armeira Elara (armaduras), preparador Nilo (poções), decoradora Lume (decoração), registradora Iara (guildas), corretor Oren (mercado/contratos), guardiã Sela (residência), instrutor Kael (arena e treinamento), agricultora Nara (sementes), coletora Dara (licenças/tutorial), mestre de viagens Varo (teleporte). Locais: praça, arena central delimitada, banco/armazém, portão oeste/leste, estações públicas, cais e pousada. Oito NPCs de comércio/serviço nunca ficam dentro da arena.

Forjaponte: mestre metalúrgica, cartógrafo, artesão, guarda das minas, intendente, corretor, curandeiro, viajante. Porto Junco: estaleira, pescador, boticária, criadora, capitã, corretor, guardião de cais, guia do charco. Vigília Alta: historiadora, ferreira de relíquias, guardião astral, chefe de expedições, corretor, preparadora, mestre de viagens, intendente. NPCs repetem funções essenciais, mas têm identidade, diálogo e missões próprias. Inventário NPC: básicos limitados e caros comparados à produção humana; nunca vende itens superiores equivalentes aos melhores craftados.

### 3.1 Missões e narrativa

Campanha em oito arcos: chegada; restauração do moinho; colapso das minas; rotas de âmbar; lanternas do charco; reabertura do porto; guerra dos guardiões; primeiro sol. Capítulos por nível/reputação, escolhas narrativas sem bloqueio de profissão. Cada arco possui 5 missões encadeadas (40); cada região 5 secundárias (60), cidades 6 contratos narrativos (24), total 124 únicas; 24 modelos repetíveis (caravana, encomenda, reparo, coleta, caça, entrega, colheita, estudo de monstro). Missões dão XP da ação relevante, ouro limitado, receitas, reputação ou materiais, nunca forçam todo jogador a matar. Diário registra objetivo, região e recompensas; objetivos compartilhados para grupos; abandono e retomada; diálogos com escolhas e consequências locais. Contratos comunitários de reconstrução consomem insumos de várias profissões.

## 4. Profissões e equipamentos

| Profissão | Jogabilidade | Produtos/serviços | Dependências |
|---|---|---|---|
| Caçador | combate, exploração, raids, captura controlada | couro, osso, carne, essências, troféus, componentes, proteção de comboio | refeições/poções, armas, ferramentas e transporte |
| Coletor | mineração, lenha, fibra, pesca, ervas, refino de insumo | troncos, minério, pedra, fibra, sal, gemas, lingotes/pranchas | ferramentas do construtor, comida do preparador, fertilizantes/óleo |
| Preparador | estações de cozinha, fermentação, alquimia, curtume leve | refeições, bebidas, poções, ração, conservantes, cola, couro tratado | colheitas, carne, ervas, recipientes |
| Construtor | fundição final, forja, marcenaria, obras, montagem | ferramentas, armas, armaduras, joias, móveis, casas, veículos, manutenção | minérios, madeira, fibras, couro e resinas |
| Mercador | ordens, arbitragem, entrega, consignação, logística | serviço de venda, frete, caravanas, contratos regionais, armazenamento | bens de todos; veículos, alimentos e escolta |
| Fazendeiro | cultivo, irrigação, criação, reprodução, adubação | sementes, vegetais, grãos, leite, ovos, lã, animais, adubo | instalações, ração, ferramentas, insumos de caça/coleta |

Cada profissão tem nível 1–50 independente, árvore de domínio de 4 ramos, receitas por nível e treino; XP somente pela ação válida, não pelo mero tempo online. Nível de carreira civil = maior nível entre as cinco profissões não combatentes. Nível de combate = Caçador; título e nível civil são exibidos junto ao nível de combate. Sem bônus de dano por vender itens. Atributos de combate são adquiridos apenas ao evoluir Caçador. Produtos básicos são acessíveis a todos, especializações têm eficiência, rendimento e receitas exclusivas de maestria (não monopólio absoluto: várias alternativas funcionais). Troca de especialização em cidade, custo e carência. Até dois ramos de maestria máxima simultâneos por personagem, restantes podem atingir proficiência normal. Não existe limite que impeça aprender uma profissão.

Ramos: Caçador (lâminas, balística, arcano, guarda); Coletor (madeira, mineral, botânica/fibra, pesca); Preparador (cozinha, bebidas, alquimia, tratamento); Construtor (forja, marcenaria, arquitetura, veículos); Mercador (varejo, atacado, logística, corretagem); Fazendeiro (cultivo, animais, irrigação, sementes). Caçador não precisa escolher ramo exclusivo para usar arma, maestria é bônus marginal. Skills civil: 1, 10, 20, 30, 40, 50. Estações T1–T5 com capacidade e manutenção. Receitas determinísticas mostram insumos, duração, rendimento e custo antes de confirmar. Equipamentos não mudam aparência do corpo, roupa ou silhueta; armas/ferramentas aparecem somente durante a ação para leitura visual, opção de ocultar fora de combate; status e raridade aparecem no inventário. Slots: arma, secundário, cabeça, torso, pernas, mãos, pés, dois anéis, colar, ferramenta ativa, bolsa. Não há identificação de classe por roupa.

## 5. Combate e PvP

Ação em tempo real, alcance e colisão server-side, esquiva com janela breve, ataques telegrafados, mana/energia, seis habilidades equipáveis, uma ação básica, uma reação. Armas: espada, machado, maça, lança, adagas, arco, besta, cajado, grimório e escudo como secundário. Cada família tem básico e 4 habilidades; seis universais (esquiva, aparar, investida, purificação, cura simples, provocação). Requisitos de atributos, não de classe. Exemplos: tanque lança+escudo, mago de suporte cajado+cura, assassino adagas, arqueiro híbrido com cura. Troca fora de combate; cooldown não reinicia ao reequipar. Status: sangramento, queimadura, veneno, lentidão, atordoamento, vulnerabilidade, proteção, cura ao longo do tempo, regeneração, raiz. Sem combo de controle permanente; feedback de resistência e imunidade temporária. Inimigos com patrulha, perseguição, retorno ao território, telegráfo, ataque, reação, morte e respawn; não ficam presos em objetos. Elite: duas habilidades extras, comportamento mais perigoso, não só HP. Chefes: fases com objetivos legíveis, ataques de área e janelas de recuperação.

| Zona | Regra de PvP | Derrota |
|---|---|---|
| verde e cidade | proibido, incluindo dano indireto | PvE: desgaste, retorno a santuário |
| arena central | qualquer pessoa dentro pode atacar sem inscrição, sem aviso por combate individual | sem loot, desgaste zero, respawn fora da arena |
| amarela | PvP livre fora de refúgios; aviso de entrada, não por ataque | desgaste + perda de até 10% dos recursos carregados não protegidos |
| vermelha | PvP livre, rotas alternativas e aviso de fronteira | até 25% dos recursos carregados não protegidos, desgaste; equipamentos nunca caem |

A arena tem borda visível, espaço de entrada com linha de visão, sem invulnerabilidade explorável; volta à cidade após 8s sem combate em saída delimitada. Penalidade por atacar personagens muito inferiores em zonas abertas: redução de recompensa e reputação de agressor, guardas nos refúgios; nenhuma recompensa por matar repetidamente a mesma conta. Componentes indispensáveis possuem rota verde mais lenta ou alternativa por mercado; não se obriga PvP para atividade civil. Relatórios e moderação, bloqueio/mute, nomes adequados e ferramentas anti-bot.

## 6. Coleta, residência, contratos e veículos

Coleta: jazidas e árvores têm 3–10 cargas, níveis de ferramenta, reserva de um ponto por jogador, interação contínua a cada 6–12 s durante até 15 minutos de ausência, termina se recurso acaba, bolsa cheia, ferramenta quebra, ataque ou desconexão. Pontos próprios dedicados, sem clicar infinitamente; nenhuma automação externa permitida. AFK permitido somente no mecanismo nativo, mesmas regras de PvP e risco de exposição. Reposição em 2–12 minutos e distribuição por região; áreas perigosas têm ganho ajustado, não exclusividade. Recurso esgotado tem modelo visual distinto. Coleta ativa usa procura e rotas, rende mais que AFK estacionário. Recurso bruto empilhável, peso, venda regional, refino em estações. Pesca manual/canalizada segue regras de coleta.

Residência privada por personagem, instância 32×32 unidades, escritura inicial gratuita e terreno totalmente vazio (grama/solo, limites invisíveis, ponto de chegada). Expande a 48×48 e 64×64 com obra e ouro. Modo construção: grid 1m, rotação 90°, sobreposição proibida, prévia válida/inválida, conectividade de corredores, caminho para NPC, confirmação e cancelamento; desmontagem devolve 50% materiais comuns, sem duplicação. Estruturas: cercas, placas, caminhos, poço, celeiro, galinheiro, estábulo, casa, cozinha, oficina, armazém, estufa, cisterna, pomar, doca em expansão fluvial, estaleiro, decoração. Casa dá descanso moderado, armazenamento e estética; não gera poder passivamente. Acesso só proprietário, convite temporário ou pedido aceito. Papéis proprietário/visitante/trabalhador/administrador de layout (delegação explícita); permissões granulares por objeto, revogação imediata, log de acesso. Visitante não colhe, retira, constrói nem altera salvo permissão. Cultivos: preparar solo, plantar, regar, colher, semente ou alimento; animais precisam de ração, abrigo e cuidado, não morrem por ausência (produção pausa).

Contratação entre amigos: oferta de tarefa, profissão/nível mínimo, duração, salário/hora, insumos reservados e consentimento do contratado. NPC único com aparência simplificada e snapshot de atributos civis do amigo no aceite (não transfere progressão, inventário ou poder de combate). O amigo continua livre para jogar. Trabalho desconta tempo de servidor, persiste offline, para se falta insumo/saída/energia de estação, não ganha XP para empregado, proprietário recebe produto sem XP de execução. Pagamento por minuto efetivamente trabalhado, proporcional à hora, fundos em escrow, cancelamento devolve saldo não usado. Um contrato ativo por trabalhador/conta, dois NPCs por residência no máximo; 4 horas/dia por conta contratada; proibir contratação própria/entre alts, ciclos de lavagem de ouro, transferências fictícias. Sem NPC contratado para combate, mercado ou coleta em mundo aberto. Painel mostra progresso, custo, destino e histórico; revogação segura. Trabalho manual mais eficiente.

Veículos: carrinho de mão, carruagem, montaria cavalo, bote, barco cargueiro e veleiro. Desbloqueio por construtor/matéria-prima, capacidade, manutenção e combustível alimentar quando aplicável. Caravanas são contratos voluntários, sem teleporte de carga comercial; barcos seguem rotas navegáveis e docas, capitão pode convidar até 3 passageiros. Sem combate naval na versão 1.0. Navegação exige mapas, deslocamento e manutenção; cargas somente entregues fisicamente.

## 7. Comércio, sociabilidade e teleporte

Ouro único, regionalização de mercados em cada cidade, ordem de compra/venda com quantidade/preço, depósito em custódia, histórico de preço mediano/volume, busca por nível e categoria; preenchimento parcial, cancelamento e expiração 72h. Mercado local, bens não teletransportam. Comércio direto com confirmação bilateral e nova confirmação se conteúdo mudar; correio apenas mensagens e retirada de recompensas administrativas, nunca teleporte de mercadoria. Armazém por cidade, banco de residência e bolsas com peso. Mercado e trades normais disponíveis a todos; Mercador recebe XP por transações legítimas com outros jogadores e entregas concluídas; habilidade aumenta slots, reduz taxas dentro de limites e melhora logística. Serviços: corretagem, encomendas com escrow, frete com caução, escolta, produção sob encomenda. Não há empréstimo com juros ou mercado real. Preços NPC como piso de resgate restrito, não garantia de rentabilidade. Item básico sempre acessível sem depender de mercado lotado.

Guilda: criação por registradora, nível de carreira ≥10, custo 2500 ouro, nome/brasão original, cargos mestre/oficial/membro/recruta, permissões auditadas, banco e projetos coletivos, chat, calendário/raids, até 50 membros. Grupos 1–4, convite consentido, marcação, líder, transferência, loot individual; amigos, presença opcional, bloqueio e denúncias. Sem guerra territorial na 1.0; projetos comunitários mantêm demanda economicamente relevante. Chat local/geral/grupo/guilda/privado/comércio/sistema, filtros, timestamps, expansão e histórico. HUD compacta: canto superior esquerdo HP/mana/energia, minimapa e bússola no superior direito, 6 habilidades inferiores, chat inferior esquerdo recolhível, objetivos opcionais e alerta de zona. Painéis modais para inventário, mercado, mapa, residência, árvore, guilda, contratos e configuração.

Teleporte: comando exato /city <nome da cidade> (aceita aliases e nomes com espaço, autocomplete), destino precisa ter sido visitado fisicamente por aquele personagem, nível mínimo da cidade aplicado ao maior entre Caçador e carreira civil, custo de ouro confirmado na interface, canalização 8 s interrompida por movimento/dano, só em área segura fora de arena, cooldown 120 s, sem carga comercial ativa, sem grupo sendo movido automaticamente. Destino: ponto seguro de chegada. Mesmo local não cobra, saldo inválido não cobra, falha de transição devolve. Descoberta exige entrar pela rota normal; teleporte não descobre cidade inédita.

## 8. Instâncias e raids

Raids individuais e de 1–4 disponíveis 24h, entrada solo possível nas grupais; dificuldade escala com participantes, loot pessoal, sem inscrição temporal obrigatória. Portais localizados no mundo; nível, reputação/descoberta e dificuldade informados. Instância 15–35 min, checkpoint pré-chefe, janela de reconexão 5 min, sem PvP. Raids individuais: Covil da Raiz (5), Mina do Vigia (12), Santuário do Lodo (22), Câmara de Vidro (40). Grupais: Fortaleza da Ferrugem (15), Templo Afundado (25), Cidadela da Neve (35), Observatório Astral (45), Fornalha Solar (50). Bosses têm ataque alternado, padrões de área, interrupções, fases e objetivos de grupo sem função obrigatória (builds flexíveis). Global: Guardião do Primeiro Sol, **diariamente às 22:00 no fuso America/Sao_Paulo**, 15 minutos de duração, lobby às 21:50, alertas 30/10/1 min; entrada nível de carreira 30, combate recomendado 35. Jogadores civis participam de logística, reparos e abastecimento com contribuições reais, não mero AFK. Instâncias paralelas de até 40 pessoas compartilham objetivo por mundo; cada conta recebe uma recompensa principal diária se atingir contribuição mínima por combate, cura, suporte ou logística. Se falhar, recompensa parcial proporcional. Nenhuma moeda exclusiva indispensável, raid não monopoliza a economia. Persistir ocorrência por data local; sem duplicação pós-reinício. Calendário exibe hora de Brasília e local do cliente.

## 9. Arquitetura, dados, QA e entregas

Tecnologia recomendada para PC: Godot 4 ou Unity 3D em cliente, servidor autoritativo dedicado independente (ex.: Go/C#), PostgreSQL para persistência transacional, cache opcional e CDN para assets. Para navegador: cliente WebGL com Godot ou Babylon.js/Three.js após prova de desempenho; WebSocket seguro e servidor dedicado; não usar banco como servidor de simulação. Escolha final após protótipo, nenhuma API de IA necessária. Meta inicial: 100 CCU por mundo, 40 por instância global, 30 Hz simulação (avaliar 20 Hz), snapshots 10–15 Hz, interesse espacial por células, interpolação e reconciliação. Jogadores em diferentes regiões não recebem estado desnecessário. Mundo é compartilhado, residência e raids instanciadas sob demanda. Requisitos de segurança defensiva: validação server-side de posição, cooldown, alcance, propriedade e inventário; rate limit, controle de acesso, logs, idempotência por operação, transações atômicas de ouro/itens, backups e restauração testada, configurações versionadas. Senhas tratadas pelo provedor de autenticação; sem credenciais no cliente. Dados: account, character, appearance, stats, profession_xp, mastery, skill, item_definition, item_instance, inventory, recipe, station, resource_node, zone, npc, quest, quest_progress, discovery, housing_plot, placed_object, crop, animal, contract, escrow, market_order, ledger, guild, friend, raid_run, daily_event, moderation. IDs estáveis e entidades orientadas a dados, migrações de esquema, telemetria com consentimento e exclusão de conta conforme política aplicável.

Fases (portões de aceitação, não prazos prometidos):
1. P0: vertical slice com Bravamar, Z1 e Z3; login/5 slots, combate, coleta, inventário, persistência, arte piloto.
2. P1: seis profissões T1–T2, construção e terreno vazio, mercado e contratos, tutorial, arena, dois mapas adicionais.
3. P2: zonas Z4–Z8, cidades C2/C3, fazenda, veículos terrestres, teleporte, raids, guildas e trabalho NPC.
4. P3: Z9–Z12, C4, mar, T4–T5, raid global, economia e missões totais.
5. P4: QA de conteúdo, acessibilidade, testes concorrentes, moderação, carga, recuperação, playtest fechado, beta e lançamento 1.0.
Aceite: recriar personagem, persistência sob reinício, limite 5, impossibilidade de duplicar itens, comércio atômico, nenhum dano em zona verde/fora arena, viagem restrita a descoberta, contratos pagam exatamente trabalho, cada recurso possui compradores e rotas de consumo, todas profissões alcançam nível 50 sem combate obrigatório (exceto Caçador), content lint, fluxo de raid escalável e reset às 22h sem duplicidade. Pós-lançamento: temporadas narrativas, regiões, territórios e combate naval somente após validação econômica.

# DOCUMENTO 2 — INVENTÁRIO E AQUISIÇÃO DE ASSETS

## 10. Direção visual e especificação técnica

Estilo low-poly 3D estilizado, fantasia medieval colorida, proporções humanas simplificadas (não voxel nem pixel art), formas legíveis à distância, materiais foscos, iluminação suave, sombras de contato e efeitos discretos. Quaternius como família principal; não misturar aleatoriamente packs realistas, pixelados, chibi extremos ou texturas fotográficas. Paleta global: pedra cinza-azulada #65747A, madeira #865D42, vegetação #507B52, tecido #B6A47E, metal #A6AFB4; cada bioma altera acentos, não o estilo. Bravamar verde/azul; mineração ferrugem/ocre; charco verde-musgo/âmbar; neve azul/frio; deserto dourado/lilás; astral violeta/azul; Fenda obsidiana/laranja. UI grafite, pergaminho em painéis, dourado moderado; vermelho e verde acompanhados de ícones e texto. Modelo-base do avatar 1,75 m, proporção aproximada de 5,5–6 cabeças; criaturas comuns 0,5–2,5 m, elites 1,5–3 m, chefes 3–8 m. Blender para padronizar materiais e rig, exportar glTF/GLB (FBX se necessário), escala 1 unidade = 1 m, pivô no chão; sockets mão direita/esquerda, cabeça, costas, VFX; texturas sRGB para cor, mapas técnicos lineares. Normalizar orientação pelo importador. Meshes sem geometrias invisíveis redundantes; LOD0/1/2; atlas de materiais 512–1024, chefes 2048 quando necessário. Alvos indicativos: avatar 2–6k triângulos, NPC 1–4k, animal/mob 0,8–5k, boss 5–15k, objetos 100–2k, módulos 200–3k, LOD1 ~50%, LOD2 ~20%. Instancing para vegetação e repetidos; colisores simples e navmesh separado; modelos distantes simplificados. Animações 30 fps, in-place para locomoção, eventos de impacto e som, root motion apenas quando servidor valida deslocamento. Nunca copiar diretamente a estética de interfaces ou personagens proprietários.

### 10.1 Regras de aquisição

Metas de contagem são slots funcionais, não arquivos comprovadamente presentes nos packs. Variantes de cor, crescimento e dano são contabilizadas como instâncias/estados, não obrigatoriamente meshes exclusivos. P0 = imprescindível vertical slice; P1 = primeira economia; P2/P3 = restante do lançamento. Adaptar quando pack não cobre a função: kitbash de meshes CC0 verificados, recolor, retarget, modelagem original. Um asset só entra no jogo após aprovação de licença, origem, visual, escala, UV, rig, colisão, desempenho e teste em cena. Não usar arte extraída de jogos comerciais.

## 11. Catálogo OpenGameArt — pacotes candidatos

Pesquisa de índice público em 27/11/2026. As páginas do domínio bloquearam abertura direta por robots.txt; títulos, descrição, autor, licença e formatos abaixo foram obtidos dos resultados indexados, não de download ou inspeção do ZIP. Confirmar arquivo e licença na página original antes de importar. CC0 é a preferência; verificar cada arquivo e conteúdo incorporado. Links diretos abaixo são os retornados pelo índice.

| Código | Pacote e origem | Licença indicada | Uso e ressalvas |
|---|---|---|---|
| Q01 | [LowPoly RPG Characters](https://opengameart.org/content/lowpoly-rpg-characters) — Quaternius | CC0 | 6 personagens animados/rigados/texturizados; FBX/OBJ/Blend, base avatar/NPC; roupas devem ser somente aparência |
| Q02 | [Animated Human Low Poly](https://opengameart.org/content/animated-human-low-poly) — Quaternius | CC0 | idle, walk, run, work, jump, punch, death; rig auxiliar, não misturar antes de normalizar proporção |
| Q03 | [Low Poly RPG Pack](https://opengameart.org/content/low-poly-rpg-pack) — Quaternius | CC0 | 100+ modelos de itens e renders PNG; FBX/OBJ/Blend; inventário, armas, gemas |
| Q04 | [LowPoly Animated Monsters](https://opengameart.org/node/87239) — Quaternius | CC0 | criaturas animadas (gosma, esqueleto, dragão, morcego indicados); verificar quantidade e clipes |
| Q05 | [LowPoly Medieval Village Pack](https://opengameart.org/content/lowpoly-medieval-village-pack) — Quaternius | CC0 | arquitetura/props; base de cidades, casas, residência |
| Q06 | [LowPoly Modular Dungeon Pack](https://opengameart.org/content/lowpoly-modular-dungeon-pack) — Quaternius | CC0 | >45 peças modulares; FBX/OBJ/Blend; minas, ruínas e raids |
| Q07 | [LowPoly Animated Farm Animal Pack](https://opengameart.org/content/lowpoly-animated-farm-animal-pack) — Quaternius | CC0 | vaca, cavalo, ovelha, porco, entre outros indicados; verificar criação e animações |
| Q08 | [LowPoly Crops Pack](https://opengameart.org/content/lowpoly-crops-pack) — Quaternius | CC0 | 100+ modelos em cinco estágios; base da fazenda |
| Q09 | [LowPoly Ship Pack](https://opengameart.org/content/lowpoly-ship-pack) — Quaternius | CC0 | selecionar somente barcos compatíveis com época medieval; adaptar vela/carga |
| Q10 | [Coleção All CC0 – Quaternius](https://opengameart.org/content/all-cc0-uploader-quaternius) | coleção, verificar cada entrada | procurar Stylized Nature MegaKit, Fantasy Props MegaKit, Medieval Village MegaKit, Low Poly Food Pack, Furniture Low Poly, LowPoly House Interior Pack, LowPoly Survival Pack, Animated Fish, Textured Cute Monster Pack, Universal Animation Library 1/2, LowPoly Medieval Weapons; páginas individuais e rig ainda a validar |
| K01 | [Fantasy UI Borders](https://opengameart.org/content/fantasy-ui-borders) — Kenney | CC0 | 130+ PNG e vetores; molduras 9-slice, recolor |
| K02 | [UI Pack](https://opengameart.org/content/ui-pack) — Kenney | CC0 | 430+ sprites, vetores, 2 fontes, 6 SFX; botões e controles |
| U01 | [RPG UI Icons](https://opengameart.org/content/rpg-ui-icons) — OwlishMedia | CC0 | ícones 16/32 px; vetorizar ou redesenhar em 64 px para manter legibilidade |
| S01 | [RPG Sound Pack](https://opengameart.org/content/rpg-sound-pack) — artisticdude | CC0 | 95 WAV de batalha, interface, criaturas e itens |
| S02 | [80 CC0 RPG SFX](https://opengameart.org/content/80-cc0-rpg-sfx) — rubberduck | CC0 | 80 efeitos; criaturas, feitiços, pedra, metal, madeira |
| M01 | [CC0 Fantasy Music & Sounds](https://opengameart.org/content/cc0-fantasy-music-sounds) | coleção, verificar cada faixa | pesquisar Town Theme RPG, Forest Ambience, The Field Of Dreams, Boss Battle Music, Cave Theme, trilha orquestral; auditar loops, autoria e licença |

Plano: importar Q01, Q03, Q04, Q05, Q06, Q07, Q08 primeiro. Cenário comparativo com personagem, gosma, árvore, casa, arma, pedra, vaca, plantação e uma janela UI sob mesma câmera e luz. Aprovar ou rejeitar em conjunto. Em Q10, buscar inicialmente packs de natureza, móveis, comida e animação (mesmo artista); não adotar todos automaticamente. Se houver incompatibilidade entre gerações, priorizar a família 2020/2021 e ajustar materiais/rig dos antigos. Fontes de UI, áudio e ícones não precisam ser do mesmo artista porque serão padronizadas separadamente.

## 12. Checklist de inventário de produção (escopo 1.0)

| ID | Categoria / requisito | Meta | Origem / trabalho | Fase |
|---|---|---:|---|---|
| A01 | avatar 2 corpos base, 8 rostos, 12 cabelos, 6 roupas, 6 tons pele, 8 tintas de cabelo | 2 rigs + opções | Q01/Q02, adaptar modularidade; sem armadura equipada visível | P0 |
| A02 | NPCs 36 funções nomeadas + 12 figurantes/guardas | 48 configurações | Q01/Q02, cabelos/roupas/recolor; retratos renderizados | P0–3 |
| A03 | inimigos: gosma, coelho, lobo, besouro, javali, bandido, vespa, kobold, escorpião, morcego, golem, aranha, urso, dríade, sapo, espectro, crocodilo, lodo, caranguejo, pirata, harpia, enguia, orc, lagarto, abutre, yeti, elemental, serpente, sentinela, djinn, treant, feiticeiro, mariposa, dragão, guardião, revenante | 36 famílias + 24 variantes | Q04/Q10; lacunas modelagem original; evitar só recolor para espécies distintas | P0–3 |
| A04 | chefes: Raiz Andante, Vigia de Ferro, Rei do Lodo, Colosso de Vidro, Marechal Ferrugem, Hidra do Charco, Titã da Neve, Oráculo Astral, Forjador Solar, Guardião do Primeiro Sol | 10 | kitbash/modelagem original, rig e VFX próprios | P1–3 |
| A05 | animais domésticos: galinha, vaca, porco, ovelha, cavalo, cabra, coelho, pato; juvenis opcionais por escala | 8 + 8 estados juvenis | Q07/Q10; aves e lacunas conferir | P1–2 |
| A06 | peixes: comum, carpa, truta, enguia, peixe de recife, peixe lunar | 6 | Q10 Animated Fish, adaptar variantes | P1–3 |
| A07 | armas: espada, machado, maça, lança, adagas, arco, besta, cajado, grimório, escudo em T1–T5 | 50 designs funcionais | Q03/Q10; madeira inicial; armas aparecem em ação | P0–3 |
| A08 | armaduras/joias: cabeça, torso, pernas, mãos, pés, anel, colar; leve/médio/pesado quando adequado | 85 ícones (15 por tipo de armadura + 10 joias) | Q03 render/recolor; não alterar avatar | P0–3 |
| A09 | ferramentas: picareta, machado, foice, vara, enxada, martelo, regador, faca, pá, kit alquímico T1–T5 | 50 props/ícones (reusar mesh entre tiers se legível) | Q03/Q10 + criar ferramentas faltantes | P0–3 |
| A10 | recursos do catálogo §15: item bruto/refinado, moedas, troféus, sementes, essências, recipientes | 100+ ícones, 40 props pickup | Q03/Q10, renders padronizados; estimativa derivada de todos os IDs de item | P0–3 |
| A11 | nós: pinho/carvalho/cedro/lunar, cobre/ferro/estanho/prata/ouro/cristal, pedra/basalto/obsidiana/quartzo, fibra/junco/erva/fungo/aloé, sal/argila/resina/âmbar, pesca/coral | 25 famílias × 2–3 estados | Q10 Nature, criar minérios visíveis, exauridos e brotos | P0–3 |
| A12 | vegetação não colhível: árvores 12, arbustos 12, ervas 10, flores 10, cogumelos 6, tocos 6, troncos caídos 6, pedras 15 | 77 | Q10 Nature; variação por escala limitada | P0–3 |
| A13 | superfícies: grama, barro, terra, areia, neve, gelo, cascalho, minério, basalto, pedra, mosaico, prancha, telha, campo arado, água rasa/profunda e lava | 17 materiais + transições | Q05/Q06/Q10; shaders originais | P0–3 |
| A14 | terreno: estrada reta/curva/entroncamento, rampa, degrau, borda, penhasco, caverna, ponte, margem, rio, lago, cachoeira, costa, ilha, duna, montanha | 35 módulos mínimos | Q06/Q10, Blender/terrain | P0–3 |
| A15 | arquitetura: parede, porta, janela, teto, coluna, escada, viga, fundação, varanda, portão, arco, muro, torre, ponte | 14 famílias × 4 estilos (56 slots) | Q05/Q10, adaptar neve/deserto/porto | P0–3 |
| A16 | prédios/locais: casa, pousada, loja arma/armadura/poção/decor, prefeitura, guilda, armazém, mercado, ferreiro, estábulo, moinho, templo, mina, porto, estaleiro, altar, arena, observatório | 20 composições | Q05/Q06/Q10, montagem modular | P0–3 |
| A17 | dungeon: piso, parede, canto, portal, arco, cela, grade, escada, ponte, coluna, altar, sarcófago, armadilha, alavanca, runa, cristal, pedestal, baú | 45+ módulos | Q06, 5 paletas regionais | P1–3 |
| A18 | mobiliário: cama, cadeira, mesa, estante, armário, baú, tapete, banco, jarro, quadro, vaso, luminária, espelho, cortina, barril, caixa, bandeira, estátua, fogueira, floreira, fonte, placa, cerca, portão | 48 variantes | Q05/Q10, criação seletiva | P1 |
| A19 | estações: bancada/refino/forja/marcenaria/tecelagem/curtume/cozinha/fermentação/alquimia/estaleiro/irrigações | 11 × 3 visuais (33) | Q10 + adaptar níveis | P1–3 |
| A20 | fazenda: canteiro, regador, balde, poço, cisterna, irrigador, comedouro, ninho, galinheiro, celeiro, curral, estábulo, silo, estufa | 14 + estados | Q07/Q08/Q10 | P1–2 |
| A21 | cultivos: trigo, milho, cenoura, batata, couve, abóbora, maçã, uva, lúpulo, algodão, erva medicinal, pimenta, flor lunar, aloé | 14 × 5 estágios = 70 | Q08; verificar espécies, adaptar variantes | P1–3 |
| A22 | veículos: carrinho, carroça, cavalo com arreio, bote, cargueiro, veleiro; carga vazia/cheia e danificada | 6 × 3 estados | Q07/Q09 + criar carroça/arreio | P2–3 |
| A23 | comidas e bebidas: pão, ensopado, carne assada, salada, torta, queijo, biscoito, ração, água, chá, cerveja, vinho, tônico e poções de 6 efeitos | 19+ modelos/ícones | Q03/Q10 Food, adaptar garrafas | P1–3 |
| A24 | props ambientais: tochas, cordas, sacos, placas direcionais, marcos, bandeiras, caixas, carris, vagão mineiro, rede, âncora, barraca, ossos, ruínas, barris, carvão | 40 | Q05/Q06/Q10 | P0–3 |
| A25 | UI: 24 telas/painéis descritos abaixo, botões em 5 estados, barra HP/energia, abas, sliders, tooltip, modal, drag, notificações, slots, cursores | 60 componentes + 24 layouts | K01/K02, composição original | P0–3 |
| A26 | ícones: cada item/receita, 46 skills, 24 ramos, 10 status, 12 profissões/indicadores, 20 mapas/POIs, 12 raridade/qualidade/reputação, 16 social/contrato | mínimo 300, deduplicar | Q03 renders + U01/K02, criar ícones próprios | P0–3 |
| A27 | VFX: impacto físico, slash, projétil, cura, veneno, gelo, fogo, proteção, stun, raiz, sangramento, teleporte, mineração, cavaco, poeira, colheita, construção, água, chuva, neve, luz, portal, raid, level-up | 40 prefabs + variantes | partículas originais, atlas de máscaras | P0–3 |
| A28 | áudio: UI 15, combate 35, criaturas 36×2 (72), passos 8 superfícies×4 (32), coleta 12, produção 12, fazenda 12, ambiente 20, transporte 8, eventos 10, jingle 6 | 234 cues alvo, reuso moderado | S01/S02, gravar/criar lacunas | P0–3 |
| A29 | música: menu, seleção, 4 cidades, 12 zonas, 9 instâncias, 1 global, 1 vitória, 1 derrota | 30 loops/stingers (pode compartilhar motivos) | M01, selecionar licença faixa a faixa | P0–3 |
| A30 | apresentação: logo original, wordmark, loading, splash/menu 3D, cenário seleção, fundos de painel, 4 capas de cidade, 12 cards de zona, 10 retratos de boss, miniaturas | 33+ imagens/prefabs | render do próprio mundo, branding original | P0–3 |

Contagem de A08: armadura 5 slots × 3 categorias × 5 tiers = 75; anel/colar × 5 = 10. Não comprar 85 malhas de armadura. A28 representa cues, não necessariamente 234 arquivos exclusivos. Orçamento de armazenamento de produção depende de modelos e áudio aprovados; não inferir tamanho final pelos ZIPs do catálogo.

### 12.1 Matriz de animação obrigatória

| Rig | Clipes mínimos |
|---|---|
| Avatar humanoide | idle, walk, run, turn, dodge, hit, knockdown, getup, death, respawn, interact, carry, sit, emote, mount/dismount, ride, swim (somente se permitido), 5 ataques de corpo a corpo, 4 ataques à distância, 4 conjurações, block/parry, heal, mine, chop, harvest, fish, hammer, mix, cook, plant, water, feed, place, trade |
| NPC | idle, walk, talk, gesture, work, sit, carry; trabalhador executa clipes de coleta, plantio, preparo, construção |
| Quadrúpede | idle, walk, run, eat, drink, hit, attack (selvagem), die, sleep; cavalo mount/ride |
| Voador | idle/perch, takeoff, fly, dive, attack, hit, land, die |
| Monstro bípede | idle, walk, run, 2 ataques, 1 telegráfo, hit, die, elite cast |
| Gosma/invertebrado | idle, deslocamento, ataque, dano, morte, habilidade |
| Boss | entrada, idle, locomoção, 3–5 ataques (antecipação/impacto/recuperação), 2 transições de fase, stun/interrupt, morte, dissolução |
| Estruturas/objetos | porta, baú, roda, moinho, bandeira, estação em uso, árvore caída, minério exaurido, colheita, construção em 3 fases, barco navegar/ancorar |

Retarget não garante qualidade: verificar mãos sobre ferramentas, pés no chão, eixo, altura, overshoot, ataque alinhado a hitbox; animação nunca altera posição lógica sozinha. Prévia em vídeo de cada rig e amostra em cena. Equipamento não deforma o modelo-base.

### 12.2 Telas e componentes a compor

Login, cadastro, recuperação, seleção, criação, loading/mapa de transição, HUD, inventário, equipamentos/atributos, skills, profissões, crafting/receitas, loja NPC, mercado, comércio direto, mapa/missões, amigos, guilda, grupo/raids, residência/layout, contratos/trabalhadores, fazenda/animais, configurações/acessibilidade, créditos/moderação (24 grupos de telas). Estados vazio/carregando/erro/sucesso, confirmação irreversível, tooltips de requisito, preview de custo e cooldown, chat recolhível, alerta de zona e contribuição global. Ícones de itens 128×128 PNG com transparência, fundo/raridade na UI; skills 64 ou 128; atlas 1024; contraste e escalabilidade para 720p–4K. Sem fontes ilegíveis ou layout diretamente copiado de Mu/Albion.

### 12.3 Manifesto e auditoria

Cada asset: asset_id, categoria, nome funcional, URL exata, autor, data de aquisição, licença, atribuição requerida e texto, versão/hash SHA256, arquivo original, caminho convertido, modificações, formato, escala, eixo, triângulos, texturas, animações, sockets, collider, LODs, dependências, responsável, status (candidato/download/licença verificada/importado/padronizado/aprovado/rejeitado), teste e captura de comparação. Estrutura: assets/source/<autor>/<pack>; assets/runtime/{characters,creatures,environment,props,items,ui,vfx,audio,music}; credits/ASSET_MANIFEST.csv; não redistribuir packs sem verificar licença. Manter arquivos fonte intactos, cópias editadas separadas, registrar créditos mesmo se opcionais. Checar CC-BY e condições de atribuição, CC-BY-SA e compatibilidade da adaptação, outras licenças antes do uso; rejeitar licença desconhecida ou direitos de terceiros duvidosos. Não presumir que toda coleção tem licença uniforme. Critérios de aceite: cena lado a lado, sem clipping; paleta normalizada; LOD e colisão corretos; rig e clipes úteis; 60 fps em equipamento-alvo do piloto ou revisar orçamento; áudio normalizado e sem clipping, loops sem salto; fontes com licença e caracteres PT-BR; relatório de lacunas atualizado. Nenhum ZIP foi baixado ou auditado nesta etapa.

# DOCUMENTO 3 — BALANCEAMENTO DE LANÇAMENTO

## 13. Método, metas e convenções

Parâmetros iniciais de design, não resultados de simulação ou testes multiplayer. Números devem ser carregados de tabelas versionadas, nunca espalhados em código. Ouro = G; segundos = s; tier T1–T5; recursos, quantidades e XP inteiros; contabilidade em centavos de G para salários e taxas, UI mostra duas casas quando necessário. Arredondamento monetário comercial para cima (taxa) e salário acumulado por minuto para evitar erro repetido. Multiplicadores são multiplicativos salvo indicação. Nenhum jogador recebe XP duas vezes por mesma operação; aplicar idempotência. Nenhum recurso pode entrar em ciclo de duplicação física ou financeira.

| Meta | Alvo inicial |
|---|---|
| tempo até tutorial e terreno | 20–30 min |
| nível 10 por profissão | ~2–4 h de jogo efetivo |
| nível 20 / 35 / 50 | ~8–15 / 30–50 / 80–130 h por profissão, ajustar a XP real |
| TTK mob comum equivalente | 5–9 s com build ofensiva, 9–15 s tanque |
| TTK PvP equivalente | 12–25 s sem foco de múltiplos jogadores |
| atividade econômica inicial | 120–240 G/h líquido em preço de referência, não garantia |
| produção manual / NPC | manual pelo menos 1,5× produtividade |
| PvP risco-recompensa | amarelo +15%, vermelho +30% de rendimento esperado bruto sobre equivalente verde |
| idle coleta | 60–75% da produtividade ativa por hora de coleta comparável |
| mercado | >80% itens negociáveis ativos com demanda em 7 dias; nenhum grupo >35% do valor negociado |
| consumo | 2+ usos de cada recurso não especial; ≥1 sumidouro recorrente |
| economia | criação/destruição de ouro em faixa 0,90–1,10 após estabilização, ajustar por coorte |

### 13.1 Experiência e tiers

XP para avançar do nível L para L+1 = arred((90 × L^1,43 + 110) × k), L=1..49; k=0,35 para L1–9, 0,50 para L10–19, 0,75 para L20–34 e 1,00 para L35–49; XP total = soma. Nível máximo 50 por profissão; XP excedente vai a progresso cosmético de prestígio, sem poder. Tiers desbloqueados 1/10/20/30/40; maestria 50. Tier não substitui requisitos de atributos de armas. Receitas de cada tier incluem dois insumos de tier anterior, mantendo valor de recursos iniciais. Nível de carreira e combate não se somam. XP base por ação validada no tier t: fórmula abaixo; aplicar fator de diferença de tier f = max(0,10; 1 - 0,22 × max(0, tier_do_jogador - tier_da_ação)); ações muito antigas ainda produzem utilidade, mas XP baixa.

| Profissão | XP base | Ritmo de referência | Condição |
|---|---:|---|---|
| Caçador | 24 × t por mob normal (+ elite ×2,5) | 35–60 mobs/h | participação válida; XP efetivo por mob = base × max(0,1; 1-0,08×diferença positiva de nível) |
| Coletor | 8 × t por carga colhida | 120–180 cargas/h | nó válido e consumido; AFK ×0,75 XP |
| Preparador | 20 × t por lote | 40–65 lotes/h | insumos consumidos, lote final íntegro |
| Construtor | 25 × t por receita padrão | 35–55 equivalentes/h | receita concluída, obras grandes XP proporcional a custo de referência |
| Mercador | 12 × t por entrega ou 0,08 × valor elegível em G de ordem (cap 60 × t por ordem) | 45–80 eventos equivalentes/h | contraparte independente, entrega confirmada, anti-circular; não XP por simples revenda própria |
| Fazendeiro | 12 × t por canteiro colhido, 18 × t por ciclo animal | 50–80 equivalentes/h | cultivo completo ou produção com ração/cuidado |

Missões de profissão: 120 × tier por tarefa narrativa ou 40 × tier por contrato diário, até 3 contratos recompensados por profissão/dia e 6 por conta/dia. Raids dão XP conforme tabela §19. Curva e XP/h precisam ser validados juntos: medir minutos efetivos por nível; ajustar XP por profissão e tier, não acelerar recursos/ouro ao ajustar XP. Ações sem custo real (colocação/remoção repetida, venda falsa, plantio cancelado) não dão XP. Maestrias: 10 pontos distribuíveis por profissão (1 a cada 5 níveis); níveis 10/20/30/40/50 liberam melhorias; bônus por ponto +2% de eficiência do ramo, teto +20%; no máximo dois ramos com 10 pontos em todo o personagem, outros até 8 (pontos podem permanecer disponíveis e redistribuíveis). Redistribuição 250 G + 50 G por ponto movido, cooldown 24h. Habilidades de combate não dependem da ocupação dos dois ramos máximos.

## 14. Combate, atributos, equipamentos e PvP

Ao nível 1, FOR/AGI/INT/VIT/ESP = 10 cada; 5 pontos livres a cada nível (245 ao 50), mínimo 10, máximo 120 investidos por atributo sem equipamento. Reset em cidade 50 + 20×L G, gratuito até L10. Fórmulas de atributos finais (incluem equipamento):
- HP = 100 + 12×(L−1) + 10×VIT; mana = 40 + 3×(L−1) + 6×ESP; energia = 100.
- Ataque físico = dano da arma + 1,6×FOR para pesadas ou 1,4×AGI para leves/distância; magia = poder da arma + 1,7×INT. Armas híbridas têm coeficiente definido na tabela abaixo.
- Armadura física A = soma gear + 0,8×VIT; resistência mágica R = soma gear + 0,8×ESP. Mitigação = defesa/(defesa+100+4×nível_atacante), teto 65%.
- Crítico = min(25%; 5% + 0,12%×(AGI−10) + bônus); multiplicador crítico 1,5. Atributos não reduzem cooldown diretamente; teto de redução por gear 15%.
- Dano bruto = ataque × coeficiente da habilidade × variação determinística/aleatória 0,95–1,05. Dano final = max(1, arred(dano bruto×(1−mitigação)×crítico×mods)), mods PvP 0,65 para dano, 0,75 para cura, 0,80 para escudos. Sem dano amigo no grupo em PvE; PvP arena ignora aliança salvo grupo opt-in permitido fora arena. Dano de área limitado a 8 alvos em PvP, redução 15% por alvo adicional até piso 40%.
- Regeneração mana 2+0,035×ESP/s fora de combate, 30% em combate; HP 1%/s fora de combate após 8s; energia 12/s após 0,5s sem gastar. Movimento 4,5 m/s, desaceleração em combate 5% quando carregando ataque pesado. Esquiva 18 energia, cooldown 3s, 0,25s invulnerabilidade somente PvE; PvP 0,12s. Alcance corpo a corpo 2,1m, lança 3m, arco/cajado até 12m.

| Família | Escala / requisito T1 base (por tier +12 no principal, +4 no secundário) | básico: coef/CD s | habilidades: coeficiente / CD s / custo (energia E, mana M) |
|---|---|---|---|
| espada | 1,6 FOR / FOR10 AGI10 | 1,0/0,9 | corte 1,5/5/12E; estocada 1,8/8/18E; riposta 1,2/10/12E; guarda 25% escudo/14/20E |
| machado | 1,6 FOR / FOR10 VIT10 | 1,3/1,2 | fenda 1,9/7/20E; varredura 1,4/8/20E; rasgo 1,0+DoT0,6/10/16E; impulso 1,1/12/20E |
| maça | 1,6 FOR / FOR10 VIT10 | 1,2/1,2 | esmagar 1,8/7/20E; abalar 1,0+stun/12/22E; muralha 25%/14/20E; choque 1,4/9/18E |
| lança | 0,9 FOR+0,7 AGI / FOR10 AGI10 | 1,05/1,0 | perfurar 1,7/6/16E; varrer 1,3/8/18E; recuo 1,0/10/16E; interceptar 1,1/12/20E |
| adagas | 1,4 AGI / AGI10 FOR10 | 0,75/0,65 | golpe duplo 1,6/5/14E; veneno 0,8+DoT0,6/9/16E; passo 0,7/10/20E; precisão 1,8/12/22E |
| arco | 1,4 AGI / AGI10 ESP10 | 1,0/1,0 | tiro preciso 1,8/7/18E; chuva 1,4/10/20E; flecha lenta 1,0/8/14E; recuo 0,7/12/20E |
| besta | 1,4 AGI / AGI10 FOR10 | 1,4/1,45 | virote 2,0/8/20E; ricochete 1,2/9/18E; armadilha raiz/12/20E; rajada 1,6/14/24E |
| cajado | 1,7 INT / INT10 ESP10 | 1,0/1,1 | chama 1,7/6/18M; gelo 1,2+lento/8/20M; onda 1,4/10/24M; cura 1,2 poder/12/28M |
| grimório | 1,7 INT / INT10 ESP10 | 0,85/1,0 | raio 1,6/6/18M; marca +10% dano/12/22M; barreira 20% HP/14/26M; restauração 1,0 poder/10/24M |
| escudo secundário | VIT10 FOR10 | sem ataque básico | bloqueio 40%/8/18E; provocação PvE/12/12E; pancada 0,8+stun/12/20E; cobertura 15% aliado/16/25E |

6 universais: esquiva (ação própria, não ocupa slot), aparar (30% redução, CD8, 18E), investida (coef0,8 CD12 20E), purificar (1 efeito CD18 20M), cura simples (0,5 poder mágico CD18 20M), provocação (PvE CD12 15E). Cinco famílias corpo a corpo/à distância têm golpes com arco/área, alvos limite 4 PvE e 3 PvP por padrão (chuva/onda até 8). Telegráfo ações fortes 0,4–1,2s; duração CC stun 0,8s, raiz 1,8s, lento 25% 3s. Janela de 6s após controle: próximo controle forte metade; terceiro imunidade temporária. DoT total dividido em ticks 1s, duração 4–6s; mesma fonte renova sem empilhar; diferentes fontes máximo 3. Cura/escudo cap por habilidade, buffs da mesma categoria não somam (maior prevalece). Sem dano puramente inevitável em raids; stun de boss vira interrupção de cast indicado, não imobilização permanente.

| Tier | nível profissional de fabricação | dano/poder arma base | armadura por peça leve/médio/pesado | resistência por peça leve/médio/pesado | durabilidade |
|---|---:|---:|---|---|---:|
| 1 | 1 | 10 | 3/5/7 | 7/5/3 | 100 |
| 2 | 10 | 24 | 8/12/16 | 16/12/8 | 120 |
| 3 | 20 | 44 | 14/20/27 | 27/20/14 | 140 |
| 4 | 30 | 68 | 21/30/40 | 40/30/21 | 160 |
| 5 | 40 | 96 | 29/42/56 | 56/42/29 | 180 |
Armadura por peça: torso ×1,3, pernas ×1,1, cabeça ×0,9, mãos/pés ×0,85. Pesada -2% velocidade por peça (máximo -10%); leve +2% mana por peça; médio +1% energia por peça. Anel/colar T1–5 +2/4/6/8/10 de atributo selecionado (3 slots, não somar duplicidade de mesmo efeito lendário). Escudo adiciona 6×tier armadura e 3×tier resistência. Equipamentos comuns, incomuns, raros e épicos: multiplicadores 1,00/1,03/1,07/1,10; qualidade determinada por receita e componente, não lootbox. Bônus totais de equipamento em atributos ≤45 por atributo, teto de crit 25%. Ferramentas: T1–5 potência 1/1,10/1,20/1,30/1,40; não coletam tier superior sem requisito. T1 inicial vinculado tem dano/potência T1 comum.

Mobs: nível n: HP = 120+25n+1,7n²; ataque = 10+2,2n; armadura = 4+2n; resistência = 4+1,6n; ataque a cada 2,2s; ajustar por família. Ex.: n1 HP147/ATK12, n10 HP540/ATK32, n30 HP2400/ATK76, n50 HP5620/ATK120. Alvos de TTK exigem calibração de HP real por tier com os DPS calculados; esta curva é ponto de partida, particularmente para níveis altos (reduzir HP se exceder alvo). Rápido HP×0,65, ataque×0,8, CD×0,75; tanque HP×1,5, ataque×0,85; conjurador HP×0,8, ataque×1,25 com cast; elite HP×2,4, ataque×1,25, recompensa×2,5. Respawn comum 30–60s, elite 3–5min, spawn por grupo 3–6. Ameaça = dano + 0,5×cura efetiva, provocação muda alvo por 3s. Jogador derrotado: respawn no santuário, não perde XP, 5% durabilidade PvE, 8% PvP amarela, 12% vermelha, arena zero. Drops de recursos calculados por stack, arredondados para baixo e limitados à quantidade carregada; itens vinculados, equipamentos e ouro protegidos. PvP só recompensa reputação/trofeus sem valor direto em mortes elegíveis; limite conta/contraparte 1 recompensa/24h, sem prêmio por diferença >10 níveis.

## 15. Catálogo econômico e matriz de utilidade

Tabela define famílias de item, preço de referência inicial (G/unidade de bruto T1, multiplicador T2–T5 1,7/2,8/4,5/7, quando aplicável), origem e demandas. Preço de referência serve para testes, impostos e XP limitado, não força preço entre jogadores. Variantes regionais precisam de receita funcional ou substituição; não recursos decorativos sem saída.

| ID | Material / tier | origem | valor G base | usos permanentes ou recorrentes |
|---|---|---|---:|---|
| R01 | tronco pinho/carvalho/cedro/lunar (T1/2/4/5) | árvores | 2 | prancha, carvão, reparos, veículos |
| R02 | cobre/ferro/estanho/prata/ouro mineral (T1/2/3/4/5) | jazida | 3 | lingote, ferramentas, armas, joias |
| R03 | pedra/basalto/obsidiana/quartzo (T1/3/5/4) | rochas | 2 | tijolos, construção, abrasivo e catalisador |
| R04 | fibra/junco/algodão (T1/3/2) | coleta/fazenda | 2 | corda, tecido, embalagem/manutenção de vela |
| R05 | erva medicinal/aloé/flor noturna (T1/4/5) | coleta/fazenda | 3 | poções, chá, tônicos |
| R06 | argila/sal/sal azul (T1/1/4) | solo/costa | 2 | recipientes, conservação, ração mineral |
| R07 | resina/âmbar (T2/3) | árvores | 3 | cola, acabamento, catalisador de poção |
| R08 | fungo/junco do charco (T3) | charco | 3 | adubo, antídoto, tecido alternativo |
| R09 | cristal astral/solar/gelo mineral/coral (T4–5) | veios/costa | 5 | joia, runa, bússola, reparo de relíquia |
| R10 | couro/pele | caça | 3 | couro tratado, armaduras, sela e bolsas |
| R11 | osso/chifre/presa | caça | 2 | adubo, cola, cabo de ferramenta, catalisador |
| R12 | carne | caça/criação | 3 | prato cozido, ração carnívora, conserva |
| R13 | essência/lodo/fragmento elemental | monstro | 4 | poção, runa, manutenção de estações |
| R14 | peixe/algas | pesca/coleta | 3 | comida, óleo, adubo |
| R15 | trigo/milho/batata/cenoura/couve/abóbora | fazenda | 2 | comida, ração, fermentação/adubo |
| R16 | maçã/uva/lúpulo/pimenta | fazenda | 3 | bebida, comida, conservante |
| R17 | leite/ovo | fazenda | 3 | prato, queijo, torta, ração enriquecida |
| R18 | lã | fazenda | 3 | tecido, bolsa, decoração, isolamento de edifício |
| R19 | esterco/composto | fazenda | 1 | adubo, combustível de estação |
| R20 | sementes/mudas (14 espécies) | cultivo, NPC | 2 | replantio, óleo/ração (sementes comuns), melhoria de sementes |
| R21 | troféu boss / selo raid | instância | 15×tier | runa, encomenda coletiva, cosmético, reciclagem em essência |
| R22 | água | poço/cidade | 0,5 | irrigação, bebida, alquimia |
| R23 | carvão | refino madeira/carvão de mina | 2 | forja, cozinha, estação |
| R24 | pimenta/algas raras | cultivo/costa | 4 | conservante e refeição avançada |
| R25 | tinta/pigmento | plantas/pedra | 3 | cosméticos, placas, decoração, manutenção de sinalização |

Refinados (preço base indicativo): prancha 5, pedra talhada/tijolo 5, lingote 8, tecido 5, corda 5, couro tratado 8, cola 4, recipiente 4, óleo 6, farinha 4, adubo 4, ração 5, carvão 3, essência concentrada 10, cristal lapidado 12, runa 20, ferragem 10. Fórmula geral de valor de referência receita = soma(preço_ref insumos)/rendimento + custo de estação/rendimento + 15% de margem de mão de obra de referência. Se tabela indicar valor menor que custo derivado, prevalece fórmula (tabela serve como semente); NPC não compra refinado acima de custo. Peso: bruto/refinado 0,5–2kg (pedra/minério 1,5, madeira 1,0, plantas 0,25); alimento/poção 0,2–0,5; equipamento 2–8; stack 99 recursos/20 consumíveis/1 equipamento. Bolsa 40 slots/80kg inicial; bolsas T2–5 50/60/70/80 slots e 110/140/180/220kg; acima de 100% peso não coleta, 80–100% movimento -15%; itens essenciais iniciais não ocupam peso excessivo. Armazém cidade 100 slots iniciais, expansão +50 por 500×nível G; residência 60 via baú.

### 15.1 Receitas e dependências

Todas as receitas são determinísticas. T = tier, B = insumo compatível do tier de receita e P = insumo do tier anterior (T1 usa T1). Componentes superiores podem substituir somente quando receita explicitamente autoriza, sem multiplicar output. T2+ exige refinados P para manter relevância de níveis baixos. Valores por lote, duração de execução manual, taxa estação pública = max(1 G, 3% do custo de referência de insumos), residência paga manutenção ao produzir (1% + manutenção diária), tempo tier T2+ ×(1+0,15×(T−1)), XP proporcional ao lote sem multiplicação por múltiplas subações. Taxas da tabela abaixo não são ouro produzido.

| Receita / família | insumos por lote | saída | s base | profissão |
|---|---|---|---:|---|
| prancha | 3 troncos B | 2 | 12 | Coletor |
| lingote | 3 minério B + 1 carvão P | 2 | 20 | Coletor |
| tijolo/pedra talhada | 3 pedra B + 1 argila | 2 | 16 | Coletor |
| fibra tratada | 3 fibra B | 2 | 12 | Coletor |
| carvão | 2 troncos | 2 | 12 | Coletor |
| gemas lapidadas | 2 cristal + 1 abrasivo pedra | 1 | 18 | Coletor |
| corda/tecido | 2 fibra tratada + 1 fibra P | 1 | 15 | Construtor |
| couro tratado | 2 couro + 1 sal + 1 resina | 2 | 20 | Preparador |
| cola | 2 osso + 1 resina + água | 2 | 15 | Preparador |
| recipiente | 2 argila + 1 carvão | 2 | 14 | Construtor |
| óleo | 2 peixe ou 3 sementes + 1 recipiente | 2 | 18 | Preparador |
| adubo | 2 esterco + 1 osso ou fungo | 3 | 12 | Fazendeiro |
| ração | 2 grão + 1 legume ou carne | 3 | 15 | Preparador |
| farinha | 3 trigo | 2 | 12 | Preparador |
| pão | 2 farinha + água + carvão | 2 | 22 | Preparador |
| ensopado | 2 carne/peixe + 2 legume + sal | 2 | 25 | Preparador |
| assado | 2 carne + pimenta + carvão | 2 | 22 | Preparador |
| salada | 3 legumes + óleo | 2 | 15 | Preparador |
| queijo/torta | 2 leite/ovo + 2 farinha + sal | 2 | 24 | Preparador |
| chá | 2 ervas + 2 água | 2 | 15 | Preparador |
| cerveja/vinho | 3 grão/fruta + água + recipiente | 2 | 30 | Preparador |
| poção HP/mana | 2 erva B + essência P + recipiente + água | 2 | 20 | Preparador |
| antídoto | fungo + erva + sal + recipiente | 2 | 20 | Preparador |
| tônico vigor/resistência | 2 erva B + essência B + óleo + recipiente | 2 | 25 | Preparador |
| conservante | 2 sal + alga/pimenta | 2 | 15 | Preparador |
| ferramenta | 3 lingote B (T1 madeira usa 3 prancha) + 2 prancha P + corda | 1 | 35 | Construtor |
| arma | 5 lingote/prancha B + 2 material arma P + couro/corda | 1 | 45 | Construtor |
| armadura | 4 tecido/couro/lingote B + 2 material P + cola | 1 | 40 | Construtor |
| joia | 2 lingote B + cristal lapidado + 1 essência P | 1 | 45 | Construtor |
| ferragem | 2 lingote + 1 carvão | 2 | 15 | Construtor |
| bolsa | 4 couro/tecido B + 2 corda P + ferragem | 1 | 45 | Construtor |
| runa | essência concentrada + cristal + troféu (ou 3 essências substitutas) | 1 | 35 | Construtor |
| essência concentrada | 4 essência + sal | 1 | 20 | Preparador |
| pigmento | 2 flor/rocha + óleo | 2 | 15 | Preparador |
| placa/cerca | 2 prancha + corda ou ferragem | 1 | 15 | Construtor |
| piso/muro | 3 tijolo/prancha + cola | 2 | 20 | Construtor |
| móvel | 4 prancha + 2 tecido + ferragem | 1 | 30 | Construtor |
| casa pequena | 40 prancha+30 tijolo+12 ferragem+10 tecido+8 cola | 1 | 180 | Construtor T2 |
| celeiro/curral | 20 prancha+12 tijolo+6 ferragem+6 corda | 1 | 120 | Construtor T2 |
| poço/irrigação | 15 tijolo+5 ferragem+5 corda | 1 | 90 | Construtor T1–2 |
| estação | 15 prancha B+12 tijolo B+8 ferragem B+2 essência P | 1 | 120 | Construtor |
| carroça | 25 prancha T2+12 ferragem+6 corda+4 couro | 1 | 180 | Construtor T2 |
| bote | 30 prancha T3+8 corda+10 cola+4 ferragem | 1 | 180 | Construtor T3 |
| cargueiro | 80 prancha T4+25 ferragem+20 corda+15 tecido+10 cola | 1 | 300 | Construtor T4 |
| veleiro | 100 prancha T5+40 tecido+30 ferragem+25 corda+20 cola | 1 | 420 | Construtor T5 |
| reparo estação/veículo | 2 material P + 1 ferragem/couro | 10% condição | 20 | Construtor |
| semente melhorada | 3 sementes + 1 adubo | 2, +10% rendimento | 15 | Fazendeiro |

Qualidade: maestria 5 pontos permite receita incomum com +15% insumos; 8 rara +35%; 10 épica +60% e runa/troféu alternativo (poder total limitado). Reparo custa materiais mais 1% valor_ref por 10% durabilidade recuperada; uso de ferramenta -1 por 5 cargas, armas -1 por 10 ataques, armadura -1 por 12 impactos, estação -1 por 10 lotes. Abaixo 20% potência -15%; 0% inutilizável até reparar; item nunca desaparece por quebra. Reciclagem voluntária devolve 30% insumos comuns arredondados para baixo (zero moedas/troféus), não XP. Decoração pode ser desfeita em 50% material, nunca simultaneamente reciclar o item e desmontá-lo.

## 16. Coleta e agricultura

| Tier recurso | cargas por nó | tempo/carga s | respawn s | bruto por carga | nível necessário |
|---|---:|---:|---:|---:|---:|
| T1 | 6 | 6 | 120 | 1–2 (média 1,5) | 1 |
| T2 | 6 | 7 | 180 | 1–2 | 10 |
| T3 | 5 | 8 | 240 | 1–2 | 20 |
| T4 | 4 | 10 | 360 | 1–2 | 30 |
| T5 | 3 | 12 | 480 | 1–2 | 40 |

Tempo ajustado = base/potência ferramenta/(1+bônus maestria), piso 4s. A coleta adicional em zona amarela/vermelha é chance de unidade extra 15%/30%, sem sobreposição à potência; verde tem rotas alternativas de todos os materiais estratégicos (ex. T5 em Floresta Astral, obsidiana como alternativa de pedra em missão/refino). Cada zona oferece inicialmente 30 nós por 20 coletores simultâneos, ajustar dinamicamente densidade dentro dos limites planejados, sem criar nós sob demanda individual. AFK: máximo 15 min por sessão, pausa após ataque/desconexão, XP 75%, tamanho da bolsa e respawn impedem exploração infinita. Carga colhida alocada atomicamente. Sem XP por tentativa em nó vazio. Medir disputa e tempo ocioso, não ajustar nós unicamente para favorecer AFK.

Canteiros: 12 iniciais construíveis, máximo 24/48/80 conforme expansão; 1 semente + rega inicial, segunda rega a metade do ciclo se desejar bônus; sem rega, pausa (não perde semente). ciclo desde plantio persistido: trigo/milho 30min, cenoura/batata/couve 45min, abóbora 60min, maçã/uva/lúpulo 90min, algodão/erva 60min, pimenta/aloé/flor lunar 120min. Rendimento base 3 unidades + chance 25% de semente adicional, sempre opção de reservar uma unidade como semente para próximo ciclo em culturas comuns; árvores dão 3 frutos por ciclo após primeira maturação. Adubo +1 unidade, rega extra +10% chance de +1, maestria máximo +20% rendimento esperado. Melhoramento não acumula ilimitado. Limite de rendimento de bônus total +40% além da base, arredondamento probabilístico. Culturas T1 trigo/cenoura/couve, T2 milho/batata/algodão/maçã, T3 abóbora/uva/lúpulo, T4 pimenta/aloé, T5 flor lunar; erva medicinal tem variantes T1–5.

Animais: galinha/pato (2 ovos/2h, 1 ração), vaca/cabra (3 leite/4h, 2 ração), ovelha (2 lã/4h, 2 ração), porco/coelho (2 carne por ciclo de criação de 12h, 3 ração; reprodução/abate representado abstratamente), cavalo (montaria após 24h de cuidado/6 ração, uso requer sela, não gera múltiplos por duplicação). Cap 4/8/12 animais por terreno conforme expansão; reprodução 12–24h, ocupa vaga antes de iniciar, consumo e estoque reservados. Bem-estar 0–100, água/ração/abrigo elevam, abaixo 40 produção pausada. Produção offline habilitada somente para ciclo iniciado, não fila infinita; máximo 2 ciclos reservados.

## 17. Residências, trabalho, custos recorrentes

| Item | requisito | custo / efeito |
|---|---|---|
| escritura 32×32 | tutorial | 0 G, vazio, 12 canteiros/4 animais máximos |
| expansão 48×48 | carreira 15 | 1500 G + 60 tijolos + 50 pranchas; 24 canteiros/8 animais |
| expansão 64×64 | carreira 30 | 6000 G + 100 tijolos T3 + 80 pranchas T3 + 30 ferragens; 48 canteiros/12 animais; 80 com estufa T4 |
| estação T1–5 | nível profissão correspondente | insumo receita §15, manutenção 5/10/20/40/80 G por dia de uso e materiais por desgaste |
| casa | Construtor 10 | descanso +10% XP por 30 min após 8h offline, não acumula, sem bônus ao ouro |
| contrato NPC | amigo elegível | 30–120 G/h sugerido, salário definido bilateralmente, mínimo 15×tier G/h, taxa 3% sobre salário |
| guilda | carreira 10 | 2500 G criação + 100 G/semana se usar serviços coletivos |
| montaria/carrinho | carreira 10 | +40/+60 kg, velocidade cavalo 6m/s; carroça +180 kg, 5m/s |
| bote/cargueiro/veleiro | construtor T3/4/5 ou compra | carga 150/400/600kg; manutenção 2% valor_ref por viagem longa, não teleporta |

Exemplo contrato: 2h × 60 G/h = 120 G escrow + 3,60 G taxa; se trabalha 75 min, remuneração 75 G, taxa efetiva 2,25 G, devolve 46,35 G. Pagar em lotes idempotentes de minuto, reservar taxa máxima, pausa não custa. Trabalhador produz 60% do ritmo manual, rendimento base sem bônus de maestria de proprietário; snapshot autoriza receitas que o contratado conhece, proprietário precisa estação/insumos. Até dois NPCs, 4h por conta contratada/dia, cap também 8h de NPC total por residência/dia. Sem salário do sistema, apenas transferência real; teste com cancelamento e reinício.

## 18. Economia, comércio e teleporte

Mercado: taxa de anúncio 1% valor anunciado (não reembolsável, mínima 0,10 G), taxa de conclusão 5% do valor executado para vendedor (reduções Mercador até 3%, mínimo); compra direta de ordem já anunciada sem taxa extra ao comprador. Slots base 10, nível Mercador 10/20/30/40/50 = 15/20/25/30/40. Corretagem remunerada de 1–5% (acordo), escrow para encomendas/frete, caução ≤ valor_ref carga ×1,2, expiração 72h. Frete NPC não existe. Taxa de depósito de contrato comercial 1%, manutenção de rota/veículo. Transação circular entre mesmas contas, preço extremo, mesma propriedade e autofinanciamento não dão XP; transferências legítimas ainda permitidas entre amigos (auditadas); não bloquear acesso por mera amizade. Mercador tem XP elegível por conta até 6× XP/h-alvo/dia em operações repetitivas, sem impedir comércio adicional. Taxas não podem ficar negativas.

Exemplo: vender 100 pranchas por 6 G = 600 G bruto, anúncio 6 G + venda 30 G = 564 G líquido (Mercador mestre 576 G). Se insumos custam 450 G e estação 12 G, lucro realizado 102 G, não ouro criado. Compra antecipada, armazenamento e risco de preço contam. Loja NPC compra bruto por 25% preço_ref, cap 100 G/dia por conta; vende básicos por 180% preço_ref, quantidade por conta/dia (20 sementes/10 poções/1 ferramenta); itens vinculados iniciais sem valor. Não vende refinados para arbitragem garantida. Ouro nasce de loot, missão, recompensa global, resgate NPC limitado; taxas, viagens, reparos, contratos de cidade e expansão destroem ouro. Comércio, salários e vendas entre jogadores transferem ouro.

| Atividade | cenário T1 em 1h, valor_ref | observação |
|---|---|---|
| Caçador | 45 mobs × (2 G diretos + 1,5 itens ×3 G) = 292,5 G bruto equivalente; 40–60 G consumo/reparo | itens apenas viram ouro se vendidos |
| Coletor | 130 cargas ×1,5 ×2,5 G = 487,5 G bruto; custo de ferramenta/tempo de viagem e preço real reduzem | alvo ajustar frequência/venda para 120–240 líquido/h, comparar oferta real |
| Preparador | 45 lotes × margem 3–6 G = 135–270 G | exige demanda, custo já descontado |
| Construtor | 40 equivalentes × margem 4–7 G = 160–280 G | grandes obras esporádicas e manutenção |
| Mercador | 5 entregas × 35–50 G de frete líquido = 175–250 G | risco/percurso real, sem ouro criado |
| Fazendeiro | 12 canteiros ×3 unidades ×2 G em 30min, ~144 G bruto/h, + animais; menos semente/ração/água | tempo ativo distinto de espera, escalar residência sem superar coleta ativa |

Esses cenários não são renda garantida; os preços de referência de coleta estão altos para equilíbrio líquido pretendido e precisam ser ajustados em teste (por exemplo reduzir densidade/volume e referência ou aumentar demanda/custo). Meta comparável: renda por hora ATIVA, rendimento de patrimônio separado; evitar que criação de alts produza vantagem desproporcional. Limitar bônus diários de missões/raid/resgate por conta, não restringir jogo normal. Custos e rendimentos equivalentes sob T2–5 escalam em função do preço de referência e tempo, não linearmente com poder.

Teleporte: Bravamar lvl1 20 G, Forjaponte lvl10 60 G, Porto Junco lvl20 120 G, Vigília Alta lvl35 220 G; desconto Mercador não aplicável, sem teleporte de carga de frete. Transporte de bens pessoais permitido dentro de limite de 10kg de materiais negociáveis e sem ordem de frete, para impedir arbitragem por /city; equipamento e consumíveis de uso próprio excluídos do limite. Confirmar restrição antes de cobrar. Rotas terrestres entre cidades 3–8min a pé; rota marítima 4–7min. Preço e tempos ajustáveis para tornar mercador útil sem tornar locomoção punitiva.

## 19. Recompensas, raids e consumo

Loot normal por criatura: ouro 1+0,1×n (arredondado, chance 70%); material temático: 1 unidade garantida se participação válida + chance 35% de segunda; essência 15%, receita comum 2% (duplicada pode ser ensinada/vendida), troféu elite 10%; elite ×2,5 ouro/material. Sem equipamento superior completo em mobs comuns: raramente componentes (5%). Níveis muito baixos (diferença ≥15) ouro ×0,2, materiais normais preservados. Loot pessoal: participação dano/cura/controle ≥5% ou ação de grupo válida dentro da área; dividir criação de ouro/material para evitar 4× ganho trivial em mob comum (pool de material por mob, distribuição por contribuição, mínimo chance proporcional, não garantido por pessoa). Raids usam loot individual com orçamento de recompensa explicitamente escalado por jogador. Sem duplicação por reconexão.

| Consumível | efeito T1 | tier scaling | duração/CD |
|---|---|---|---|
| poção vida | 20% HP + 20 | +2 pontos percentuais/tier acima 1, cap 28% | CD45s compartilhado cura |
| poção mana | 25% mana | +2 p.p./tier, cap33% | CD45s mana |
| antídoto | remove veneno e 1 lento | mesmo | CD60s |
| tônico vigor | +10% energia reg | +2 p.p./tier (cap18%) | 10min |
| tônico resistência | +5% mitigação final, dentro teto | +1 p.p./tier cap9% | 10min |
| refeição | +5% regeneração HP/mana fora combate | +2 p.p./tier | 30min |
| refeição trabalho | +5% rendimento/velocidade (somente uma) | +2 p.p./tier, teto 13% | 30min |
| chá/bebida | +5% recuperação energia | +1 p.p./tier | 20min |
Comida, bebida e tônico: um ativo por categoria; não combinam dois bônus do mesmo efeito; teto bônus de produtividade +40%; persistir tempo real online/offline. Sem fome obrigatória que puna jogador inativo. Consumíveis T1 permanecem úteis por efeito percentual.

| Raid | tier | minutos | G primeira conclusão elegível | XP Caçador | componente |
|---|---:|---:|---:|---:|---|
| Covil da Raiz | 1 | 12–15 | 40 | 220 | seiva/troféu raiz |
| Mina do Vigia | 2 | 15–20 | 70 | 450 | ferragem rúnica |
| Santuário do Lodo | 3 | 18–22 | 120 | 750 | essência do charco |
| Câmara de Vidro | 5 | 22–28 | 220 | 1400 | cristal vidro |
| Fortaleza Ferrugem | 2 | 18–25 | 90 | 550 | selo marechal |
| Templo Afundado | 3 | 20–26 | 140 | 850 | escama hidra |
| Cidadela da Neve | 4 | 24–30 | 190 | 1150 | núcleo gelo |
| Observatório Astral | 5 | 25–32 | 240 | 1550 | runa astral |
| Fornalha Solar | 5 | 28–35 | 280 | 1800 | coração solar |
| Global 22h | 4–5 | 15 | 300 | 1800 ou XP civil equivalente | selo global + materiais |

Raids solo/grupo acessíveis sem limite; primeira vitória de cada instância por conta/dia recebe recompensa integral; repetição ouro ×0,3, XP ×0,6, componentes ×0,7 em valor esperado, sem impedir entrada. Evita farm desproporcional mantendo materiais disponíveis. Raids solo boss HP = HP mob nível indicado ×5, ataque ×1,4; grupal base solo ×6 HP, ×1,45 ataque; para p participantes HP ×(1+0,75×(p−1)), dano boss ×(1+0,08×(p−1)), adds 1 por jogador adicional; reduzir mecânica de simultaneidade quando p=1, nunca exigir duas pessoas fisicamente. Alvo: boss 2–4min solo, 3–6min grupo; restante exploração/objetivos. Recompensa por participante válida, não multiplicar se entrou e saiu. Global HP definido por DPS mediano testado ×900s × participantes ativos ×0,75, congelado na entrada da fase (ajuste por fase limitado ±15%); máximo 40 por shard; contribuição normalizada por função: dano, cura efetiva, interrupção, frete/insumos consumidos e reparo em objetivos válidos; exigir ≥4 eventos separados e ≥2min atividade + escore ≥30% da mediana do papel, ou limite mínimo fixo testado. Não exigir build específica. Falha 30% ouro/XP/materiais se elegível, uma recompensa global/conta/data local. Inputs civis previamente definidos, não aceitar itens inúteis só para contribuição.

## 20. Controle de equilíbrio e cenários de validação

Métricas agregadas diárias e por tier/servidor: ouro criado/destruído, ouro per capita P50/P90 e concentração, itens criados/consumidos, estoques em inventário/mercado, preço mediano e volume, tempo de ordem, retorno líquido por atividade e horas ativas, especialização, uso de receitas, abandono de tutorial, mortes por zona e diferença de nível, TTK, dano/cura por habilidade, escolha de arma, tentativas de raid, vitória por tamanho de grupo, eficiência NPC vs manual, acesso civil por cidade. Usar medianas e percentis, não média isolada. Testar com coortes 10/50/100 jogadores simultâneos e simulação sintética 30 dias (agentes econômicos simplificados, sem IA externa). Antes de lançamento real, observar beta por duas semanas; comparar metas §13.

| Teste | procedimento / critério de aprovação | ajuste se falhar |
|---|---|---|
| curva XP | reproduzir XP cumulativa para cada nível, medir XP/h real de cada profissão | ajustar XP por ação, não ouro |
| acesso civil | fazendeiro lv35 sem Caçador>1 visita cidades com rota segura e /city | rotas NPC/transportes desbloqueio civil |
| economia básica | 20 coletores, 10 preparadores, 10 construtores, 20 caçadores, 10 fazendeiros, 10 mercadores simulados | demanda, densidade e margens por cadeia |
| item sem demanda | 30 dias sem consumo/trade de recurso não vinculado | nova receita de manutenção/substituição ou retirar item antes do lançamento |
| domínio de profissão | lucro ativo P50 de profissão >1,5× mediana por 14 dias | corrigir receita, oferta/demanda e custos em até 10% por patch |
| inflação | ouro criado/destruído fora 0,90–1,10 por 14 dias e preços cesta +15% | ajustar faucets/sinks progressivos, não confiscar saldo |
| PvP | matriz 10 armas×3 builds×3 tiers, confrontos pares, dano vs cura | se taxa vitória >60% contra equivalentes, revisar skills e TTK |
| arena | entrar/sair, morte, desconexão, ataque fora da borda | zero dano fora; zero loot/desgaste |
| raid | p=1,2,3,4, composições sem healer/tanque, reconectar | ajustar mecânicas e HP antes de prêmio |
| global | relógio America/Sao_Paulo, reinício 21:59/22:05, corrida de claim | uma ocorrência e claim por conta/data |
| fazenda | realizar 2 ciclos offline, água/ração insuficiente, expansão | nenhuma produção extra ou morte por ausência |
| NPC | salário parcial, pausa, revogação, input faltante, duplicação de chamada | conservação de ouro/insumos, igualdade com ledger |
| mercado | ordem parcial, cancelamento simultâneo, dois compradores, queda do servidor | nenhum saldo negativo, perda/duplicação |
| coleta | dois jogadores mesmo nó, exaustão, AFK, PvP, peso cheio | atomicidade, timing e interrupção |
| arte | avatar com mesmo design ao trocar todos equipamentos, legibilidade de arma/skill | excluir malha cosmética involuntária |
| aquisição | auditoria de licença, fonte e scene test de cada asset | excluir/recriar lacuna |

Exemplo KPI de conservação: para cada item i, estoque_final = estoque_inicial + produção + loot − consumo − reciclagem líquida − descarte; transferências cancelam. Para ouro, saldo_total_final = inicial + emissão legítima − taxas/sumidouros. Alerta por discrepância de ledger, não por mera riqueza. Alterações de balanceamento versionadas com changelog, aplicar a novos drops/receitas; nunca modificar custos de contrato iniciado. Um ciclo por semana na beta; produção normal em etapas de 2–4 semanas, hotfix apenas para bugs críticos. Controle de mudanças exige razão, métrica, parâmetro anterior/novo, teste de regressão e plano de rollback.

## 21. Checklist final antes de implementação

- Confirmar público/plataforma, nome definitivo, regras de PvP e modelo de monetização sem poder.
- Aprovar arte piloto com Quaternius e referências UI/áudio, depois fechar catálogo de lacunas.
- Converter tabelas de items, recipes, skills, mobs, zones, profession_xp, loot, travel, housing, crops, animals, raids e assets em CSV/JSON com IDs únicos e chaves referenciais. Este documento especifica famílias, fórmulas e variantes; geração de registros individuais é tarefa de implementação, não catálogo de ZIP já validado.
- Validar fórmulas em planilha/simulador e teste com jogadores; nenhum valor pretende representar balanceamento final comprovado.
- Implementar primeiro a cadeia tronco/minério → refino → ferramenta → coleta → mercado → refeição → caça → construção → fazenda → demanda recorrente. Só expandir conteúdo quando todas as profissões forem viáveis.
- Preservar o princípio: um item pode ter utilidade de consumo, manutenção, produção, missão, transporte, aparência ou comércio; não precisa obrigatoriamente aumentar dano. Todos os estilos de jogador devem contribuir com autonomia no início e especialização profissional no longo prazo.

**Fim — versão 1.0.**
