extends Enemy
class_name Boss

@onready var boss: Boss = owner as Boss
@onready var boss_zone: BossZone = $BossZone
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var boss_weapon: BossWeaponScene = $BossWeapon


func _ready() -> void:
	super._ready()
	boss_zone.global_position = global_position
	boss_zone.set_up_zone(0, stats.max_health)
	random_zone_position()


func set_health(hp: int) -> void:
	super.set_health(hp)
	boss_zone.update_hp_progress(hp)


func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var theta = randf_range(0.0, TAU)
	var r = radius * sqrt(randf())
	var x = center.x + r * cos(theta)
	var y = center.y + r * sin(theta)
	return Vector2(x, y)


func random_zone_position() -> Vector2:
	randomize()

	var max_distance_x := boss_zone.get_rect().size.x / 2
	var max_distance_y := boss_zone.get_rect().size.y / 2

	var radius: float = max(max_distance_x, max_distance_y)

	return boss_zone.global_position + random_point_in_circle(Vector2(0,0), radius)


func physics_process(_delta: float) -> void:
	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0


func detection_exited(body) -> void:
	if body == possible_target:
		possible_target = null

	if body is Player and ai:
		possible_target = null
		state_machine.travel("Idle")
