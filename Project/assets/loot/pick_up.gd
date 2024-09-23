extends RigidBody2D

const FLOAT := preload("res://assets/effects/damage_number.tscn")

@export var item: Item = null
@export var animation: SpriteFrames


@onready var _animation: AnimatedSprite2D = %Animation


func _ready() -> void:
	_animation.sprite_frames = animation
	_animation.play()
	apply_central_impulse(Vector2(randi_range(-50, 50), -200))


func _physics_process(_delta: float) -> void:
	_animation.global_position = global_position


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		if body.inventory.add_item(item):
			var floating := FLOAT.instantiate()
			floating.damage_number = -1
			floating.global_position = global_position
			floating.color = Color.WHITE
			get_tree().root.add_child.call_deferred(floating)
			queue_free()
