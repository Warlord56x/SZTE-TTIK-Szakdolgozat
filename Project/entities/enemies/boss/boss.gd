extends Enemy
class_name Boss

@onready var boss: Boss = owner as Boss
@onready var chase_timer := $ChaseTimer
@onready var boss_zone: BossZone = $BossZone
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var boss_weapon: BossWeaponScene = $BossWeapon


func _ready() -> void:
	super._ready()
	boss_zone.global_position = global_position


func random_zone_position() -> Vector2:
	randomize()

	var rand_x := randf_range(-100, 99)
	var rand_y := randf_range(-100, 99)
	var rand_vec := Vector2(rand_x, rand_y)

	if not boss_zone.get_rect().has_point(rand_vec):
		printerr("Point is not inside the zone!")
	return rand_vec


func physics_process(_delta: float) -> void:
	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player and ai:
		target = body
		state_machine.travel("Combat")


func _on_detect_range_body_exited(body: Node2D) -> void:
	if body is Player and ai:
		target = null
		state_machine.travel("Idle")
