extends InteractionArea
class_name Camp

@export var camp_name: StringName
@export var anvil: bool = false:
	set(an):
		%Anvil.visible = an
		anvil = an

var active: bool = false
var player: Player
var in_camp: bool

signal _interact(b: bool)


func activate() -> void:
	active = true


func deactivate() -> void:
	active = false


func zoom(in_out: bool, camera: Camera2D) -> void:
	var tween = create_tween()
	if in_out:
		tween.tween_property(camera, "zoom", Vector2(6,6), 0.2)
	else:
		tween.tween_property(camera, "zoom", Vector2(3,3), 0.2)


func interact(_player: Player = null) -> bool:
	if not GameEnv.input_process:
		return interactable
	player = _player
	player.camp = camp_name

	if not active:
		player.active_camps.append(camp_name)
	activate()

	in_camp = true
	zoom(true, player.camera)
	_interact.emit(true, self)
	GameEnv.input_process = false

	return interactable


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		if in_camp:
			in_camp = false
			interaction_done.emit()
			zoom(false, player.camera)
			_interact.emit(false, null)
			GameEnv.input_process = true
			get_window().set_input_as_handled()
