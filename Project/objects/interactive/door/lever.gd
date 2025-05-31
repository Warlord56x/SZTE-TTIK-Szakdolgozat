extends InteractionArea


@export var to_activate: Door = null


func interact(player: Player = null) -> bool:
	if player:
		pass
	
	# TODO: Actual behavior
	
	interaction_done.emit()
	return true
