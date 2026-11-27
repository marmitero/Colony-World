#!/usr/bin/env python3
import csv,hashlib,json,pathlib,struct,sys
root=pathlib.Path(sys.argv[1]).resolve(); pilot=pathlib.Path(sys.argv[2]).resolve(); output=pathlib.Path(sys.argv[3]).resolve()
specs=json.loads((pilot/'assets/conversion.json').read_text()); layout=json.loads((pilot/'layout.json').read_text())
original={r['id']:r['sha256'] for r in csv.DictReader((root/'assets/manifest.csv').open())}
counts={}; rows=[]
for s in specs:
 p=pilot/'assets'/f"{s['id']}.glb";b=p.read_bytes()
 magic,ver,size=struct.unpack_from('<4sII',b)
 assert magic==b'glTF' and ver==2 and size==len(b),(p,'invalid header')
 n=struct.unpack_from('<I',b,12)[0];j=json.loads(b[20:20+n])
 clips=[a.get('name','') for a in j.get('animations',[])]
 assert len(clips)==len(s['actions']), (s['id'],len(clips),len(s['actions']))
 assert all(i.get('bufferView') is not None or i.get('uri','').startswith('data:') for i in j.get('images',[])),(s['id'],'external image')
 assert all(t['resolved'] for t in s['textures']),(s['id'],'unresolved textures')
 assert j.get('meshes'),s['id']
 ninst=sum(a[0]==s['id'] for a in layout['placements'])
 status='rejected_style' if s['id'] in {'deer','chicken'} else 'pilot_candidate_not_production'
 rows.append(dict(id=s['id'],pack=s['pack'],source_member=s['source_member'],source_archive_sha256=original[s['pack']],glb_sha256=hashlib.sha256(b).hexdigest(),height_m=s['height'],triangles=s['triangles'],clips=len(clips),clip_names=';'.join(clips),textures=len(j.get('textures',[])),instances=ninst,bytes=len(b),status=status))
 counts[s['id']]=s['triangles']
assert all(a[0] in counts for a in layout['placements'])
assert not any(a[0] in ('deer','chicken') for a in layout['placements'])
with output.open('w',newline='',encoding='utf-8') as f:
 w=csv.DictWriter(f,fieldnames=rows[0].keys());w.writeheader();w.writerows(rows)
print('VALIDATED',len(rows),'GLBs,',sum(r['clips'] for r in rows),'clips,',sum(r['bytes'] for r in rows),'bytes,',len(layout['placements']),'instances,',sum(counts[x[0]] for x in layout['placements']),'raw instance triangles')
