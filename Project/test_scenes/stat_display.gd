@tool
extends HBoxContainer
class_name StatDisplay


@export var stat_name: String:
	set = set_stat_name
@export var stat: int:
	set = set_stat
@export var stat_scale: Scale.Scales:
	set = set_stat_scale

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
	var d := str(stat)
	if stat == 0:
		d = "-"
	stat_display.text = d


func set_stat_scale(sc: Scale.Scales) -> void:
	stat_scale = sc
	if not is_node_ready():
		await ready
	var d := str(Scale.Scales.find_key(sc))
	if stat_scale == Scale.Scales.NONE:
		d = "-"
	stat_display.text = d
