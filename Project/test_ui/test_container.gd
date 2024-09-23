@tool
extends Container


var r : int = get_child_count()


func _notification(what : int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		# Must re-sort the children
		var center : Vector2 = Vector2(position.x + position.x/2, position.y + position.y/2)
		
		var coords : Array[Vector2] = []
		var delta_theta = 2 * PI / get_child_count()
		for i in range(0, get_child_count()):
			var theta = i * delta_theta
			
			var x = center.x + r * cos(theta)
			var y = center.y + r * sin(theta)
			coords.append(Vector2(x,y))
		
		print("sorting...")
		for c in get_child_count():
			# Fit to own size
			get_children()[c].set_position(coords[c])
