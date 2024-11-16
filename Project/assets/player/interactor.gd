extends Area2D
class_name Interactor

@onready var player: Player = owner
@onready var interaction_target: InteractionArea = null


func get_interaction_type() -> InteractionArea.INTERACTION_TYPE:
	return interaction_target.type if interaction_target else InteractionArea.INTERACTION_TYPE.NONE


func _unhandled_input(event: InputEvent) -> void:
	if not GameEnv.input_process:
		return

	if event.is_action_pressed("interact") and interaction_target:
		if not interaction_target.interact(player):
			player.request_interaction_visible(false)
			await interaction_target.interaction_done
			interaction_target = null


func _on_area_entered(area: Area2D) -> void:
	if area is InteractionArea and (area as InteractionArea).interactable:
		interaction_target = area
		if not player.on_ladder:
			player.request_interaction_visible(true)


func _on_area_exited(area: Area2D) -> void:
	if area is InteractionArea and area == interaction_target:
		interaction_target = null
		player.request_interaction_visible(false)
