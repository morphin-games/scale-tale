class_name WaterArea3D
extends Area3D

var player : SPPlayer3D
var camera : CameraFollow3D

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			player = body
			var v_tween : Tween = get_tree().create_tween()
			v_tween.tween_property(body, "velocity:y", -1.0, 0.5)
			(body as SPPlayer3D).player_state = (body as SPPlayer3D).PlayerStates.SWIMMING
	))

	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			player = null
			(body as SPPlayer3D).player_state = (body as SPPlayer3D).PlayerStates.JUMPING
	))

	area_entered.connect(Callable(func(area : Area3D) -> void:
		if(area.get_parent() is CameraFollow3D):
			camera = area.get_parent()
			(camera as CameraFollow3D).underwater.get_active_material(0).set_shader_parameter("tint", Color(0.0, 0.22, 1.0, 0.85))
	))
	
	area_exited.connect(Callable(func(area : Area3D) -> void:
		if(area.get_parent() is CameraFollow3D):
			(camera as CameraFollow3D).underwater.get_active_material(0).set_shader_parameter("tint", Color(0.0, 0.22, 1.0, 0.0))
			camera = null
	))

func _process(delta: float) -> void:
	if(player != null):
		player.player_state = player.PlayerStates.SWIMMING
