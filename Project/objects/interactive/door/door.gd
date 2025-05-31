extends Node2D
class_name Door

## The node that is moved using tweens.
@onready var door_body: AnimatableBody2D = $DoorBody


## How much time it takes to open.
@export var open_time: float = 0.2

## How high the door should go.
@export var open_amount: float = 0.5

## How activation does it take to open .
@export var opening_count: int = 1
var current_opening: int = 0

## Is the door open, should not be modified externally
var _is_open: bool = false


## Handles opening the door.
func open() -> void:
	if _is_open:
		return
	current_opening += 1
	if current_opening >= opening_count:
		_is_open = true
		create_tween().tween_property(
			door_body,
			"global_position:y",
			global_position.y - open_amount,
			open_time
			)


## Handles closing the door.
func close() -> void:
	if not _is_open:
		return
	_is_open = false
	create_tween().tween_property(
		door_body,
		"global_position:y",
		global_position.y + open_amount,
		open_time
		)


## Handles the door in a flip-flop manner.
func switch() -> void:
	if _is_open:
		close()
	else:
		open()
