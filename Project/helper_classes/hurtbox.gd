@tool
extends Area2D
class_name Hurtbox

@export var parent_ref: Node2D = owner
@export var ignore_enemy: bool = false

signal hurt


func _init() -> void:
	input_pickable = false
	collision_layer = 0
	collision_mask = 64
	monitoring = true
	monitorable = false


func _ready() -> void:
	area_entered.connect(hurtbox_entered)


func hurtbox_entered(hitbox: Node2D) -> void:
	hitbox = hitbox as Hitbox

	if hitbox.parent_ref == parent_ref:
		return
	if ignore_enemy and hitbox.parent_ref is Enemy:
		return

	if hitbox.hit_callback:
		hitbox.hit_callback.call()

	if parent_ref.has_method("hurt"):
		if parent_ref.state_machine:
			if parent_ref.state_machine.is_active("parry"):
				hitbox.parent_ref.stun()
				return
		if parent_ref.hurt(hitbox.damage, hitbox.parent_ref):
			if hitbox.sound_on_hit:
				hitbox.sound_on_hit.play()
			hurt.emit()
		parent_ref.knock_back(hitbox.parent_ref.global_position, hitbox.knock_back_strength)
