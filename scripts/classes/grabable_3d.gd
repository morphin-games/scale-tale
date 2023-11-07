class_name Grabable3D
extends Node3D

@export var item : Node3D
@export var interactuable : Interactuable3D

func _ready() -> void:
	interactuable.interacted.connect(Callable(func() -> void:
		print("SAYDUIASYDISAHDO")
		interactuable.player_near.grab(item)
	))
