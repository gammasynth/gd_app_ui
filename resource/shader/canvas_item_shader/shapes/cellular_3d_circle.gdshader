shader_type canvas_item;

#include "res://lib/gd_app_ui/resource/shader/shader_lib/shapes/circle_color.gdshaderinc"
#include "res://lib/gd_app_ui/resource/shader/shader_lib/custom_noise/colored_cellular_3d.gdshaderinc"

uniform float noise_mix: hint_range(0.0, 1.0, 0.01) = 0.5;



void fragment() {
	// Called for every pixel the material is visible on.
	vec4 og_circle = color_circle(UV, vec2(0.5));
	vec4 color = og_circle;
	
	if (travel == vec2(0.0)) {
		extra *= travel;
	}
	
	extra += travel * TIME;
	
	vec4 noise_color = cellular_noise_color(UV);
	vec2 n = cellular3d(vec3((UV+(offset + extra))*(scale * clamp(abs(sin(TIME) - TIME) * 20.1, 0.15, 2.0) * 1.55), (sin(TIME) * time_mod) + time_offset));
	
	//noise_color.a = mix(noise_color.a, color.a, 0.5);
	
	noise_color.a -= 1.0 - og_circle.a;
	noise_color.a *= alpha_mod;
	//noise_color.a = clamp(noise_color.a, 0.0, og_circle.a + (n.x * noise_mix * 2.0));
	
	color.a = mix(color.a, noise_color.a, (noise_mix) + (-(noise_color.a) * floor(noise_mix)));
	color += (n.x * noise_mix * 2.0);
	
	
	
	color = mix(color, noise_color, noise_mix);
	
	color.a *= mix(1.0, alpha_mod, alpha_mod * 0.25);
	
	//COLOR = vec4(vec3(dist), 1.0);
	COLOR = color;
}