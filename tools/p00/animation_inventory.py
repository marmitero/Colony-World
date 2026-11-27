"""Blender background: read action names from rigged source .blend and GLB libraries."""
import bpy, pathlib, tempfile, zipfile, csv, json, struct, sys
args=sys.argv[sys.argv.index('--')+1:]; root=pathlib.Path(args[0]).resolve(); output=pathlib.Path(args[1]).resolve()
rows=[]
with tempfile.TemporaryDirectory() as tmp:
 for code in ['Q01','Q02','Q04','Q07','Q18','Q19','Q20','Q21']:
  with zipfile.ZipFile(root/'assets/source/quaternius'/code/'original.zip') as z:
   for n in z.namelist():
    p=pathlib.PurePosixPath(n)
    if '__MACOSX' in p.parts or 'Only Weapons' in p.parts:continue
    if code in ('Q20','Q21'):
     if p.suffix.lower()!='.glb':continue
     b=z.read(n);j=json.loads(b[20:20+struct.unpack_from('<I',b,12)[0]])
     names=[a.get('name','unnamed') for a in j.get('animations',[])]
    else:
     if p.suffix.lower()!='.blend':continue
     local=pathlib.Path(tmp)/(code+'-'+p.name);local.write_bytes(z.read(n))
     try:
      with bpy.data.libraries.load(str(local),link=False) as (src,dst):names=list(src.actions)
     except Exception as e: print(code,n,e);continue
    for name in names:rows.append({'pack':code,'source_member':n,'candidate':p.stem,'action':name,'status':'source_name_only_not_retargeted'})
with output.open('w',newline='',encoding='utf-8') as f:
 w=csv.DictWriter(f,fieldnames=['pack','source_member','candidate','action','status']);w.writeheader();w.writerows(rows)
print('SOURCE_ACTIONS',len(rows),'MODELS',len({r['source_member'] for r in rows}))
