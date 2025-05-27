extends Resource
class_name Scale

enum Scales {
	NONE = 0,
	E = 025,
	D = 040,
	C = 060,
	B = 090,
	A = 140,
	S = 175,
}

@export var vitality_scale: Scales = Scales.E
@export var strength_scale: Scales = Scales.E
@export var dexterity_scale: Scales = Scales.E
@export var intelligence_scale: Scales = Scales.E


func calc_scale(num: float, scale: Scales, stat: int) -> float:
	if scale == Scales.NONE:
		return num
	var s = scale / 100.0
	return num * (1 + stat / 100.0 * s)


func calc_all_scales(num: int, stats: Array[int]) -> int:
	var _scales := [
		vitality_scale,
		strength_scale,
		dexterity_scale,
		intelligence_scale,
	]
	var n: float = num
	for i: int in len(_scales):
		n = calc_scale(n, _scales[i], stats[i])
	return round(n)
