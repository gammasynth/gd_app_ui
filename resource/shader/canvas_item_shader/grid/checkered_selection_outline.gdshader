shader_type canvas_item;

uniform sampler2D base_texture: hint_default_transparent;
uniform float line_mod = 1.0;
uniform float line_speed = 1.0;

uniform float checker_speed = 3.5;

uniform float color_offset = 0.5;
uniform float color_mod = 0.5;
uniform vec4 line_color: source_color = vec4(0.75);
uniform vec4 fill_color: source_color = vec4(0.0);

uniform bool checkered = true;
uniform bool only_fill = false;
uniform float fill_mod = 1.0;
uniform float alpha_mod = 1.0;
uniform float outline_alpha_mod = 1.0;


void fragment() {
    vec4 trans = fill_color; // Transparent color
    vec4 grid_color = line_color; // Border color
    vec4 color = trans; // Default to transparent
	
	
	
    // Define the border thickness using your measurements
    vec2 texture_size = vec2(textureSize(base_texture, 0)); // Texture dimensions in pixels
    vec2 size = 1.0 / texture_size; // One pixel's size in UV units (1/texture_width, 1/texture_height)
	//vec2 size = TEXTURE_PIXEL_SIZE;// * 0.0125 * 2.0 * 516.0;
    //size.x *= 1.025;
    //size.y *= 1.135;
	//size.x *= 3.0;

    // Normalize UV coordinates
    vec2 uv = UV;

    // Define the rectangle's boundaries (full texture size)
    float rect_width = 1.0; // Full width of the texture
    float rect_height = 1.0; // Full height of the texture
	
	vec2 line_size = size * line_mod;

    // Check if the pixel is within the border region
    if (uv.x < size.x || uv.x > rect_width - size.x ||
        uv.y < size.y || uv.y > rect_height - size.y) {
        float grey = 1.0;
		if (checkered) {
			grey = smoothstep(sin(((TIME * line_speed) / line_speed)) * fract(pow(uv.x , uv.y)) * fract(pow(uv.y , uv.x)) * fract(UV.x) * fract(UV.y),1.0,fract(color_offset + color_offset * color_mod * clamp(sin(((TIME * line_speed) * 10.0) + fract(uv.x) * pow(line_size.x, line_size.y) + fract(uv.y) * pow(line_size.x, line_size.y)), 0.0125, 0.75))); // Varies between 0.0 and 1.0
			if (mod(sin(TIME * line_speed) * uv.x, size.x) > size.x || mod(sin(TIME * line_speed) * uv.y, size.y) > size.y) {
				grey = 0.0;
			}
			// Calculate pixel coordinates in texture space
            vec2 pixel_coord = uv * texture_size;
            // Alternate grey based on pixel position
            float checker = mod(floor(pixel_coord.x + floor(TIME * checker_speed * 2.0)) + floor(pixel_coord.y + floor(TIME * checker_speed)), 2.0);
            grey = mix(0.5, 0.75, checker * grey); // Alternate between two grey shades (0.5 and 0.75)
		}
		else {
			grey = color_mod * (color_offset + color_offset + clamp(sin(((TIME * line_speed) * 10.0) + fract(uv.x) * pow(line_size.x, line_size.y) + fract(uv.y) * pow(line_size.x, line_size.y)), 0.0125, 0.75)); // Varies between 0.0 and 1.0
		}
        grey = fract(grey) * fract(grey);
		color = vec4(grey, grey, grey, 1.0); // Grey shade with full opacity
    }
	vec4 sample = texture(TEXTURE,(UV));
	if (sample.a < 1.0) {
		sample *= 0.5;
	}
	color.a *= outline_alpha_mod;
	vec4 final_color = color;
	//sample.a -= 0.1;
	if (only_fill) {
		vec4 f2 = mix(sample, color, round(min(sample.a, color.a)));
		final_color = mix(sample, color, min(sample.a, color.a) * fill_mod);//mix(trans, smoothstep(trans, color, f2), f2.a);
	}
	else {
   	 final_color = color; // Output the final color
	}
	final_color.a *= alpha_mod;
	COLOR = final_color;
}