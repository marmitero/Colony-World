"""Check Bravamar art data and future zone boundaries; no gameplay rules."""
import json,math,pathlib,struct
root=pathlib.Path(__file__).resolve().parents[1]/'client'
layout=json.load(open(root/'world/bravamar.json'))
assert layout['id']=='bravamar' and len(layout['exits'])==2
assert {e['id'] for e in layout['exits']}=={'bosque','ferrugem'}
assert layout['outside']=='safe'
cx,cz=layout['arena']['center'];r=layout['arena']['radius']
def in_arena(x,z):return math.hypot(x-cx,z-cz)<=r
assert not in_arena(layout['spawn'][0],layout['spawn'][2])
npcs=[p for p in layout['placements'] if p['kind']=='npc']
assert len(npcs)==12 and len({p['id'] for p in npcs})==12
assert all(not in_arena(p['x'],p['z']) for p in npcs)
services={p['service'] for p in layout['placements'] if p['kind']=='building'}
assert {'guild','elder','weapons','armor','potions','deco','residence','bank','travel'}<=services
assert all(not in_arena(e['x'],e['z']) for e in layout['exits'])
# Main two road ribbons connect via safe spawn/plaza bypass, not the future PvP circle.
for name in ['west_road','east_road','north_loop','port_road']:
 m=next(m for m in layout['meshes'] if m['id']==name)
 assert all(not in_arena(v[0],v[2]) for v in m['vertices']),name
for p in layout['placements']:
 path=root/'world/assets'/f"{p['asset']}.glb"
 if not path.exists():path=root/'menu_assets'/f"{p['asset']}.glb"
 b=path.read_bytes();magic,version,length=struct.unpack_from('<4sII',b)
 assert magic==b'glTF' and version==2 and length==len(b),path
for mesh in layout['meshes']:
 assert all(0<=i<len(mesh['vertices']) for face in mesh['faces'] for i in face)
print('CW_P04_LAYOUT_OK',len(layout['placements']),'instances',len(npcs),'NPCs',len(layout['exits']),'exits',len(layout['meshes']),'surfaces')
