from PIL import Image,ImageDraw,ImageFont
import pathlib,sys,json
thumb=pathlib.Path(sys.argv[1]); spec=json.load(open(sys.argv[2])); out=pathlib.Path(sys.argv[3]); w,h=1600,104+((len(spec)+4)//5)*326+20
im=Image.new('RGB',(w,h),'#15252d');d=ImageDraw.Draw(im)
font='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';bold='/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
title=ImageFont.truetype(bold,34);label=ImageFont.truetype(bold,19);sub=ImageFont.truetype(font,14)
d.text((32,22),'COLONY WORLD  /  P00 — CATÁLOGO PILOTO',font=title,fill='#e4ead7')
d.text((35,64),'21 derivados GLB · modelos reais do acervo OpenGameArt · prévia técnica, escala comparativa por cartão',font=sub,fill='#9fb8b9')
for i,m in enumerate(spec):
 x=28+(i%5)*310;y=104+(i//5)*326
 d.rounded_rectangle((x,y,x+294,y+307),radius=11,fill='#e9e6d9')
 p=Image.open(thumb/(m['id']+'.png')).convert('RGBA');p.thumbnail((258,242));im.paste(p,(x+(294-p.width)//2,y+12),p)
 d.text((x+12,y+254),m['id'].upper()+(' · REJEITADO' if m['id'] in {'deer','chicken'} else ''),font=label,fill='#9c3934' if m['id'] in {'deer','chicken'} else '#21353d')
 d.text((x+12,y+280),f"{m['pack']} · {m['triangles']:,} tris · {len(m['actions'])} clipes",font=sub,fill='#536264')
im.save(out,quality=92)
