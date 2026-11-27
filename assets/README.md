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

## Importação reproduzível

Os 14 arquivos originais foram baixados localmente e tiveram tamanho, SHA-256 e CRC registrados. Execute `python3 tools/download_assets.py` na raiz para obter e validar os arquivos ausentes. A presença remota deve ser confirmada pela árvore Git; status do manifesto indica verificação local, não publicação.
