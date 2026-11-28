"""Verify the client/server movement geometry is identical and source animation clips survived."""
import json,pathlib,struct
root=pathlib.Path(__file__).resolve().parents[1]
a=(root/'client/world/collision.json').read_bytes();b=(root/'server/internal/world/collision.json').read_bytes()
assert a==b
g=json.loads(a);assert len(g['boxes'])==126 and g['spawn']==[0,13.8]
p=root/'client/world/assets/avatar_custom.glb';b=p.read_bytes();m=json.loads(b[20:20+struct.unpack_from('<I',b,12)[0]])
assert {'Idle','Walk','Run'}<={a['name'] for a in m['animations']} and len(m['animations'])==11
assert {'CW_Outfit','CW_Skin','CW_Hair'}<={a['name'] for a in m['materials']}
assert {'CW_Hair_short','CW_Hair_swept'}<={a['name'] for a in m['nodes']}
print('CW_P05_DATA_OK',len(g['boxes']),'colliders',len(m['animations']),'clips')
