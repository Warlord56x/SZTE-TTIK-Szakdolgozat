@tool
extends HBoxContainer
class_name StatIncreaseSpinner


@export var stat_name := "Stat":
	set(s):
		stat_name = s
		if not is_node_ready():
			await ready
		stat_label.text = stat_name + ":"

@export var current_stat := 1:
	set(s):
		current_stat = s
		next_stat = s
		if not is_node_ready():
			await ready
		current_stat_label.text = str(current_stat)
		next_stat_editor.text = str(current_stat)

@export var disabled: bool = false:
	set(d):
		disabled = d
		if not is_node_ready():
			await ready
		left_arrow.visible = !d
		right_arrow.visible = !d
		next_stat_editor.disabled = d
		if d:
			next_stat_editor.focus_mode = Control.FOCUS_NONE
		else:
			next_stat_editor.focus_mode = Control.FOCUS_ALL

@export var lock: bool = false:
	set(l):
		lock = l
		update_spinner()

@onready var stat_label: Label = %StatLabel
@onready var current_stat_label: Label = %CurrentStatLabel

@onready var left_arrow: Button = %LeftArrow
@onready var next_stat_editor: Button = %NextStatEditor
@onready var right_arrow: Button = %RightArrow

var next_stat := current_stat:
	set = set_next_stat

signal next_stat_changed(stat: int)


func _ready() -> void:
	stat_label.text = stat_name + ":"
	current_stat_label.text = str(current_stat)
	next_stat_editor.text = str(current_stat)


func set_next_stat(ns: int) -> void:
	next_stat = ns
	if not is_node_ready():
		await ready
	next_stat_editor.text = str(ns)

	if next_stat == current_stat:
		next_stat_editor.add_theme_color_override("font_color", Colors.DEFAULT_FONT_COLOR)
		next_stat_editor.add_theme_color_override("font_disabled_color", Colors.DEFAULT_FONT_COLOR)
	else:
		next_stat_editor.add_theme_color_override("font_color", Colors.UPDATE_FONT_COLOR)
		next_stat_editor.add_theme_color_override("font_disabled_color", Colors.UPDATE_FONT_COLOR)


func manage_error(err: bool) -> void:
	if err:
		next_stat_editor.add_theme_color_override("font_disabled_color", Colors.ERROR_COLOR)
	else:
		next_stat_editor.add_theme_color_override("font_disabled_color", Colors.DEFAULT_FONT_COLOR)


func update_spinner() -> void:
	if next_stat == current_stat:
		left_arrow.focus_mode = Control.FOCUS_NONE
	else:
		left_arrow.focus_mode = Control.FOCUS_ALL
	right_arrow.disabled = lock
	left_arrow.disabled = next_stat == current_stat


func update_number(num: int) -> void:
	if (next_stat + num < current_stat and num < 0) or (num > 0 and lock):
		return
	next_stat_editor.text = str(int(next_stat_editor.text) + num)
	next_stat += num
	next_stat_changed.emit(next_stat)
	update_spinner()


func simulate_press(node: Button) -> void:
	node.toggle_mode = true
	node.button_pressed = true


func _on_next_stat_editor_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		update_number(-1)
		simulate_press(left_arrow)
		accept_event()
	if event.is_action_pressed("ui_right"):
		update_number(1)
		simulate_press(right_arrow)
		accept_event()

	if event.is_action_released("ui_left"):
		left_arrow.toggle_mode = false
		accept_event()
	if event.is_action_released("ui_right"):
		right_arrow.toggle_mode = false
		accept_event()


func _on_left_arrow_pressed() -> void:
	update_number(-1)


func _on_right_arrow_pressed() -> void:
	update_number(1)
