extends PanelContainer


@export var focus_target: Control


func _ready() -> void:
	visibility_changed.connect(vis_changed)


func vis_changed() -> void:
	if focus_target:
		focus_target.grab_focus()
