@tool
extends Node2D
class_name Chain

const CHAIN_JOINT := preload("res://test_scenes/chain/chain_joint.tscn")
@onready var base: StaticBody2D = $Base
@onready var segments: Node2D = $Segments


@export_range(0, 50) var length: int = 1:
	set = set_length


func set_length(l: int) -> void:
	length = l
	update_chain.call_deferred()


func update_chain() -> void:
	if segments == null or not segments.is_node_ready():
		await ready
	var children := segments.get_children()

	# Clear existing children (both chain segments and joints)
	for child: Node in children:
		child.queue_free()

	var prev_chain: RigidBody2D = null  # Assuming CHAIN_JOINT is a RigidBody2D
	var spacing := 8  # Adjust based on your chain segment's size
	
	for joint: int in range(length):
		# Instantiate and position the new chain segment
		var chain := CHAIN_JOINT.instantiate()
		segments.add_child(chain)
		chain.position = Vector2(0, joint * spacing)
		if joint == length - 1:
			chain.end = true

		# Create joints between consecutive segments
		if prev_chain != null:
			var j := PinJoint2D.new()
			j.node_a = prev_chain.get_path()
			j.node_b = chain.get_path()
			
			# Position the joint between the two segments
			j.position = (prev_chain.position + chain.position) * 0.5
			segments.add_child(j)

		prev_chain = chain  # Update previous chain reference

	# Connect the first segment to the base point
	if length > 0 and base is StaticBody2D:
		var first_joint := PinJoint2D.new()
		first_joint.node_a = base.get_path()
		first_joint.node_b = segments.get_child(0).get_path()
		first_joint.position.y = -4
		segments.add_child(first_joint)
