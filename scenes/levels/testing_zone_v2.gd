extends Node3D

func _ready() -> void:
	($ControllerPlatformer3D as ControllerPlatformer3D).target = ($PlayerV2/PawnPlayer as PawnPlayer)
