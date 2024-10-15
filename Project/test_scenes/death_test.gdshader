shader_type canvas_item;

uniform float transition: hint_range(0, 1, 0.1) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
	//vec2 vertex = VERTEX + vec2(cos(sin(TIME*2.0)),sin(TIME));
	//
	//vertex.x *= sin(TIME) + 1.0;
	//
	//VERTEX = vertex;
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR += vec4(.0, .0, 0.4 * transition, .0);
}

