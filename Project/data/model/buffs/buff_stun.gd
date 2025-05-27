extends Buff
class_name BuffStun

@export var duration: float = 1.0


func _ready() -> void:
	buff_time = duration
	super._ready()


func effect() -> void:
	var state_machine: StateMachine = apply_to.get_node_or_null("StateMachine")
	if state_machine:
		var stun_state: State = state_machine.get_state("stun")
		if stun_state:
			stun_state.duration = duration
			state_machine.travel("stun")
