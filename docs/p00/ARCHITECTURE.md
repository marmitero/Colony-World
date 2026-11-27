# P00 — Arquitetura técnica escolhida

Data: 27/11/2026. Decisão inicial ratificável: **Godot 4.7.2 stable, GDScript no cliente, Go no servidor autoritativo, PostgreSQL para persistência**. Primário Windows/PC; navegador é uma expansão opcional, não a exigência inicial. Godot instalado nesta execução: 4.7.2.stable.official.ed1daf0bf; Blender 4.3.2. Fixar versões no desenvolvimento. Não instalar serviços nem implementar rede nesta etapa.

## Motivos e limites

- Godot oferece pipeline GLB, animações, cena 3D, ferramentas de navegação, câmera, partículas e interface, sem depender de serviços proprietários para rodar.
- GDScript facilita iterações de visual e gameplay. Simulação autoritativa não depende de renderização ou do frame rate do cliente. Go é a escolha do serviço, não um requisito do cliente. PostgreSQL concentra transações de ouro, inventário e contratos.
- Compatibilidade (OpenGL/WebGL como baseline visual) na P00; Forward+ pode ser avaliado para PC depois. Não usar efeitos exclusivos de um renderer sem fallback aprovado. O export Web exige verificação específica de WebAssembly, WebGL e desempenho; não prometer navegador sem teste. Godot suporta headless para desenvolvimento/testes, não substitui a decisão por servidor independente.
- Sem API IA. Serviços e dados próprios. Redis somente se perfis reais indicarem benefício. Nada de blockchain ou economia real.
- Referências oficiais: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html ; https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html ; https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html .

## Estrutura alvo (P0+, não inicializada como jogo nesta etapa)

| Pasta | Responsabilidade |
|---|---|
| client/ | projeto Godot, UI, câmera, input, efeitos, interpolação, cenas, adapters de rede |
| server/ | serviço Go: sessões, mapa, simulação, regras, inventário, transações, eventos e shards |
| shared/ | contratos versionados, IDs e schemas; exportação de definições, mensagens e fixtures |
| data/ | balanceamento CSV/JSON, catálogos, recipes, zones, quests, mobs, progression |
| migrations/ | PostgreSQL, registro transacional e versões |
| assets/source/ | originais imutáveis |
| assets/runtime/ | derivados homologados; importar/copiar para client no build sob manifesto |
| tools/ | audit, conversão, validação e build |
| prototypes/p00/ | cena piloto isolada, não produção |
| tests/ | testes de regras, integridade, importação e regressão |
| docs/ | decisões, GDD, changelog, roadmaps e aprovações |

## Limites cliente-servidor

Cliente: captura de intenção, visual de movimento previsto, HUD, poses/efeitos, interação, menu; nunca decide saldo, dano ou propriedade. Servidor: valida intenção, posição alcançável, cooldown, interação, permissões e resultado; transações idempotentes, event log, snapshots. Banco: estado durável e ledger. Comunicação proposta: WebSocket seguro para sessão, comandos e snapshots; estudar UDP/ENet apenas se latência e plataforma justificarem. Tick inicial 20 Hz com snapshots 10–15 Hz é hipótese P0; medir. Chunks por interesse espacial e versão dos dados; mapas manuais, residência e raid instanciados. Sem implementação nesta P00.

## Validação e escolha de renderer

P00 realmente exportou 19 GLB com Blender e executou importação headless em Godot 4.7.2. A cena contém instâncias, ambiente, luz, câmera orbitável, zoom e preview de Idle. O render visual é produzido com Blender a partir dos mesmos GLBs e layout, não uma captura do Godot. Headless não mede FPS, GPU, shader e aparência do renderer. P0 exige cena GUI e benchmark no hardware de referência (Windows, GPU integrada e dedicada) antes de alterar render pipeline. A escolha PC evita prematuramente limitar o mundo por tamanho de download de navegador; GLB e GDScript mantêm caminho opcional.

## P0 — portão de aceitação

1. Criar projeto client e servidor com loop de conexão local, movimento validado, estado persistente básico e 5 slots permitidos.
2. Exibir Bravamar em câmera elevada, tamanho humano 1,75 m, construção/vegetação em escala coerente.
3. Pilotar Bosque do Orvalho e Desfiladeiro Ferrugem; assets críticos da matriz precisam de decisão e lote aprovado.
4. Prova jogável mínima: movimentação, ataque, coleta, inventário, respawn, zona segura e persistência. Não começar mercado, guilda ou raid global antes de validar núcleo.
5. Simular dois clientes, reconectar, testar transações e regras sem duplicação; benchmark gráfico real. Critérios do GDD permanecem obrigatórios.
