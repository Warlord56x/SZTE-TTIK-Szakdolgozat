extends Node2D
class_name Barrel


const DESTRUCTION_PART = preload("res://test_scenes/destruction_part.tscn")

@export var force: int = 30
@onready var hit_area: Hurtbox = $HitArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var num_parts: int = 5

var parts: Array[Rect2] = []

func partition_rect(rect: Rect2, min_size: int) -> Array[Rect2]:
	var segments: Array[Rect2] = []
	
	# Check if rect is large enough to be split further (horizontally or vertically)
	var can_split_horizontally = rect.size.y > min_size * 2
	var can_split_vertically = rect.size.x > min_size * 2

	# Decide whether to split or to stop (you can also add a random chance to stop splitting)
	if can_split_horizontally or can_split_vertically:
		# Choose the axis of split based on what is available.
		var split_horizontally = false
		if can_split_horizontally and can_split_vertically:
			split_horizontally = randf() < 0.5
		elif can_split_horizontally:
			split_horizontally = true

		if split_horizontally:
			# Ensure the split point leaves at least min_size in both segments
			var max_split = rect.size.y - min_size
			var split_pos = randi() % int(max_split - min_size + 1) + min_size
			var rect_top = Rect2(rect.position, Vector2(rect.size.x, split_pos))
			var rect_bottom = Rect2(rect.position + Vector2(0, split_pos), Vector2(rect.size.x, rect.size.y - split_pos))
			
			segments += partition_rect(rect_top, min_size)
			segments += partition_rect(rect_bottom, min_size)
		else:
			var max_split = rect.size.x - min_size
			var split_pos = randi() % int(max_split - min_size + 1) + min_size
			var rect_left = Rect2(rect.position, Vector2(split_pos, rect.size.y))
			var rect_right = Rect2(rect.position + Vector2(split_pos, 0), Vector2(rect.size.x - split_pos, rect.size.y))
			
			segments += partition_rect(rect_left, min_size)
			segments += partition_rect(rect_right, min_size)
	else:
		segments.append(rect)
		
	return segments


func _ready() -> void:
	var original_rect = sprite.region_rect
	parts = partition_rect(original_rect, 2)


func hurt(_e_damage: int, _dealer: Node2D = null) -> bool:
	hit_area.set_deferred("monitoring", false)
	sprite.visible = false
	for p: Rect2 in parts:
		var s := DESTRUCTION_PART.instantiate()
		s.texture = sprite.texture
		s.filter = sprite.region_filter_clip_enabled
		s.life_time = 10

		s.part = p
		add_child.call_deferred(s)
		s.apply_central_impulse(Vector2(randi_range(-force, force), randi_range(-force, force)))
	return true
