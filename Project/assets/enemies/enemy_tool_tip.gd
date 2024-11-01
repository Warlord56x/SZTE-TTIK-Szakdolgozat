extends Control
class_name DebugInfo


@export var anchor_point: Vector2 = Vector2(0, 0)
@export var anchor_preset: Control.LayoutPreset = Control.PRESET_CENTER_TOP
var tool_tip: String = ""
@onready var tp_node: Label = $Label


func _ready() -> void:
	tp_node.text = tool_tip
	await get_tree().create_timer(0.1).timeout
	position = anchor_point
	tp_node.set_anchors_and_offsets_preset(anchor_preset)


func _process(_delta: float) -> void:
	tp_node.text = tool_tip
