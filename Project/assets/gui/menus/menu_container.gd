@tool
extends Container
class_name MenuContainer

@export var separation: int = 0:  # Gap between child controls
	set = set_separation

var previous_scales := {}


# Cache each child's scale for change detection
func _cache_child_scales() -> void:
	for child in get_children():
		if child is Control:
			previous_scales[child] = child.scale


func set_separation(s: int) -> void:
	separation = s
	minimum_size_changed.emit()
	queue_sort()


func _ready() -> void:
	_cache_child_scales()


func _process(_delta: float) -> void:
	# Check if any child has a changed scale, then trigger a sort
	for child in get_children():
		if child is Control:
			var current_scale = child.scale
			if current_scale != previous_scales.get(child, current_scale):
				minimum_size_changed.emit()
				queue_sort()
				previous_scales[child] = current_scale


func _get_minimum_size() -> Vector2:
	var children = get_children()
	if children.is_empty():
		return Vector2.ZERO

	var total_width: float = 0
	var max_height: float = 0
	var visible_count: int = 0
	
	# Calculate total fixed width and maximum height
	for child in children:
		if child is Control and child.visible:
			var child_min = child.get_minimum_size() * child.scale
			total_width += child_min.x
			max_height = max(max_height, child_min.y)
			visible_count += 1
	
	# Account for separation gaps between visible children
	if visible_count > 1:
		total_width += separation * (visible_count - 1)
		
	return Vector2(total_width, max_height)


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_cache_child_scales()

	if what == NOTIFICATION_SORT_CHILDREN:
		# Cache visible children for layout calculations.
		var children := []
		for c in get_children():
			if c is Control and c.visible:
				children.append(c)

		# First pass: compute the total fixed width and gather expanding children.
		var total_fixed_width: float = 0
		var expanding_children := []
		for c in children:
			# Use bitwise flag check to see if the control should expand horizontally.
			if c.size_flags_horizontal & Control.SIZE_EXPAND:
				expanding_children.append(c)
			else:
				total_fixed_width += c.get_minimum_size().x * c.scale.x

		# Include separation gaps between children.
		var separation_total = separation * max(0, children.size() - 1)
		var available_width = max(0, size.x - total_fixed_width - separation_total)
		
		var expand_width = 0
		if (expanding_children.size() > 0):
			expand_width = available_width / expanding_children.size()

		# Second pass: position and size each child.
		var offset_x: float = 0
		for c: Control in children:
			var child_min = c.get_minimum_size() * c.scale
			var new_size = child_min
			# For expanding controls, assign the computed width.
			if c in expanding_children:
				new_size.x = expand_width
			# For vertical expansion, stretch to the container's height.
			if c.size_flags_vertical & Control.SIZE_EXPAND:
				new_size.y = size.y

			c.position = Vector2(offset_x, 0)
			c.size = new_size
			offset_x += new_size.x + separation
