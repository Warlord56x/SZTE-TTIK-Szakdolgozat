extends CharacterBody2D
class_name Player

const SPEED := 80.0

const DROP := preload("res://assets/loot/pick_up.tscn")

const SPLATTER := preload("res://assets/effects/splatter.tscn")
const DAMAGE_NUMBER := preload("res://assets/effects/damage_number.tscn")

const MIN_JUMP_VELOCITY := -100.0
const MAX_JUMP_VELOCITY := -200.0

const MIN_AIRBORNE_TIME := 0.2

const DEFAULT_SPAWN_POINT := Vector2i(25, -20)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var pushback_force: Vector2 = Vector2.ZERO:
	set(value):
		# Make sure it goes to 0 0 not to -0 -0
		value -= Vector2.ONE
		value += Vector2.ONE
		pushback_force = value

enum player_res {
	HEALTH,
	MANA,
	STAMINA,
}

@export var inventory: Inventory

@onready var state_machine: StateMachine = $StateMachine
@onready var _coins : Control = %CoinLabel
@onready var weapon : AnimatedSprite2D = $Weapon
@onready var weapon_hitbox: Area2D = $Weapon/WeaponHitbox
@onready var interactor: Interactor = $Interactor

@onready var health_bar : Bar = %HealthBar
@onready var mana_bar : Bar = %ManaBar
@onready var stamina_bar : Bar = %StaminaBar

@onready var action_wheel : Container = %Wheel

@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_tree : AnimationTree = $AnimationTree

@onready var anim_state_m : AnimationNodeStateMachinePlayback = anim_tree["parameters/StateMachine/playback"]

@onready var camera : Camera2D = $Camera

@onready var stamina_time_waiter : Timer = Timer.new()
@onready var stamina_time : Timer = Timer.new()
@onready var stamina_wall_drainer : Timer = $WallStaminaDrain

@onready var mana_time_waiter : Timer = Timer.new()
@onready var mana_time : Timer = Timer.new()

@onready var health_time_waiter : Timer = Timer.new()
@onready var health_time : Timer = Timer.new()

@onready var sword_hit: AudioStreamPlayer2D = $SwordHit

@onready var move_direction : Vector2 = Vector2.RIGHT

var watch : Vector2i = Vector2i.ZERO
var crouch : bool = false
var airborne_time : float = 0

var input_direction: float

#var look_axis : Vector2 = Vector2.ZERO

var on_ladder : bool = false
var ladder_pos : float = 0.0

var checkpoint : Node2D:
	set = set_checkpoint

var dash_max : int = 1
var dash_count : int = 0

#region Collectibles
var max_coins : int = 9999
@export_range(0, 9999, 1, "suffix:coin") var coins : int = 0:
	set = set_coins

#@export_category("Arrow")
#@export_range(0, 100, 1, "suffix:Arrow") var max_arrows : int = 20
#@export_range(0, 20, 1, "suffix:Arrow") var arrows : int = 20:
	#set = set_arrows
#endregion

#region Health Variables
@export_category("Health")
var max_health : int = 20
@export_range(0.1, 2.0, 0.1, "suffix:s") var health_regen_wait_time : float = 1.0
@export_range(0.1, 2.0, 0.1, "suffix:s") var health_regen_time : float = 0.2
@export_range(0, 20, 1, "suffix:Health") var max_health_regen : int = 12
@export_range(0, 20, 1, "suffix:/interval") var health_regen : int = 1
@export_range(0, 20, 1, "suffix:Health") var health : int = 20:
	set = set_health
#endregion

#region Mana Variables
@export_category("Mana")
var max_mana : int = 20
@export_range(0.1, 2.0, 0.1, "suffix:s") var mana_regen_wait_time : float = 1.0
@export_range(0.1, 2.0, 0.1, "suffix:s") var mana_regen_time : float = 0.2
@export_range(0, 20, 1, "suffix:Mana") var max_mana_regen : int = 4
@export_range(0, 20, 1, "suffix:/interval") var mana_regen : int = 1
@export_range(0, 20, 1, "suffix:Mana") var mana : int = 20:
	set = set_mana
#endregion

#region Stamina Variables
@export_category("Stamina")
var max_stamina : int = 20
@export_range(0.1, 2.0, 0.1, "suffix:s") var stamina_regen_wait_time : float = 0.5
@export_range(0.1, 2.0, 0.1, "suffix:s") var stamina_regen_time : float = 0.1
@export_range(0, 20, 1, "suffix:Stamina") var max_stamina_regen : int = 20
@export_range(0, 20, 1, "suffix:/interval") var stamina_regen : int = 1
@export_range(0, 20, 1, "suffix:Stamina") var stamina : int = 20:
	set = set_stamina
@export_range(0.1, 2.0, 0.1, "suffix:s") var wall_drain_time : float = 0.1:
	set(t):
		await ready
		stamina_wall_drainer.wait_time = t
		wall_drain_time = t
#endregion


#region Setters
func set_mana(m : int) -> void:
	m = clamp(m, 0, max_mana)
	if mana > m:
		mana_time.stop()
	mana = m
	mana_bar.resource = m
	if m < max_mana_regen:
		mana_time_waiter.start()
	else:
		mana_time.stop()
		mana_time_waiter.stop()


func set_health(h : int) -> void:
	h = clamp(h, 0, max_health)
	if health > h:
		health_time.stop()
	health = h
	health_bar.resource = h
	if h < max_health_regen:
		health_time_waiter.start()
	else:
		health_time.stop()
		health_time_waiter.stop()


func set_stamina(s : int) -> void:
	s = clamp(s, 0, max_stamina)
	if stamina > s:
		stamina_time.stop()
	stamina = s
	stamina_bar.resource = s
	if s < max_stamina_regen:
		stamina_time_waiter.start()
	else:
		stamina_time.stop()
		stamina_time_waiter.stop()


#func set_arrows(a : int) -> void:
	#a = clamp(a, 0, max_arrows)
	#arrows = a
	#arrow_count.text = str(a)


func set_coins(c : int) -> void:
	clamp(c, 0, 9999)
	coins = c
	_coins.value = c


func set_checkpoint(c : Node2D) -> void:
	if checkpoint:
		checkpoint.deactivate()
	c.activate()
	checkpoint = c
#endregion


func _unhandled_input(event : InputEvent) -> void:

	if event.is_action_pressed("cast_spell"):
		if not state_machine.get_state("cast").active:
			state_machine.travel("cast")
			print("casting!")

	if event.is_action_pressed("dash"):
		if dash_count == dash_max or stamina == 0 or state_machine.get_state("dash").active:
			return
		state_machine.travel("dash")

	if event.is_action_pressed("jump") and is_on_floor() and stamina != 0:
		velocity.y = MAX_JUMP_VELOCITY
		stamina -= 2
	elif event.is_action_released("jump"):
		if velocity.y < MIN_JUMP_VELOCITY:
			velocity.y = MIN_JUMP_VELOCITY

	if event.is_action_pressed("interact"):
		if not state_machine.get_state("climb").active and on_ladder:
			state_machine.travel("climb")
		if interactor.get_interaction_type() == InteractionArea.INTERACTION_TYPE.DEAFULT:
			state_machine.travel("interact")

	watch.y = sign(Input.get_axis("look_down", "look_up"))
	if watch.y == 0:
		watch.y = sign(Input.get_axis("crouch", "stand"))
	watch.x = sign(Input.get_axis("look_left", "look_right"))

	if event.is_action_pressed("move_drop") and is_on_floor() and watch.y == -1:
		position.y += 1


	if event.is_action_pressed("test"):
		pass


func default_process(dir : float) -> void:
	if dir:
		velocity.x = dir * SPEED if watch.y == 0 else (dir * SPEED) * 0.5
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	dash_count = 0


func default_animations(dir: float) -> void:
	if dir:
		if watch.y == 0:
			anim_state_m.travel("run")
		elif watch.y == -1:
			anim_state_m.travel("run_crouch")
		else:
			anim_state_m.travel("run_look_up")
	else:
		if watch.y == 0:
			anim_state_m.travel("idle")
		elif watch.y == -1:
			anim_state_m.travel("idle_crouch")
		else:
			anim_state_m.travel("idle_look_up")
		if watch.x != 0:
			anim_sprite.flip_h = watch.x == -1
			anim_state_m.travel("run")

	if on_ladder:
		if watch.y == 0:
			anim_state_m.travel("climb_idle")
		elif watch.y == -1:
			anim_state_m.travel("climb_idle_crouch")
		else:
			anim_state_m.travel("climb_idle_look_up")

	anim_tree["parameters/speed/scale"] = dir


func regener(res : player_res) -> void:
	var res_string : String = player_res.keys()[res].to_lower()
	set(res_string, get(res_string) + get(res_string+"_regen"))


func regener_waiter(res : player_res) -> void:
	var res_string : String = player_res.keys()[res].to_lower()
	var timer : Timer = get(res_string+"_time")
	timer.start()


func init_regen_timer(res : player_res, waiter_time : float, regen_time : float) -> void:
	var res_string : String = player_res.keys()[res].to_lower()

	var time_waiter : Timer = get(res_string + "_time_waiter")
	var time_regener : Timer = get(res_string + "_time")

	time_waiter.wait_time = waiter_time
	time_waiter.one_shot = true
	time_waiter.timeout.connect(regener_waiter.bind(res))

	time_regener.wait_time = regen_time
	time_regener.timeout.connect(regener.bind(res))

	add_child(time_waiter)
	add_child(time_regener)


func request_interaction_visible(b : bool) -> void:
	$Label.visible = b


func is_interaction_available() -> bool:
	print("NO DON'T USE THIS, YOU'RE DUMB")
	return $Label.visible


func _ready() -> void:
	init_regen_timer(player_res.HEALTH, health_regen_wait_time, health_regen_time)
	init_regen_timer(player_res.MANA, mana_regen_wait_time, mana_regen_time)
	init_regen_timer(player_res.STAMINA, stamina_regen_wait_time, stamina_regen_time)


func blinker(val: float):
	($AnimatedSprite2D.material as ShaderMaterial).set_shader_parameter("blend", val)


func hurt(damage: int, _dealer: Node2D = null) -> void:
	health -= damage

	if health <= 0:
		state_machine.travel("Death")

	camera.add_trauma(0.2, 0.85)

	collision_mask = 8
	collision_layer = 8

	var inv_tween = get_tree().create_tween().set_loops(5)
	inv_tween.finished.connect(invincibility_timeout)

	inv_tween.tween_method(blinker, 0.0, 1.0, 0.15)
	inv_tween.tween_method(blinker, 1.0, 0.0, 0.15)

	for intensity in damage:
		var splatter = SPLATTER.instantiate()
		splatter.global_position = global_position
		add_child(splatter)

	var damage_number = DAMAGE_NUMBER.instantiate()
	damage_number.damage_number = damage
	damage_number.global_position = global_position
	add_child.call_deferred(damage_number)


func knock_back(source_position: Vector2, intensity: float = 1.0) -> void:
	pushback_force = -global_position.direction_to(source_position) * intensity
	pushback_force.y = MIN_JUMP_VELOCITY * intensity
	pushback_force.x *= SPEED


func _physics_process(_delta: float) -> void:
	input_direction = Input.get_axis("move_left", "move_right")
	if input_direction:
		move_direction.x = sign(input_direction)

	if pushback_force.length() > 0.1:
		input_direction = 0.0

	velocity += pushback_force

	anim_sprite.flip_h = move_direction.x < 0
	pushback_force = pushback_force.lerp(Vector2.ZERO, 0.5)


func _on_wall_stamina_drain_timeout() -> void:
	stamina -= 1


func _on_weapon_hitbox_body_entered(body : Node2D) -> void:
	if body is Enemy and body.has_method("hurt"):
		body = body as Enemy
		body.hurt(1)
		body.knock_back(global_position, 0.5)
		sword_hit.play()


func invincibility_timeout() -> void:
	collision_mask = 17
	collision_layer = 1
	blinker(0.0)
