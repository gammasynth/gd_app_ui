shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.5); // grid lines
uniform float grid_thickness = 0.1; // Thickness of grid lines (fraction of a pixel)
uniform sampler2D back_texture: hint_default_transparent;

void fragment() {
    vec2 uv = UV * vec2(textureSize(back_texture, 0)); // Convert UV to pixel coordinates
    vec2 grid = fract(uv); // Get fractional part of pixel coordinates
    
    // Check if we're near a pixel boundary
    bool is_grid_line = grid.x < grid_thickness || grid.y < grid_thickness;
    
    // Sample the texture
    vec4 tex_color = vec4(0.0);
    
    // Output grid color if on a grid line, otherwise use texture color
    COLOR = is_grid_line ? grid_color : tex_color;
}