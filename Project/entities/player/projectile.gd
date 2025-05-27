extends CharacterBody2D

class_name Projectile

const PROJECTILE_SPEED: int = 300

@export var direction: Vector2
@export var p_rotation: float
@export var override_speed: int
@export var type: int = 0
@export var damage: int = 1

var parent_ref: Node2D

@onready var hitbox: Hitbox = $Hitbox
@onready var animation: AnimatedSprite2D = $Animation


func _ready() -> void:
	global_rotation = p_rotation
	if !override_speed:
		velocity = direction * PROJECTILE_SPEED
	else:
		velocity = direction * override_speed
	$PointLight2D.visible = bool(type)
	match type:
		0:
			animation.play("a_default")
			$BowAudio.play()
			hitbox.sound_on_hit = $BowImpact
			hitbox.knock_back_strength = 0.4
		1:
			animation.play("f_default")
			$FireAudio.play()
			hitbox.sound_on_hit = $FireImpact
			hitbox.knock_back_strength = 0.2
	hitbox.parent_ref = parent_ref
	hitbox.hit_callback = finished_callback
	hitbox.damage = damage


func _physics_process(_delta : float) -> void:
	if get_last_slide_collision() != null:
		finished_callback()
	move_and_slide()


# Making sure that it gets freed even if it does not hit anything.
func _on_free_timer_timeout() -> void:
	queue_free()


func finished_callback() -> void:
	hitbox.set_deferred("monitorable", false)
	velocity = Vector2.ZERO
	animation.play("f_boom" if type else "a_boom")
	var tween: Tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 0.0, 0.3)
	if animation.is_playing():
		await animation.animation_finished
	queue_free()
