import json,zipfile,pathlib,sys
root=pathlib.Path(sys.argv[1]); out=pathlib.Path(sys.argv[2]); specs=json.load(open(pathlib.Path(__file__).with_name('pilot_models.json')))
for code in sorted({m['pack'] for m in specs}):
 with zipfile.ZipFile(root/'assets/source/quaternius'/code/'original.zip') as z:
  for n in z.namelist():
   p=pathlib.PurePosixPath(n)
   if p.is_absolute() or '..' in p.parts or '\\' in n:raise ValueError(n)
  z.extractall(out/code)
for m in specs:
 paths=[p for p in (out/m['pack']).rglob('*.'+m['format']) if p.stem==m['stem'] and '__MACOSX' not in str(p)]
 if len(paths)!=1: raise ValueError((m,paths))
 m['input']=str(paths[0].resolve())
(out/'inputs.json').write_text(json.dumps(specs,indent=2))
# PBR fallback color for Q11; preserve alpha in scratch only.
from PIL import Image
p=out/'Q11/glTF/Leaves_NormalTree_C.png'
im=Image.open(p).convert('RGBA'); color=Image.new('RGBA',im.size,(111,154,78,255));color.putalpha(im.getchannel('A'));color.save(p)
