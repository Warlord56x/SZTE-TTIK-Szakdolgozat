extends State
class_name StateParry

@onready var player: Player = owner as Player
@onready var parry_time: Timer = Timer.new()


func _ready() -> void:
	parry_time.wait_time = 0.3
	parry_time.one_shot = true
	add_child(parry_time)


func enter() -> void:
	parry_time.start()
	player.anim_tree["parameters/speed/scale"] = 1
	player.anim_state_m.travel("parry")
	await get_tree().create_timer(0.4).timeout
	travel("Default")


func physics_process(delta: float) -> void:
	var hb = player.get_node_or_null("HurtBox")
	if hb:
		pass
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta


func leave() -> void:
	parry_time.stop()


func _on_hurt_box_hurt() -> void:
	if active and parry_time.time_left > 0:
		print("parry")
		
	parry_time.stop()
	parry_time.start()
