extends HBoxContainer

var previous_scales = {}


func _ready() -> void:
	for child: Control in get_children():
		previous_scales[child] = child.scale


func _process(_delta: float) -> void:
	for child: Control in get_children():
		var current_scale = child.scale
		if current_scale != previous_scales[child]:
			queue_sort()
			previous_scales[child] = current_scale
