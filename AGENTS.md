# AGENTS.md — Colony World

## Autoridade e escopo
Leia README.md, docs/MMORPG_GDD_Assets_Balanceamento.md e docs/p00/ antes de desenvolver. P00 é pré-produção; não afirmar que MMORPG já existe. O nome Colony World identifica o repositório; Aurevia é nome provisório no GDD. Não implementar ou ampliar fase seguinte sem autorização. Preservar decisões de produto, atualizar docs/roadmap e registrar testes e lacunas ao fim de cada lote.

## Tecnologias
Godot 4.7.2 + GDScript para cliente PC; Go para serviço autoritativo e PostgreSQL para estado persistente. Projetos isolados; render Compatibility como baseline P00, Forward+ apenas após perfil real. glTF/GLB como intercâmbio. Servidor autoritativo: não confiar em cliente para ouro, XP, dano, permissões, inventário ou contratos. Nenhuma API IA ou asset proprietário extraído de jogos existentes.

## Arte — regra de ouro
Fantasia medieval low-poly 3D; Quaternius é família principal, não misturar estilos realistas, voxel, pixel art ou proporções chibi muito extremas. Usar formas orgânicas e silhuetas legíveis, não substituir arte por primitivas geométricas como entrega final. Primitivas podem ser terreno/colisor/proxy explicitamente marcado. Paleta terrosa e verde, metal fosco, acentos regionais. Iluminação coerente; sem bloom exagerado. Equipamento NÃO altera corpo ou roupa do jogador. Armas e ferramentas visíveis somente durante ação; sockets independentes. Avatares neutros sem classe fixa. NPCs devem ter identidade; bosses desenho, tamanho, clipes e mecânicas próprios. Não usar somente recolor/zoom para espécie ou chefe.

## Gestão de assets
- assets/source/ é imutável; preservar ZIP, SHA, autor, URL e licença. Nunca editar dentro do original.
- docs/p00/asset_catalog.csv é inventário de candidatos, não lista de assets aprovados. Confirmar arquivo específico, licença interna e eventuais componentes terceiros. CC0 página + evidência interna quando disponível; fontes separadas. Nenhum asset de origem desconhecida.
- Selecionar poucos por vez, trabalhar em scratch, converter e salvar derivados promovidos em assets/runtime/{categoria}/. Protótipos isolados em prototypes/p00/. Não duplicar 576 MB de originais ou extrair tudo dentro do Git.
- ID estável cw_<categoria>_<nome>_<variante>; nomes snake_case. Manifesto inclui origem/pack/member, hash original, ferramenta/versão, transform, material, triângulos, clipes, textura, licenças, status e arquivos de preview. LOD e collider independentes; pivô no chão e unidade metro. Blender Z-up → glTF Y-up → Godot Y-up.
- Avatar 1,75 m, 2–6k tris (exceção explicitada antes de otimizar); NPC 1–4k; mob 0,8–5k; boss 5–15k; prop 100–2k; módulo 200–3k. Alvos de desempenho, não máximos cegos. Atlas 512–1024, artefatos de normal/alpha revisados. Reutilizar atlas compartilhado em produção; o piloto pode embutir texturas.
- Animar in-place, nomes canônicos idle/walk/run/attack/hit/die/work; retarget validado por esqueleto, pesos, contato de pés, sockets e hit events. Não assumir que nomes de ações equivalem a clipes exportados: contar após export GLB. P00 detectou necessidade de NLA, alpha opaco dos FBX antigos, relink de textura e tratamento de vertex color Q11.
- Por lote: scene test com iluminação/câmera padrão, screenshots e, para clipes, preview frame a frame ou GIF; validar mesh, materiais, clip count, importação, escala, hitbox, performance; publicar somente após auditoria e aprovação. Não alegar 60 FPS sem benchmark real. Para QA de bosses, escalar tomando avatar como referência e checar silhueta/ataques.

## Regras de design
Todos podem aprender profissões; progressão independente, especialização econômica. Toda família de recurso deve ter demanda recorrente. Evitar sistemas pay-to-win; não recriar UI, mapas ou assets de outros jogos. Cap 5 personagens, zonas iniciais non-PvP, arena PvP delimitada; /city somente cidades descobertas e elegibilidade; raid global 22:00 America/Sao_Paulo. Não modificar economia sem simulação e changelog; números GDD são baseline.

## Entregas e verificações
Não cometer secrets, caches .godot/, arquivos temporários, build ou extrações duplicadas. Testar em headless e GUI quando pertinente. Registrar resultado verificável, problemas restantes, decisões e próxima etapa. Alterações de scope e aprovação artística são do usuário. Não avançar P01/P0 sem aprovar P00.
