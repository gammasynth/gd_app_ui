
#include "res://lib/gd_app_ui/resource/shader/lib/noise/cellular3d.gdshaderinc"

uniform vec4 noise_albedo: source_color = vec4(1.0);

uniform float time_mod: hint_range(0.0, 10.0, 0.01) = 0.0;
uniform float time_offset: hint_range(0.0, 100.0, 0.01) = 1.0;

uniform vec2 travel = vec2(0.0);

varying vec2 extra;

uniform float alpha_mod: hint_range(0.0, 10.0, 0.01) = 1.0;

//void fragment() {
	//if (travel == vec2(0.0)) {
		//extra *= travel;
	//}
	//
	//extra += travel * TIME;
	//
//}

vec4 ominous_noise_color(vec2 uv) {

	vec2 n = cellular3d(vec3((uv+(offset + extra))*(scale * clamp(abs(sin(TIME) - TIME) * 20.1, 0.15, 2.0) * 1.55), (sin(TIME) * time_mod) + time_offset));
	vec4 noise_color = vec4(n.x) * noise_albedo;
	return noise_color;
}