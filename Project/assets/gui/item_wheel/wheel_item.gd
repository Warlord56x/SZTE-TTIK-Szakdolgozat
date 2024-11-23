@tool
extends Control
class_name WheelItem


@onready var back_ground: Sprite2D = $BackGround
@onready var label: Label = $Label
@onready var panel: Panel = $Label/Panel
@onready var for_ground: Sprite2D = $ForGround
@onready var item_rect: TextureRect = $ItemRect


@export var item : Item = null:
	set(it):
		if it:
			item_rect.texture = it.icon
		else:
			item_rect.texture = null

		if item != null:
			if item.stack_changed.is_connected(refresh_label):
				item.stack_changed.disconnect(refresh_label)
			item = it

			if it:
				item.stack_changed.connect(refresh_label)
		else:
			item = it
		refresh_label()


@export var focus : bool = false:
	set(f):
		if not is_node_ready():
			await ready
		for_ground.visible = f
		focus = f


func _ready() -> void:
	refresh_label()


func refresh_label() -> void:
	if item:
		label.text = str(item.stack)
		label.visible = item.stack_size != 0 and item.stack != 0
	else:
		label.visible = false
