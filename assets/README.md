# Biblioteca de assets — Colony World

Direção: fantasia medieval low-poly 3D, Quaternius como família visual principal. Kenney para UI; efeitos e música independentes. Consulte o GDD em docs/.

## Arquitetura

- source/<autor>/<pack>/: originais intactos (ZIP e licença/origem).
- runtime/characters/: avatares e NPCs; creatures/: monstros e animais; environment/: terreno, cidades e dungeons; props/: objetos e construções; items/: armas, ferramentas e ícones; ui/, vfx/, audio/, music/: conteúdo convertido e aprovado.
- credits/: créditos, licenças e registros de origem.
- manifest.csv: rastreabilidade de cada pack; estados distinguem candidato, arquivo baixado e aprovado.
- tools/: importação e validação.

Originais não são automaticamente assets de produção. Verificar licença, arquivos contidos, escala, materiais, rig, animações, colisão, LOD e compatibilidade visual. Exportar derivados em GLB/glTF, UI em PNG/SVG, áudio em OGG/WAV. Manter manifestos com SHA-256, URLs, autor, licença e fonte. Coleções são índices, não pacotes únicos; selecionar entradas individualmente.

Não há motor definido ainda: esta estrutura é independente de engine. Apenas conteúdo aprovado será colocado em runtime.

## Importação e validação

Os 14 pacotes individuais estão publicados integralmente como ZIPs originais em source/. Os hashes Git remotos coincidem com os arquivos baixados e o manifesto fixa SHA-256, tamanho, URL e licença indicada. Execute `python3 tools/download_assets.py` na raiz para validar os arquivos (e baixar um arquivo ausente). O workflow Import pinned original assets também permite restaurar pacotes ausentes.

As coleções Q10 e M01 são índices, com links de candidatos complementares em credits/complementary-candidates.md. A importação de arquivos não equivale à homologação estética ou auditoria de licenças internas.
