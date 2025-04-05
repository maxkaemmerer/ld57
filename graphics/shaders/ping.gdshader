shader_type canvas_item;

// --- Uniforms --- //
uniform float circle_width: hint_range(0.0, 1.0, 0.01) = 0.15;
uniform float wait_time: hint_range(0.0, 5.0, 0.1) = 0.5;
uniform float speed: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float alpha_boost: hint_range(1.0, 5.0, 0.1) = 2.0;

// --- Functions --- //
void fragment() {
	float dist = distance(UV, vec2(0.5));
	float mod_dist = dist - mod(TIME * speed, 0.75 + wait_time) + 0.5;
	float val = COLOR.a;
	val *= 1.0 - step(0.5, mod_dist);
	val += step(0.5 - circle_width / 2.0, mod_dist) - 1.0;
	val -= 2.0 * dist;
	val *= alpha_boost;
	COLOR.a = clamp(val, 0, 1);
}
