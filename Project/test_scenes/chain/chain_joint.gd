@tool
extends RigidBody2D
class_name ChainJoint

@onready var default: Sprite2D = $Default
@onready var end_node: Sprite2D = $End

@export var end: bool = false:
	set(e):
		end = e
		end_node.visible = e
		default.visible = !e
