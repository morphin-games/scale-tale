class_name EnemyBodyStunnable3D
extends EnemyBody3D

@export var stompable : Stompable3D

func _ready() -> void:
	player = get_parent().player
