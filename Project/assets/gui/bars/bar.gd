@tool
extends GridContainer
class_name Bar

@export var heart: PackedScene = null

@export var max_resource: int = 20
@export_range(0, 20, 1,"suffix:resource") var resource: int = 20:
	set = set_resource


func _init() -> void:
	await ready

	for child in get_children():
		child.queue_free()
	for i in range(0, max_resource, 4):
		var heart_instance = heart.instantiate() as Heart
		heart_instance.set_full()
		if Engine.is_editor_hint():
			add_child.call_deferred(heart_instance)
		else:
			add_child(heart_instance)


func set_resource(res: int) -> void:
	resource = clamp(res, 0, max_resource)
	var children: Array[Node] = get_children()

	if res == 0:
		for child: Heart in children:
			child.set_null()
		return
	if res == max_resource:
		for child: Heart in children:
			child.set_full()
		return

	for child: Heart in children:
		child.current = 0

	if children.is_empty(): return
	var child: int = 0
	for _r in res:
		if children[child].current == 4:
			child += 1
		children[child].current += 1
