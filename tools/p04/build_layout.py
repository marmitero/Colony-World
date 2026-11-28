"""Original Bravamar layout. Godot X,Z in meters; deterministic art data."""
import json,math,random,sys
from pathlib import Path
rng=random.Random(72); meshes=[];placements=[];points=[]
def addmesh(id,verts,faces,c,color_variation=False):
 meshes.append(dict(id=id,vertices=verts,faces=faces,color=c,variation=color_variation))
def shore(x):return 26.5+1.8*math.sin(x*.12)+.9*math.sin(x*.26+1.2)
# irregular shore, flat navigable core; vertex color variation handled by renderer.
xs=list(range(-48,49,2));rows=37
v=[]
for x in xs:
 for j in range(rows):
  z=-36+(shore(x)+36)*j/(rows-1)
  v.append([x,0,z])
f=[]
for i in range(len(xs)-1):
 for j in range(rows-1):
  a=i*rows+j;b=(i+1)*rows+j;f.extend([[a,a+1,b],[b,a+1,b+1]])
addmesh("terrain",v,f,"#79975c",True)
v=[]
for x in xs:v.extend([[x,.012,shore(x)-2.6],[x,.013,shore(x)]])
f=[]
for i in range(len(xs)-1):a=i*2;f.extend([[a,a+1,a+2],[a+2,a+1,a+3]])
addmesh("shore",v,f,"#bfa679",True)
def catmull(points):
 p=[points[0]]+points+[points[-1]]
 out=[]
 for i in range(1,len(p)-2):
  a,b,c,d=p[i-1:i+3]
  for k in range(8):
   t=k/8
   out.append([.5*((2*b[j])+(-a[j]+c[j])*t+(2*a[j]-5*b[j]+4*c[j]-d[j])*t*t+(-a[j]+3*b[j]-3*c[j]+d[j])*t*t*t) for j in range(2)])
 return out+[points[-1]]
def ribbon(name,pts,width,color):
 curve=catmull(pts);v=[]
 for i,(x,z) in enumerate(curve):
  a=curve[max(0,i-1)];b=curve[min(len(curve)-1,i+1)];dx=b[0]-a[0];dz=b[1]-a[1];l=math.hypot(dx,dz) or 1
  w=width*.5*(1+.045*math.sin(i*1.7))
  h=.026+.001*sum(m["id"].endswith(("road","loop","lane")) for m in meshes)
  v.extend([[x-dz/l*w,h,z+dx/l*w],[x+dz/l*w,h,z-dx/l*w]])
 f=[]
 for i in range(len(curve)-1):a=2*i;f.extend([[a,a+2,a+1],[a+1,a+2,a+3]])
 addmesh(name,v,f,color,True)
ribbon("west_road",[[-48,-3],[-35,-3],[-25,2],[-16,5],[-10,9],[0,12]],4.1,"#c5aa7e")
ribbon("east_road",[[0,12],[13,9],[23,3],[35,-1],[48,-3]],4.1,"#c5aa7e")
ribbon("north_loop",[[-25,2],[-19,-9],[-12,-14],[0,-15],[13,-14],[20,-8],[23,3]],3.7,"#c0a37a")
ribbon("port_road",[[0,12],[-2,17],[1,23],[5,27]],4.2,"#c5aa7e")
ribbon("market_lane",[[-26,2],[-27,12],[-21,19]],3.25,"#bf9f76")
ribbon("work_lane",[[23,3],[28,10],[31,19]],3.25,"#bf9f76")
ribbon("guild_lane",[[0,-15],[0,-23],[3,-34]],3.4,"#c5aa7e")
ribbon("farm_lane",[[-19,-9],[-30,-15],[-39,-21]],2.6,"#bca074")
ribbon("plaza_west_lane",[[-10,-1],[-14,1],[-19,4]],2.4,"#bfa37c")
ribbon("plaza_east_lane",[[10,-1],[15,-3],[20,-5]],2.4,"#bfa37c")
ribbon("plaza_north_lane",[[4,-10],[5,-12],[6,-15]],2.1,"#bfa37c")
ribbon("plaza_south_lane",[[0,9],[0,11],[0,13]],2.5,"#bfa37c")
def disk(name,r,color,y,center=(0,-1),n=64):
 v=[[center[0],y,center[1]]]+[[center[0]+math.cos(i*2*math.pi/n)*r,y,center[1]+math.sin(i*2*math.pi/n)*r] for i in range(n)]
 f=[[0,(i+1)%n+1,i+1] for i in range(n)]
 addmesh(name,v,f,color,True)
disk("plaza",10.9,"#a8a698",.045)
disk("arena",5.8,"#b48d65",.065)
for band in range(4):
 r1=6.9+band*.94;r2=r1+.87;n=48+band*7
 for group in range(3):
  v=[];f=[]
  for i in range(group,n,3):
   a=(i+.5*(band%2))*2*math.pi/n+.008;b=(i+1+.5*(band%2))*2*math.pi/n-.008
   j=len(v)
   for r,t in [(r1,a),(r2,a),(r2,b),(r1,b)]:v.append([r*math.cos(t),.053,-1+r*math.sin(t)])
   f.extend([[j,j+2,j+1],[j,j+3,j+2]])
  addmesh("plaza_stones_%d_%d"%(band,group),v,f,["#b8b6a8","#a6a79b","#c0b9a6"][group],True)
# quays, plank texture through bands, actual boat models
def rect(name,x,z,w,d,y,c):
 addmesh(name,[[x-w/2,y,z-d/2],[x+w/2,y,z-d/2],[x+w/2,y,z+d/2],[x-w/2,y,z+d/2]],[[0,2,1],[0,3,2]],c)
rect("pier_base",7,29.5,10,9,.13,"#73543a")
for i in range(20):rect("pier_plank_%d"%i,7,25.15+i*.43,9.7,.4,.15,"#95714d" if i%3==0 else "#84623e")
rect("pier_side",15,28,6,4,.13,"#73543a")
for i in range(9):rect("side_plank_%d"%i,15,26.18+i*.43,5.8,.4,.15,"#95714d" if i%3==0 else "#84623e")
def dock_post(id,x,z,height=.8):
 v=[];n=8
 for y in [-.65,height]:
  for i in range(n):
   a=i*2*math.pi/n;v.append([x+.19*math.cos(a),y,z+.19*math.sin(a)])
 f=[]
 for i in range(n):
  j=(i+1)%n;f.extend([[i,j,n+i],[j,n+j,n+i]])
 for i in range(1,n-1):f.append([n,n+i,n+i+1])
 addmesh(id,v,f,"#654b34")
for i,(x,z) in enumerate([(2.3,25.5),(11.7,25.5),(2.3,29.5),(11.7,29.5),(2.3,33.6),(11.7,33.6),(18,26.2),(18,29.8)]):dock_post("dock_post_%d"%i,x,z)
def put(asset,x,z,rot=0,scale=1,kind="prop",y=0,**kw):
 placements.append(dict(asset=asset,x=x,z=z,y=y,rotation=rot,scale=scale,kind=kind,**kw))
# civic district, services with distinct buildings deliberately fronting roads
buildings=[
("house4",0,-23,180,"guild","Casa das Guildas"),("tower",-11,-22,180,"tower","Torre do Sino"),
("gazebo",0,-13,0,"elder","Pavilhão da Anciã"),("inn",-19,-16,-30,"inn","Pousada do Vento"),
("house3",-28,-9,-20,"deco","Ateliê de Lume"),("house2",-18,1,90,"potions","Botica de Nilo"),
("house",-16,15,180,"armor","Armaduras de Elara"),("house3",-28,16,180,"bank","Armazém"),
("smith",23,-13,15,"weapons","Forja de Tovan"),("sawmill",33,-17,-25,"wood","Serraria"),
("stable",30,10,-90,"stable","Estábulo"),("mill",-36,-20,22,"mill","Moinho"),
("house2",14,-19,180,"residence","Registro de Terras"),("house3",34,0,-90,"travel","Casa de Viagens"),
("house2",9,19,180,"port","Capitania"),("house",20,19,180,"portshop","Casa do Cais"),
("house3",-9,-29,180,"home1","Moradia"),("house2",11,-30,0,"home2","Moradia"),
("house", -34,5,90,"home3","Moradia"),("house2",39,-9,-90,"home4","Moradia")]
for id,x,z,rot,key,name in buildings:
 put(id,x,z,rot,1,"building",service=key,label=name)
 if id in ("house3","house4"):
  large=id=="house4"
  width,depth,height=(9.56,10.49,5.3) if large else (5.01,5.49,5.4)
  rw,rd,rh=(4.55,5.42,3.1) if large else (3.26,4.47,2.5)
  h=2.8 if large else 1.95
  put("roof_large" if large else "roof_small",x,z,rot,1,"roof",y=height-.12,scale_xyz=[(width+.34)/rw,h/rh,(depth+.4)/rd])
  # Structural gable panels close the ends below the library roof; same palette as timber trim.
  r=math.radians(rot)
  def transform(lx,ly,lz):return [x+lx*math.cos(r)+lz*math.sin(r),ly,z-lx*math.sin(r)+lz*math.cos(r)]
  for sign in (-1,1):
   lz=sign*depth*.48
   verts=[transform(-width*.48,height-.13,lz),transform(width*.48,height-.13,lz),transform(0,height+h*.88,lz)]
   addmesh("gable_"+key+("_front" if sign==1 else "_back"),verts,[[0,1,2]],"#7e6d54")
# market square off west road and civic decorations
for id,x,z,r in [("market",-23,7,0),("market2",-25,9,90),("market",-20,10,180),("market2",-23,13,0),("market",18,8,-60),("well",-11,6,0),("well",12,-11,0),("cart",-27,6,45),("cart",24,15,20),("cart",7,23,90),("cauldron",-17,4,0),("bonfire",-21,-11,0),("bonfire",19,-8,0),("bench",-7,9,10),("bench",7,9,-10),("bench",-4,-10,0),("bench",4,-10,0)]:
 put(id,x,z,r)
for x,z in [(-26,8),(-21,8),(-28,13),(-15,13),(20,-10),(26,-10),(30,-13),(32,12),(9,23),(12,25),(17,25),(-6,21),(-35,7)]:
 put("crate",x,z,rng.uniform(0,360));put("barrel",x+.9,z+.15,rng.uniform(0,360))
for x,z in [(30,8),(32,8),(30,14),(-35,-17),(-37,-16)]:put("hay",x,z,rng.uniform(0,360),1.1)
# ring paving + banners clearly delimiting PvP arena, entrances at N/S/E/W
for i in range(40):
 a=i*2*math.pi/40;x=6.48*math.cos(a);z=-1+6.48*math.sin(a)
 put("paver",x,z,math.degrees(a),1.05,"arena_marker",y=.069)
for a in [45,135,225,315]:
 rad=math.radians(a);put("banner",7.35*math.cos(rad),-1+7.35*math.sin(rad),a+90,.9,"arena_marker",y=.07)
# gardening west farm, vegetables and wheat cluster
rect("farm_plot",-37,-26,7,5,.027,"#91673f")
for ix in range(5):
 for iz in range(3):put("pumpkin",-39.6+ix*1.3,-27.4+iz*1.4,rng.uniform(0,360),.8)
for ix in range(10):
 for iz in range(5):put("wheat",-31+ix*.26,-28+iz*.33,rng.uniform(0,360),.95)
for x in range(-41,-33,2):put("fence",x,-29,0)
for z in range(-29,-23,2):put("fence",-41,z,90)
# coast boats, pier crates, edge rocks/vegetation
for x,z,r,s in [(-.5,33.5,-18,1),(15,33,35,1.2),(25,30,90,.85)]:put("boat",x,z,r,s,"boat",y=-.12)
for x,z in [(-40,20),(-31,23),(-20,23),(-12,25),(-6,25),(24,24),(33,20),(41,20),(-46,-22),(45,-23)]:put("rock",x,z,rng.uniform(0,360),rng.uniform(.8,1.5))
for x,z in [(-44,-29),(-39,-32),(-29,-32),(-20,-30),(-15,-33),(-6,-34),(3,-35),(16,-34),(24,-32),(33,-30),(40,-32),(45,-26),(-45,-15),(-45,-10),(-45,8),(-43,15),(-39,22),(-30,23),(-23,23),(-13,22),(26,23),(35,21),(43,14),(45,7),(43,-20),(-24,-23),(23,-23),(-10,-16),(10,-16)]:
 put("tree",x,z,rng.uniform(0,360),rng.uniform(.78,1.15))
for x,z in [(-42,-26),(-35,-32),(-25,-31),(-18,-24),(-12,-27),(7,-32),(21,-28),(38,-25),(44,-12),(-43,12),(-37,19),(-27,21),(-10,23),(24,23),(37,18),(44,11),(-30,-18),(29,-23)]:
 for j in range(4):put("grass",x+rng.uniform(-1.3,1.3),z+rng.uniform(-1.3,1.3),rng.uniform(0,360),rng.uniform(.8,1.35))
# Organic ornamental clusters in grass margins, set back from paths/arena.
for x,z in [(-41,10),(-37,11),(-33,12),(-29,19),(-22,19),(-14,20),(-7,21),(1,20),(14,22),(23,21),(36,18),(40,11),(43,-13),(36,-24),(26,-25),(18,-29),(6,-31),(-5,-30),(-15,-26),(-22,-21),(-31,-25),(-41,-17),(-14,-7),(-11,-7),(11,-6),(14,-8),(-8,11),(8,11)]:
 for j in range(2):
  put("bush",x+rng.uniform(-.65,.65),z+rng.uniform(-.65,.65),rng.uniform(0,360),rng.uniform(.65,1.05))
 for j in range(3):
  put("flowers",x+rng.uniform(-1.1,1.1),z+rng.uniform(-1.1,1.1),rng.uniform(0,360),rng.uniform(.75,1.2))
# service NPC anchors: no interactions in P0.4
npcs=[
("maia","Anciã Maia","Missões principais","npc_cleric",0,-10.6,0),
("tovan","Tovan","Armas e reparos","npc_warrior",22,-9.3,0),
("elara","Elara","Armaduras","npc_ranger",-16,11.8,0),
("nilo","Nilo","Poções","npc_wizard",-15.5,2.2,0),
("lume","Lume","Decorações","npc_rogue",-27,-5.6,0),
("iara","Iara","Guildas","npc_cleric",3,-17.7,0),
("oren","Oren","Mercado e contratos","npc_rogue",-22,5.1,0),
("sela","Sela","Residência","npc_cleric",13,-15.4,0),
("kael","Kael","Treinamento e arena","npc_warrior",8.5,-7.6,0),
("nara","Nara","Sementes","npc_ranger",-35,-22.8,0),
("dara","Dara","Coleta","avatar",30,-13.6,0),
("varo","Varo","Viagens","npc_wizard",32,3.2,0)]
for id,name,role,asset,x,z,r in npcs:put(asset,x,z,r,1,"npc",id=id,label=name,role=role)
exits=[dict(id="bosque",label="Bosque do Orvalho",level="Nv. 1–5",x=-46,z=-3),dict(id="ferrugem",label="Desfiladeiro Ferrugem",level="Nv. 10+",x=46,z=-3)]
data=dict(id="bravamar",size=[96,78],spawn=[0,0,13.8],arena=dict(center=[0,-1],radius=5.8,mode="pvp_future"),outside="safe",meshes=meshes,placements=placements,exits=exits)
Path(sys.argv[1]).write_text(json.dumps(data,separators=(",",":"),ensure_ascii=False))
print(len(placements),"placements",len(meshes),"meshes",len(npcs),"NPCs")
