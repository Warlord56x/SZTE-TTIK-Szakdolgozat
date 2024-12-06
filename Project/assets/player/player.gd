extends CharacterBody2D
class_name Player

const DAMAGE_NUMBER := preload("res://assets/effects/damage_number.tscn")
const SPLATTER := preload("res://assets/effects/splatter.tscn")
const DROP := preload("res://assets/loot/pick_up.tscn")

const SPEED := 80.0
const MIN_JUMP_VELOCITY := -100.0
const MAX_JUMP_VELOCITY := -200.0
const MIN_AIRBORNE_TIME := 0.2

const DEFAULT_SPAWN_POINT := Vector2i(25, -20)

enum player_res {
	HEALTH,
	MANA,
	STAMINA,
}

var inventory: Inventory = Inventory.new()
@export var tool_tip_node: DebugInfo
@export var debug: bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var _coins: Control = %CoinLabel
@onready var weapon: AnimatedSprite2D = %Weapon
@onready var weapon_hitbox: Hitbox = %Weapon/Hitbox
@onready var interactor: Interactor = $Interactor

@onready var buff_display: HBoxContainer = %BuffDisplay

@onready var health_bar: Bar = %HealthBar
@onready var mana_bar: Bar = %ManaBar
@onready var stamina_bar: Bar = %StaminaBar

@onready var action_wheel: ItemWheel = %Wheel

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_tree: AnimationTree = $AnimationTree

@onready var anim_state_m: AnimationNodeStateMachinePlayback = anim_tree["parameters/StateMachine/playback"]

@onready var camera: MainCamera = $Camera

@onready var stamina_time_waiter: Timer = Timer.new()
@onready var stamina_time: Timer = Timer.new()
@onready var stamina_wall_drainer: Timer = $WallStaminaDrain

@onready var mana_time_waiter: Timer = Timer.new()
@onready var mana_time: Timer = Timer.new()

@onready var health_time_waiter: Timer = Timer.new()
@onready var health_time: Timer = Timer.new()

@onready var sword_hit: AudioStreamPlayer2D = $SwordHit
@onready var sword_swing: AudioStreamPlayer2D = $SwordSwing

@onready var move_direction: Vector2 = Vector2.RIGHT

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var pushback_force: Vector2 = Vector2.ZERO:
	set(value):
		# Make sure it goes to 0 0 not to -0 -0
		value -= Vector2.ONE
		value += Vector2.ONE
		pushback_force = value

var watch: Vector2i = Vector2i.ZERO
var airborne_time: float = 0

var input_direction: float

var on_ladder: bool = false
var ladder_pos: float = 0.0

var checkpoint: Checkpoint:
	set = set_checkpoint

var camp: Camp = null:
	set = set_camp

var dash_max: int = 1
var dash_count: int = 0

@export var inv_time = 0.1


#region Collectibles
var max_coins: int = 9999
@export_range(0, 9999, 1, "suffix:coin") var coins: int = 0:
	set = set_coins
#endregion

#region Health Variables
@export_category("Health")
var max_health: int = 20
@export_range(0.1, 2.0, 0.1, "suffix:s") var health_regen_wait_time: float = 1.0
@export_range(0.1, 2.0, 0.1, "suffix:s") var health_regen_time: float = 0.2
@export_range(0, 20, 1, "suffix:Health") var max_health_regen: int = 12
@export_range(0, 20, 1, "suffix:/interval") var health_regen: int = 1
@export_range(0, 20, 1, "suffix:Health") var health: int = 20:
	set = set_health
#endregion

#region Mana Variables
@export_category("Mana")
var max_mana: int = 20
@export_range(0.1, 2.0, 0.1, "suffix:s") var mana_regen_wait_time: float = 1.0
@export_range(0.1, 2.0, 0.1, "suffix:s") var mana_regen_time: float = 0.2
@export_range(0, 20, 1, "suffix:Mana") var max_mana_regen: int = 4
@export_range(0, 20, 1, "suffix:/interval") var mana_regen: int = 1
@export_range(0, 20, 1, "suffix:Mana") var mana: int = 20:
	set = set_mana
#endregion

#region Stamina Variables
@export_category("Stamina")
var max_stamina : int = 20
@export_range(0.1, 2.0, 0.1, "suffix:s") var stamina_regen_wait_time: float = 0.5
@export_range(0.1, 2.0, 0.1, "suffix:s") var stamina_regen_time: float = 0.1
@export_range(0, 20, 1, "suffix:Stamina") var max_stamina_regen: int = 20
@export_range(0, 20, 1, "suffix:/interval") var stamina_regen: int = 1
@export_range(0, 20, 1, "suffix:Stamina") var stamina: int = 20:
	set = set_stamina
@export_range(0.1, 2.0, 0.1, "suffix:s") var wall_drain_time: float = 0.1:
	set(t):
		if not is_node_ready():
			await ready
		stamina_wall_drainer.wait_time = t
		wall_drain_time = t
#endregion


#region Setters
func set_mana(m: int) -> void:
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


func set_health(h: int) -> void:
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


func set_stamina(s: int) -> void:
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


func set_coins(c: int) -> void:
	clamp(c, 0, 9999)
	coins = c
	#_coins.value = c


func set_checkpoint(c: Checkpoint) -> void:
	if checkpoint:
		checkpoint.deactivate()
	checkpoint = c
	c.activate()


func set_camp(c: Camp) -> void:
	camp = c
	c.activate()
#endregion


func _unhandled_input(event: InputEvent) -> void:
	if not GameEnv.input_process:
		return

# Should do a parry
	if event.is_action_pressed("test"):
		if not state_machine.get_state("parry").active:
			state_machine.travel("parry")

	if event.is_action_pressed("cast_spell"):
		if not state_machine.get_state("cast").active:
			state_machine.travel("cast")

	if event.is_action_pressed("dash"):
		if dash_count == dash_max or stamina == 0 or state_machine.get_state("dash").active:
			return
		state_machine.travel("dash")

	if event.is_action_pressed("move_drop") and is_on_floor() and watch.y == -1:
		position.y += 1
		return

	if event.is_action_pressed("jump") and is_on_floor() and stamina != 0:
		velocity.y = MAX_JUMP_VELOCITY
		stamina -= 2
	elif event.is_action_released("jump"):
		if velocity.y < MIN_JUMP_VELOCITY:
			velocity.y = MIN_JUMP_VELOCITY

	watch.y = sign(Input.get_axis("look_down", "look_up"))
	if watch.y == 0:
		watch.y = sign(Input.get_axis("crouch", "stand"))
	watch.x = sign(Input.get_axis("look_left", "look_right"))


func default_process(dir: float) -> void:
	if dir:
		var base_speed = dir * SPEED
		velocity.x = base_speed if watch.y == 0 else base_speed * 0.5
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


func regener(res: player_res) -> void:
	var res_string: String = player_res.keys()[res].to_lower()
	set(res_string, get(res_string) + get(res_string+"_regen"))


func regener_waiter(res: player_res) -> void:
	var res_string: String = player_res.keys()[res].to_lower()
	var timer: Timer = get(res_string+"_time")
	timer.start()


func init_regen_timer(res: player_res, waiter_time: float, regen_time: float) -> void:
	var res_string: String = player_res.keys()[res].to_lower()

	var time_waiter: Timer = get(res_string + "_time_waiter")
	var time_regener: Timer = get(res_string + "_time")

	time_waiter.wait_time = waiter_time
	time_waiter.one_shot = true
	time_waiter.timeout.connect(regener_waiter.bind(res))

	time_regener.wait_time = regen_time
	time_regener.timeout.connect(regener.bind(res))

	add_child(time_waiter)
	add_child(time_regener)


func request_interaction_visible(b: bool) -> void:
	%InteractHelper.visible = b


func save() -> Dictionary:
	
	var test = []
	for item in inventory.get_items():
		test.append(item.duplicate())
	
	return {
		"filename" : get_scene_file_path(),
		"parent": get_parent().get_path(),
		"health" : health,
		"mana" : mana,
		"coins" : coins,
		"camp" : camp.camp_name if camp else &"",
		"inventory" : test
	}


func _ready() -> void:
	if global_position == Vector2.ZERO:
		global_position = DEFAULT_SPAWN_POINT
	tool_tip_node.visible = debug

	init_regen_timer(player_res.HEALTH, health_regen_wait_time, health_regen_time)
	init_regen_timer(player_res.MANA, mana_regen_wait_time, mana_regen_time)
	init_regen_timer(player_res.STAMINA, stamina_regen_wait_time, stamina_regen_time)

	if inventory:
		action_wheel.inventory = inventory
		inventory.items_changed.connect(items_changed)


func items_changed(item: Item) -> void:
	if not item:
		return
	if item.name.to_lower() == "coin":
		_coins.value = item.stack
	print("\nItems changed")
	for _item in inventory.get_items():
		prints(_item.name, _item.stack)


func blinker(val: float):
	($AnimatedSprite2D.material as ShaderMaterial).set_shader_parameter("blend", val)


func hurt(damage: int, _dealer: Node2D = null) -> bool:
	if has_node("HurtBox"):
		$HurtBox.set_deferred("monitoring", false)

	health -= damage

	if health <= 0:
		if state_machine.current_state.name.to_lower() != "death":
			state_machine.travel("Death")

	camera.add_trauma(0.2, 0.85)

	var inv_tween = create_tween().set_loops(3)
	var inv_timer = get_tree().create_timer(inv_time)
	inv_tween.finished.connect(blinker_timeout)
	inv_timer.timeout.connect(invincibility_timeout)

	inv_tween.tween_method(blinker, 0.0, 1.0, 0.15)
	inv_tween.tween_method(blinker, 1.0, 0.0, 0.15)

	for intensity in damage:
		var splatter = SPLATTER.instantiate()
		splatter.global_position = global_position
		get_tree().root.add_child(splatter)

	var damage_number = DAMAGE_NUMBER.instantiate()
	damage_number.damage_number = damage
	damage_number.global_position = global_position
	add_child.call_deferred(damage_number)
	return true


func knock_back(source_position: Vector2, intensity: float = 1.0) -> bool:
	pushback_force = -global_position.direction_to(source_position) * intensity
	pushback_force.y = MIN_JUMP_VELOCITY * intensity
	pushback_force.x *= SPEED
	return true


func _process(_delta: float) -> void:
	if debug:
		tool_tip_node.tool_tip = str(
			"Name: ", name, "\n",
			"Node: ", self, "\n",
			"\n",
			"Health: ", health, "/", max_health, "\n",
			"State: ", state_machine.current_state.name, "\n",
			"State: ", anim_state_m.get_current_node(), "\n",
			"Invincible: ", collision_layer == 8, "\n",
			"Position: ", global_position, "\n",
			"Knock_back: ", pushback_force, "\n",
			"Velocity: ", velocity, "\n",
			)


func _physics_process(_delta: float) -> void:
	if GameEnv.input_process:
		input_direction = Input.get_axis("move_left", "move_right")

	if input_direction:
		move_direction.x = sign(input_direction)

	if pushback_force.length() > 0.01:
		input_direction = 0.0

	velocity += pushback_force

	anim_sprite.flip_h = move_direction.x < 0
	pushback_force = pushback_force.lerp(Vector2.ZERO, 0.5)


func _on_wall_stamina_drain_timeout() -> void:
	stamina -= 1


func blinker_timeout() -> void:
	blinker(0.0)


func invincibility_timeout() -> void:
	if has_node("HurtBox"):
		$HurtBox.set_deferred("monitoring", true)
