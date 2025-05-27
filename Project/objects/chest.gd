extends InteractionArea

const DROP := preload("res://data/loot/pick_up.tscn")

@onready var animation: AnimatedSprite2D = $Animation

var is_open: bool = false


func interact(_player: Player = null) -> bool:
	if !is_open:
		animation.play("open")
		is_open = true
		set_deferred("monitorable", false)
		interactable = false
	return interactable


func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "open":
		interaction_done.emit()
		for i in randi_range(4, 10):
			var loot = DROP.instantiate()
			var choice: Item = ItemLoader.BASE_LOOT_TABLE.pick_random()
			loot.item = choice
			add_child(loot)
