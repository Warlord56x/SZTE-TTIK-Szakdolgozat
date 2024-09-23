@tool
extends Button
class_name ItemTest

const item_frames : SpriteFrames = preload("res://test_ui/item_frames.tres")

enum item_types {
	WEAPON,
	SPELL,
	CONSUMABLE,
}

var data : Dictionary = {
	"type" : 0,
	"icon" : 0,
	"name" : "asd",
	"item_frame" : 0,
	"max_stack_size" : 1,
	"stack" : 1,
}

enum pre_defined {
	HEALTH_POTION,
	MANA_POTION,
	SWORD,
	BOW,
	FIREBALL,
}

var dragging : bool = false

@export var item_type : item_types = item_types.WEAPON:
	set = set_item_type
@export var item_name : String = "asd":
	set = set_item_name
@export var frame : int = 0:
	set = set_frame


func set_frame(f : int) -> void:
	frame = f
	data["item_frame"] = f
	if get_child_count() != 0:
		get_child(0).frame = f


func set_item_type(t : item_types) -> void:
	item_type = t
	data.type = t


func set_item_name(n : String) -> void:
	item_name = n
	data.name = n
	text = n


static func make_predefined(type : int) -> ItemTest:
	var item = ItemTest.new()
	match type:
		pre_defined.HEALTH_POTION:
			item.data["type"] = item_types.CONSUMABLE
			item.data["max_stack_size"] = 4
			item.data["stack"] = 1
			item.data["name"] = "Health Potion"
			item.text = "Health Potion"
		pre_defined.MANA_POTION:
			item.data["type"] = item_types.CONSUMABLE
			item.data["max_stack_size"] = 4
			item.data["stack"] = 1
			item.data["name"] = "Mana Potion"
			item.text = "Mana Potion"
		pre_defined.SWORD:
			item.data["type"] = item_types.WEAPON
			item.data["max_stack_size"] = 1
			item.data["stack"] = 1
			item.data["name"] = "Basic Sword"
			item.text = "Basic Sword"
		pre_defined.BOW:
			item.data["type"] = item_types.WEAPON
			item.data["max_stack_size"] = 1
			item.data["stack"] = 1
			item.data["name"] = "Basic Bow"
			item.text = "Basic Bow"
	return item


static func make_item(_data : Dictionary) -> ItemTest:
	var item = ItemTest.new()
	item.custom_minimum_size = Vector2(50,50)
	item.data = _data
	item.text = _data.name
	item.frame = _data.item_frame
	return item


func _ready() -> void:
	if get_child_count() == 0:
		var frames := item_frames
		var sprite := AnimatedSprite2D.new()
		sprite.scale = Vector2(5,5)
		sprite.offset = Vector2(5,5)
		sprite.sprite_frames = frames
		sprite.frame = frame
		add_child(sprite)


func _get_drag_data(_at_position : Vector2) -> Variant:
	set_drag_preview(self.duplicate())
	dragging = true
	return data


func _notification(what : int) -> void:
	if what == NOTIFICATION_DRAG_END and is_drag_successful() and dragging:
		queue_free()
	elif what == NOTIFICATION_DRAG_END and !is_drag_successful():
		dragging = false
