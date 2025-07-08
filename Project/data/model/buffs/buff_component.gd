extends Node
class_name BuffComponent

const BUFF_ELEMENT := preload("res://gui/buff_element/buff_element.tscn")

@export var display_element: Control
@export var apply_to: Node


func _ready() -> void:
	child_entered_tree.connect(child_entered)


func child_entered(buff: Node) -> void:
	if buff is Buff:
		buff.apply_to = apply_to
		if not display_element:
			return
		if not buff.is_node_ready():
			await buff.ready
		var b_element = BUFF_ELEMENT.instantiate()
		b_element.buff = buff
		display_element.add_child(b_element)
