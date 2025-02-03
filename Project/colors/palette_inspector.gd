@tool
extends GridContainer


@export var palette: Palette:
	set = set_palette


func set_palette(p: Palette) -> void:
	palette = p
	if p == null:
		return
	update_palette()


func _ready() -> void:
	update_palette()


func update_palette() -> void:
	for child: ColorRect in get_children():
		child.queue_free()
	columns = palette.width

	for color: int in palette.colors_max:
		var _color_node := ColorRect.new()
		_color_node.color = palette.colors[color].color
		_color_node.custom_minimum_size = Vector2(20,20)
		add_child(_color_node)
