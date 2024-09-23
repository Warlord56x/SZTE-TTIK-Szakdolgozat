extends Enemy
class_name Bat

var movement_target_position: Vector2
var knockback_vel: Vector2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var chase_timer: Timer = $ChaseTimer


func _ready():
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	initial_pos = global_position
	movement_target_position = initial_pos
	set_movement_target(movement_target_position)


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func move() -> void:
	velocity = Vector2.ZERO
	if target:
		set_movement_target(target.global_position)
	if !navigation_agent.is_navigation_finished():
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position)
		#print(new_velocity, target.global_position if target else 0)
		new_velocity = new_velocity * movement_speed

		
		velocity += new_velocity


func _physics_process(_delta : float) -> void:

	if health <= 0:
		queue_free()

	move_and_slide()


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player:
		target = body
		chase_timer.stop()


func _on_chase_timer_timeout():
	target = null
	set_movement_target(initial_pos)


func _on_detect_range_body_exited(body : Node2D) -> void:
	if body is Player and body == target and chase_timer.is_inside_tree():
		chase_timer.start()
