extends CharacterBody2D
class_name Enemy

# Debug tool tip
const DEBUG_TIP : PackedScene = preload("res://debug/debug_info.tscn")
const SPLATTER := preload("res://assets/effects/splatter.tscn")
const DAMAGE_NUMBER := preload("res://assets/effects/damage_number.tscn")
const DEATH_SCENE_TEST := preload("res://assets/effects/death_effect.tscn")
const FLOATING_HP_BAR := preload("res://gui/floating_bar/floating_hp_bar.tscn")

@export var weapon_item: WeaponItem
@export var state_machine: StateMachine
@export var navigation_agent: NavigationAgent2D
@export var detect_range: Area2D
@export var travel_on_detect: State
@export var chase_timer: Timer
@export var sprite: Node2D
@export var movement_speed: float = 70
@export var limit_nav_axis: Vector2i = Vector2i.ONE
@export var min_jump_velocity: float = -100
@export var inv_time: float = 0.3
var health: int:
	set = set_health

@export var ai: bool = true
@export var debug: bool = false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var damage: int = 1:
	get = get_damage
var pushback_force: Vector2:
	set(value):
		value -= Vector2.ONE
		value += Vector2.ONE
		pushback_force = value

var possible_target: Player
var target: Player
var tool_tip_node: DebugInfo = DEBUG_TIP.instantiate()
var floating_hp_bar: FloatingHpBar = FLOATING_HP_BAR.instantiate()
var raycast: RayCast2D = RayCast2D.new()
var invincible: bool = false
var navmap_ready: bool = false
@export var stats: EntityStats:
	set = set_stats

@onready var initial_pos: Vector2

@export var hurtbox: Hurtbox 
@export var hitbox: Hitbox

var move_direction: float


func _init() -> void:
	tool_tip_node.anchor_point = Vector2(0, -5)
	tool_tip_node.anchor_preset = Control.PRESET_CENTER_BOTTOM
	add_child(tool_tip_node)


func set_health(h: int) -> void:
	health = h
	floating_hp_bar.value = h
	if health <= 0:
		death()


## Sets the stat object on the enemy.
## Updates [FloatingHpBar].
func set_stats(sts: EntityStats) -> void:
	stats = sts
	if not is_node_ready():
		await ready
	health = stats.max_health
	floating_hp_bar.max_value = stats.max_health
	floating_hp_bar.value = stats.max_health


## returns the weapons damage, or the default enemy damage if a weapon is not provided
func get_damage() -> int:
	if weapon_item:
		return weapon_item.calc_damage(stats)
	else:
		return damage


func _ready() -> void:
	agent_setup.call_deferred()
	tool_tip_node.visible = debug
	initial_pos = global_position

	floating_hp_bar.position = Vector2(0, -10)
	add_child(floating_hp_bar)
	floating_hp_bar.max_value = stats.max_health
	floating_hp_bar.value = health
	floating_hp_bar.effect = true

	for ch in get_children():
		if ch is Hitbox and not hitbox:
			hitbox = ch
		if ch is Hurtbox and not hurtbox:
			hurtbox = ch
	if not hurtbox:
		print("%s should have a hurtbox (currently: %)" % [name, hurtbox])

	add_child(raycast)
	if detect_range:
		detect_range.body_entered.connect(detection_entered)
		detect_range.body_exited.connect(detection_exited)


## Called defered to avoid bottlenecking the main thread.
## Ensures that the [NavigationAgent2D] is ready to be used
func agent_setup() -> void:
	# Wait for the NavigationServer to sync.
	if NavigationServer2D.get_maps().is_empty():
		await NavigationServer2D.map_changed
	await get_tree().process_frame
	navmap_ready = true

	# Now that the navigation map is no longer empty, set the movement target.
	initial_pos = global_position
	set_movement_target(initial_pos)


## Moves the enemy to the last known movement target.
func move() -> void:
	if not navmap_ready:
		return

	if !navigation_agent.is_navigation_finished():

		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position)
		new_velocity = new_velocity * movement_speed

		if pushback_force.length() < 0.1:
			if limit_nav_axis.x == 1:
				velocity.x = new_velocity.x
			if limit_nav_axis.y == 1:
				velocity.y = new_velocity.y
	else:
		if limit_nav_axis.x == 1:
			velocity.x = move_toward(velocity.x, 0, movement_speed)
		if limit_nav_axis.y == 1:
			velocity.y = move_toward(velocity.y, 0, movement_speed)


## Sets the [NavigationAgent2D]s target position to [param movement_target]
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _process(_delta : float) -> void:
	if debug:
		tool_tip_node.tool_tip = str(
			"Name: ", name, "\n",
			"\n",
			"Health: ", health, "/", stats.max_health, "\n",
			"Damage: ", damage, "\n",
			"AI: ", ai,"\n",
			"Target: ", target, "\n",
			"Invincible: ", invincible, "\n",
			"Attacking in: ", get_node_or_null("AttackTimer").time_left if get_node_or_null("AttackTimer") else 0, "\n",
			"Chasing: ", chase_timer.time_left if chase_timer else 0.0, "\n",
			"State: ", state_machine.current_state.name, "\n",
			"Position: ", global_position, "\n",
			"Knock_back: ", pushback_force, "\n",
			"Velocity: ", velocity, "\n",
			)


## Default physics operations
func _physics_process(delta: float) -> void:
	if velocity:
		move_direction = sign(velocity.x)

	if possible_target:
		raycast.target_position = to_local(possible_target.global_position)
		raycast.force_raycast_update()
		if raycast.get_collider() == possible_target:
			target = possible_target
			if state_machine.current_state.name.to_lower() == "idle":
				state_machine.travel(travel_on_detect.name)
				#print("stucking")

	physics_process(delta)
	velocity += pushback_force

	pushback_force = pushback_force.lerp(Vector2.ZERO, 0.5)

	move_and_slide()


## This function should be overloaded instead of the regular one
func physics_process(_delta: float) -> void:
	pass


## Active when the enemy is getting attacked
## Will make the enemy flash in white
func blinker(val: float) -> void:
	(sprite.material as ShaderMaterial).set_shader_parameter("blend", val)


## The default behavior for when the player enters the detection area.
func detection_entered(body) -> void:
	if state_machine.has_state("stun") and state_machine.is_active("stun"):
		return

	if body is Player and ai:
		possible_target = body


## The default behavior for when the player leaves the detection area.
## (Usually stars the chase timer).
func detection_exited(body) -> void:
	if state_machine.has_state("stun") and state_machine.is_active("stun"):
		return
	if body == possible_target:
		possible_target = null
		#target = null
	if body is Player and ai:
		state_machine.travel("Chase")


## Function that is called when the enemy is hurt.
## (When it's [Hurtbox] detects that a [Hitbox] is contacted)
func hurt(e_damage: int, dealer: Node2D = null) -> bool:
	if hurtbox:
		hurtbox.set_deferred("monitoring", false)

	var inv_tween = create_tween().set_loops(3)
	var inv_timer = get_tree().create_timer(inv_time)
	inv_tween.finished.connect(blinker_timeout)
	inv_timer.timeout.connect(invincibility_timeout)

	inv_tween.tween_method(blinker, 0.0, 1.0, 0.15)
	inv_tween.tween_method(blinker, 1.0, 0.0, 0.15)

	for intensity in e_damage:
		var splatter = SPLATTER.instantiate()
		splatter.global_position = global_position
		get_tree().root.add_child.call_deferred(splatter)

	var damage_number = DAMAGE_NUMBER.instantiate()
	damage_number.damage_number = e_damage
	damage_number.global_position = global_position
	get_tree().root.add_child.call_deferred(damage_number)

	health -= e_damage

	if dealer and dealer is Player:
		target = dealer
		if state_machine.get_state("idle").active:
			if not ai:
				return true
			state_machine.travel("chase")
	return true


## [param source_position] is from where the target is getting knocked back.
## [param intensity] is the amount of knockback.
func knock_back(source_position: Vector2, intensity: float = 1.0) -> bool:

	pushback_force = -global_position.direction_to(source_position) * intensity
	pushback_force.y = min_jump_velocity * intensity
	pushback_force.x *= movement_speed
	#pushback_force *= Vector2(limit_nav_axis)
	if state_machine.current_state == state_machine.get_state("knockback"):
		return true
	state_machine.travel("knockback")
	return true


## if a [BuffComponent] is present adds a new stun debuff to stop the enemy.
func stun() -> void:
	var buff_component = get_node_or_null("BuffComponent")
	if buff_component:
		var stun_buff = BuffStun.new()
		stun_buff.duration = 2.0
		buff_component.add_child(stun_buff)


## Restores the blinker to stop flashing
func blinker_timeout() -> void:
	blinker(0.0)


## Sets the hurtbox back to it's default state usually after an attack
func invincibility_timeout() -> void:
	hurtbox.set_deferred("monitoring", true)


## Frees the object, adds animations and registers the object for respawn
func death() -> void:
	var _death = DEATH_SCENE_TEST.instantiate()
	_death.global_position = global_position
	get_tree().root.add_child(_death)
	var data := {"position": initial_pos, "filename": scene_file_path, "parent": get_parent().get_path()}
	GameEnv.nodes_to_respawn.append(data)
	queue_free()


func _to_string() -> String:
	return str(
				"Name: ", name, "\n",
				"\n",
				"Health: ", health, "/", stats.max_health, "\n",
				"Damage: ", damage, "\n",
				"AI: ", ai,"\n",
				"Target: ", target, "\n",
				"State: ", state_machine.current_state.name, "\n",
				"Position: ", global_position, "\n",
				"Knock_back: ", pushback_force, "\n",
				"Velocity: ", velocity, "\n",
				)
