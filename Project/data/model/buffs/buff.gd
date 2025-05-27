extends Node
class_name Buff

@onready var buff_timer: Timer = Timer.new()
@export var buff_time: float
@export var buff_icon: Texture2D
@export var apply_to: Node


func _ready() -> void:
	buff_timer.wait_time = buff_time
	buff_timer.one_shot = true
	add_child(buff_timer)
	buff_timer.timeout.connect(buff_timeout)
	buff_timer.start()
	effect()


func effect() -> void:
	pass


func buff_timeout() -> void:
	queue_free()
