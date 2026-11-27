"""Blender background: normalize selected models; export GLB and audit animations."""
import bpy, mathutils, json, pathlib, sys, math
from mathutils import Vector
args=sys.argv[sys.argv.index('--')+1:]; inputs=pathlib.Path(args[0]).resolve(); out=pathlib.Path(args[1]); out.mkdir(parents=True,exist_ok=True)
specs=json.loads(inputs.read_text()); result=[]
for m in specs:
 bpy.ops.wm.read_factory_settings(use_empty=True)
 source=pathlib.Path(m['input'])
 if m['format']=='fbx':
  bpy.ops.import_scene.fbx(filepath=str(source),use_image_search=True)
 else:
  if m['pack']=='Q12':
   import shutil
   for tex in (inputs.parent/'Q12'/'Textures').glob('*.png'):
    target=source.parent/tex.name
    if not target.exists():shutil.copyfile(tex,target)
  bpy.ops.import_scene.gltf(filepath=str(source))
 objs=list(bpy.context.scene.objects)
 meshes=[o for o in objs if o.type=='MESH']
 # Old FBX packs have missing external base-color textures and erroneous material alpha.
 if m['format']=='fbx':
  for mat in bpy.data.materials:
   mat.use_nodes=True
   bs=next((n for n in mat.node_tree.nodes if n.type=='BSDF_PRINCIPLED'),None)
   if not bs:continue
   bs.inputs['Alpha'].default_value=1
   mat.diffuse_color[3]=1
   if m['pack'] in {'Q01','Q19'}:
    stem=m['stem']+'_Texture.png'
    if 'bow' in mat.name.lower():stem='Ranger_Bow_Texture.png'
    found=list((inputs.parent/m['pack']).rglob(stem))
    if found:
     tex=mat.node_tree.nodes.new('ShaderNodeTexImage');tex.image=bpy.data.images.load(str(found[0]),check_existing=True)
     mat.node_tree.links.new(tex.outputs['Color'],bs.inputs['Base Color'])
   if m['id']=='potion':
    if 'liquid' in mat.name.lower():bs.inputs['Base Color'].default_value=(.5,.025,.04,1)
    elif 'glass' in mat.name.lower():bs.inputs['Base Color'].default_value=(.38,.09,.14,1)
 # Q11 Standard uses vertex colors intended for a shader absent from the free pack.
 # For the pilot foliage use texture color directly; keep texture alpha and original geometry.
 if m['id']=='tree':
  for mesh in meshes:
   for attr in list(mesh.data.color_attributes):mesh.data.color_attributes.remove(attr)
  for mat in bpy.data.materials:
   if not mat.use_nodes:continue
   bs=next((n for n in mat.node_tree.nodes if n.type=='BSDF_PRINCIPLED'),None)
   tex=next((n for n in mat.node_tree.nodes if n.type=='TEX_IMAGE' and n.image and ('Leaves_NormalTree_C' in n.image.name or 'Bark_NormalTree'==n.image.name)),None)
   if bs and tex:mat.node_tree.links.new(tex.outputs['Color'],bs.inputs['Base Color'])
 # Reconnect texture references in sibling pack folders when current paths are broken.
 images=[]
 for im in bpy.data.images:
  if im.source!='FILE':continue
  p=pathlib.Path(bpy.path.abspath(im.filepath))
  if not p.exists() and not im.packed_file:
   names=list((inputs.parent/m['pack']).rglob(p.name))
   if names:im.filepath=str(names[0]); im.reload()
  resolved=bool(im.packed_file or pathlib.Path(bpy.path.abspath(im.filepath)).exists())
  if resolved and max(im.size)>1024:
   ratio=1024/max(im.size);im.scale(max(1,round(im.size[0]*ratio)),max(1,round(im.size[1]*ratio)));im.pack()
  images.append({'name':im.name,'resolved':resolved,'size':list(im.size)})
 # Create one named NLA track per imported FBX action so each clip survives export.
 rigs=[o for o in objs if o.type=='ARMATURE']
 if len(rigs)==1 and bpy.data.actions:
  rig=rigs[0]; rig.animation_data_create(); ad=rig.animation_data
  imported=list(bpy.data.actions)
  for track in list(ad.nla_tracks):ad.nla_tracks.remove(track)
  idle=next((a for a in imported if a.name.lower().endswith('idle')),imported[0])
  ad.action=idle
  bpy.context.scene.frame_set(int(idle.frame_range[0]));bpy.context.view_layer.update()
 # isolate and normalize mesh bounds using parent root, preserve rig/animation transforms.
 bpy.context.view_layer.update()
 coords=[o.matrix_world @ Vector(c) for o in meshes for c in o.bound_box]
 low=Vector(tuple(min(v[i] for v in coords) for i in range(3))); hi=Vector(tuple(max(v[i] for v in coords) for i in range(3)))
 size=hi-low; scale=m['height']/size.z
 roots=[o for o in objs if o.parent is None]
 root=bpy.data.objects.new('CW_'+m['id'],None);bpy.context.collection.objects.link(root)
 for o in roots:
  w=o.matrix_world.copy();o.parent=root;o.matrix_world=w
 root.scale=(scale,)*3
 root.location=(-((low.x+hi.x)/2)*scale,-((low.y+hi.y)/2)*scale,-low.z*scale)
 bpy.context.view_layer.update()
 tri=sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in meshes)
 actions=[{'name':a.name,'frames':[round(float(x),2) for x in a.frame_range]} for a in bpy.data.actions]
 if len(rigs)==1 and bpy.data.actions:
  ad=rigs[0].animation_data; ad.action=None
  for a in imported:
   name=a.name.split('|')[-1]
   track=ad.nla_tracks.new();track.name=name
   track.strips.new(name,int(a.frame_range[0]),a)
   track.mute=True
  # Export via ACTIONS with associated NLA tracks; exporter evaluates tracks independently.
 glb=out/(m['id']+'.glb')
 bpy.ops.export_scene.gltf(filepath=str(glb),export_format='GLB',export_animations=True,export_animation_mode='NLA_TRACKS',export_materials='EXPORT')
 result.append({**{k:v for k,v in m.items() if k!='input'},'source_member':str(source.relative_to(inputs.parent/m['pack'])),'source_size_m':[round(v,4) for v in size],'scale':round(scale,6),'mesh_count':len(meshes),'triangles':tri,'rig_count':sum(o.type=='ARMATURE' for o in objs),'actions':actions,'textures':images,'output_bytes':glb.stat().st_size})
 print('CW_PASS',m['id'],tri,len(actions),glb.stat().st_size,flush=True)
(out/'conversion.json').write_text(json.dumps(result,indent=2))
