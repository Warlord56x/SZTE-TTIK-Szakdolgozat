extends RigidBody2D
class_name DestructionPart

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var texture: Texture2D
var part: Rect2
var filter: bool

var life_time: float = 0.3


func _ready() -> void:
	sprite.texture = texture
	sprite.region_rect = part
	sprite.region_filter_clip_enabled = filter
	timer.wait_time = life_time
	timer.start()


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
	await tween.finished
	queue_free()
