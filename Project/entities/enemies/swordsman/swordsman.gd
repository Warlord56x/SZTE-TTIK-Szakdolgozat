extends Enemy
class_name Swordsman

@onready var weapon: AnimatedSprite2D = %Weapon
@onready var weapon_pivot: Node2D = %WeaponPivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_hit: AudioStreamPlayer2D = $SwordHit
@onready var weapon_hitbox: Hitbox = %Hitbox


func _ready() -> void:
	super._ready()
	weapon_hitbox.damage = damage
	weapon_hitbox.monitorable = false


func physics_process(_delta: float) -> void:

	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0
