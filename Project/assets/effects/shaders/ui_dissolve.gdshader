/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/teleport-effect

This shader is under CC0 license. Feel free to use, improve and
change this shader according to your needs and consider sharing
the modified result on godotshaders.com.
*/

shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.0;
uniform float noise_desnity = 30;
uniform float beam_size: hint_range(0.01, 0.15) = 0.01;
uniform vec4 color: source_color = vec4(1.0);
uniform float pixel_size: hint_range(0.0, 1.0, 0.01) = 0.01;
uniform float corner_radius: hint_range(0.0, 0.5) = 0.1;
uniform bool invert = false;


// We are generating our own noise here. You could experiment with the
// built in SimplexNoise or your own noise texture for other effects.
vec2 random(vec2 uv){
	uv = vec2( dot(uv, vec2(127.1,311.7) ),
				dot(uv, vec2(269.5,183.3) ) );
	return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);

	vec2 blur = smoothstep(0.0, 1.0, uv_fract);

	return mix(
		mix(dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
			dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
		mix(dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
			dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) * 0.5 + 0.5;
		}


void fragment()
{
	vec2 pixelatedUV = floor(UV / pixel_size) * pixel_size;
	vec4 tex = texture(TEXTURE, pixelatedUV);

	float scale = pixelatedUV.x;
	if (invert) {
		scale = 1.0 - pixelatedUV.x;
	}
	float noise = noise(pixelatedUV * noise_desnity) * scale;

	float epsilon = 0.001;
	float d1 = step(noise, progress - epsilon);
	float d2 = step(noise, progress - beam_size - epsilon);

	vec3 beam = vec3(d1 - d2) * color.rgb;

	tex.rgb = COLOR.rgb;
	tex.rgb += beam;
	tex.a *= d1;

	// Rounded corner calculations
	vec2 limit_tl = vec2(corner_radius, corner_radius);
	vec2 limit_tr = vec2(1.0 - corner_radius, corner_radius);
	vec2 limit_bl = vec2(corner_radius, 1.0 - corner_radius);
	vec2 limit_br = vec2(1.0 - corner_radius, 1.0 - corner_radius);

	float dist_tl = distance(UV, limit_tl);
	float dist_tr = distance(UV, limit_tr);
	float dist_bl = distance(UV, limit_bl);
	float dist_br = distance(UV, limit_br);

	// Discard pixels outside the rounded corners
	if ((UV.x < corner_radius && UV.y < corner_radius && dist_tl > corner_radius) ||
		(UV.x > limit_tr.x && UV.y < corner_radius && dist_tr > corner_radius) ||
		(UV.x < corner_radius && UV.y > limit_bl.y && dist_bl > corner_radius) ||
		(UV.x > limit_br.x && UV.y > limit_br.y && dist_br > corner_radius)) {
		discard;
	} else {
		COLOR = tex;
	}
}