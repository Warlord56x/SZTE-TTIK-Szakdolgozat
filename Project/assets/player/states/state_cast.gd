extends State
class_name StateCast

const PROJECTILE: PackedScene = preload("res://assets/player/projectile.tscn")


@onready var player: Player = owner as Player

var projectile_instance: Projectile


func enter() -> void:
	var item: Item = player.action_wheel.get_wheel_selection()
	var anim_tree = player.anim_tree
	var anim_state_m = player.anim_state_m

	player.anim_tree["parameters/speed/scale"] = 1

	if not item or (item and item.used):
		travel("default")
		return
	item.used = true

	if item is WeaponItem:
		player.weapon_hitbox.damage = item.damage * player.stats.strength

	if item.name.to_lower() == "fireball":
		if player.mana == 0:
			travel("default")
			return
		anim_state_m.travel("cast_spell")
		await anim_tree.animation_finished
		player.mana -= 1

	if item.name.to_lower() == "bow":
		if player.stamina == 0 or item.stack == 0:
			travel("default")
			return
		anim_state_m.travel("fire_bow")
		await anim_tree.animation_finished
		player.stamina -= 1
		player.inventory.remove_item(item)

	# Prep the Projectile
	if item is RangedWeaponItem:
		projectile_instance = PROJECTILE.instantiate() as Projectile
		projectile_instance.type = int(item.name.to_lower() == "fireball")
		projectile_instance.direction = player.move_direction

		var target = player.global_position + player.move_direction
		projectile_instance.p_rotation = player.global_position.angle_to_point(target)
		projectile_instance.position = player.position
		projectile_instance.parent_ref = player
		projectile_instance.damage = item.damage
		if bool(item.name.to_lower() == "fireball"):
			projectile_instance.damage *= player.stats.intelligence
		else:
			projectile_instance.damage *= player.stats.dexterity
		player.add_child(projectile_instance)

	if item.name.to_lower() == "hammer":
		if player.stamina == 0:
			travel("default")
			return
		player.weapon.animation = "default"
		anim_state_m.travel("hit")
		await anim_tree.animation_finished

		player.stamina -= 1

	if item.name.to_lower() == "sword":
		if player.stamina == 0:
			travel("default")
			return
		player.weapon.animation = "sword"
		player.sword_swing.play()
		anim_state_m.travel("hit")
		await anim_tree.animation_finished

		player.stamina -= 1

	if item is ConsumableItem:
		if item.stack == 0:
			travel("default")
			return
		item.consume(player)
		player.inventory.remove_item(item)

	travel("default")


func physics_process(delta: float) -> void:
	player.default_process(player.input_direction)
	player.velocity.y += player.gravity * delta

	if player.move_direction.x != 1:
		%WeaponPivot.scale.x = -1
	else:
		%WeaponPivot.scale.x = 1
	player.move_and_slide()
