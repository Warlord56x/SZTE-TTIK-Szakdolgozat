extends Control

@onready var master_volume_slider: VolumeSlider = %MasterVolumeSlider
@onready var fullscreen_check: CheckButton = %FullscreenCheck
@onready var vsync_check: CheckButton = %VsyncCheck
@onready var menus: Array[Node] = get_tree().get_nodes_in_group("Menus")
@onready var menus_reversed: Array[Node] = (func():
	var r = menus.duplicate()
	r.reverse()
	return r ).call()

@onready var _effect_nodes: Array[Node] = get_tree().get_nodes_in_group("Effects")
@onready var effects: Array = _effect_nodes.map(func(n): return n.material as ShaderMaterial)


var main_open: bool = false:
	set = set_main


func _ready() -> void:
	master_volume_slider.value = Settings.settings.master_volume * 100
	fullscreen_check.button_pressed = Settings.settings.fullscreen
	vsync_check.button_pressed = Settings.settings.vsync

	for menu in menus:
		menu.scale.x = 0.001
		var menu_effect: ShaderMaterial = menu.get_node("Effect").material
		menu_effect.set_shader_parameter("progress", 1.0)
		menu.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		main_open = !main_open


func set_main(_open: bool) -> void:
	GameEnv.set_blur(_open, 0.7)
	GameEnv.input_process = !_open

	if _open:
		open(menus[0])
	else:
		for menu in menus_reversed:
			if menu.visible:
				close(menu)
	main_open = _open


func open(menu: Control) -> void:

	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_method(_scaler.bind(menu), 0.001, 1.0, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(_progress.bind(effects[menus.find(menu)]), 1.0, 0.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	menu.visible = true
	await tween.finished


func close(menu: Control) -> void:

	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_method(_progress.bind(effects[menus.find(menu)]), 0.0, 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(_scaler.bind(menu), 1.0, 0.001, 0.7).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	menu.visible = false


#region Animation Helpers
func _progress(f: float, effect: ShaderMaterial) -> void:
	effect.set_shader_parameter("progress", f)


func _scaler(f: float, node: Control) -> void:
	node.scale.x = f
#endregion


#region Settings events
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
	Settings.save_settings()
#endregion


#region Main events
func _on_continue_pressed() -> void:
	main_open = false


func _on_save_pressed() -> void:
	if menus[2].visible:
		close(menus[2])
	else:
		open(menus[2])


func _on_load_pressed() -> void:
	if menus[3].visible:
		close(menus[3])
	else:
		open(menus[3])


func _on_settings_pressed() -> void:
	if menus[1].visible:
		close(menus[1])
	else:
		open(menus[1])


func _on_back_pressed() -> void:
	GameEnv.fade_in_out(0.3)
	await GameEnv.fade_step2
	GameEnv.set_blur(false)
	get_tree().change_scene_to_packed(GameEnv.MAIN_MENU)


func _on_exit_pressed() -> void:
	get_tree().quit()
#endregion
