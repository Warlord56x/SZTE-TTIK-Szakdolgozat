extends Buff
class_name BuffPeriodicEffect


@onready var interval_timer: Timer = Timer.new()
@export var buff_interval: float


func _ready() -> void:
	interval_timer.wait_time = buff_interval
	add_child(interval_timer)
	interval_timer.timeout.connect(interval_timeout)
	interval_timer.start()
	super._ready()


func interval_timeout() -> void:
	effect()
