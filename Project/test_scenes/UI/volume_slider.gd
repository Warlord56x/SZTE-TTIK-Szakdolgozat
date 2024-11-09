extends HBoxContainer
class_name VolumeSlider


@onready var label: Label = $Label
@onready var h_slider: HSlider = $HSlider
@onready var spin_box: SpinBox = $SpinBox

@export var value: float = 50:
	set = value_set

signal volume_changed(value: float)


func value_set(v: float) -> void:
	h_slider.value = v
	spin_box.value = v


func _on_h_slider_value_changed(_value: float) -> void:
	spin_box.value = _value
	volume_changed.emit(_value / 100)


func _on_spin_box_value_changed(_value: float) -> void:
	h_slider.value = _value
	volume_changed.emit(_value / 100)
