extends Node
class_name State

var active: bool = false

signal _travel(from: State, to: String)
signal _back(from: State)


func back() -> void:
	_back.emit(self)


func travel(state: String) -> void:
	_travel.emit(self, state)


func enter() -> void: pass
func leave() -> void: pass
func unhandled_input(_event: InputEvent) -> void: pass
func process(_delta: float) -> void: pass
func physics_process(_delta: float) -> void: pass
