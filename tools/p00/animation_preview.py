"""Sample actual exported NLA animations from GLB; not a retarget test."""
import bpy,sys,pathlib,math
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:]; root=pathlib.Path(args[0]).resolve(); out=pathlib.Path(args[1]).resolve();out.mkdir(parents=True,exist_ok=True)
for ident,clip,height in [('avatar','Walk',1.75),('slime','Slime_Walk',.65),('cow','Walk',1.45)]:
 bpy.ops.wm.read_factory_settings(use_empty=True);bpy.ops.import_scene.gltf(filepath=str(root/(ident+'.glb')))
 rig=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE')
 ad=rig.animation_data
 tr=next((t for t in ad.nla_tracks if t.name==clip),None)
 if tr is None:raise RuntimeError((ident,clip,[t.name for t in ad.nla_tracks]))
 for t in ad.nla_tracks:t.mute=t!=tr
 ad.action=None
 start,end=tr.strips[0].frame_start,tr.strips[0].frame_end
 cam_target=Vector((0,0,height*.48))
 world=bpy.data.worlds.new('Studio');world.use_nodes=True;bpy.context.scene.world=world;world.node_tree.nodes['Background'].inputs[0].default_value=(.72,.82,.92,1);world.node_tree.nodes['Background'].inputs[1].default_value=.9
 bpy.ops.object.light_add(type='SUN');bpy.context.object.rotation_euler=(.6,-.5,-.2);bpy.context.object.data.energy=2.3
 bpy.ops.object.camera_add(location=cam_target+Vector((3,-4,2))*height);cam=bpy.context.object;cam.rotation_euler=(cam_target-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.type='ORTHO';cam.data.ortho_scale=height*2.2;bpy.context.scene.camera=cam
 sc=bpy.context.scene;sc.render.engine='CYCLES';sc.cycles.samples=8;sc.cycles.use_denoising=False;sc.render.resolution_x=260;sc.render.resolution_y=260;sc.render.resolution_percentage=100;sc.render.film_transparent=True;sc.render.image_settings.file_format='PNG'
 for i in range(12):
  sc.frame_set(round(start+(end-start)*i/12));sc.render.filepath=str(out/(f'{ident}_{i:02d}.png'));bpy.ops.render.render(write_still=True)
 print('CLIP_OK',ident,clip,start,end)
