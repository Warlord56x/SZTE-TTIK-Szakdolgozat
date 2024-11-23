extends Node2D
class_name Buff

@onready var buff_timer: Timer = $BuffTimer
@onready var interval_timer: Timer = $IntervalTimer

@export var buff_time: float
@export var buff_interval: float


func _ready() -> void:
	buff_timer.wait_time = buff_time
	interval_timer.wait_time = buff_interval
	interval_timer.start()
	buff_timer.start()


func _on_buff_timer_timeout() -> void:
	queue_free()


func _on_interval_timer_timeout() -> void:
	get_parent().health += 1
	print("buff")
