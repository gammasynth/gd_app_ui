

vec4 draw_brush(vec2 uv, vec2 point, float brush_size, vec4 brush_color, vec4 back_color, float softness, bool invert_softness) {
	vec4 color = brush_color;
	
	float dist = distance(uv, point);
	if ((dist) * PI >= brush_size) {
		color = back_color;
	}
	
	if (softness > 0.0) {
		float b1 = 1.0 - ((dist * softness) * PI);
		float b2 =  1.0 - ((dist * 2.0 * softness) * PI);
		
		if (invert_softness) {
			b1 = ((dist * softness) * PI);
			b2 =  ((dist * 2.0 * softness) * PI);
		}
		
		color *= vec4(vec3(b1), b2);
	}
	return color;
}