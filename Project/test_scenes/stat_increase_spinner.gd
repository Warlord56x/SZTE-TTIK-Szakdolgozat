@tool
extends HBoxContainer


@export var stat_name := "Stat":
	set(s):
		if not is_node_ready():
			await ready
		stat_name = s
		stat_label.text = stat_name + ":"
@export var current_stat := 1:
	set(s):
		if not is_node_ready():
			await ready
		current_stat = s
		current_stat_label.text = str(current_stat)
		next_stat_editor.text = str(current_stat)

@onready var stat_label: Label = %StatLabel
@onready var current_stat_label: Label = %CurrentStatLabel

@onready var left_arrow: Button = %LeftArrow
@onready var next_stat_editor: Button = %NextStatEditor
@onready var right_arrow: Button = %RightArrow

var next_stat := 1

signal next_stat_changed(stat: int)


func _ready() -> void:
	stat_label.text = stat_name + ":"
	current_stat_label.text = str(current_stat)
	next_stat_editor.text = str(current_stat)


func update_spinner() -> void:
	if next_stat == current_stat:
		left_arrow.focus_mode = Control.FOCUS_NONE
	else:
		left_arrow.focus_mode = Control.FOCUS_ALL
	left_arrow.disabled = next_stat == current_stat


func update_number(num: int) -> void:
	if next_stat + num < current_stat and num < 0:
		return
	next_stat_editor.text = str(int(next_stat_editor.text) + num)
	next_stat += num
	next_stat_changed.emit(num)
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
