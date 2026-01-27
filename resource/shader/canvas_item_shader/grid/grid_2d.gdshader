shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.5);
uniform float grid_thickness = 0.05; // Relative to the cell size
uniform float texture_scale = 1.0;
uniform sampler2D back_texture : hint_default_transparent;

void fragment() {
    vec2 tex_size = vec2(textureSize(back_texture, 0));
    // We don't need 'zoom' uniform if we use screen-space derivatives
    vec2 uv = UV * tex_size * texture_scale;

    vec2 grid = fract(uv);

    // Calculate how much the UV changes per screen pixel
    // This automatically accounts for camera zoom
    vec2 derivative = fwidth(uv);

    // Create a smooth edge for the grid lines
    // This prevents the lines from disappearing or flickering when thin
    vec2 target_thickness = vec2(grid_thickness);
    vec2 line = smoothstep(target_thickness + derivative, target_thickness - derivative, grid);

    // Combine X and Y lines
    float line_alpha = max(line.x, line.y);

    // Keep lines at least 1 screen pixel wide even when zoomed out
    // Optional: remove if you want lines to disappear naturally
    line_alpha = clamp(line_alpha, 0.0, 1.0);

    COLOR = vec4(grid_color.rgb, line_alpha * grid_color.a);
}
