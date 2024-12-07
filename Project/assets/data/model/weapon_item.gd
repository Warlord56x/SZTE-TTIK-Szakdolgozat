extends Item
class_name WeaponItem

@export var damage: int = 1


func _to_string() -> String:
	return str("Weapon: ",name)
