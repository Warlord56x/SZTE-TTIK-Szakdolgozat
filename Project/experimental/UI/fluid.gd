@tool
extends Area2D

#Drawing
@export var draw_water: bool = true
@export var draw_points: bool = false
@export var draw_neighbouring_springs: bool = false
@export var draw_area: bool = false

@export var draw_points_size: float = 5.0
@export var draw_spring_size: float = 3.0
@export var draw_spring_distance: float = 32.0

@export var mouse_apply_force: float = 64.0
@export var mouse_apply_width: float = 48.0

#Passive wave variables
@export var waves_enabled: bool = true #Whether passive waves are enabled or not
@export var wave_height: float = 4.0 #How high the passive waves are
@export var wave_speed: float = 4.0 #How quick they are
@export var wave_width: float = 16.0 #How wide they are

@export var wave_spread_amount: int = 4 #How many times forces should be calculated between neighbouring points per frame. Higher values means waves travel faster

## STUPID, higher the value lesser the points man
@export var point_per_distance: int = 8 #A point will be created every nth units along the water's surface. More points means higher fidelity
var points = [] #The list of points along the water's surface

@export var point_damping = 0.99 #This is multiplied with a point's motion every frame. Smaller values mean waves will fade quicker # (float, 0.0, 1.0, 0.001)
@export var point_independent_stiffness: float = 1.0 #Stiffness between a point and it's resting y pos.
@export var point_neighbouring_stiffness: float = 2.0 #Stiffness between neighbouring points. Higher values mean motion is transferred between points quicker.

var collision_polygon : CollisionPolygon2D #A reference a CollisionPolygon2D.
var top_left_point : Vector2 #The top left point of the "collision_polygon"'s polygon
var top_right_point : Vector2 #The top tight point of the "collision_polygon"'s polygon

@onready var water_point_scene := preload("res://test_scenes/UI/fluid_node.tscn") #The scene for the points along the water's surface


var previous_position : Vector2

func _ready():
	previous_position = global_position  # Store initial position
	
	#Find a "CollisionPolygon2D" to use
	for child in get_children():
		#Check class of child
		if child.get_class() == "CollisionPolygon2D":
			if child.polygon.size() == 4:
				#Update reference
				collision_polygon = child

				#Assign Points
				top_left_point = collision_polygon.polygon[0]
				top_right_point = collision_polygon.polygon[1]

				#Create points along surface
				create_surface_points()

				#Stop loop
				break


func create_surface_points() -> void:
	#Create an Array of WaterPoints along the Surface
	var point_amount = int(floor((top_right_point.x - top_left_point.x) / point_per_distance))
	for i in range(point_amount):
		var point = water_point_scene.instantiate()
		add_child(point)

		point.damping = point_damping

		point.position = Vector2(top_left_point.x + (point_per_distance * (i + 0.5)), top_left_point.y)
		points.append(point)


func destroy_surface_points() -> void:
	#Destroy WaterPoints along the Surface
	for point in points:
		point.queue_free()
	points.clear()


var delta_time = 0.0
func _physics_process(delta) -> void:
	# Check if position has changed
	if global_position != previous_position:
		# Calculate the displacement (change in position)
		var displacement = global_position - previous_position
		# Apply wave effect based on displacement
		apply_wave_from_displacement(displacement)
		# Update the previous position to the current position
		previous_position = global_position
	#Delta Time
	if waves_enabled:
		delta_time += delta
		if delta_time > PI * 2.0:
			delta_time -= PI * 2.0

	#Update Points
	if collision_polygon != null:
		var target_y = global_position.y + top_left_point.y
		for i in range(points.size()):
			#Calculate Motion for Point
			var point = points[i]
			point.motion += point.calculate_motion(Vector2(point.global_position.x, target_y), point_independent_stiffness)

			#Add Some Wave
			if waves_enabled:
				point.motion.y += sin(((i / float(points.size())) * wave_width) + (delta_time * wave_speed)) * (wave_height + randf_range(-2, 2))

			#Apply spring forces between neighbouring points
			for j in range(wave_spread_amount):
				#Point to Left
				if i - 1 >= 0:
					var left_point = points[i - 1]
					point.motion += point.calculate_motion(Vector2(point.global_position.x, left_point.global_position.y), point_neighbouring_stiffness)

				#Point to Right
				if i + 1 < points.size():
					var right_point = points[i + 1]
					point.motion += point.calculate_motion(Vector2(point.global_position.x, right_point.global_position.y), point_neighbouring_stiffness)

	##Apply force at mouse position
	#if Input.is_action_pressed("ui_accept"):
		#apply_force(get_global_mouse_position(), mouse_apply_force * Vector2.DOWN, mouse_apply_width)

	#Draw Points
	queue_redraw()


func apply_wave_from_displacement(displacement: Vector2) -> void:
	# Calculate the base wave force using the displacement magnitude
	var base_wave_force = displacement.length()

	# Determine the main direction of the displacement
	var displacement_direction = displacement.normalized()

	#for i in range(len(points) -1, 0, -1) if displacement_direction.sign().x == -1 else range(0, len(points) -1, 1):
	for i in range(0, len(points) -1, 1):
		var point = points[i]

		# Calculate the horizontal distance from the displacement center
		var distance_to_side: float = points[displacement_direction.sign().x * -1].global_position.x - point.global_position.x
		var influence_radius := 10

		# Calculate a falloff based on distance to the center
		var distance_factor: float = (influence_radius - abs(distance_to_side)) / influence_radius
		distance_factor = clamp(distance_factor, 0.0, 1.0)  # Ensure it's within 0 to 1

		# Apply a randomized directional force, scaled by distance factor and displacement
		var directional_force: float = base_wave_force * distance_factor * randf_range(0.5, 3.0)
		
		# Apply the force in the vertical direction, creating a wave effect
		point.motion.y += directional_force


func apply_force(pos: Vector2, force: Vector2, width: float = 16.0) -> void:
	#Ignore if pos is outside area
	if (points[0].global_position.x - width) > pos.x || (points[points.size() - 1].global_position.x + width) < pos.x:
		return

	#Convert global coords to local coords
	var local_pos = to_local(pos)

	#Find the furthest positions that could be affected to the left and right
	var left_most = local_pos.x - (width / 2.0)
	var right_most = local_pos.x + (width / 2.0)

	#Convert those local positions to indices in the "points" array
	var left_most_index = get_index_from_local_pos(Vector2(left_most, local_pos.y))
	var right_most_index = get_index_from_local_pos(Vector2(right_most, local_pos.y))

	#Run through the indices and apply the force
	for i in range(left_most_index, right_most_index + 1):
		points[i].motion += force


func get_index_from_local_pos(pos: Vector2) -> int:
	#Returns an index of the "points" array on water's surface to the local pos
	var index = floor((abs(top_left_point.x - pos.x) / (top_right_point.x - top_left_point.x)) * points.size())

	#Ensure the index is a possible index of the array
	return int(clamp(index, 0, points.size() - 1))


func _draw() -> void:
	#Draw Points
	if collision_polygon != null:
		if draw_area:
			var area = collision_polygon.polygon
			var col = Color(0.0, 0.0, 1.0, 0.25)
			draw_polygon(area, [col, col, col, col])

		if draw_water:
			var surface = [top_left_point]
			var polygon = [top_left_point]
			var colors = [Color.BLUE]
			for i in range(points.size()):
				#Append points
				surface.append(points[i].position)
				polygon.append(points[i].position)
				colors.append(Color.BLUE)

			surface.append(top_right_point)

			polygon.append(top_right_point)
			colors.append(Color.BLUE)
			polygon.append(collision_polygon.polygon[2])
			colors.append(Color.BLUE)
			polygon.append(collision_polygon.polygon[3])
			colors.append(Color.BLUE)

			draw_polygon(polygon, colors)
			draw_polyline(surface, Color.LIGHT_BLUE, 5.0)

		if draw_points:
			var target_y = top_left_point.y
			for i in range(points.size()):
				var point = points[i]
				draw_circle(point.position, draw_points_size, Color.WHITE)

				#Draw Spring
				var w = 1.0 - (abs(point.position.y - target_y) / draw_spring_distance)
				draw_line(point.position, Vector2(point.position.x, target_y), Color.WHITE, draw_spring_size * w)

				#Draw Neighbouring Springs
				if draw_neighbouring_springs:
					#Point to Left
					if i - 1 >= 0:
						var left_point = points[i - 1]
						var lw = 1.0 - (abs(point.position.y - left_point.position.y) / draw_spring_distance)
						draw_line(point.position, left_point.position, Color.WHITE, draw_spring_size * lw)

					#Point to Right
					if i + 1 < points.size():
						var right_point = points[i + 1]
						var rw = 1.0 - (abs(point.position.y - right_point.position.y) / draw_spring_distance)
						draw_line(point.position, right_point.position, Color.WHITE, draw_spring_size * rw)
