shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform float diamondPixelSize = 16.0;
uniform bool reverse = false;

void fragment() {
	float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
	float yFraction = fract(FRAGCOORD.y / diamondPixelSize);

	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);

	float diagonal = UV.x + UV.y;

	if (reverse) {
		diagonal = (1.0 - UV.x) + (1.0 - UV.y);
	}

	if (xDistance + yDistance + diagonal > progress * 4.0) {
		discard;
	}
}