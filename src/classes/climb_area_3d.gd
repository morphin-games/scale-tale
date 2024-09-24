class_name ClimbArea3D
extends Area3D

signal player_entered(player : SPPlayer3D)
signal player_exited(player : SPPlayer3D)

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			(body as SPPlayer3D).climb_area = self
			(body as SPPlayer3D).player_state = (body as SPPlayer3D).PlayerStates.CLIMBING
			
			var current_camera : Camera3D = get_viewport().get_camera_3d()
			if(current_camera != null):
				if(current_camera is CameraFollow3D):
					current_camera.min_height = -current_camera.max_height
	))
	
	body_exited.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			(body as SPPlayer3D).climb_area = null
			(body as SPPlayer3D).player_state = (body as SPPlayer3D).PlayerStates.IDLE
			
			var current_camera : Camera3D = get_viewport().get_camera_3d()
			if(current_camera != null):
				if(current_camera is CameraFollow3D):
					current_camera.min_height = -0.5
	))
