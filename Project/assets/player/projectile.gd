extends CharacterBody2D

class_name Projectile

const PROJECTILE_SPEED: int = 300

var direction: Vector2
var p_rotation: float
var override_speed: int
var type: int = 0


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
		1:
			animation.play("f_default")
			$FireAudio.play()


func _physics_process(_delta : float) -> void:
	move_and_slide()


# Making sure that it gets freed even if it does not hit anything.
func _on_free_timer_timeout() -> void:
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != owner:
		velocity = Vector2.ZERO
		$Hitbox.set_deferred("monitoring", false)
		match type:
			0:
				animation.play("a_boom")
				if body.has_method("knock_back"):
					body.knock_back(global_position, 0.5)
				$BowImpact.play()
			1:
				animation.play("f_boom")
				if body.has_method("knock_back"):
					body.knock_back(global_position, 0.2)

				var tween: Tween = create_tween()
				tween.tween_property($PointLight2D, "energy", 0.0, 0.3)
				$FireImpact.play()

		if body.has_method("hurt"):
			body.hurt(1, owner)


		if animation.is_playing():
			await animation.animation_finished
		queue_free()
