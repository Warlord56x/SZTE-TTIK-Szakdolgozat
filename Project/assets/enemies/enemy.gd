extends CharacterBody2D
class_name Enemy

# Debug tool tip
const debug_tip : PackedScene = preload("res://assets/enemies/enemy_tool_tip.tscn")
const SPLATTER := preload("res://assets/effects/splatter.tscn")
const DAMAGE_NUMBER := preload("res://assets/effects/damage_number.tscn")
const DEATH_SCENE_TEST := preload("res://test_scenes/death_test.tscn")

@export var state_machine: StateMachine
@export var sprite: Node2D
@export var movement_speed: float = 70
@export var min_jump_velocity: float = -100
@export var max_health: int = 10
@export var health: int = 10:
	set = health_set

@export var ai: bool = true
@export var debug: bool = false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var damage: int = 1
var pushback_force: Vector2:
	set(value):
		value -= Vector2.ONE
		value += Vector2.ONE
		pushback_force = value

var target: Player
var tool_tip_node: DebugInfo = debug_tip.instantiate()
var invincible: bool = false

@onready var initial_pos: Vector2

var move_direction: float


func health_set(h: int) -> void:
	health = h
	if health <= 0:
		death()


func _init() -> void:

	tool_tip_node.anchor_point = Vector2(0, -5)
	tool_tip_node.anchor_preset = Control.PRESET_CENTER_BOTTOM
	add_child(tool_tip_node)

	initial_pos = global_position



func _ready() -> void:
	tool_tip_node.visible = debug
	ready()


func ready() -> void:
	pass


func _process(_delta : float) -> void:
	if debug:
		tool_tip_node.tool_tip = str(
			"Name: ", name, "\n",
			"Node: ", self, "\n",
			"\n",
			"Health: ", health, "/", max_health, "\n",
			"AI: ", ai,"\n",
			"State: ", state_machine.current_state.name, "\n",
			"Position: ", global_position, "\n",
			"Knock_back: ", pushback_force, "\n",
			"velocity: ", velocity, "\n",
			)


func _physics_process(delta: float) -> void:
	if velocity:
		move_direction = sign(velocity.x)

	physics_process(delta)
	velocity += pushback_force

	pushback_force = pushback_force.lerp(Vector2.ZERO, 0.5)
	move_and_slide()


# This function should be overloaded instead of the regular one
func physics_process(_delta: float) -> void:
	pass


func blinker(val: float):
	(sprite.material as ShaderMaterial).set_shader_parameter("blend", val)


func hurt(e_damage: int, dealer: Node2D) -> bool:
	if invincible:
		return false

	invincible = true
	health -= e_damage

	var inv_tween = get_tree().create_tween().set_loops(3)
	inv_tween.finished.connect(invincibility_timeout)

	inv_tween.tween_method(blinker, 0.0, 1.0, 0.15)
	inv_tween.tween_method(blinker, 1.0, 0.0, 0.15)

	var splatter = SPLATTER.instantiate()
	splatter.global_position = global_position
	get_tree().root.add_child(splatter)

	if dealer:
		target = dealer
		if state_machine.get_state("idle").active:
			if not ai:
				return true
			state_machine.travel("chase")
	return true


func knock_back(source_position: Vector2, intensity: float = 1.0) -> bool:
	if invincible:
		return false

	pushback_force = -global_position.direction_to(source_position) * intensity
	pushback_force.y = min_jump_velocity * intensity
	pushback_force.x *= movement_speed
	return true


func invincibility_timeout() -> void:
	blinker(0.0)
	invincible = false


func death() -> void:
	var _death = DEATH_SCENE_TEST.instantiate()
	_death.global_position = global_position
	get_tree().root.add_child(_death)
	queue_free()
