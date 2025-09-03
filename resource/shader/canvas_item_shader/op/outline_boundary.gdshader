shader_type canvas_item;

uniform bool use_fill = false;
uniform vec4 fill_color : source_color = vec4(0);
uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 20) = 0.0;
uniform bool add_margins = true;

uniform bool pulse_outline = false;
uniform float pulse_speed = 1.0;

void vertex() {
    if (add_margins) {
        VERTEX += (UV * 2.0 - 1.0) * line_thickness;
    }
}

void fragment() {
    vec2 uv = UV;
    
    if (add_margins) {
        vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(line_thickness * 2.0));
        
        uv = (uv - texture_pixel_size * line_thickness) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
        
        if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
            COLOR.a = 0.0;
        } else {
            COLOR = texture(TEXTURE, uv);
        }
    } else {
        COLOR = texture(TEXTURE, uv);
    }
    
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
    
    if (line_thickness < 0.1) {
        vec4 color = texture(TEXTURE, uv);
        COLOR = color;
    } else {
        float outline = texture(TEXTURE, uv + vec2(-size.x, 0)).a;
        outline += texture(TEXTURE, uv + vec2(0, size.y)).a;
        outline += texture(TEXTURE, uv + vec2(size.x, 0)).a;
        outline += texture(TEXTURE, uv + vec2(0, -size.y)).a;
        outline += texture(TEXTURE, uv + vec2(-size.x * 0.866, size.y * 0.5)).a;
        outline += texture(TEXTURE, uv + vec2(-size.x * 0.5, size.y * 0.866)).a;
        outline += texture(TEXTURE, uv + vec2(size.x * 0.866, size.y * 0.5)).a;
        outline += texture(TEXTURE, uv + vec2(size.x * 0.5, size.y * 0.866)).a;
        outline += texture(TEXTURE, uv + vec2(-size.x * 0.866, -size.y * 0.5)).a;
        outline += texture(TEXTURE, uv + vec2(-size.x * 0.5, -size.y * 0.866)).a;
        outline += texture(TEXTURE, uv + vec2(size.x * 0.866, -size.y * 0.5)).a;
        outline += texture(TEXTURE, uv + vec2(size.x * 0.5, -size.y * 0.866)).a;
        outline = min(outline, 1.0);
        
        vec4 color = texture(TEXTURE, uv);
		if (use_fill == true) {
			color = fill_color;
		}
		
		if (pulse_outline) {
			float f = (pow(outline,outline) - (color.a - (line_thickness))) + outline;
			f += smoothstep(color.a, f, f) * pow(sin(TIME * pulse_speed) + outline + sin(TIME * pulse_speed * line_thickness) + (outline * 0.5) + line_thickness, f);
			COLOR = mix(color, line_color, f);
		}
		else {
        	COLOR = mix(color, line_color, outline - color.a);
		}
		
    }
}