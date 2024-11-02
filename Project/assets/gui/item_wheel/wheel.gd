@tool
extends Container
class_name ItemWheel

@export_range(10, 30, 1) var r: int = 15:
	set(_r):
		if is_node_ready():
			queue_sort()
			r = _r

@export var angle: int = 90:
	set(a):
		if is_node_ready():
			queue_sort()
			angle = (a % 360 + 360) % 360

@export var inventory: Inventory

var coords: Array[Vector2] = []
var min_node: WheelItem

var tween: Tween


func _notification(what : int) -> void:
	if what == NOTIFICATION_PRE_SORT_CHILDREN:

		coords.clear()
		var center : Vector2 = get_global_rect().get_center()
		var delta_theta = 2 * PI / get_child_count()
		for i in range(0, get_child_count()):
			var theta = i * delta_theta - deg_to_rad(angle)

			var x = center.x + r * cos(theta)
			var y = center.y + r * sin(theta)
			coords.append(Vector2(x,y))

	if what == NOTIFICATION_SORT_CHILDREN:
#		print("sorting...")
		var center : Vector2 = get_global_rect().get_center()
		var diff = abs(center - get_rect().get_center()).y
		var min_y : float = 1000
		for c in get_child_count():
			var child: WheelItem = get_children()[c]
			child.focus = false
			child.global_position = (coords[c]) - Vector2(diff,diff)
			if child.global_position.y < min_y:
				min_node = child
				min_y = child.global_position.y
		min_node.focus = true


func _ready() -> void:
	if not Engine.is_editor_hint():
		for item_idx in len(inventory.get_items()):
			var wheel_slot: WheelItem = get_child(item_idx)
			if wheel_slot:
				wheel_slot.item = inventory.get_item(item_idx)
		inventory.items_changed.connect(update_wheel)


func update_wheel() -> void:
	for slot: WheelItem in get_children():
		slot.item = null

	for item_idx in len(inventory.get_items()):
		var wheel_slot: WheelItem = get_child(item_idx)
		if wheel_slot:
			wheel_slot.item = inventory.get_item(item_idx)


func _get_minimum_size() -> Vector2:
	var ch = get_child(0)
	if ch == null:
		return Vector2(0,0)
	return ((ch.size / 2) + Vector2(r, r)) * 2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("wheel_plus") or event.is_action_pressed("wheel_minus"):
		turn_wheel(round(Input.get_axis("wheel_plus", "wheel_minus")))

	if event.is_action_pressed("item_actions"):
		seek_to_item(event.as_text() as int)


func turn_wheel(dir: int) -> void:
	if tween and tween.is_running():
		await tween.finished
	tween = create_tween()
	tween.tween_property(self, "angle", angle - dir * 45, 0.2)


func seek_to_item(idx: int) -> void:
	if tween and tween.is_running():
		await tween.finished

	var target_rot = ((90 + (idx - 1) * 45) % 360 + 360) % 360

	var diff = target_rot - angle

	if diff > 180:
		diff -= 360
	elif diff < -180:
		diff += 360

	var rot = angle + diff

	tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "angle", rot, 1.0)


func get_wheel_selection() -> Item:
	return min_node.item
