extends Enemy
class_name Mage

var movement_target_position: Vector2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


#region Navigation setup
func ready():
	# Make sure to not await during _ready.
	actor_setup.call_deferred()


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	initial_pos = global_position
	set_movement_target(initial_pos)


func move() -> void:

	if !navigation_agent.is_navigation_finished():

		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position)
		new_velocity = new_velocity * movement_speed

		if pushback_force.length() < 0.1:
			velocity.x = new_velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
#endregion


func physics_process(_delta: float) -> void:

	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not invincible:
		body.hurt(1)
		body.knock_back(global_position, 0.6)


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player:
		target = body
		if not ai:
			return
		state_machine.travel("combat")


func _on_detect_range_body_exited(body : Node2D) -> void:
	if body is Player:
		target = body
		if not ai:
			return
		state_machine.travel("Chase")
