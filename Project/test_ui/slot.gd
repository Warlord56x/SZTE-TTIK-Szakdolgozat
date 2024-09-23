extends Button
#class_name Slot


enum slot_type {
	WEAPON,
	SPELL,
}

@onready var inventory_ref : GridContainer = %Inventory

@export var type : slot_type = slot_type.WEAPON
var slot_data : Dictionary = {}

var dragging : bool = false


func _can_drop_data(_at_position : Vector2, data : Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type") and type == data.type


func _drop_data(_at_position : Vector2, data : Variant) -> void:
	#if !slot_data.is_empty():
		#var item : Item = Item.make_item(slot_data)
		#inventory_ref.add_child(item)
	slot_data = data
	text = slot_data.name
	get_child(0).frame = slot_data.item_frame


func _get_drag_data(_at_position : Vector2) -> Variant:
	if slot_data.is_empty():
		return null
	var preview = Button.new()
	preview.size = Vector2(50,50)
	preview.text = slot_data.name
	set_drag_preview(preview)
	dragging = true
	return {
		"data" : slot_data,
		"slot" : true,
	}


func _notification(what : int) -> void:
	if what == NOTIFICATION_DRAG_END and is_drag_successful() and dragging:
		slot_data = {}
		text = ""
		get_child(0).frame = 0
		dragging = false
