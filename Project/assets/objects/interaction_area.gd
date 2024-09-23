extends Area2D
class_name InteractionArea

enum INTERACTION_TYPE {
	DEAFULT,
	LADDER,
	NONE,
}

signal interaction_done

var type: INTERACTION_TYPE = INTERACTION_TYPE.DEAFULT
var interactable: bool = true

func interact() -> bool: 
	interaction_done.emit()
	return interactable
