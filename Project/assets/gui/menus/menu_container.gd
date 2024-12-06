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
			minimum_size_changed.emit()
			queue_sort()
			previous_scales[child] = current_scale


func _get_minimum_size() -> Vector2:
	var min_size := (get_child(0) as Control).get_minimum_size()
	for child: Control in get_children():
		if child.visible:
			min_size.x += child.get_minimum_size().x * child.scale.x
			if child.get_minimum_size().y > min_size.y:
				min_size.y = child.get_minimum_size().y * child.scale.y
	return min_size


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		for child: Control in get_children():
			previous_scales[child] = child.scale

	if what == NOTIFICATION_SORT_CHILDREN:
		var total_fixed_width = 0
		var expanding_children = []
		var offset_x = 0

		for c: Control in get_children():
			if not c.visible:
				continue

			var flags_h := c.size_flags_horizontal

			if flags_h != SIZE_EXPAND and flags_h != SIZE_EXPAND_FILL:
				var min_size_x = c.get_minimum_size().x * c.scale.x
				total_fixed_width += min_size_x
			else:
				expanding_children.append(c)

		for c: Control in get_children():
			if not c.visible:
				continue

			var child_size := c.get_minimum_size()
			var flags_v := c.size_flags_vertical

			if c in expanding_children:
				child_size.x = (size.x - total_fixed_width) / expanding_children.size()
			child_size.x *= c.scale.x

			if flags_v == SIZE_EXPAND or flags_v == SIZE_EXPAND_FILL:
				child_size.y = size.y

			c.position.x = offset_x
			c.size = child_size

			offset_x += child_size.x
