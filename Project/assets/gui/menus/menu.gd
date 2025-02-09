extends PanelContainer
class_name Menu


@export var focus_target: Control
@export var effect: EffectLayer
@export var visible_default: bool = false
@export var invert: bool = false

var tween: Tween


func _ready() -> void:
	visibility_changed.connect(vis_changed)
	visible = visible_default
	if visible:
		vis_changed()
	scale.x = 0.001
	if effect:
		effect.progress = 0.0
		effect.invert = invert
	if invert:
		pivot_offset.x = size.x


func vis_changed() -> void:
	if focus_target and visible:
		focus_target.grab_focus()


func _get_minimum_size() -> Vector2:
	return Vector2.ZERO


func switch() -> void:
	if visible:
		close()
	else:
		open()


func open() -> void:
	if visible:
		return
	if tween and tween.is_running():
		await tween.finished

	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_method(_scaler, 0.001, 1.0, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(_progress, 1.0, 0.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	visible = true
	await tween.finished


func close() -> void:
	if not visible:
		return
	if tween and tween.is_running():
		await tween.finished

	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_method(_progress, 0.0, 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(_scaler, 1.0, 0.001, 0.7).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	visible = false


#region Animation Helpers
func _progress(f: float) -> void:
	if not effect:
		return
	effect.progress = f


func _scaler(f: float) -> void:
	scale.x = f
#endregion
