"""Render model thumbnails from normalized GLBs (Blender)."""
import bpy,sys,pathlib,math,json
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:]; assets=pathlib.Path(args[0]).resolve(); out=pathlib.Path(args[1]).resolve();out.mkdir(parents=True,exist_ok=True)
specs=json.loads((assets/'conversion.json').read_text())
for m in specs:
 bpy.ops.wm.read_factory_settings(use_empty=True)
 bpy.ops.import_scene.gltf(filepath=str(assets/(m['id']+'.glb')))
 for o in bpy.context.scene.objects:
  if o.type=='ARMATURE' and o.animation_data:
   tracks=list(o.animation_data.nla_tracks)
   for t in tracks:t.mute=True
   idle=next((t for t in tracks if 'idle' in t.name.lower()),None)
   if idle:idle.mute=False
 bpy.context.scene.frame_set(1);bpy.context.view_layer.update()
 meshes=[o for o in bpy.context.scene.objects if o.type=='MESH'];coords=[o.matrix_world@Vector(c) for o in meshes for c in o.bound_box]
 low=Vector(tuple(min(v[i] for v in coords) for i in range(3)));hi=Vector(tuple(max(v[i] for v in coords) for i in range(3)));center=(hi+low)*.5;extent=max(hi-low)
 world=bpy.data.worlds.new('sky');world.use_nodes=True;bpy.context.scene.world=world
 world.node_tree.nodes['Background'].inputs[0].default_value=(.68,.78,.9,1);world.node_tree.nodes['Background'].inputs[1].default_value=.9
 def look(o,p):o.rotation_euler=(p-o.location).to_track_quat('-Z','Y').to_euler()
 bpy.ops.object.light_add(type='SUN',location=(2,-3,5));o=bpy.context.object;o.rotation_euler=(.6,-.5,-.5);o.data.energy=2.6;o.data.angle=.15
 bpy.ops.object.camera_add(location=center+Vector((1.6,-3,1.8))*extent);cam=bpy.context.object;look(cam,center);cam.data.type='ORTHO';cam.data.ortho_scale=extent*1.5;bpy.context.scene.camera=cam
 scene=bpy.context.scene;scene.render.engine='CYCLES';scene.cycles.samples=12;scene.cycles.use_denoising=False;scene.render.resolution_x=300;scene.render.resolution_y=300;scene.render.resolution_percentage=100;scene.render.film_transparent=True;scene.render.image_settings.file_format='PNG';scene.render.filepath=str(out/(m['id']+'.png'));bpy.ops.render.render(write_still=True)
