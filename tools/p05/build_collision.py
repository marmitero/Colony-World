"""Generate shared OBB collision footprint from Bravamar layout and normalized GLB dimensions."""
import json,pathlib,sys,math
root=pathlib.Path(sys.argv[1]);layout=json.load(open(root/'client/world/bravamar.json'))
spec={}
for f in [pathlib.Path(sys.argv[2]),root/'client/world/assets/conversion.json']:
 for m in json.load(open(f)):
  spec[m['id']]=[x*m['scale'] for x in m['source_size_m']]
solid={'crate','barrel','well','cart','market','market2','bench','hay','cauldron','bonfire','fence','rock','tree'}
boxes=[]
for p in layout['placements']:
 id=p['asset'];k=p['kind']
 if k not in ('building','npc') and id not in solid:continue
 if id not in spec:raise ValueError(id)
 sx,sz,sy=spec[id];scale=p['scale']
 if id=='tree':sx=sz=.85;sy=3
 elif k=='npc':sx=sz=.65;sy=1.75
 elif id=='fence':sz=max(sz,.18)
 boxes.append(dict(id=p.get('id',p.get('service',id)),x=p['x'],z=p['z'],hx=round(sx*scale*.5,4),hz=round(sz*scale*.5,4),height=round(sy*scale,4),rot=p['rotation']))
data=dict(version=1,spawn=[0,13.8],bounds=[-47.5,47.5,-35.5],radius=.32,arena=layout['arena'],piers=[dict(x=7,z=29.5,hx=5,hz=4.5),dict(x=15,z=28,hx=3,hz=2)],boxes=boxes)
b=json.dumps(data,separators=(',',':'),ensure_ascii=False)
(root/'client/world/collision.json').write_text(b);(root/'server/internal/world/collision.json').write_text(b)
print('collision boxes',len(boxes))
