# Colony World — Protótipo P00

Prova de direção artística isolada do jogo. Todos os GLBs derivam dos ZIPs originais já publicados. Não são modelos finais de produção. Dois GLBs rejeitados (deer/chicken) estão disponíveis apenas para comparação.

## Executar

Godot 4.7.2 stable (renderer Compatibility).

1. Abrir `project.godot` no editor, aguardar importação, executar F5.
2. Setas esquerda/direita para girar; cima/baixo para zoom; Espaço pausa ou retoma Idle.
3. A cena é apenas showroom, sem movimentação de jogador ou rede.

CLI a partir da raiz do repositório:

```bash
godot --headless --editor --import --path prototypes/p00
godot --headless --path prototypes/p00 --quit-after 8
python3 tools/p00/validate_pilot.py . prototypes/p00 /tmp/pilot-manifest.csv
```

Resultado: `P00_OK models=21 instances=93 animation_players=5`.

## Regenerar os derivados e evidências

Python 3.12+ com Pillow, Blender 4.3.2, originais em assets/source.

```bash
python3 tools/p00/audit.py . /tmp/cw-audit
blender -b --python tools/p00/animation_inventory.py -- . /tmp/animation_inventory.csv
python3 tools/p00/extract_pilot.py . /tmp/cw-extracted
blender -b --python tools/p00/convert_pilot.py -- /tmp/cw-extracted/inputs.json /tmp/cw-glb
blender -b --python tools/p00/render_pilot.py -- /tmp/cw-glb prototypes/p00/layout.json /tmp/cw-pilot.png
blender -b --python tools/p00/contact_sheet.py -- /tmp/cw-glb /tmp/cw-thumbs
python3 tools/p00/assemble_sheet.py /tmp/cw-thumbs /tmp/cw-glb/conversion.json /tmp/cw-contact.jpg
blender -b --python tools/p00/animation_preview.py -- /tmp/cw-glb /tmp/cw-frames
python3 tools/p00/assemble_animation.py /tmp/cw-frames /tmp/cw-animation.gif
```

Import settings default: GLBs self-contained, editor pode extrair texturas locais durante importação. O Git preserva GLBs e arquivos fonte do projeto; cache/extrações editor são ignorados. O render Blender não é captura de Godot. Veja [auditoria e decisões](../../docs/p00/README.md).
