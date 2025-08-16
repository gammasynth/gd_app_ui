shader_type canvas_item;

#include "res://lib/gd_app_ui/resources/shader/lib/noise/classic_perlin4d.gdshaderinc"

uniform vec4 albedo_bright: source_color = vec4(1.0);
uniform vec4 albedo_dark: source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform bool posterize = false;
uniform float darkness : hint_range(0.0, 2.0, 0.01) = 1.0;

uniform float time_mod: hint_range(0.0, 10.0, 0.01) = 0.0;
uniform float time_offset: hint_range(0.0, 100.0, 0.01) = 1.0;

uniform vec2 travel = vec2(0.0);

varying vec2 extra;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	if (travel == vec2(0.0)) {
		extra *= travel;
	}

	extra += travel * TIME;


	float n = cnoise(
		vec4(
			(UV * (scale * mix(sin(TIME * time_mod) * 0.00001, 1.0, 0.15)))+(offset + extra)
			 * (scale * sin(TIME * time_mod * 0.0025) * time_offset) * 1.55,
			 1.0,
			TIME
			))*0.5+0.5;
   // COLOR.rgb = vec3(n);

	vec4 color = albedo_bright;

	if (posterize) {
		if (n < darkness) {
			color = albedo_dark;
		}
	}
	else {
		color = mix(color, albedo_dark, n * darkness);
	}

	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
