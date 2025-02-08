extends Control
class_name BuffElement

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

var buff: Buff:
	set = set_buff


func set_buff(b: Buff) -> void:
	buff = b
	buff.tree_exited.connect(queue_free)


func _process(_delta: float) -> void:
	if not buff:
		return
	label.text = "%d s" % buff.buff_timer.time_left
