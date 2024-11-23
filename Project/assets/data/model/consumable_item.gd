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
	consumer.add_child(t)
