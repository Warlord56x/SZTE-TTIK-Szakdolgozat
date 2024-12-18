@tool
extends ColorRect
class_name EffectLayer

const SHADER := preload("res://assets/effects/shaders/ui_dissolve.gdshader")


@export_range(0.0, 1.0, 0.001) var progress: float = 0.0:
	set = _set_progress
@export_range(0.0, 1.0, 0.01) var pixel_size: float = 0.01:
	set = _set_pixel_size
@export_range(0.0, 1.0, 0.01) var corner_radius: float = 0.0:
	set = _set_corner_radius
@export var invert: bool = false:
	set = _set_invert


func _init() -> void:
	material = ShaderMaterial.new()
	material.shader = SHADER
	color = Color.BLACK

	material.set_shader_parameter("corner_radius", 0)
	material.set_shader_parameter("progress", 0)

	pivot_offset = size / 2
	material.set_shader_parameter("inverse_x", invert)
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE


func fade(for_: float = 0.0, fading_time: float = 0.3) -> void:
	var tween := create_tween()
	tween.tween_method(_set_progress, 0.0, 1.0, fading_time)
	tween.tween_method(_set_progress, 1.0, 1.0, for_)
	tween.tween_method(_set_progress, 1.0, 0.0, fading_time)


func _set_progress(f: float) -> void:
	progress = f
	material.set_shader_parameter("progress", f)


func _set_corner_radius(f: float) -> void:
	corner_radius = f
	material.set_shader_parameter("corner_radius", f)


func _set_pixel_size(f: float) -> void:
	pixel_size = f
	material.set_shader_parameter("pixel_size", f)


func _set_invert(b: bool) -> void:
	invert = b
	material.set_shader_parameter("invert", b)
