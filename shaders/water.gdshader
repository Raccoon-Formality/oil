shader_type spatial;
//render_mode unshaded;
//render_mode world_vertex_coords;
//render_mode blend_add;
//render_mode cull_disabled;

uniform float offset = 0.0;

uniform sampler2D water;
uniform sampler2D noise;


uniform float amp: hint_range(0.0, 1.0, 0.01) = 0.1f;

varying vec3 normal;
varying vec2 uv;
float random (vec2 uv2) {
    return fract(sin(dot(uv2.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

varying vec4 worldPos;
void vertex() {
	//some_color = NORMAL; // make the normal the color
	
	normal = NORMAL;
	
	worldPos = MODEL_MATRIX * vec4(VERTEX,1);
	
	vec4 noise_tex = texture(noise,UV);
	float t = cos((UV.y + TIME * 0.005) * TAU * 50.0) * 0.5 +noise_tex.x;
	
	float t2 =  cos((UV.x-offset + TIME * 0.005) * TAU * 50.0) * 0.5 + 0.5 +noise_tex.x;
	VERTEX.y += clamp(t * t2* amp,-1.0,1.0);
	
}

float InverseLerp(float a, float b, float v) {
	return (v-a)/(b-a);
}

void fragment() {
	
	
	vec2 topdownProject = worldPos.xz;
	float t = cos((UV.y + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	
	float t2 = cos((UV.x + TIME * 0.1) * TAU * 5.0) * 0.5 + 0.5;
	//ALPHA = clamp(1.0-UV.y, 0.0, 1.0);
	vec4 water_tex = texture(water,topdownProject-TIME*0.1);
	vec4 noise_tex = texture(noise,topdownProject*.2+TIME*0.1);
	
	vec4 final = mix(vec4(0.25,0.62,1.0,1.0), vec4(1.0), round(noise_tex.x-0.2));
	
	ALBEDO = clamp(final.rgb,0.0,1.0);
}
