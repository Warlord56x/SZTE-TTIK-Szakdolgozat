@tool
extends HBoxContainer
class_name StatDisplay


@export var stat_name: String:
	set = set_stat_name
@export var stat: int:
	set = set_stat

@onready var stat_label: Label = $StatLabel
@onready var stat_display: Label = $StatDisplay



func set_stat_name(sn: String) -> void:
	stat_name = sn
	if not is_node_ready():
		await ready
	stat_label.text = stat_name + ":"


func set_stat(s: int) -> void:
	stat = s
	if not is_node_ready():
		await ready
	stat_display.text = str(stat)
