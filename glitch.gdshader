shader_type canvas_item;

uniform bool enabled = true;
uniform float glitch_density : hint_range(0.0, 1.0) = 0.2;
uniform float speed = 8.0;

float rand(float n){
    return fract(sin(n) * 43758.5453123);
}

void fragment() {

    vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;

    // exact integer pixel coordinate
    vec2 pixel = floor(UV * tex_size);

    vec2 sample_pixel = pixel;

    if (enabled) {

        float r = rand(pixel.y + floor(TIME * speed));

        if (r < glitch_density) {

            float shift = floor(rand(pixel.y * 2.0) * 3.0) + 1.0;
            float dir = sign(rand(pixel.y * 3.0) - 0.5);

            sample_pixel.x += shift * dir;
        }
    }

    // sample exactly at pixel center
    vec2 sample_uv = (sample_pixel + 0.5) * TEXTURE_PIXEL_SIZE;

    COLOR = texture(TEXTURE, sample_uv);
}