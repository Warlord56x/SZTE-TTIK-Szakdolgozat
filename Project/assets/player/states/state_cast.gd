extends State
class_name StateCast

const projectile: PackedScene = preload("res://assets/player/projectile.tscn")


@onready var player: Player = owner as Player

var projectile_instance: Projectile


func enter() -> void:
	var item: Item = player.action_wheel.get_wheel_selection()
	var anim_tree = player.anim_tree
	var anim_state_m = player.anim_state_m

	player.anim_tree["parameters/speed/scale"] = 1

	if item and item.name.to_lower() == "fireball":
		if player.mana == 0:
			travel("default")
			return
		anim_state_m.travel("cast_spell")
		await anim_tree.animation_finished
		player.mana -= 1

	if item and item.name.to_lower() == "bow":
		if player.stamina == 0 or item.stack == 0:
			travel("default")
			return
		anim_state_m.travel("fire_bow")
		await anim_tree.animation_finished
		player.stamina -= 1
		player.inventory.remove_item(item)

	# Prep the Projectile
	if item and item is RangedItem:
		projectile_instance = projectile.instantiate() as Projectile
		projectile_instance.type = int(item.name.to_lower() == "fireball")
		projectile_instance.direction = player.move_direction
		var target = player.global_position + player.move_direction
		projectile_instance.p_rotation = player.global_position.angle_to_point(target)
		projectile_instance.position = player.position
		player.add_child(projectile_instance)
		projectile_instance.owner = player

	if item and item.name.to_lower() == "hammer":
		if player.stamina == 0:
			travel("default")
			return
		player.weapon.animation = "default"

		var tween : Tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(player.weapon, "position", Vector2(player.move_direction.x * 8, 0), 0.3)
		tween.play()

		anim_state_m.travel("hit")
		player.weapon.flip_h = player.move_direction.x < 0
		player.weapon.position = Vector2(0, -8)

		await anim_tree.animation_finished

		player.weapon.position = Vector2(0, -8)
		player.stamina -= 1

	if item and item.name.to_lower() == "sword":
		if player.stamina == 0:
			travel("default")
			return
		player.weapon.animation = "sword"

		var tween : Tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(player.weapon, "position", Vector2(player.move_direction.x * 8, 0), 0.3)
		tween.play()
		$"../../SwordSwing".play()

		anim_state_m.travel("hit")
		player.weapon.flip_h = player.move_direction.x < 0
		player.weapon.position = Vector2(0, -8)

		await anim_tree.animation_finished

		player.weapon.position = Vector2(0, -8)
		player.stamina -= 1

	travel("default")


func physics_process(delta: float) -> void:
	player.default_process(player.input_direction)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
