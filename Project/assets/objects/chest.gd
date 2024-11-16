extends InteractionArea

const DROP := preload("res://assets/loot/pick_up.tscn")

@export var _loot: Item
@export var _animation: SpriteFrames

var is_open: bool = false
var inside: bool = false


func interact(_player: Player = null) -> bool:
	if !is_open:
		$AnimatedSprite2D.play("open")
		is_open = true
		interactable = false
	return interactable


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "open":
		interaction_done.emit()

		for i in randi_range(4, 10):
			var loot = DROP.instantiate()
			loot.item = _loot
			loot.animation = _animation
			add_child(loot)
