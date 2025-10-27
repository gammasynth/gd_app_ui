shader_type canvas_item;

// Source color of the card
uniform vec4 card_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Background color set to transparent for the cutout effect
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);

// Default to -1.0 to disable the override
uniform float override_corner_radius : hint_range(-1.0, 1.0) = -1.0;

// Corner radii for each corner
uniform float top_left_radius : hint_range(0.0, 1.0) = 0.1;
uniform float top_right_radius : hint_range(0.0, 1.0) = 0.1;
uniform float bottom_left_radius : hint_range(0.0, 1.0) = 0.1;
uniform float bottom_right_radius : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Get the fragment position in the texture's UV coordinates
    vec2 size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec2 pos = UV * size;
    vec2 half_size = size * 0.5;

    // Determine the corner radius to use
    float tl_radius = (override_corner_radius >= 0.0) ? override_corner_radius : top_left_radius;
    float tr_radius = (override_corner_radius >= 0.0) ? override_corner_radius : top_right_radius;
    float bl_radius = (override_corner_radius >= 0.0) ? override_corner_radius : bottom_left_radius;
    float br_radius = (override_corner_radius >= 0.0) ? override_corner_radius : bottom_right_radius;

    // Check corners
    float alpha = 1.0;

    // Top-left corner
    if (pos.x < tl_radius && pos.y < tl_radius) {
        float distance_to_corner = length(vec2(pos.x - tl_radius, pos.y - tl_radius));
        if (distance_to_corner > tl_radius) {
            alpha = 0.0;
        }
    }

    // Top-right corner
    if (pos.x > size.x - tr_radius && pos.y < tr_radius) {
        float distance_to_corner = length(vec2(pos.x - (size.x - tr_radius), pos.y - tr_radius));
        if (distance_to_corner > tr_radius) {
            alpha = 0.0;
        }
    }

    // Bottom-left corner
    if (pos.x < bl_radius && pos.y > size.y - bl_radius) {
        float distance_to_corner = length(vec2(pos.x - bl_radius, pos.y - (size.y - bl_radius)));
        if (distance_to_corner > bl_radius) {
            alpha = 0.0;
        }
    }

    // Bottom-right corner
    if (pos.x > size.x - br_radius && pos.y > size.y - br_radius) {
        float distance_to_corner = length(vec2(pos.x - (size.x - br_radius), pos.y - (size.y - br_radius)));
        if (distance_to_corner > br_radius) {
            alpha = 0.0;
        }
    }

    // If a corner is cut out, use the background color; otherwise, use the source color
    if (alpha < 1.0) {
        COLOR = background_color;
    } else {
        COLOR = card_color;
    }
}

