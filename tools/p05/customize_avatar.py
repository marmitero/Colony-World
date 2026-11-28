"""Derive configurable head/hair/skin/outfit geometry from the CC0 Q01 Monk GLB."""
import bpy,sys,pathlib,json,math
from mathutils import Vector,Matrix
args=sys.argv[sys.argv.index('--')+1:];src=pathlib.Path(args[0]).resolve();out=pathlib.Path(args[1]).resolve()
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=str(src))
head=bpy.data.objects.get('Monk.001');body=bpy.data.objects.get('Monk')
assert head and body
# Distinct material IDs preserve texture while allowing independent palette overrides.
base=body.data.materials[0]
base.name='CW_Outfit'
skin=base.copy();skin.name='CW_Skin'
head.data.materials.clear();head.data.materials.append(skin)
body.data.materials.append(skin)
for poly in body.data.polygons:
 center=sum((body.data.vertices[i].co for i in poly.vertices),Vector())/len(poly.vertices)
 if abs(center.x)>1.30:poly.material_index=1
hair=bpy.data.materials.new('CW_Hair');hair.use_nodes=True
hair.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=(.055,.027,.012,1)
hair.node_tree.nodes.get('Principled BSDF').inputs['Roughness'].default_value=.87
origin=Vector((0,0,2.34))
for style in ['short','swept']:
 verts=[];faces=[];mapping={}
 # Surface-derived cap: upper head triangles, volume follows actual head topology.
 for p in head.data.polygons:
  co=[head.data.vertices[i].co for i in p.vertices]
  avg=sum(co,Vector())/len(co)
  if avg.z<2.41:continue
  face=[]
  for idx in p.vertices:
   if idx not in mapping:
    v=head.data.vertices[idx].co.copy()
    radial=v-origin
    v+=radial.normalized()*(.035 if style=='short' else .05)
    if style=='swept':
     t=max(0,min(1,(v.z-2.42)/.27))
     v.x+=.085*t;v.z+=.12*t*(1-abs(v.x)/.55)
    mapping[idx]=len(verts);verts.append(v)
   face.append(mapping[idx])
  faces.append(face)
 mesh=bpy.data.meshes.new('CW_Hair_'+style);mesh.from_pydata(verts,[],faces);mesh.update()
 ob=bpy.data.objects.new('CW_Hair_'+style,mesh);bpy.context.collection.objects.link(ob)
 ob.parent=head;ob.matrix_parent_inverse=Matrix.Identity(4);ob.matrix_basis=Matrix.Identity(4)
 mesh.materials.append(hair)
# Keep original 11 NLA tracks; remove importer bone display helper only.
for ob in list(bpy.context.scene.objects):
 if ob.name=='Icosphere' and ob.parent is None:bpy.data.objects.remove(ob,do_unlink=True)
bpy.ops.export_scene.gltf(filepath=str(out),export_format='GLB',export_animations=True,export_animation_mode='NLA_TRACKS',export_materials='EXPORT')
print('CW_CUSTOM_AVATAR',out)
