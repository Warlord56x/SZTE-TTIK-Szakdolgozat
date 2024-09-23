shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;

const highp mat3 agx = mat3(
    vec3(0.842479062253094f, 0.0784335999999992f, 0.0792237451477643f),
    vec3(0.0423282422610123f, 0.878468636469772f, 0.0791661274605434f),
    vec3(0.0423756549057051f, 0.0784336f, 0.879142973793104f)
);

const highp mat3 inv_agx = mat3(
    vec3(1.19687900512017f, -0.0980208811401368f, -0.0990297440797205f),
    vec3(-0.0528968517574562f, 1.15190312990417f, -0.0989611768448433f),
    vec3(-0.0529716355144438f, -0.0980434501171241f, 1.15107367264116f)
);

vec3 agxDefaultContrastApprox(vec3 x) {
  vec3 x2 = x * x;
  vec3 x3 = x2 * x;
  vec3 x4 = x2 * x2;
  vec3 x5 = x4 * x;
  vec3 x6 = x4 * x2;
  vec3 x7 = x6 * x;

  return - 17.86     * x7
         + 78.01     * x6
         - 126.7     * x5
         + 92.06     * x4
         - 28.72     * x3
         + 4.361     * x2
         - 0.1718    * x
         + 0.002857;
}

void fragment() {
	// LINEAR
	vec3 col = texture(screen, UV).rgb;

	// AGX
	col *= agx;
	col = clamp((log2(col) + 12.47393f) / 16.5, 0.0, 1.0);
	col = agxDefaultContrastApprox(col);
	col *= inv_agx;

	COLOR = vec4(col, 1.0);
}
