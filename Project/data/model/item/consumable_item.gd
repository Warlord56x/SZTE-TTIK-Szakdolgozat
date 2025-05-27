extends Item
class_name ConsumableItem

@export var _effect: GDScript

@export var effect_time: float
@export var effect_interval: float


func consume(consumer: Node2D) -> void:
	if stack <= 0:
		return
	if not consumer.has_node("BuffComponent"):
		return

	var buff_component = consumer.get_node("BuffComponent")
	var effect = _effect.new()
	effect.buff_time = effect_time
	effect.buff_interval = effect_interval
	effect.buff_icon = icon

	effect.apply_to = buff_component.apply_to
	buff_component.add_child(effect)


func _to_string() -> String:
	return str("Consumable: ", name)
