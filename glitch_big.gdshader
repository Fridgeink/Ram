shader_type canvas_item;

uniform bool enabled = true;
uniform float glitch_strength : hint_range(1.0, 3.0) = 2.0; // max pixel shift
uniform float glitch_density : hint_range(0.0, 1.0) = 0.25; // how many lines glitch
uniform float speed = 8.0;
uniform float tex_height = 196.0; // texture height in pixels

// simple hash
float rand(float n) {
    return fract(sin(n) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;

    if (enabled) {
        float y_pixel = floor(UV.y * tex_height);

        // generate time-varying random per scanline
        float r = rand(y_pixel + floor(TIME * speed));

        if (r < glitch_density) {
            // shift amount in pixels
            float shift_pixels = floor(rand(y_pixel * 2.0) * glitch_strength) + 1.0;

            // random direction
            float dir = sign(rand(y_pixel * 3.0) - 0.5);

            uv.x += dir * shift_pixels * TEXTURE_PIXEL_SIZE.x;
        }
    }

    COLOR = texture(TEXTURE, uv);
}