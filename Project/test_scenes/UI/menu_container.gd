@tool
extends Container
class_name MenuContainer


var previous_scales = {}


func _ready() -> void:

	for child: Control in get_children():
		previous_scales[child] = child.scale


func _process(_delta: float) -> void:
	for child: Control in get_children():
		var current_scale = child.scale
		if current_scale != previous_scales[child]:
			queue_sort()
			previous_scales[child] = current_scale


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		var offset_x = 0

		for c: Control in get_children():
			if not c.visible:
				continue

			var child_size = c.get_minimum_size()
			child_size.y = size.y

			child_size.x *= c.scale.x
			c.position.x = offset_x
			c.size = child_size

			offset_x += child_size.x
