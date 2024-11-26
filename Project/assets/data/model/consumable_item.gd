extends Item
class_name ConsumableItem

const test := preload("res://test_scenes/buff.tscn")

@export var effect_time: float
@export var effect_interval: float


func consume(consumer: Node2D) -> void:
	if stack <= 0:
		return

	var t = test.instantiate()
	t.buff_time = effect_time
	t.buff_interval = effect_interval
	t.buff_icon = icon
	if consumer.has_node("BuffComponent"):
		var buff_component = consumer.get_node("BuffComponent")
		t.apply_to = buff_component.apply_to
		buff_component.add_child(t)
