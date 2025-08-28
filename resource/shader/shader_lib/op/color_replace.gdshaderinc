uniform vec4 old_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 new_color: source_color = vec4(0.0);

uniform float area: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float strength: hint_range(0.0, 1.0, 0.01) = 1.0;

//uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;


vec4 replace_color(vec2 uv, vec4 color) {
	//vec4 color = texture(SCREEN_TEXTURE, uv);
	float dist = distance(color, old_color);
	if (dist < area) {
		float s = strength;
		color = mix(color, new_color, s);
	}
	return color;
}