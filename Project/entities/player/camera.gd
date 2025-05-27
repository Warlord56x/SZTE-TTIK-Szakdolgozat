extends Camera2D
class_name MainCamera

var trauma: float = 0
var intensity: float = 0

@export var minimum_zoom: Vector2
@export var maximum_zoom: Vector2


func add_trauma(amount: float, _intensity: float) -> void:
	trauma = amount
	intensity = _intensity


func _unhandled_input(event: InputEvent) -> void:
	if not GameEnv.input_process:
		return

	var t_inp = event.get_action_strength("wheel_up") - event.get_action_strength("wheel_down")
	if t_inp:
		var tween = get_tree().create_tween()
		tween.tween_property(
			self,
			"zoom",
			clamp(
				zoom + (Vector2(0.1,0.1) * t_inp),
				minimum_zoom,
				maximum_zoom
				),
			0.1
			)
		tween.play()


func _process(delta: float) -> void:
	var t_inp = Input.get_axis("wheel_down", "wheel_up") * 0.4
	if t_inp != 0 and not GameEnv.input_process:
		var tween = get_tree().create_tween()
		tween.tween_property(
			self,
			"zoom",
			clamp(
				zoom + (Vector2.ONE * t_inp),
				minimum_zoom,
				maximum_zoom
				),
			0.1
			)
		tween.play()

	if trauma > 0:
		trauma -= delta
		#TODO: Need to look at why the particles are messed up if the camera is rotated
		global_rotation = randf_range(-intensity * 0.1, intensity * 0.1)
		offset += Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
	else:
		global_rotation = 0
		offset = Vector2.ZERO
