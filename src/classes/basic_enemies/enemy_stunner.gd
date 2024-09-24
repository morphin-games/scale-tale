class_name EnemyStun
extends Node

@export var stompable : Stompable3D

func _ready() -> void:
	stompable.stomped.connect(Callable(func() -> void:
		pass
	))
