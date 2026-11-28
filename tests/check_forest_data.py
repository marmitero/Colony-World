import json,pathlib,struct,hashlib,collections
root=pathlib.Path(__file__).resolve().parents[1]
world=root/'client/world'
assert (world/'forest_collision.json').read_bytes()==(root/'server/internal/world/forest_collision.json').read_bytes()
layout=json.loads((world/'forest.json').read_text())
geo=json.loads((world/'forest_collision.json').read_text())
assert len({p['id'] for p in layout['placements']})==len(layout['placements'])
counts=collections.Counter(p['kind'] for p in layout['placements'])
assert counts['creature']==19 and counts['resource']==38
assert geo['max_z']==44.5 and geo['arena']['radius']<0
for p in layout['placements']:
 assert any((d/(p['asset']+'.glb')).exists() for d in [world/'forest_assets',world/'assets',root/'client/menu_assets'])
for m in json.loads((world/'forest_assets/conversion.json').read_text()):
 b=(world/'forest_assets'/(m['id']+'.glb')).read_bytes()
 assert hashlib.sha256(b).hexdigest()==m['sha256']
 n=struct.unpack_from('<I',b,12)[0]
 d=json.loads(b[20:20+n])
 assert [x.get('name') for x in d.get('animations',[])]==m['exported_clips']
print('CW_FOREST_DATA_OK',counts)
