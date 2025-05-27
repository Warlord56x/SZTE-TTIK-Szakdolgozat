extends Area2D
class_name InteractionArea


signal interaction_done

@export var interactable: bool = true


func interact(_player: Player = null) -> bool: 
	interaction_done.emit()
	return interactable
