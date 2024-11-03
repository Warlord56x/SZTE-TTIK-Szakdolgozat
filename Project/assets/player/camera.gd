extends Camera2D
class_name MainCamera

var trauma: float = 0
var intensity: float = 0


func add_trauma(amount: float, _intensity: float) -> void:
	trauma = amount
	intensity = _intensity


func _unhandled_input(_event: InputEvent) -> void:

	var t_inp = Input.get_axis("wheel_down", "wheel_up")
	if t_inp:
		var tween = get_tree().create_tween()
		tween.tween_property(
			self,
			"zoom",
			clamp(
				zoom + (Vector2(0.1,0.1) * t_inp),
				Vector2(0.1,0.1),
				Vector2(2.0, 2.0)
				),
			0.1
			)
		tween.play()


func _process(delta: float) -> void:
	var t_inp = Input.get_axis("wheel_down", "wheel_up") * 0.4
	if t_inp != 0:
		var tween = get_tree().create_tween()
		tween.tween_property(
			self,
			"zoom",
			clamp(
				zoom + (Vector2.ONE * t_inp),
				Vector2(1.0,1.0),
				Vector2(2.0,2.0)
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
