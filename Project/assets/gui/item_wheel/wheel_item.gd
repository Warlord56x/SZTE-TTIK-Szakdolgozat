@tool
extends Control
class_name WheelItem


@onready var back_ground: Sprite2D = $BackGround
@onready var label: Label = $Label
@onready var for_ground: Sprite2D = $ForGround
@onready var item_rect: TextureRect = $ItemRect

@onready var cooldown_mat: ShaderMaterial = $CooldownRect.material as ShaderMaterial


@export var item : Item = null:
	set(it):
		if item:
			if item.stack_changed.is_connected(refresh_label):
				item.stack_changed.disconnect(refresh_label)
			if item._used.is_connected(_used):
				item._used.disconnect(_used)
		if it:
			item = it
			item_rect.texture = it.icon
			item.stack_changed.connect(refresh_label)
			item._used.connect(_used)
		else:
			item_rect.texture = null
		refresh_label()


@export var focus : bool = false:
	set(f):
		if not is_node_ready():
			await ready
		for_ground.visible = f
		focus = f


func _ready() -> void:
	refresh_label()


func _used(used: bool) -> void:
	if item and used:
		cooldown_mat.set_shader_parameter("cooldown_progress", 0.0)
		var tween = create_tween()
		tween.tween_property(cooldown_mat, "shader_parameter/cooldown_progress", 1.0, item.cooldown)
		await tween.finished
		cooldown_mat.set_shader_parameter("cooldown_progress", 0.0)
		item.used = false


func refresh_label() -> void:
	if item:
		label.text = str(item.stack)
		label.visible = item.stack_size != 0 and item.stack != 0
	else:
		label.visible = false
