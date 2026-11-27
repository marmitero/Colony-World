#!/usr/bin/env python3
"""Audit source archives, candidate names and licensing without extracting."""
import csv, hashlib, json, zipfile, pathlib, collections, re, sys
root=pathlib.Path(sys.argv[1] if len(sys.argv)>1 else '.').resolve()
out=pathlib.Path(sys.argv[2] if len(sys.argv)>2 else root/'docs/p00');out.mkdir(parents=True,exist_ok=True)
def csvout(name,fields,rows):
 with (out/name).open('w',newline='',encoding='utf-8') as f:
  w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
rows=[]; catalog=[]; license_notes=[]
formats={'.blend','.fbx','.obj','.gltf','.glb','.dae'}
for r in csv.DictReader((root/'assets/manifest.csv').open()):
 if not r['path']:continue
 path=root/'assets'/r['path']; code=r['id']; h=hashlib.sha256(path.read_bytes()).hexdigest()
 if h!=r['sha256']: raise RuntimeError(code+' hash mismatch')
 groups=collections.defaultdict(list); counts=collections.Counter(); licenses=[]; invalid=[]
 if path.suffix=='.zip':
  with zipfile.ZipFile(path) as z:
   bad=z.testzip()
   if bad:raise RuntimeError(code+' CRC '+bad)
   for i in z.infolist():
    if i.is_dir():continue
    n=i.filename; p=pathlib.PurePosixPath(n)
    if p.is_absolute() or '..' in p.parts or '\\' in n:invalid.append(n)
    if '__MACOSX' in p.parts or p.name.startswith('._'):continue
    ext=p.suffix.lower();counts[ext]+=1
    if re.search(r'license|licence|copyright|credits|readme|terms',p.name,re.I) and ext in {'.txt','.md'}:
     data=z.read(i).decode('utf-8','replace')[:5000];licenses.append((n,data))
    if ext in formats:
     key=('model',p.stem.casefold())
    elif ext in {'.ogg','.wav','.mp3','.flac'}:
     key=('audio',p.stem.casefold())
    elif code.startswith(('K','U')) and ext in {'.png','.svg','.ttf','.otf'}:
     key=('ui',p.stem.casefold())
    elif ext in {'.png','.jpg','.jpeg','.tga','.dds','.webp'}:
     key=('texture_or_preview',p.stem.casefold())
    else:continue
    groups[key].append(n)
 else:
  counts[path.suffix]=1;groups['audio',path.stem]=[path.name]
 for (typ,key),paths in sorted(groups.items()):
  catalog.append(dict(pack=code,kind=typ,candidate=key,formats=';'.join(sorted({pathlib.PurePosixPath(x).suffix.lower() for x in paths})),representative=paths[0],file_count=len(paths),status='candidate_not_homologated'))
 statements='\n'.join(x[1] for x in licenses).lower()
 if licenses and ('cc0' in statements or 'public domain' in statements or 'creative commons zero' in statements): lic='internal_cc0_text'
 elif licenses:lic='internal_text_review_required'
 else:lic='page_cc0_only'
 if code in {'K01','K02'} and licenses:lic='internal_text_review_required'
 rows.append(dict(pack=code,title=r['title'],archive=r['path'],bytes=path.stat().st_size,sha256=h,zip_crc='pass' if path.suffix=='.zip' else 'not_applicable',unsafe_paths=len(invalid),files=sum(counts.values()),model_candidates=sum(k[0]=='model' for k in groups),audio_candidates=sum(k[0]=='audio' for k in groups),ui_candidates=sum(k[0]=='ui' for k in groups),extensions=';'.join(f'{k}:{v}' for k,v in counts.most_common()),license_status=lic,internal_documents=';'.join(x[0] for x in licenses)))
 for n,d in licenses:license_notes.append(f'## {code}: {n}\n\n{d}\n')
csvout('pack_audit.csv',list(rows[0]),rows)
csvout('asset_catalog.csv',list(catalog[0]),catalog)
(out/'license_review.md').write_text('# Internal license evidence\n\nText copied from original archives for audit (not a replacement for checking the upstream page).\n\n'+'\n'.join(license_notes))
print('packs',len(rows),'files',sum(r['files'] for r in rows),'models',sum(r['model_candidates'] for r in rows),'audio',sum(r['audio_candidates'] for r in rows),'ui',sum(r['ui_candidates'] for r in rows),'rows',len(catalog))
print(collections.Counter(r['license_status'] for r in rows))
