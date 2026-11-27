"""Render the P00 composition from normalized GLBs, no external imagery."""
import bpy,json,sys,pathlib,math
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:]; assets=pathlib.Path(args[0]).resolve(); layout=json.load(open(args[1])); output=pathlib.Path(args[2]).resolve()
bpy.ops.wm.read_factory_settings(use_empty=True)
def mat(name,color):
 m=bpy.data.materials.new(name);m.diffuse_color=(*color,1);m.use_nodes=True
 bs=m.node_tree.nodes.get('Principled BSDF');bs.inputs['Base Color'].default_value=(*color,1);bs.inputs['Roughness'].default_value=.9
 return m
def block(name,x,y,z,sz,material):
 bpy.ops.mesh.primitive_cube_add(size=1,location=(x,y,z));o=bpy.context.object;o.name=name;o.scale=sz;o.data.materials.append(material);return o
ground=mat('meadow',(.19,.32,.13));road=mat('sand',(.47,.32,.18));soil=mat('tilled earth',(.26,.13,.065))
block('terrain',0,0,-.2,(32,24,.4),ground)
for i,(x,y,w,d) in enumerate(layout['paths']):block('path',x,y,.008+i*.001,(w,d,.016),soil if i==3 else road)
for code,x,y,z,rot in layout['placements']:
 before=set(bpy.context.scene.objects)
 bpy.ops.import_scene.gltf(filepath=str(assets/(code+'.glb')))
 objs=list(set(bpy.context.scene.objects)-before)
 for o in objs:
  if o.type=='ARMATURE' and o.animation_data:
   a=o.animation_data
   tracks=list(a.nla_tracks)
   for tr in tracks:tr.mute=True
   idle=next((t for t in tracks if 'idle' in t.name.lower()),None)
   if idle:idle.mute=False
 roots=[o for o in objs if o.parent not in objs]
 pivot=bpy.data.objects.new('instance_'+code,None);bpy.context.collection.objects.link(pivot)
 for o in roots:
  w=o.matrix_world.copy();o.parent=pivot;o.matrix_world=w
 pivot.location=(x,y,z);pivot.rotation_euler[2]=math.radians(rot)
bpy.context.scene.frame_set(1)
world=bpy.data.worlds.new('Sky');bpy.context.scene.world=world;world.use_nodes=True
world.node_tree.nodes['Background'].inputs[0].default_value=(.62,.75,.85,1);world.node_tree.nodes['Background'].inputs[1].default_value=.85
def point_at(o,target):o.rotation_euler=(Vector(target)-o.location).to_track_quat('-Z','Y').to_euler()
bpy.ops.object.light_add(type='SUN',location=(-12,-8,20));sun=bpy.context.object;sun.rotation_euler=(math.radians(27),math.radians(-28),math.radians(-25));sun.data.energy=2.8;sun.data.angle=math.radians(12)
bpy.ops.object.light_add(type='AREA',location=(7,-8,15));fill=bpy.context.object;fill.data.energy=1400;fill.data.shape='DISK';fill.data.size=12;point_at(fill,(0,0,0))
bpy.ops.object.camera_add(location=(15,-31,32));cam=bpy.context.object;point_at(cam,(0,0,0));cam.data.type='ORTHO';cam.data.ortho_scale=38;bpy.context.scene.camera=cam
if len(args)>3 and args[3]=='detail':
 cam.location=(8,-19,16);point_at(cam,(-2,-.5,1.2));cam.data.ortho_scale=19
scene=bpy.context.scene;scene.render.engine='CYCLES';scene.cycles.samples=24;scene.cycles.use_denoising=False;scene.render.resolution_x=1440;scene.render.resolution_y=1080;scene.render.resolution_percentage=100
scene.view_settings.view_transform='AgX';scene.render.image_settings.file_format='PNG';scene.render.filepath=str(output)
bpy.ops.render.render(write_still=True)
