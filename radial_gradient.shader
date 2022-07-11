shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	float d = length(2.0 * UV - 1.0);
	vec4 col = texture(gradient, vec2(fract(d), 0));
	COLOR = col;
}
