"""Blender preview of same Bravamar layout/GLB instances, not Godot screenshot."""
import bpy,sys,pathlib,json,math
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:]
client=pathlib.Path(args[0]).resolve();out=pathlib.Path(args[1]).resolve();mode=args[2] if len(args)>2 else 'overview'
layout=json.loads((client/'world/forest.json').read_text())
bpy.ops.wm.read_factory_settings(use_empty=True)
def xyz(v):return (v[0],-v[2],v[1])
def linear(a):return a/12.92 if a<=.04045 else ((a+.055)/1.055)**2.4
def color(hexstr):return tuple(linear(int(hexstr[i:i+2],16)/255) for i in (1,3,5))
for md in layout['meshes']:
 mesh=bpy.data.meshes.new(md['id']);mesh.from_pydata([xyz(v) for v in md['vertices']],[],md['faces']);mesh.update()
 obj=bpy.data.objects.new(md['id'],mesh);bpy.context.collection.objects.link(obj)
 mat=bpy.data.materials.new(md['id']);mat.use_nodes=True;bs=mat.node_tree.nodes.get('Principled BSDF');bs.inputs['Roughness'].default_value=.95
 co=color(md['color'])
 if md['variation']:
  attr=mesh.color_attributes.new(name='terrain_color',type='FLOAT_COLOR',domain='POINT')
  for i,v in enumerate(md['vertices']):
   factor=.94+.09*math.sin(v[0]*.69+v[2]*.37)*math.cos(v[2]*.74)
   attr.data[i].color=(*(x*factor for x in co),1)
  n=mat.node_tree.nodes.new('ShaderNodeVertexColor');n.layer_name='terrain_color';mat.node_tree.links.new(n.outputs['Color'],bs.inputs['Base Color'])
 else:bs.inputs['Base Color'].default_value=(*co,1)
 mesh.materials.append(mat)
cache={}
for p in layout['placements']:
 id=p['asset']
 if p['kind']=='creature':
  src=client/'world/forest_assets'/f'{id}.glb'
  if not src.exists():src=client/'world/assets'/f'{id}.glb'
  if not src.exists():src=client/'menu_assets'/f'{id}.glb'
  before=set(bpy.context.scene.objects);bpy.ops.import_scene.gltf(filepath=str(src));new=list(set(bpy.context.scene.objects)-before)
  for ob in new:
   if ob.type=='ARMATURE' and ob.animation_data:
    tracks=list(ob.animation_data.nla_tracks)
    for t in tracks:t.mute=True
    idle=next((t for t in tracks if 'idle' in t.name.lower()),None)
    if idle:idle.mute=False
  roots=[o for o in new if o.parent not in new]
  pivot=bpy.data.objects.new('npc_'+p.get('id',id),None);bpy.context.collection.objects.link(pivot)
  for o in roots:
   w=o.matrix_world.copy();o.parent=pivot;o.matrix_world=w
  pivot.location=(p['x'],-p['z'],p['y']);pivot.rotation_euler.z=math.radians(p['rotation']);pivot.scale=(p['scale'],)*3
  continue
 if id not in cache:
  src=client/'world/forest_assets'/f'{id}.glb'
  if not src.exists():src=client/'world/assets'/f'{id}.glb'
  if not src.exists():src=client/'menu_assets'/f'{id}.glb'
  before=set(bpy.context.scene.objects);bpy.ops.import_scene.gltf(filepath=str(src));new=list(set(bpy.context.scene.objects)-before)
  collection=bpy.data.collections.new('asset_'+id)
  for ob in new:
   if ob.type=='ARMATURE' and ob.animation_data:
    tracks=list(ob.animation_data.nla_tracks)
    for t in tracks:t.mute=True
    idle=next((t for t in tracks if 'idle' in t.name.lower()),None)
    if idle:idle.mute=False
   for c in list(ob.users_collection):c.objects.unlink(ob)
   collection.objects.link(ob)
  cache[id]=collection
 obj=bpy.data.objects.new(id,None);bpy.context.collection.objects.link(obj);obj.instance_type='COLLECTION';obj.instance_collection=cache[id];obj.location=(p['x'],-p['z'],p['y']);obj.rotation_euler.z=math.radians(p['rotation']);obj.scale=(p['scale'],)*3
 if 'scale_xyz' in p:obj.scale=(p['scale_xyz'][0],p['scale_xyz'][2],p['scale_xyz'][1])
bpy.context.scene.frame_set(1)
world=bpy.data.worlds.new('sky');bpy.context.scene.world=world;world.use_nodes=True;world.node_tree.nodes['Background'].inputs[0].default_value=(.65,.78,.9,1);world.node_tree.nodes['Background'].inputs[1].default_value=.92
bpy.ops.object.light_add(type='SUN');sun=bpy.context.object;sun.rotation_euler=(math.radians(30),math.radians(-30),math.radians(-25));sun.data.energy=2.6;sun.data.angle=.16
target=Vector((0,0,0));location=Vector((58,-88,88));scale=123
if mode=='central':target=Vector((19,-10,1));location=target+Vector((20,-32,30));scale=35
elif mode=='port':target=Vector((10,-23,1));location=target+Vector((20,-25,23));scale=31
bpy.ops.object.camera_add(location=location);cam=bpy.context.object;cam.rotation_euler=(target-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.type='ORTHO';cam.data.ortho_scale=scale;bpy.context.scene.camera=cam
sc=bpy.context.scene;sc.render.engine='CYCLES';sc.cycles.samples=12;sc.cycles.use_denoising=False;sc.render.resolution_x=1200;sc.render.resolution_y=800;sc.render.resolution_percentage=100;sc.view_settings.view_transform='AgX';sc.render.image_settings.file_format='PNG';sc.render.filepath=str(out);bpy.ops.render.render(write_still=True)
