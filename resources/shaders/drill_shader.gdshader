shader_type canvas_item;

uniform sampler2D color_gradient;
uniform sampler2D noiseTexture;
uniform float variation: hint_range (0.0,1.0);
uniform float width: hint_range (0.0,1.0);

void fragment() {
	vec2 noise_uv = fract(UV + vec2(TIME));
	float noise_sample = texture(noiseTexture, noise_uv).r;
	float x_offset = noise_sample*variation - variation/2.0;
	COLOR = texture(color_gradient, vec2((UV.y-0.5)/width + 0.5 + x_offset/width));
}