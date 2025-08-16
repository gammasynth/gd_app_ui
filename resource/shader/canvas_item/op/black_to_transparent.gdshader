shader_type canvas_item;

#include "res://lib/gd_app_ui/resources/shader/lib/op/color_replace.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(SCREEN_TEXTURE, UV);
	color = replace_color(UV, color);
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
