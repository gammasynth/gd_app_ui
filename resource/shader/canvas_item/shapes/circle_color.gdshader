shader_type canvas_item;

#include "res://lib/gd_app_ui/resource/shader/lib/shapes/circle_color.gdshaderinc"

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = color_circle(UV, vec2(0.5));
	//COLOR = vec4(vec3(dist), 1.0);
	COLOR = color;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
