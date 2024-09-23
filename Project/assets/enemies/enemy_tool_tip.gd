extends Control


var tool_tip : String = ""
@onready var tp_node : Label = $Label


func _ready() -> void:
	tp_node.text = tool_tip


func _process(_delta: float) -> void:
	tp_node.text = tool_tip


func _on_visibility_changed() -> void:
	tp_node.text = tool_tip
	global_position = get_global_mouse_position() + (tp_node.get_minimum_size() / 2)
