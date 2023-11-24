class_name SyncroLabel
extends Label

@export var slider : Slider

func _ready() -> void:
	slider.value_changed.connect(Callable(func(value : float) -> void:
		text = str(value)
	))
