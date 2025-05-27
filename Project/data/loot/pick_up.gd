extends RigidBody2D
class_name PickUp

const FLOAT := preload("res://assets/effects/damage_number.tscn")

@export var item: Item = null


@onready var animation: AnimatedSprite2D = %Animation
@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	if item.pickup_animation:
		animation.sprite_frames = item.pickup_animation
		animation.play()
	else:
		sprite.texture = item.icon
	apply_central_impulse(Vector2(randi_range(-50, 50), -200))


func _physics_process(_delta: float) -> void:
	animation.global_position = global_position


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		if body.inventory.add_item(item):
			var floating := FLOAT.instantiate()
			floating.damage_number = -1
			floating.global_position = global_position
			floating.color = Color.WHITE
			get_tree().root.add_child.call_deferred(floating)
			queue_free()
