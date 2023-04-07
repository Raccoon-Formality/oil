shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0],MODEL_MATRIX[1],vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz,MODEL_MATRIX[1].xyz)), 0.0),MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(1.0, 0.0, 0.0, 0.0),vec4(0.0, 1.0/length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0),vec4(0.0, 0.0, 0.0 ,1.0));
}

void fragment() {
	
	vec2 uv_centered = UV*2.0 -1.0;
	float radial_distance = length(uv_centered);
	ALBEDO = texture(noise, UV).rrr;
	ALPHA = texture(noise, UV).r;
	ALPHA *= 1.0-radial_distance;
	ALPHA = clamp(ALPHA,0.0,1.0);
}
