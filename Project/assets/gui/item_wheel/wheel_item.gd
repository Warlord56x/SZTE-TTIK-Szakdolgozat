@tool
extends Control
class_name WheelItem

@export var item : Item = null:
	set(it):
		if it:
			$TextureRect.texture = it.icon
		else:
			$TextureRect.texture = null

		if item != null:
			if item.used.is_connected(refresh_label):
				item.used.disconnect(refresh_label)
			item = it

			if it:
				item.used.connect(refresh_label)
		else:
			item = it
		refresh_label()


@export var focus : bool = false:
	set(f):
		$ForGround.visible = f
		focus = f


func _ready() -> void:
	refresh_label()


func refresh_label() -> void:
	if item:
		$Label.text = str(item.stack)
		$Label.visible = item.stack_size != 0 and item.stack != 0
	else:
		$Label.visible = false
