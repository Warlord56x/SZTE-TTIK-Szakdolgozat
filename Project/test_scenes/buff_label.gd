extends Label
class_name BuffLabel

var _buff: Buff

func _init(buff: Buff) -> void:
	_buff = buff
	buff.tree_exited.connect(queue_free)


func _process(_delta: float) -> void:
	if _buff:
		text = "%d" % _buff.buff_timer.time_left
