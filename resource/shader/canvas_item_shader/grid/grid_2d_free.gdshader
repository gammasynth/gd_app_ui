shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.5); // Grid line color
uniform float grid_thickness_pixels = 1.0; // Thickness of grid lines in screen pixels
uniform vec2 grid_scale = vec2(1.0, 1.0); // Grid scale factor
uniform float zoom = 1.0; // Camera zoom factor
uniform float time_mod = 1.0; // Time modulation factor for movement speed
uniform vec2 move_direction = vec2(1.0, 1.0); // Direction and magnitude of movement

void fragment() {
    // Calculate UV offset based on time and movement direction
    vec2 offset = move_direction * TIME * time_mod;
    
    // Apply scale, zoom, and time-based offset to UV coordinates
    vec2 uv = ((UV) + offset) * grid_scale * zoom;
    
    // Get fractional part for grid calculation
    vec2 grid = fract(uv);
    
    // Calculate thickness based on screen pixels and zoom
    // This maintains consistent line thickness on screen as you zoom in and out.
    vec2 adjusted_thickness = (SCREEN_PIXEL_SIZE * grid_thickness_pixels) / (grid_scale * zoom);
    
    // Check if fragment is on a grid line
    bool is_grid_line = grid.x < adjusted_thickness.x || grid.y < adjusted_thickness.y;
    
    // Clear color
    vec4 tex_color = vec4(0.0);
    
    // Output grid color if on a grid line, otherwise use clear color
    COLOR = is_grid_line ? grid_color : tex_color;
}