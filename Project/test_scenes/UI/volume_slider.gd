extends HBoxContainer


@onready var label: Label = $Label
@onready var h_slider: HSlider = $HSlider
@onready var spin_box: SpinBox = $SpinBox

signal volume_changed(value: float)


func _on_h_slider_value_changed(value: float) -> void:
	spin_box.value = value
	volume_changed.emit(value / 100)


func _on_spin_box_value_changed(value: float) -> void:
	h_slider.value = value
	volume_changed.emit(value / 100)
