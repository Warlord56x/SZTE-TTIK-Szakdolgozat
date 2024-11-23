extends Item
class_name ConsumableItem

@export var effect_time: float = 0.0
@export var effect: bool


func consume(consumer: Node2D) -> void:
	pass


func restore(consumer: Node2D) -> void:
	pass
