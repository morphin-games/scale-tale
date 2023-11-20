class_name SPPlayer3D
extends CharacterBody3D

signal direction_changed(new_direction : Vector2)
signal scaling_started
signal scaling_stopped
signal near_body_entered(body : Node3D)
signal near_body_exited(body : Node3D)
signal grabbed_item_changed(body : Node3D)

@export var health_system : HealthSystem
@export_category("Controls")
@export var max_speed : float = 5.0
@export var acceleration : float = 0.25
@export var max_jump_force : float = 12
@export_category("Shaders")
@export var grass_mesh : MultiMeshInstance3D

@onready var r_acceleration : float = acceleration
@onready var speed : float = max_speed

enum PlayerStates {
	IDLE = 0
	,MOVING = 1
	,JUMPING = 2
	,OLYMPIC_JUMPING = 201
	,WALLJUMPING = 202
	,HANGJUMPING = 203
	,GROUNDPOUNDING = 3
	,CROUCHING = 4
	,HANGING = 5
	,SWIMMING = 6
}

var prev_cam_data : Dictionary
var near_bodies : Array[Node3D] = []
var near_bodies_with_scale_particles : Array[Node3D] = []
var looking_down : bool = false
var ray_color : Color = Color(0.04, 0.0, 0.97)
var ray_ignited : bool = false
var grabbed_item : Node3D = null : 
	set(new_grabbed):
		grabbed_item = new_grabbed
		emit_signal("grabbed_item_changed", new_grabbed)
		add_scale_particles(new_grabbed)
		
var camera_rotation_speed : float = 0.75
# jump_external_force is a Vector2 to move the players against their wills when performing a special jump (olympic or backflip)
var jump_external_force : Vector2 = Vector2.ZERO
var player_state : PlayerStates = PlayerStates.IDLE
var gravity : float = ProjectSettings.get("physics/3d/default_gravity")
var time_since_direction_change : float = 0.0
var time_since_lateral : float = 0.0
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

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	respawn()
#	$NearBodies/RayVisualizer/RayMesh/RayActive.play("active")

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		if(event.is_action_released("ui_jump") and velocity.y > 0 and player_state == PlayerStates.JUMPING):
			var v_tween : Tween = get_tree().create_tween()
			v_tween.tween_property(self, "velocity:y", 0.0, 0.1)
			$JumpSFX.play()

func _process(delta: float) -> void:
	$NearBodies/RayVisualizer/RayMesh.mesh.material.set_shader_parameter("_shield_color", ray_color)
	if(grass_mesh != null):
		grass_mesh.material_override.set_shader_parameter("character_position", global_transform.origin)
	if($ShadowRaycast.get_collider() != null):
		$Shadow.global_transform.origin.y = $ShadowRaycast.get_collision_point().y
		$Shadow.basis.y = $ShadowRaycast.get_collision_normal()
		$Shadow.basis.x = -$Shadow.basis.z.cross($ShadowRaycast.get_collision_normal())
		$Shadow.basis = $Shadow.basis.orthonormalized()
				
func _physics_process(delta: float) -> void:
#	Camera functionality
	var current_camera : Camera3D = get_viewport().get_camera_3d()
	var camera_view_direction : Vector3 = Vector3(1, 1, 1)
	if(current_camera != null):
		camera_view_direction = (current_camera.global_transform.origin - global_transform.origin).normalized()
		if(current_camera is CameraFollow3D):
			$MovementPivot.rotation.y = move_toward($MovementPivot.rotation.y, -current_camera.angle, camera_rotation_speed)
			
			if(current_camera.height >= 8.0 and !looking_down):
				looking_down = true
				var n_tween : Tween = get_tree().create_tween()
				n_tween.tween_property($NearBodies, "rotation_degrees:z", -90.0, 1.0)
			elif(current_camera.height < 5.0 and looking_down):
				looking_down = false
				var n_tween : Tween = get_tree().create_tween()
				n_tween.tween_property($NearBodies, "rotation_degrees:z", 0.0, 1.0)
			
#	Movement
	time_since_lateral += delta
	time_since_direction_change += delta
	if(direction.length() > 0.5):
		last_movement_direction = direction
	direction = Vector2(Input.get_axis("ui_down", "ui_up"), Input.get_axis("ui_left", "ui_right")).normalized()
	
	if(abs(rad_to_deg(last_movement_direction.angle_to(direction))) > 167.5):
		time_since_lateral = 0.0
	
	$MovementPivot/Movement.transform.origin.x = move_toward($MovementPivot/Movement.transform.origin.x, (direction.x * 2) + jump_external_force.x, acceleration)
	$MovementPivot/Movement.transform.origin.z = move_toward($MovementPivot/Movement.transform.origin.z, (direction.y * 2) + jump_external_force.y, acceleration)
	
	if(player_state == PlayerStates.CROUCHING):
		speed = move_toward(speed, max_speed * 0.2, 0.4)
	elif(player_state == PlayerStates.SWIMMING):
		speed = move_toward(speed, max_speed * 0.4, 0.4)
	
	velocity.x = (global_transform.origin.x - $MovementPivot/Movement.global_transform.origin.x) * speed
	velocity.z = (global_transform.origin.z - $MovementPivot/Movement.global_transform.origin.z) * speed

	jump_external_force = jump_external_force.move_toward(Vector2.ZERO, 0.075)
	gravity = move_toward(gravity, ProjectSettings.get("physics/3d/default_gravity"), 0.25)
	acceleration = move_toward(acceleration, r_acceleration, 0.12)
	if(player_state != PlayerStates.CROUCHING and player_state != PlayerStates.JUMPING  and player_state != PlayerStates.HANGJUMPING and player_state != PlayerStates.OLYMPIC_JUMPING and player_state != PlayerStates.WALLJUMPING):
		speed = move_toward(speed, max_speed, 0.075)
	if(Vector2(velocity.x, velocity.z).length() > 0):
		%Mesh.rotation.y = lerp_angle(%Mesh.rotation.y, Vector2(-last_movement_direction.x, last_movement_direction.y).angle() + $MovementPivot.rotation.y, 0.33)
		$CollisionShape3D.rotation.y = %Mesh.rotation.y
		$GrabPivot.rotation.y = %Mesh.rotation.y
	
	$NearBodies.rotation.y = %Mesh.rotation.y
	$WallHangers.rotation.y = %Mesh.rotation.y
	
	if(velocity.y < -100.0):
		$WallHangers.scale.x = 1.0
		
	if(player_state != PlayerStates.SWIMMING):
		if(is_on_floor()):
			if(player_state != PlayerStates.JUMPING and player_state != PlayerStates.HANGJUMPING and player_state != PlayerStates.OLYMPIC_JUMPING and player_state != PlayerStates.WALLJUMPING):
				$WallHangers.scale.x = 1.0
				velocity.y = 0.0
				jump_external_force = Vector2.ZERO
				camera_rotation_speed = 0.75
			if(player_state != PlayerStates.JUMPING and player_state != PlayerStates.HANGJUMPING and player_state != PlayerStates.GROUNDPOUNDING and player_state != PlayerStates.OLYMPIC_JUMPING and player_state != PlayerStates.WALLJUMPING):
				if(Input.is_action_pressed("ui_groundpound")):
					player_state = PlayerStates.CROUCHING
				if(Input.is_action_just_released("ui_groundpound")):
					player_state = PlayerStates.IDLE
				
			if((velocity.x == 0 or velocity.z == 0) and player_state != PlayerStates.CROUCHING):
				player_state = PlayerStates.IDLE
			elif((velocity.x != 0 or velocity.z != 0) and player_state != PlayerStates.CROUCHING):
				player_state = PlayerStates.MOVING

			if(Input.is_action_just_pressed("ui_jump") and is_on_floor()):
				if(player_state == PlayerStates.CROUCHING):
					player_state = PlayerStates.JUMPING
					$JumpSFX.play()
					if(Vector2(velocity.x, velocity.z).length() > 0.2):
	#					Olympic jump
						player_state = PlayerStates.OLYMPIC_JUMPING
						speed = max_speed * 0.8
						camera_rotation_speed = 0.035
						jump_external_force = last_movement_direction * 5.0
						gravity = ProjectSettings.get("physics/3d/default_gravity")
						velocity.y = max_jump_force * 0.75
						return
					else:
	#					Backflip
						camera_rotation_speed = 0.01
						acceleration = 2.0
						$WallHangers.scale.x = -1.0
						jump_external_force = -last_movement_direction * 4.0
						speed = 0.5
						gravity = ProjectSettings.get("physics/3d/default_gravity") * 0.75
						velocity.y = max_jump_force * 1.25
						return
				else:
					player_state = PlayerStates.JUMPING
		#			Normal jump
					velocity.y = max_jump_force
		#			Lateral jump
					if(time_since_lateral > 0.05 and time_since_lateral < 0.33):
						velocity.y = max_jump_force * 1.45
		else: # Not on floor
			if(player_state != PlayerStates.GROUNDPOUNDING):
				velocity.y -= gravity * delta
				if(Input.is_action_just_pressed("ui_groundpound") and (player_state == PlayerStates.JUMPING or player_state == PlayerStates.OLYMPIC_JUMPING or player_state == PlayerStates.WALLJUMPING)):
					velocity.y = 0
					player_state = PlayerStates.GROUNDPOUNDING
					await(get_tree().create_timer(0.30).timeout)
					velocity.y = -40.0
					
			if($WallHangers/Checker.get_collider() != null and $WallHangers/Hanger.get_collider() != null and !is_on_floor()):
				if(velocity.y < -5.0):
					velocity.y = -5.0
					
			if($WallHangers/Checker.get_collider() != null or $WallHangers/Hanger.get_collider() != null):
				if($WallHangers/Checker.get_collider() == null and $WallHangers/Hanger.get_collider() != null and velocity.y < 0):
					speed = 0.0
					velocity.y = 0.0
					player_state = PlayerStates.HANGING
					
	#			Wall jump
				if(player_state != PlayerStates.HANGING):
					if(Input.is_action_just_pressed("ui_jump")):
						player_state = PlayerStates.WALLJUMPING
						speed = max_speed * 0.2
						velocity = Vector3.ZERO
						velocity.y = max_jump_force * 1.25
						acceleration = 6.5
						last_movement_direction *= -1
						jump_external_force = Vector2(%Mesh.global_transform.basis.z.x, %Mesh.global_transform.basis.z.z) * 8.0
				else:
					if(Input.is_action_just_pressed("ui_groundpound")):
						player_state = PlayerStates.JUMPING
					
			if(player_state == PlayerStates.HANGING):
				if(Input.is_action_just_pressed("ui_jump")):
					player_state = PlayerStates.HANGJUMPING
					speed = max_speed * 0.5
					velocity.y = max_jump_force
					jump_external_force = last_movement_direction * 2.0
	else: # Swimming in water
		if(Input.is_action_just_pressed("ui_jump")):
			if(velocity.y >= -2.0):
				velocity.y += 2.0
			else:
				velocity.y *= -1.0
		
		velocity.y -= gravity / 8 * delta
		velocity.y = clampf(velocity.y, -3.5, 5.0)
		
	if(player_state == PlayerStates.GROUNDPOUNDING):
		speed = 0.0
			
	move_and_slide()
	
#	Item grab functionality
	if(grabbed_item != null):
		grabbed_item.global_transform.origin = $GrabPivot/Grabbed.global_transform.origin
		if(Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd").size() > 0):
			$GrabPivot/Grabbed.transform.origin.x = 1.5 + (Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")[0] as Scalable3D).current_scale.x
			$GrabPivot/Grabbed.transform.origin.y = (Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")[0] as Scalable3D).current_scale.x
		grabbed_item.global_rotation = $GrabPivot/Grabbed.global_rotation
		if(current_camera != null):
			camera_view_direction = (current_camera.global_transform.origin - global_transform.origin).normalized()
			if(current_camera is CameraFollow3D):
				var scalables : Array[Node] = Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")
				if(scalables.size() > 0):
					current_camera.distance = 7.0 + ((scalables[0] as Scalable3D).current_scale.x * 1.2)
	else:
		if(current_camera != null):
			camera_view_direction = (current_camera.global_transform.origin - global_transform.origin).normalized()
			if(current_camera is CameraFollow3D):
				prev_cam_data = current_camera.get_prev_cam_data()
				if(prev_cam_data != null):
					current_camera.distance = prev_cam_data.distance
					current_camera.height = prev_cam_data.height
			
				
#	Item scaling functionality
	if(Input.is_action_pressed("ui_upscale")):
		emit_signal("scaling_started")
		if(grabbed_item != null):
			ray_color = Color(1.0, 0.0, 0.0)
			var scalables : Array[Node] = Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")
			if(scalables.size() > 0):
				(scalables[0] as Scalable3D).downscale(delta)
				if($SFXAudioStreamPlayer3D.playing == false):
						$SFXAudioStreamPlayer3D.play()
						scale_sfx_upscale()
		else:
#			$NearBodies/RayVisualizer/RayMesh.mesh.material.set_shader_parameter("_shield_color", Color(0.0, 0.008, 1.0))
			if(!ray_ignited):
				var tween_c : Tween = get_tree().create_tween()
				tween_c.tween_property(self, "ray_color", Color(1.0, 0.0, 0.0), 0.4)
				$NearBodies/CollisionShape3D.disabled = false
				ray_ignited = true
				$NearBodies/RayVisualizer.enable()


			for body in near_bodies:
				var scalables : Array[Node] = Utils.find_custom_nodes(body, "res://scripts/classes/scalable_3d.gd")
				if(scalables.size() > 0):
					(scalables[0] as Scalable3D).downscale(delta)
					if($SFXAudioStreamPlayer3D.playing == false):
						$SFXAudioStreamPlayer3D.play()
						scale_sfx_upscale()
			
	elif(Input.is_action_pressed("ui_downscale")):
		emit_signal("scaling_started")
		if(grabbed_item != null):
			ray_color = Color(0.0, 0.03, 1.0)
			var scalables : Array[Node] = Utils.find_custom_nodes(grabbed_item, "res://scripts/classes/scalable_3d.gd")
			if(scalables.size() > 0):
				(scalables[0] as Scalable3D).upscale(delta)
				if($SFXAudioStreamPlayer3D.playing == false):
					$SFXAudioStreamPlayer3D.play()
					scale_sfx_downscale()
		else:
			$NearBodies/RayVisualizer/RayMesh.mesh.material.set_shader_parameter("_shield_color", Color(1.0, 0.0, 0.0))
			if(!ray_ignited):
				$NearBodies/CollisionShape3D.disabled = false
				ray_ignited = true
				$NearBodies/RayVisualizer.enable()
				var tween_c : Tween = get_tree().create_tween()
				tween_c.tween_property(self, "ray_color", Color(0.0, 0.03, 1.0), 0.4)
				
			for body in near_bodies:
				var scalables : Array[Node] = Utils.find_custom_nodes(body, "res://scripts/classes/scalable_3d.gd")
				if(scalables.size() > 0):
					(scalables[0] as Scalable3D).upscale(delta)
					if($SFXAudioStreamPlayer3D.playing == false):
						$SFXAudioStreamPlayer3D.play()
						scale_sfx_downscale()
					
	elif(Input.is_action_just_released("ui_upscale") or Input.is_action_just_released("ui_downscale")):
		$NearBodies/CollisionShape3D.disabled = true
		ray_ignited = false
		$NearBodies/RayVisualizer.disable()
		var tween_c : Tween = get_tree().create_tween()
		tween_c.tween_property(self, "ray_color", Color(0.04, 0.0, 0.97), 0.4)
		emit_signal("scaling_stopped")
		reset_scale_sfx()



func add_scale_particles(node : Node3D) -> void:
	var scalables : Array[Node] = Utils.find_custom_nodes(node, "res://scripts/classes/scalable_3d.gd")
	var scalable : Scalable3D
	if(scalables.size() > 0):
		scalable = scalables[0]
	else:
		return
	
	var particles : ScaleParticles = load("res://scenes/particle_effects/scale_particles.tscn").instantiate()
	node.add_child(particles)
	particles.global_transform.origin = node.global_transform.origin
		
	var scalable_colls : Array[Node] = Utils.find_custom_nodes(node, "res://scripts/classes/collision_shape_scalable_3d.gd")
	if(scalable_colls.size() > 0):
		particles.set_shape((scalable_colls[0] as CollisionShapeScalable3D).shape)
	
	scaling_started.connect(Callable(func() -> void:
		if(scalable != null):
			particles.set_size(scalable.current_scale.x)
		print(ray_color)
		particles.set_color(ray_color)
		if(!particles.emitting):
			particles.emit(true)
	))
	
	scaling_stopped.connect(Callable(func() -> void:
		if(particles.emitting):
			particles.emit(false)
	))
	
	near_body_exited.connect(Callable(func(body : Node3D) -> void:
		if(body == node):
			particles.destroy()
			particles.system_enabled = false
	))
	
	grabbed_item_changed.connect(Callable(func(body: Node3D) -> void:
		if(body == null):
			particles.destroy()
			particles.system_enabled = false
	))


func _on_near_bodies_body_entered(body: Node3D) -> void:
	emit_signal("near_body_entered", body)
	near_bodies.append(body)
	add_scale_particles(body)

func _on_near_bodies_body_exited(body: Node3D) -> void:
	emit_signal("near_body_exited", body)
	near_bodies.erase(body)

func respawn(transition : bool = false) -> void:
	if((Persistance.persistance_data as PersistanceData).respawn_position != null):
		global_transform.origin = (Persistance.persistance_data as PersistanceData).respawn_position

func scale_sfx_downscale():
	var tween_scale_sfx : Tween = get_tree().create_tween()
	tween_scale_sfx.tween_property($SFXAudioStreamPlayer3D,"pitch_scale",1.5,4)
	#if($SFXAudioStreamPlayer3D.pitch_scale < 1.5):
	#	$SFXAudioStreamPlayer3D.set_pitch_scale($SFXAudioStreamPlayer3D.pitch_scale+0.05)

func scale_sfx_upscale():
	var tween_scale_sfx : Tween = get_tree().create_tween()
	tween_scale_sfx.tween_property($SFXAudioStreamPlayer3D,"pitch_scale",0.5,4)

func reset_scale_sfx():
	$SFXAudioStreamPlayer3D.pitch_scale=1
	$SFXAudioStreamPlayer3D.stop()

func _on_sfx_timer_timeout() -> void:
	pass # Replace with function body.
