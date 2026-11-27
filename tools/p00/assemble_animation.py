from PIL import Image,ImageDraw,ImageFont
import pathlib,sys
root=pathlib.Path(sys.argv[1]);out=pathlib.Path(sys.argv[2]);frames=[]
font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',16)
for n in range(12):
 canvas=Image.new('RGB',(810,320),'#172730');d=ImageDraw.Draw(canvas)
 for i,(id,label) in enumerate([('avatar','AVATAR · WALK'),('slime','GOSMA · WALK'),('cow','VACA · WALK')]):
  x=i*270+5;d.rounded_rectangle((x,8,x+260,309),radius=10,fill='#e7e3d7')
  p=Image.open(root/(f'{id}_{n:02d}.png')).convert('RGBA');canvas.paste(p,(x,16),p)
  d.text((x+12,282),label,font=font,fill='#21353d')
 frames.append(canvas)
frames[0].save(out,save_all=True,append_images=frames[1:],duration=90,loop=0,optimize=True)
