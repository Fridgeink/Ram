shader_type canvas_item;

uniform sampler2D back_texture;
uniform sampler2D front_texture;
uniform float flip_factor : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    float scale_cos = cos(flip_factor * 3.14159); // -1 -> 1
    vec2 uv = UV;

    ivec2 tex_size;

    vec4 color;

    if (scale_cos >= 0.0) {
        tex_size = textureSize(back_texture, 0);
        color = texelFetch(back_texture, ivec2(uv * vec2(tex_size)), 0);
    } else {
        tex_size = textureSize(front_texture, 0);
        // Mirror horizontally
        color = texelFetch(front_texture, ivec2(vec2(1.0 - uv.x, uv.y) * vec2(tex_size)), 0);
    }

    COLOR = color;
}