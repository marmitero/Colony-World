"""Deterministic authored woodland layout, no gameplay rewards."""
import json,random,pathlib,math
root=pathlib.Path(__file__).resolve().parents[2]
rng=random.Random(707)
placements=[];boxes=[];meshes=[]
def surface(id,x0,z0,x1,z1,y,color,variation=True):
 meshes.append(dict(id=id,color=color,variation=variation,vertices=[[x0,y,z0],[x1,y,z0],[x1,y,z1],[x0,y,z1]],faces=[[0,1,2],[0,2,3]]))
def place(asset,x,z,scale=1,kind="prop",label="",level=0,solid=None,y=0):
 i=f"{kind}_{len(placements):03d}"
 p=dict(id=i,asset=asset,x=round(x,2),z=round(z,2),y=y,rotation=rng.randrange(360),scale=round(scale,2),kind=kind,label=label,level=level)
 placements.append(p)
 if solid:boxes.append(dict(id=i,x=p["x"],z=p["z"],hx=solid[0]*scale,hz=solid[0]*scale,height=solid[1]*scale,rot=0))
# Softly varying ground mesh, winding trails and an irregular pond.
vertices=[[x,0,z] for z in range(-48,49,4) for x in range(-52,53,4)]
cols=27; faces=[]
for iz in range(24):
 for ix in range(26):
  i=iz*cols+ix;faces.extend([[i,i+1,i+cols+1],[i,i+cols+1,i+cols]])
meshes.append(dict(id="forest_floor",color="#617c45",variation=True,vertices=vertices,faces=faces))
routes=[([(49,0),(39,0),(26,1),(15,-1),(5,1),(0,0),(-10,-3),(-20,-1),(-31,1),(-40,-3)],2.4,.012),
 ([(0,0),(2,-8),(-2,-15),(1,-24),(0,-32)],2.2,.014),
 ([(0,0),(-2,7),(2,15),(-1,24),(1,36)],1.9,.016)]
def path_distance(x,z):
 d=1000
 for pts,w,y in routes:
  for a,b in zip(pts,pts[1:]):
   dx=b[0]-a[0];dz=b[1]-a[1];u=max(0,min(1,((x-a[0])*dx+(z-a[1])*dz)/(dx*dx+dz*dz)))
   d=min(d,math.hypot(x-a[0]-u*dx,z-a[1]-u*dz)-w)
 return d
for i,(pts,w,y) in enumerate(routes):
 v=[];f=[]
 for j,(x,z) in enumerate(pts):
  a=pts[max(0,j-1)];b=pts[min(len(pts)-1,j+1)];dx=b[0]-a[0];dz=b[1]-a[1];l=math.hypot(dx,dz)
  width=w*(.95+.15*math.sin(j*1.8+i))
  v.extend([[x-dz/l*width,y,z+dx/l*width],[x+dz/l*width,y,z-dx/l*width]])
  if j:f.extend([[2*j-2,2*j-1,2*j],[2*j-1,2*j+1,2*j]])
 meshes.append(dict(id=f"trail_{i}",color="#b4a17a",variation=True,vertices=v,faces=f))
def patch(id,cx,cz,rx,rz,y,color):
 verts=[[cx,y,cz]]
 for j in range(24):
  a=math.tau*j/24;r=1+.09*math.sin(3*a)+.055*math.cos(5*a)
  verts.append([cx+rx*r*math.cos(a),y,cz+rz*r*math.sin(a)])
 meshes.append(dict(id=id,color=color,variation=True,vertices=verts,faces=[[0,j+1,1+(j+1)%24] for j in range(24)]))
patch("mill_clearing",0,-33,10,6,.01,"#9a9864")
patch("pond_bank",-22.5,22,8.8,7.2,.010,"#8c9369")
patch("pond",-22.5,22,7.5,5.8,.018,"#527e83")
for x,z,hx,hz in [(-22.5,22,6.2,3.5),(-22.5,18.6,3.8,1.5),(-22.5,25.4,3.8,1.5)]:
 boxes.append(dict(id=f"pond_{len(boxes)}",x=x,z=z,hx=hx,hz=hz,height=.35,rot=0))
place("mill",0,-34,.85,"landmark","Moinho do Orvalho",solid=(2.8,5))
place("arch",43,0,1,"landmark","Bravamar")
place("bench",7,5,1);place("bonfire",9,5,1)
# Four distinct encounter clusters with clear travel corridor.
for asset,name,lv,points in [
 ("slime","Gosma",1,[(26,9),(21,13),(15,9),(24,-11),(17,-13),(11,-9)]),
 ("deer","Cervo",1,[(31,-17),(35,-22),(26,-24),(18,-25)]),
 ("pig","Porco selvagem",3,[(-13,10),(-9,18),(-15,27),(-9,32)]),
 ("bee","Abelha do bosque",4,[(-28,-12),(-34,-17),(-21,-20),(-28,-26),(-35,-27)])]:
 for x,z in points:place(asset,x,z,1,"creature",name,lv,y=.5 if asset=="bee" else 0)
# Deliberate resource clusters, each a future node with stable id.
for x,z in [(34,8),(30,13),(22,20),(17,24),(10,29),(-12,-9),(-17,-13),(-12,-24),(-35,8),(-39,17),(-36,31),(-7,35)]:
 place("pine",x,z,rng.uniform(.75,1.1),"resource","Pinho",solid=(.47,5))
for x,z in [(-33,-7),(-39,-10),(-41,-17),(-37,-23),(-25,-32),(-17,-33),(-15,-28),(-30,31)]:
 place("rock",x,z,rng.uniform(.65,.9),"resource","Veio de cobre",solid=(.7,1.4))
for x,z in [(34,-7),(29,-10),(23,-17),(15,-18),(10,-21),(7,-25),(-7,9),(-12,15),(-8,23),(-32,3),(-27,10),(-18,12)]:
 place("fern",x,z,1,"resource","Erva do orvalho")
for x,z in [(-9,-7),(-17,-7),(-24,-9),(-33,6),(-9,28),(-15,34)]:
 place("mushroom",x,z,1,"resource","Cogumelo silvestre")
for _ in range(420):
 x=rng.uniform(-46,46);z=rng.uniform(-43,43)
 if path_distance(x,z)<1.5 or (abs(x)<13 and z<-26) or (-33<x<-12 and 14<z<30) or x>38 and abs(z)<8:continue
 if any(math.hypot(x-p["x"],z-p["z"])<(2.8 if p["kind"]!="decor" else 1.5) for p in placements):continue
 asset=rng.choice(["tree","pine","bush","grass","flowers","fern"])
 solid=(.5,5) if asset in ("tree","pine") else None
 place(asset,x,z,rng.uniform(.65,1.15),"decor",solid=solid)
# Edge vegetation framing map, preserving the exit.
for x in range(-46,47,5):
 for z in [-43,43]:place("pine",x,z,rng.uniform(.8,1.1),"decor",solid=(.5,5))
for z in range(-37,38,5):
 for x in [-46,46]:
  if x==46 and abs(z)<8:continue
  place("tree",x,z,.9,"decor",solid=(.5,4))
layout=dict(meshes=meshes,placements=placements,exits=[dict(id="bravamar",label="Bravamar",level="Nv. 1+",x=43,z=0)])
geometry=dict(version=1,spawn=[39,0],bounds=[-47.5,47.5,-44.5],max_z=44.5,radius=.32,arena=dict(center=[0,0],radius=-1),piers=[],boxes=boxes)
for path,data in [("client/world/forest.json",layout),("client/world/forest_collision.json",geometry),("server/internal/world/forest_collision.json",geometry)]:
 (root/path).write_text(json.dumps(data,ensure_ascii=False,separators=(",",":"))+"\n")
print(len(placements),len(boxes))
