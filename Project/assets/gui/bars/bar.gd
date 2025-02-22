@tool
extends GridContainer
class_name Bar

@export var heart: PackedScene = null

@export var max_resource: int = 20:
	set = set_max_resource
@export var resource: int = 20:
	set = set_resource


func _init() -> void:
	init_hearts.call_deferred()


func init_hearts() -> void:
	for child: Heart in get_children():
		# Same as queue_free() but with animation (custom method)
		child.kill_heart()
	for i in range(0, max_resource, 4):
		var heart_instance := heart.instantiate() as Heart
		heart_instance.set_full()
		if Engine.is_editor_hint():
			add_child.call_deferred(heart_instance)
		else:
			add_child(heart_instance)


func fix_hearts() -> void:
	var childs := get_child_count()
	var expected_childs := int(ceil(max_resource / 4.0))

	var diff := abs(expected_childs - childs) as int
	if childs < expected_childs:
		for _i in diff:
			add_child(heart.instantiate())
	if childs > expected_childs:
		for i in diff:
			get_children()[-(i + 1)].kill_heart()


func set_max_resource(res: int) -> void:
	max_resource = res
	fix_hearts()


func set_resource(res: int) -> void:
	resource = clamp(res, 0, max_resource)
	#if res > max_resource:
		#return
	var children: Array[Node] = get_children()

	if res == 0:
		for child: Heart in children:
			child.set_null()
		return

	for child: Heart in children:
		child.current = 0

	if children.is_empty(): return
	for r: int in res:
		children[int(r / 4.0)].current += 1
