class_name Stompable3D
extends Node3D

signal stomped

@export var enemy : EnemyBody3D
@export var player_detector : PlayerDetectArea3D
@export var death_impulse : float = 9.0
@export_category("Scale")
@export var scalable : Scalable3D
@export var vulnerable_scale : Vector3 = Vector3(0.5, 0.5, 0.5)
@export_category("Vulnerabilities")
@export var vulnerable_radius : float = 1.0

func _ready() -> void:
	player_detector.player_entered.connect(Callable(func(player : SPPlayer3D) -> void:
		if(player.global_transform.origin.y > global_transform.origin.y 
		and Utils.between(player.global_transform.origin.x, global_transform.origin.x - (vulnerable_radius / 2), global_transform.origin.x + (vulnerable_radius / 2))
		and Utils.between(player.global_transform.origin.z, global_transform.origin.z - (vulnerable_radius / 2), global_transform.origin.z + (vulnerable_radius / 2))):
			if(scalable == null or (scalable != null and scalable.current_scale.x <= vulnerable_scale.x)):
				player.velocity.y = death_impulse
				emit_signal("stomped")
		else:
			print("OOF")
	))
