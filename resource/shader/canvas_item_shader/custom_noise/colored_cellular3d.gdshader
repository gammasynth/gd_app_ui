shader_type canvas_item;

#include "res://lib/gd_app_ui/resource/shader/shader_lib/custom_noise/colored_cellular_3d.gdshaderinc"

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = cellular_noise_color(UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
