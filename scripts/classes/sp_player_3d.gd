class_name SPPlayer3D
extends CharacterBody3D

signal direction_changed(new_direction)

@export_category("Controls")
@export var max_speed : float = 5.0
@export var acceleration : float = 0.25
@export var max_jump_force : float = 12
@export_category("Shaders")
@export var grass_mesh : MultiMeshInstance3D

@onready var r_acceleration : float = acceleration

enum PlayerStates {
	IDLE = 0
	,MOVING = 1
	,JUMPING = 2
	,GROUNDPOUNDING = 3
	,CROUCHING = 4
	,HANGING = 5
}

var grabbed_item : Node3D = null
var camera_rotation_speed : float = 0.75
# jump_external_force is a Vector2 to move the players against their wills when performing a special jump (olympic or backflip)
var jump_external_force : Vector2 = Vector2.ZERO
var player_state : PlayerStates = PlayerStates.IDLE
var gravity : float = ProjectSettings.get("physics/3d/default_gravity")
var time_since_direction_change : float = 0.0
var last_direction : Vector2 = Vector2.ZERO
var last_movement_direction : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO : 
	get: 
		return direction
	set(value):
		if(value != direction):
			last_direction = direction
			direction = value
			time_since_direction_change = 0.0
			emit_signal("direction_changed", value)

func _process(delta: float) -> void:
	if(grass_mesh != null):
		grass_mesh.material_override.set_shader_parameter("character_position", global_transform.origin)
	
	if($ShadowRaycast.get_collider() != null):
		$Shadow.global_transform.origin.y = $ShadowRaycast.get_collision_point().y
		$Shadow.basis.y = $ShadowRaycast.get_collision_normal()
		$Shadow.basis.x = -$Shadow.basis.z.cross($ShadowRaycast.get_collision_normal())
		$Shadow.basis = $Shadow.basis.orthonormalized()
		
		var current_camera : Camera3D = get_viewport().get_camera_3d()
		if(current_camera != null):
			if(current_camera is CameraFollow3D):
				$CameraHeightAdjusters.rotation.y = -current_camera.angle + deg_to_rad(180)
				if($CameraHeightAdjusters/Front.is_colliding()):
					var added_height : float = 2.0 - ($CameraHeightAdjusters.global_transform.origin - $CameraHeightAdjusters/Front.get_collision_point()).length()
					current_camera.height = move_toward(current_camera.r_height, 1.5 - added_height, 0.075)
				elif($CameraHeightAdjusters/Back.is_colliding()):
					var added_height : float = 2.0 - ($CameraHeightAdjusters.global_transform.origin - $CameraHeightAdjusters/Front.get_collision_point()).length()
					current_camera.height = move_toward(current_camera.r_height, 2.5 + added_height, 0.075)
				else:
					current_camera.height = move_toward(current_camera.r_height, 2.00, 0.075)
				
func _physics_process(delta: float) -> void:
#	Camera functionality
	var current_camera : Camera3D = get_viewport().get_camera_3d()
	var camera_view_direction : Vector3 = Vector3(1, 1, 1)
	if(current_camera != null):
		camera_view_direction = (current_camera.global_transform.origin - global_transform.origin).normalized()
		if(current_camera is CameraFollow3D):
			$MovementPivot.rotation.y = move_toward($MovementPivot.rotation.y, -current_camera.angle, camera_rotation_speed)
			
#	Movement
	time_since_direction_change += delta
	print(time_since_direction_change)
	if(direction.length() > 0.5):
		last_movement_direction = direction
	direction = Vector2(Input.get_axis("ui_down", "ui_up"), Input.get_axis("ui_left", "ui_right")).normalized()
	
	$MovementPivot/Movement.transform.origin.x = move_toward($MovementPivot/Movement.transform.origin.x, (direction.x * 2) + jump_external_force.x, acceleration)
	$MovementPivot/Movement.transform.origin.z = move_toward($MovementPivot/Movement.transform.origin.z, (direction.y * 2) + jump_external_force.y, acceleration)
	
	velocity.x = (global_transform.origin.x - $MovementPivot/Movement.global_transform.origin.x) * max_speed
	velocity.z = (global_transform.origin.z - $MovementPivot/Movement.global_transform.origin.z) * max_speed
	jump_external_force = jump_external_force.move_toward(Vector2.ZERO, 0.075)
	gravity = move_toward(gravity, ProjectSettings.get("physics/3d/default_gravity"), 0.25)
	max_speed = move_toward(max_speed, 5.0, 0.075)
	acceleration = move_toward(acceleration, r_acceleration, 0.1)
	if(Vector2(velocity.x, velocity.z).length() > 0):
		%Mesh.rotation.y = lerp_angle(%Mesh.rotation.y, Vector2(-last_movement_direction.x, last_movement_direction.y).angle() + $MovementPivot.rotation.y, 0.33)
		$CollisionShape3D.rotation.y = %Mesh.rotation.y
		$GrabPivot.rotation.y = %Mesh.rotation.y
		
	$WallHangers.rotation.y = %Mesh.rotation.y
	
	if(is_on_floor()):
		if(player_state != PlayerStates.JUMPING):
			velocity.y = 0.0
			jump_external_force = Vector2.ZERO
			max_speed = 5.0
			camera_rotation_speed = 0.75
			
		if((velocity.x == 0 or velocity.z == 0)):
			player_state = PlayerStates.IDLE
		elif((velocity.x != 0 or velocity.z != 0)):
			player_state = PlayerStates.MOVING
			
		if(Input.is_action_pressed("ui_groundpound")):
			player_state = PlayerStates.CROUCHING
		if(Input.is_action_just_pressed("ui_jump")):
#			Backflip
			if(player_state == PlayerStates.CROUCHING):
				player_state = PlayerStates.JUMPING
				if(Vector2(velocity.x, velocity.z).length() > 0.2):
					camera_rotation_speed = 0.04
					jump_external_force = last_movement_direction * 5.0
					gravity = ProjectSettings.get("physics/3d/default_gravity")
					velocity.y = max_jump_force * 0.75
					return
				else:
					jump_external_force = -last_movement_direction * 4.0
					max_speed = 0.5
					gravity = ProjectSettings.get("physics/3d/default_gravity") * 0.75
					velocity.y = max_jump_force * 1.25
					return
			else:
				player_state = PlayerStates.JUMPING
	#			Normal jump
				velocity.y = max_jump_force
	#			Lateral jump
				if(abs(last_direction.y) - abs(direction.y) < 0 - 0.12):
					if(time_since_direction_change > 0.10 and time_since_direction_change < 0.33):
						velocity.y = max_jump_force * 1.75
		
	else:
		if(player_state != PlayerStates.GROUNDPOUNDING):
			velocity.y -= gravity * delta
			if(Input.is_action_pressed("ui_groundpound") and player_state == PlayerStates.JUMPING):
				velocity.y = 0
				player_state = PlayerStates.GROUNDPOUNDING
				await(get_tree().create_timer(0.30).timeout)
				velocity.y = -37.5
				
		if($WallHangers/Checker.get_collider() != null and $WallHangers/Hanger.get_collider() != null):
			if(velocity.y < -5.0):
				velocity.y = -5.0
				
		if(is_on_wall()):
			if($WallHangers/Checker.get_collider() == null and $WallHangers/Hanger.get_collider() != null and velocity.y < 0):
				max_speed = 0.0
				velocity.y = 0.0
				player_state = PlayerStates.HANGING
				
			if(player_state != PlayerStates.HANGING):
				if(Input.is_action_just_pressed("ui_jump")):
					velocity = Vector3.ZERO
					velocity.y = max_jump_force * 1.25
					acceleration = 2.0
					last_movement_direction *= -1
					jump_external_force = last_movement_direction * 3.0
			else:
				if(Input.is_action_just_pressed("ui_groundpound")):
					player_state = PlayerStates.JUMPING
				
		if(player_state == PlayerStates.HANGING):
			if(Input.is_action_just_pressed("ui_jump")):
				velocity.y = max_jump_force
				jump_external_force = last_movement_direction * 2.0
				
	move_and_slide()
	
#	Item grab functionality
	if(grabbed_item != null):
		grabbed_item.global_transform.origin = $GrabPivot/Grabbed.global_transform.origin
		if(Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd").size() > 0):
			$GrabPivot/Grabbed.transform.origin.x = 1.5 + (Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")[0] as Scalable3D).current_scale.x / 2
			$GrabPivot/Grabbed.transform.origin.y = (Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")[0] as Scalable3D).current_scale.x / 2
		grabbed_item.global_rotation = $GrabPivot/Grabbed.global_rotation
		
	if(Input.is_action_pressed("ui_downscale")):
		if(grabbed_item != null):
			var scalables : Array[Node] = Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")
			if(scalables.size() > 0):
				(scalables[0] as Scalable3D).downscale(delta)
	elif(Input.is_action_pressed("ui_upscale")):
		if(grabbed_item != null):
			var scalables : Array[Node] = Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")
			if(scalables.size() > 0):
				(scalables[0] as Scalable3D).upscale(delta)
