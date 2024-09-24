extends HSlider

#var focused
#
#func _ready() -> void:
#	focus_entered.connect(Callable(func() -> void:
#		focused = true
#	))
#
#	focus_exited.connect(Callable(func() -> void:
#		focused = false
#	))
#
#func _input(event: InputEvent) -> void:
#	if(event.is_action_pressed("ui_slider_left")):
#		value -= step
#	elif(event.is_action_pressed("ui_slider_right")):
#		value += step
