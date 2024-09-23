extends RigidBody2D

var damage_number: int = 1
@onready var label: Label = $Label
@export var wait_time: float = 1.0
@export var color: Color = Color.RED

signal animation_finished


func _ready() -> void:
	label.label_settings.font_color = color
	label.text = ("+" if -damage_number > 0 else "") + str(-damage_number)
	apply_central_impulse(Vector2(randi_range(-40, 40), -150))
	await create_tween().tween_property(label, "self_modulate:a", 0.0, wait_time).finished
	animation_finished.emit()
	queue_free()
