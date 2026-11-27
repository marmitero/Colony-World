#!/usr/bin/env python3
"""Reproduce verified original asset archives from the pinned manifest."""
import csv, hashlib, pathlib, urllib.request, zipfile, concurrent.futures
ROOT = pathlib.Path(__file__).resolve().parents[1] / 'assets'
def verify(path, row):
    if path.stat().st_size != int(row['bytes']): raise ValueError('size mismatch')
    with path.open('rb') as f:
        if hashlib.file_digest(f,'sha256').hexdigest()!=row['sha256']: raise ValueError('SHA256 mismatch')
    with zipfile.ZipFile(path) as z:
        if z.testzip() is not None: raise ValueError('ZIP CRC mismatch')
def download(row):
    p=ROOT / row['path']; p.parent.mkdir(parents=True, exist_ok=True)
    if p.exists(): verify(p,row); return row['id']+' already verified'
    tmp=p.with_suffix('.part')
    try:
        with urllib.request.urlopen(row['download_url'], timeout=120) as r, tmp.open('wb') as f:
            while chunk:=r.read(1024*1024): f.write(chunk)
        verify(tmp,row); tmp.replace(p)
    finally: tmp.unlink(missing_ok=True)
    return row['id']+' downloaded and verified'
def main():
    with (ROOT/'manifest.csv').open(newline='') as f:
        rows=[r for r in csv.DictReader(f) if r['path'] and r['sha256']]
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as ex:
        for msg in ex.map(download, rows): print(msg)
if __name__=='__main__': main()
