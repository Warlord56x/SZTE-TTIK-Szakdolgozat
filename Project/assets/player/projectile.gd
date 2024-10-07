extends CharacterBody2D

class_name Projectile

const PROJECTILE_SPEED: int = 300

var direction: Vector2
var p_rotation: float
var override_speed: int
var type: int = 0


func _ready() -> void:
	global_rotation = p_rotation
	if !override_speed:
		velocity = direction * PROJECTILE_SPEED
	else:
		velocity = direction * override_speed
	$PointLight2D.visible = bool(type)
	match type:
		0:
			$AnimatedSprite2D.play("a_default")
		1:
			$AnimatedSprite2D.play("f_default")


func _physics_process(_delta : float) -> void:
	move_and_slide()


# Making sure that it gets freed even if it does not hit anything.
func _on_free_timer_timeout() -> void:
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != owner:
		if body.has_method("hurt"):
			body.hurt(1, owner)
			print("from projectile: hit")

		velocity = Vector2.ZERO
		$Hitbox.set_deferred("monitoring", false)
		match type:
			0:
				$AnimatedSprite2D.play("a_boom")
				if body.has_method("knock_back"):
					body.knock_back(global_position, 0.5)
			1:
				$AnimatedSprite2D.play("f_boom")
				if body.has_method("knock_back"):
					body.knock_back(global_position, 0.2)

				var tween: Tween = create_tween()
				tween.tween_property($PointLight2D, "energy", 0.0, 0.3)

		await $AnimatedSprite2D.animation_finished
		queue_free()
