"""Render actual avatar derivative variants from GLB, and a walk-cycle sample."""
import bpy,sys,pathlib,math
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:];source=pathlib.Path(args[0]).resolve();out=pathlib.Path(args[1]).resolve();out.mkdir(parents=True,exist_ok=True)
def setup(body,face,skin,hair,color,outfit,clip):
 bpy.ops.wm.read_factory_settings(use_empty=True)
 bpy.ops.import_scene.gltf(filepath=str(source))
 for o in bpy.context.scene.objects:
  if o.type=='ARMATURE' and o.animation_data:
   tracks=list(o.animation_data.nla_tracks)
   for t in tracks:t.mute=t.name!=clip
  if o.name.startswith('CW_Hair_'):o.hide_render=not o.name.endswith(hair)
  if o.name=='Monk.001' and face=='angular':o.scale.x*=.93
 root=next((o for o in bpy.context.scene.objects if o.name.startswith('CW_avatar')),None)
 if root and body=='sturdy':root.scale.x*=1.12;root.scale.y*=1.12
 for m in bpy.data.materials:
  if not m.use_nodes:continue
  bs=next((n for n in m.node_tree.nodes if n.type=='BSDF_PRINCIPLED'),None)
  if not bs:continue
  if 'CW_Hair' in m.name:
   bs.inputs['Base Color'].default_value=(*color,1)
  elif 'CW_Skin' in m.name or 'CW_Outfit' in m.name:
   c=skin if 'CW_Skin' in m.name else outfit
   inputs=bs.inputs['Base Color']
   if inputs.is_linked:
    old=inputs.links[0].from_socket
    mix=m.node_tree.nodes.new('ShaderNodeMixRGB');mix.blend_type='MULTIPLY';mix.inputs[0].default_value=1;mix.inputs[2].default_value=(*c,1)
    m.node_tree.links.new(old,mix.inputs[1]);m.node_tree.links.new(mix.outputs[0],inputs)
 target=Vector((0,0,.95));bpy.ops.object.camera_add(location=(2.8,-5,2.5));cam=bpy.context.object;cam.rotation_euler=(target-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.type='ORTHO';cam.data.ortho_scale=2.45;bpy.context.scene.camera=cam
 world=bpy.data.worlds.new('studio');world.use_nodes=True;bpy.context.scene.world=world;world.node_tree.nodes['Background'].inputs[0].default_value=(.65,.78,.9,1);world.node_tree.nodes['Background'].inputs[1].default_value=.9
 bpy.ops.object.light_add(type='SUN');bpy.context.object.rotation_euler=(.6,-.5,-.2);bpy.context.object.data.energy=2.5
 sc=bpy.context.scene;sc.render.engine='CYCLES';sc.cycles.samples=16;sc.cycles.use_denoising=False;sc.render.resolution_x=420;sc.render.resolution_y=420;sc.render.resolution_percentage=100;sc.render.film_transparent=True;sc.render.image_settings.file_format='PNG'
 return sc
variants=[('standard','oval',(1,1,1),'short',(.18,.09,.035),(1,1,1)),('sturdy','angular',(.77,.57,.36),'swept',(.35,.12,.035),(.58,.8,.65)),('standard','oval',(.42,.21,.10),'short',(.02,.02,.02),(.55,.72,1))]
for i,v in enumerate(variants):
 s=setup(*v,'Idle');s.frame_set(1);s.render.filepath=str(out/f'variant{i}.png');bpy.ops.render.render(write_still=True)
for clip in ['Walk','Run']:
 s=setup(*variants[0],clip);rig=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE');track=next(t for t in rig.animation_data.nla_tracks if t.name==clip);start,end=track.strips[0].frame_start,track.strips[0].frame_end
 for i in range(12):
  s.frame_set(round(start+(end-start)*i/12));s.render.filepath=str(out/f'{clip.lower()}{i:02}.png');bpy.ops.render.render(write_still=True)
