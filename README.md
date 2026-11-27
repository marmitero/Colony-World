# Colony World

MMORPG 3D de fantasia medieval orientado à economia, profissões e cooperação. Projeto em pré-produção; Aurevia é o nome provisório do GDD.

## Documentação

- [GDD, inventário de assets e balanceamento](docs/MMORPG_GDD_Assets_Balanceamento.md)
- [Aquisição e arquitetura de assets](assets/README.md)
- [Manifesto de pacotes](assets/manifest.csv)

A implementação começará pelo vertical slice P0. Os números de balanceamento são propostas a validar. Assets candidatos só entram no runtime após verificação de licença, importação e aprovação visual.

## Status dos assets

33 arquivos originais publicados na pasta `assets/source/` (576 MB decimais), todos verificados. Consulte o manifesto antes de importar. O runtime está reservado para modelos e áudio convertidos e homologados.

## P00 — Homologação técnica e direção artística

P00 aprovada pelo usuário em 27/11/2026. Foram auditados os 33 originais e 1.028 candidatos de modelos, com 21 GLBs normalizados em uma cena-piloto Godot. A fase não implementa gameplay.

- [Relatório P00 e evidências](docs/p00/README.md)
- [Matriz de cobertura e lacunas](docs/p00/COVERAGE.md)
- [Arquitetura técnica](docs/p00/ARCHITECTURE.md)
- [Projeto-piloto Godot](prototypes/p00/README.md)
- [Padrões para agentes](AGENTS.md)

P0 iniciada após aprovação da P00.

## P0.1 — Fundação técnica

- [Roadmap da P0](docs/p0/ROADMAP.md)
- [Relatório P0.1 e testes](docs/p0/P0.1.md)

### Testar no Windows

1. Baixe e extraia o repositório.
2. Instale **Go 1.24+** uma vez e disponibilize **Godot 4.7.2** (executável na raiz, em tools/godot, no PATH ou variável GODOT_EXE).
3. Dê duplo clique em `jogar.bat`. Ele compila e inicia o servidor local, importa o projeto Godot, abre o cliente e encerra apenas o servidor que iniciou ao fechar.
4. Na P0.1, verá a prova de conexão verde; ainda não há login nem jogabilidade. PostgreSQL/Docker são opcionais para esta prova.

Não há downloads automáticos, scripts de instalação nem credenciais versionadas.
