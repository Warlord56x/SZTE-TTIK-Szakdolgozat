extends Control
class_name BuffElement

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

var buff: Buff


func _ready() -> void:
	if buff:
		buff.tree_exited.connect(queue_free)


func _process(_delta: float) -> void:
	if buff:
		label.text = "%d" % buff.buff_timer.time_left
