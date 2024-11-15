@tool
extends Container
class_name MenuMarginContainer

@export var even_margins: Vector2 = Vector2.ZERO:
	set(m):
		even_margins = m
		queue_sort()

var previous_scales = {}


func _ready() -> void:
	for child: Control in get_children():
		previous_scales[child] = child.scale
	size_flags_changed.connect(queue_sort)


func _process(_delta: float) -> void:
	for child: Control in get_children():
		var current_scale = child.scale
		if current_scale != previous_scales[child]:
			queue_sort()
			previous_scales[child] = current_scale


func _get_minimum_size() -> Vector2:
	var min_size: Vector2 = get_child(0).get_minimum_size() * get_child(0).scale
	for child: Control in get_children():
		if child.visible and child.get_minimum_size() > min_size:
			min_size = child.get_minimum_size() * child.scale
	return min_size + even_margins * 2


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		for child: Control in get_children():
			previous_scales[child] = child.scale

	if what == NOTIFICATION_SORT_CHILDREN:
		for c: Control in get_children():
			if not c.visible:
				continue

			var child_size := size * scale

			c.position = even_margins
			c.size = child_size - even_margins * 2
			if c.scale != Vector2.ONE:
				scale = c.scale
