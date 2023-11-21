class_name WaterArea3D
extends Area3D

var player : SPPlayer3D
var kinematics : Array[CharacterBody3D]
var rigids : Array[RigidBody3D]
var camera : CameraFollow3D

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			player = body
			var v_tween : Tween = get_tree().create_tween()
			v_tween.tween_property(body, "velocity:y", -1.0, 0.5)
			(body as SPPlayer3D).player_state = (body as SPPlayer3D).PlayerStates.SWIMMING
		elif(body is CharacterBody3D):
			kinematics.append(body)
		elif(body is RigidBody3D):
			body.apply_central_impulse(Vector3(0, -body.linear_velocity.y * 1.0, 0))
			rigids.append(body)
	))

	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			player = null
			(body as SPPlayer3D).player_state = (body as SPPlayer3D).PlayerStates.JUMPING
		elif(body is CharacterBody3D):
			kinematics.erase(body)
		elif(body is RigidBody3D):
			rigids.erase(body)
	))

	area_entered.connect(Callable(func(area : Area3D) -> void:
		if(area.get_parent() is CameraFollow3D):
			camera = area.get_parent()
			(camera as CameraFollow3D).underwater.visible = true
#			(camera as CameraFollow3D).underwater.get_active_material(0).set_shader_parameter("tint", Color(0.0, 0.22, 1.0, 0.85))
	))
	
	area_exited.connect(Callable(func(area : Area3D) -> void:
		if(area.get_parent() is CameraFollow3D):
			(camera as CameraFollow3D).underwater.visible = false
#			(camera as CameraFollow3D).underwater.get_active_material(0).set_shader_parameter("tint", Color(0.0, 0.22, 1.0, 0.0))
			camera = null
	))

func _process(delta: float) -> void:
	if(player != null):
		player.player_state = player.PlayerStates.SWIMMING
		
	for kinematic in kinematics:
		kinematic.velocity.y += gravity / 8 * delta
		
	for rigid in rigids:
		rigid.apply_central_force(Vector3(0, 43.0, 0))
