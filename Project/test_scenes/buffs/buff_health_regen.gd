extends BuffPeriodicEffect
class_name BuffHealthRegen

@export var restore_amount := 1


func effect() -> void:
	if apply_to.health:
		apply_to.health += restore_amount
