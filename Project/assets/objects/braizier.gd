extends InteractionArea

var lit: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Projectile and body.type == 1:
		if !lit:
			interact()


func interact(_player: Player = null) -> bool:
	if lit:
		$Anim.play_backwards("activate")
	else:
		$Anim.play("activate")
	return interactable


func _on_anim_animation_finished():
	if $Anim.animation == "activate":
		var lighter = create_tween()
		if !lit:
			lighter.tween_property($PointLight2D, "energy", 0.5, 0.2)
			$Anim.play("lit")
		else:
			lighter.tween_property($PointLight2D, "energy", 0.0, 0.2)
			$Anim.play("default")
		lit = !lit
	interaction_done.emit()
