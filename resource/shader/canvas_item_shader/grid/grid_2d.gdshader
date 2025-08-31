shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.5); // Grid line color
uniform float grid_thickness = 0.1; // Thickness of grid lines (fraction of a pixel)
uniform sampler2D back_texture : hint_default_transparent;
uniform float texture_scale = 1.0; // Texture scale factor
uniform float zoom = 1.0; // Camera zoom factor

void fragment() {
    // Get texture size
    vec2 tex_size = vec2(textureSize(back_texture, 0));
    
    // Convert UV to pixel coordinates, accounting for scale and zoom
    vec2 uv = UV * tex_size * texture_scale * zoom;
    
    // Get fractional part for grid calculation
    vec2 grid = fract(uv);
    
    // Adjust thickness based on zoom for consistent appearance
    float adjusted_thickness = grid_thickness; // Prevent division by zero
    
    // Check if fragment is on a grid line
    bool is_grid_line = grid.x < adjusted_thickness || grid.y < adjusted_thickness;
    
    // Clear color (as in original shader)
    vec4 tex_color = vec4(0.0);
    
    // Output grid color if on a grid line, otherwise use clear color
    COLOR = is_grid_line ? grid_color : tex_color;
}