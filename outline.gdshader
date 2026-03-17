shader_type canvas_item;

uniform bool enabled = false;
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform float tex_height = 196.0; // texture height in pixels

const vec4 OUTLINE_COLOR = vec4(1.0, 0.941, 0.941, 1.0);

const vec2 OFFSETS[4] = vec2[](
    vec2(-1, 0),
    vec2(1, 0),
    vec2(0, -1),
    vec2(0, 1)
);

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);

    // Clear the very top row
    float y_pixel = UV.y * tex_height;
    if (y_pixel < 1.0) {
        base_color.a = 0.0;
    }

    if (enabled) {
        vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
        float outline = 0.0;

        for (int i = 0; i < 4; i++) {
            outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
        }
        outline = min(outline, 1.0);

        COLOR = mix(base_color, OUTLINE_COLOR, outline - base_color.a);
    } else {
        COLOR = base_color;
    }
}
