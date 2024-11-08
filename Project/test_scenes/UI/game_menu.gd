extends Control

var running_tween: Tween


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		if running_tween and running_tween.is_valid():
			return
		var seen_as := visible
		GameEnv.set_blur(!seen_as, 0.7)
		var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
		running_tween = tween
		if seen_as:
			tween.tween_property(%Effect.material, "shader_parameter/progress", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(get_child(0), "scale:x", 0.001, 0.7).set_trans(Tween.TRANS_BACK)
		else:
			visible = true
			tween.tween_property(get_child(0), "scale:x", 1.0, 0.5).set_trans(Tween.TRANS_BACK)
			tween.tween_property(%Effect.material, "shader_parameter/progress", 0.0, 0.7).set_trans(Tween.TRANS_LINEAR)

		await tween.finished
		visible = !seen_as



func _on_volume_slider_volume_changed(value: float) -> void:
	Settings.settings.master_volume = value


func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.settings.fullscreen = Window.MODE_FULLSCREEN
	else:
		Settings.settings.fullscreen = Window.MODE_WINDOWED


func _on_vsync_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.settings.vsync = DisplayServer.VSYNC_ENABLED
	else:
		Settings.settings.vsync = DisplayServer.VSYNC_DISABLED


func _on_apply_pressed() -> void:
	Settings.update_settings()
