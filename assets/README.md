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

Os pacotes individuais do GDD são preservados integralmente em source/, incluindo originais de 3D, UI, SFX e trilhas. Cada arquivo tem URL, autor, licença indicada, tamanho e SHA-256 fixados no manifesto. Execute `python3 tools/download_assets.py` na raiz para validar arquivos presentes e baixar ausentes; ZIPs também passam por teste CRC.

Q10 e M01 são índices, não arquivos. As entradas individuais citadas no GDD foram selecionadas para importação; consultar manifesto para o status de publicação. O arquivo fonte opcional de edição musical de The Field Of Dreams não faz parte do runtime (somente faixa original). Nenhum pacote ainda está homologado artisticamente ou teve licenças internas auditadas.
