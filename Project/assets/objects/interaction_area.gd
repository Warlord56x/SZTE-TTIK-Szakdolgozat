extends Area2D
class_name InteractionArea

enum INTERACTION_TYPE {
	DEAFULT,
	LADDER,
	NONE,
}

signal interaction_done

@export var type: INTERACTION_TYPE = INTERACTION_TYPE.DEAFULT
@export var interactable: bool = true

func interact(_player: Player = null) -> bool: 
	interaction_done.emit()
	return interactable
