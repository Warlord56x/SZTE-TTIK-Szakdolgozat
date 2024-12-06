@tool
extends Container
class_name ItemWheel

@export_range(10, 60, 1) var r: int = 30:
	set(_r):
		if is_node_ready():
			queue_sort()
			r = _r

@export var angle: int = 90:
	set(a):
		if is_node_ready():
			queue_sort()
			angle = (a % 360 + 360) % 360

var inventory: Inventory:
	set(inv):
		inventory = inv
		inventory.items_changed.connect(update_wheel)
		update_wheel()

var coords: Array[Vector2] = []
var min_node: WheelItem

var tween: Tween


func _notification(what: int) -> void:
	if what == NOTIFICATION_PRE_SORT_CHILDREN:

		coords.clear()
		var center: Vector2 = get_rect().size / 2
		var delta_theta = 2 * PI / get_child_count()
		for i in get_child_count():
			var theta = i * delta_theta - deg_to_rad(angle)

			var x = center.x + r * cos(theta)
			var y = center.y + r * sin(theta)
			coords.append(Vector2(x,y) - get_child(i).size / 2)

	if what == NOTIFICATION_SORT_CHILDREN:

		var min_y: float = INF
		for c in get_child_count():
			var child: WheelItem = get_children()[c]
			child.focus = false
			child.position = (coords[c])
			if child.position.y < min_y:
				min_node = child
				min_y = child.position.y
		min_node.focus = true


func _ready() -> void:
	if not Engine.is_editor_hint():
		update_wheel()


func update_wheel(_item: Item = null) -> void:
	for slot: WheelItem in get_children():
		slot.item = null
	if not inventory:
		return

	for item_idx in len(inventory.get_items()):
		var wheel_slot: WheelItem = get_child(item_idx)
		if not wheel_slot:
			continue
		var item = inventory.get_item(item_idx)

		var is_weapon := item is WeaponItem
		var is_consumable := item is ConsumableItem

		if (is_weapon or is_consumable):
			wheel_slot.item = item


func _get_minimum_size() -> Vector2:
	var ch: Control = get_child(0)
	if ch == null:
		return Vector2(0,0)
	var ch_size = ch.size / 2 * get_child_count()
	return ch_size


func _unhandled_input(event: InputEvent) -> void:
	if not GameEnv.input_process:
		return
	if event.is_action_pressed("wheel_plus") or event.is_action_pressed("wheel_minus"):
		turn_wheel(sign(Input.get_axis("wheel_plus", "wheel_minus")))

	for i in range(1, 9):
		if event.is_action_pressed(str("wheel_item_",i)):
			seek_to_item(i)


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
	tween.tween_property(self, "angle", rot, 0.2)


func get_wheel_selection() -> Item:
	return min_node.item
