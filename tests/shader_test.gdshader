shader_type canvas_item;

void fragment() {
	float new_uv = UV.x + sin(UV.y * 10.0) * 0.1;
	COLOR = texture(TEXTURE, vec2(new_uv, 0));
}
