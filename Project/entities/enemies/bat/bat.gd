extends Enemy
class_name Bat


func _ready() -> void:
	super._ready()
	hitbox.hit_callback = knock_back.bind(global_position, 0.5)


func detection_exited(body) -> void:
	if body == possible_target:
		possible_target = null
	if chase_timer.is_inside_tree():
		chase_timer.start()
