@tool
extends InteractionArea

@onready var interactor: Interactor = null

enum ladder_states {
	LADDERTOP,
	LADDER,
	LADDERBASE,
}

var col_states = {
	0 : {
		"Shape" : Vector2i(10,6),
		"Position" : Vector2i(0,2),
	},
	1 : {
		"Shape" : Vector2i(8,10),
		"Position" : Vector2i(0,0),
	},
	2 : {
		"Shape" : Vector2i(10,6),
		"Position" : Vector2i(0,-2),
	},
}

@export var ladder_state : ladder_states = ladder_states.LADDER:
	set(state):
		ladder_state = state
		$AnimatedSprite2D.frame = state
		var shape = RectangleShape2D.new()
		shape.size = col_states[state].Shape
		$CollisionShape2D.shape = shape
		$CollisionShape2D.position = col_states[state].Position


func _init() -> void:
	type = INTERACTION_TYPE.LADDER


func interact(_player: Player = null) -> bool:
	if not interactor.player.on_ladder:
		interactor.player.ladder_pos = global_position.x
		interactor.player.on_ladder = true
	else:
		interactor.player.on_ladder = false
	interaction_done.emit()
	return interactable


func _on_area_entered(area: Area2D) -> void:
	if area is Interactor:
		interactor = area


func _on_area_exited(area: Area2D) -> void:
	if area is Interactor and area == interactor:
		var player = interactor.player
		interactor = null
		var top_cond : bool = ladder_state == ladder_states.LADDERTOP and player.velocity.y < 0
		var base_cond : bool = ladder_state == ladder_states.LADDERBASE and player.velocity.y > 0
		if top_cond or base_cond:
			player.on_ladder = false
