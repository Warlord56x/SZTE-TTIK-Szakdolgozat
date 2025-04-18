extends Label

const MAX_VALUE: int = 9999

@onready var parent: Control = get_parent()


var value : int = 0:
	set = set_value


func set_value(v: int) -> void:
	v = clamp(v, 0, MAX_VALUE)
	var num = str(v).lpad(4, "0")
	text = num
	display()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("test_2"):
		display()


func display() -> void:
	var tween = create_tween()
	tween.tween_property(parent, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(parent, "scale", Vector2.ONE, 1.0)
	tween.tween_property(parent, "scale", Vector2.ZERO, 0.1)
	await tween.finished


func _ready() -> void:
	parent.pivot_offset.x = parent.size.x / 2
	var tween = create_tween()
	tween.tween_property(parent, "scale", Vector2.ZERO, 0.1)
