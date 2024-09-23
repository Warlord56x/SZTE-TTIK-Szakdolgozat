shader_type canvas_item;

uniform int flip: hint_range(0, 1, 1) = 0;

void fragment() {
	vec2 flipUV;

	if (flip == 1) {
		flipUV = vec2(0.05 - UV.x, UV.y);
	} else {
		flipUV = vec2(UV.x, UV.y);
	}
	vec4 color = texture(TEXTURE, flipUV);
	COLOR = vec4(color.rgb, color.a * 0.5 );
}