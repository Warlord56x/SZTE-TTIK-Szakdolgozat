extends Node

class_name StateMachine

@export var initial_state: State = null
@export var debug: bool = false

var states: Dictionary
var current_state: State

var previous_state: State


func _ready() -> void:
	if initial_state:
		current_state = initial_state
	for state: State in get_children():
		states.get_or_add(state.name.to_lower(), state)
		state.connect("_back", on_back)
		state.connect("_travel", on_state_changed)
	await owner.ready
	current_state.active = true
	current_state.enter()
	if debug and owner and initial_state:
		print(owner.name," entered initial state (", initial_state.name.to_lower(), ")")


func travel(state: String) -> void:
	current_state.travel(state)


func back() -> void:
	if current_state == previous_state:
		current_state.travel(initial_state.name)
	current_state.travel(previous_state.name)


func _unhandled_input(event: InputEvent) -> void:
	current_state.unhandled_input(event)


func _process(delta: float) -> void:
	current_state.process(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)


func get_state(state: String) -> State:
	return states.get(state)


func has_state(state: String) -> bool:
	return states.has(state)


func is_active(state: String) -> bool:
	var st: State = states.get(state)
	if not st:
		return false
	return st.active


func on_back(from: State) -> void:
	#if from == previous_state:
		#print("works, but not what I need")
		#travel(initial_state.name)
	on_state_changed(from, previous_state.name)


func on_state_changed(from: State, to: String) -> void:
	if from != current_state:
		printerr("The state: '{0}' is not active! can't travel to '{1}'".format([from.name, current_state.name]))
		return

	var to_state: State = get_state(to.to_lower())

	if !to_state:
		printerr("Invalid state, no state named: {0}!".format([to]))
		return

	if current_state:
		# Dispose of last state if exists
		previous_state = current_state
		current_state.active = false

		current_state.leave()
		if debug and owner and from:
			prints(owner.name,"left state:", from.name.to_lower())

	#Enter new state
	current_state = to_state
	current_state.active = true
	current_state.enter()
	if debug and owner and to:
		prints(owner.name,"entered state:", to.to_lower())
