shader_type spatial;
render_mode cull_disabled;
uniform vec4 deep_color : source_color = vec4(0.075,0.22,0.29,1.0);
uniform vec4 glow_color : source_color = vec4(0.28,0.47,0.47,1.0);
varying vec3 local_vertex;
void vertex() {
    VERTEX.y += sin(VERTEX.x*0.65+TIME*0.85)*0.045+sin(VERTEX.z*0.7-TIME*1.1)*0.04;
    local_vertex=VERTEX;
}
void fragment() {
    float wave=sin(local_vertex.x*1.3+local_vertex.z*.65+TIME*.65)*0.5+0.5;
    ALBEDO=mix(deep_color.rgb,glow_color.rgb,pow(wave,9.0)*.35);
    ROUGHNESS=.36;
    METALLIC=.12;
}
