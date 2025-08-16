uniform vec4 circle_color: source_color = vec4(1.0);
uniform vec4 back_color: source_color = vec4(0.0);

uniform float size: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float circle_size_time_mod: hint_range(0.0, 2.0, 0.1) = 0.0;

uniform float blur: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform bool invert_blur = false;

vec4 color_circle(vec2 uv, vec2 center) {
	vec4 color = circle_color;
	
	float dist = distance(uv, center);
	
	float t = 0.0;
	if (circle_size_time_mod > 0.0) {
		t = (sin(TIME) * circle_size_time_mod) * 1.1;
	}
	
	if ((dist * 0.65) * PI >= (size + t) ) {
		color = back_color;
	}
	
	if (blur > 0.0) {
		float b1 = 1.0 - ((dist * blur) * PI);
		float b2 =  1.0 - ((dist * 2.0 * blur) * PI);
		
		if (invert_blur) {
			b1 = ((dist * blur) * PI);
			b2 =  ((dist * 2.0 * blur) * PI);
		}
		
		color *= vec4(vec3(b1), b2);
	}
	
	return color;
}