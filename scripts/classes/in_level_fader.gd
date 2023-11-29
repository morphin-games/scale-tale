class_name InLevelFader
extends ColorRect

signal faded_in
signal faded_out

@export var fade_on_ready : bool = true

func _ready() -> void:
	var f_tween : Tween = get_tree().create_tween()
	f_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	await f_tween.finished
	visible = false
	
func fade_in() -> void:
	visible = true
	var f_tween : Tween = get_tree().create_tween()
	f_tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	await f_tween.finished
	emit_signal("faded_in")
	
func fade_out() -> void:
	var f_tween : Tween = get_tree().create_tween()
	f_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	await f_tween.finished
	emit_signal("faded_out")
	visible = false
