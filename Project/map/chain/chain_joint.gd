@tool
extends RigidBody2D
class_name ChainJoint

@onready var default: Sprite2D = $Default
@onready var end_node: Sprite2D = $End

@export var end: bool = false:
	set(e):
		end = e
		vis(e)


func vis(v: bool) -> void:
	if not default or not end_node:
		return
	if !default.is_node_ready() or !end_node.is_node_ready():
		await end_node.ready
		await default.ready
	end_node.visible = v
	default.visible = !v
