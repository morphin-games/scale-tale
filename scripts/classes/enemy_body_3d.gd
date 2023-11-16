class_name EnemyBody3D
extends CharacterBody3D

signal recovered

@export var player : SPPlayer3D
@export var detection_distance : float = 16.0
@export_category("Nodes")
@export var stompable : Stompable3D
@export var collision_shape : CollisionShape3D
@export var player_detect_area : PlayerDetectArea3D
@export var floor_checker : RayCast3D
@export_category("Speed")
@onready var max_speed : float = 5.0
@onready var speed : float = max_speed

enum EnemyStatus {
	IDLE = 0
	,FOLLOWING = 1
	,PATROLING = 2
	,STUNNED = 3
}

var alive : bool = true
var stun_time : float = 1.5
var safezoned : bool = false
var status : EnemyStatus
var last_patrol_time : int
var patrol_start_time : int
var stun_start_time : int
var player_visible : bool = false
var target : Vector3 = Vector3.ZERO
var gravity : float = ProjectSettings.get("physics/3d/default_gravity")

func stun(time : float = 1.5) -> void:
	stun_time = time
	status = EnemyStatus.STUNNED
	stun_start_time = Utils.now()

func patrol(max_distance : float = 12.0) -> void:
	safezoned = false
	status = EnemyStatus.PATROLING
	patrol_start_time = Utils.now()
	target = global_transform.origin + (Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized() * randf_range(0.0, max_distance))
#		var r_pos : Vector3 = global_transform.origin + (Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized() * randf_range(0.0, max_distance))
#		$SafePositionChecker.global_transform.origin = r_pos
#		$SafePositionChecker.global_transform.origin.y += 1.0
#
#		print($SafePositionChecker.get_collider())
#		if($SafePositionChecker.is_colliding()):
#			target = r_pos
#			print("VALID: ", target)
#			break
#		else:
#			print("INVALID: ", r_pos)
#			print("INVALID: ", global_transform.origin)
#			print("----------------------------")
			
func go_to(where : Vector3) -> void:
	status = EnemyStatus.PATROLING
	patrol_start_time = Utils.now()
	target = where

func cancel_patrol() -> void:
	status = EnemyStatus.IDLE
	last_patrol_time = Utils.now()
	target = Vector3.ZERO
	
func set_node_rotation(node : Node3D) -> void:
	if(node == null) : return
	node.look_at(target)
	node.rotation_degrees.x = 0.0
	node.rotation_degrees.z = 0.0
	node.rotation_degrees.y += 90
	
func behaviour(delta : float) -> void:
	$WatchPlayer.target_position = player.global_transform.origin - $WatchPlayer.global_transform.origin
	if($WatchPlayer.get_collider() != null and status != EnemyStatus.STUNNED):
		if($WatchPlayer.get_collider().name != "Player"):
			player_visible = false
		else:
			if($WatchPlayer.target_position.length() <= detection_distance):
				player_visible = true
				last_patrol_time = Utils.now()
			else:
				player_visible = false

	if(status == EnemyStatus.PATROLING and !floor_checker.is_colliding() and !safezoned):
		safezoned = true
		cancel_patrol()
		var dir : Vector3 = $Mesh.global_transform.basis.z.normalized()
		go_to(-target)
		
	if(player_visible and status != EnemyStatus.STUNNED):
		status = EnemyStatus.FOLLOWING
		detection_distance = 32.0
		target = player.global_transform.origin
		if($Front.is_colliding()):
			if($Front.get_collider().name != "Player"):
				if(player.global_position.y > global_position.y):
					velocity.y = 10.0
					move_and_slide()
					
	elif(!player_visible and status != EnemyStatus.STUNNED):
		if(status != EnemyStatus.PATROLING):
			status = EnemyStatus.IDLE
		detection_distance = 18.0
		if(status == EnemyStatus.IDLE):
			target = Vector3.ZERO
		if(Utils.now() - last_patrol_time > 2.0 and status == EnemyStatus.IDLE):
			patrol()
			
	if(target != Vector3.ZERO and status != EnemyStatus.STUNNED):
		set_node_rotation($Front)
		set_node_rotation($Mesh)
		set_node_rotation($FloorChecker)
		set_node_rotation(collision_shape)
		set_node_rotation(player_detect_area)
		
		if(Utils.now() - patrol_start_time >= 0.66):
			$Front.target_position.x = 2.5
			if($Front.is_colliding()):
				if($Front.get_collider().name != "Player"):
					cancel_patrol()
		last_patrol_time = Utils.now()
		velocity.x = (target - global_transform.origin).normalized().x * speed
		velocity.z = (target - global_transform.origin).normalized().z * speed
	else:
		$Front.target_position.x = 0.0
		velocity.x = 0.0
		velocity.z = 0.0
		
	if(status == EnemyStatus.PATROLING and Utils.now() - patrol_start_time >= 5.0):
		cancel_patrol()
		
	if(status == EnemyStatus.STUNNED):
		if(Utils.now() - stun_start_time >= stun_time):
			status = EnemyStatus.IDLE
			emit_signal("recovered")
		
	if(!is_on_floor()):
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
		
	move_and_slide()
	
	
	
func _physics_process(delta: float) -> void:
	if(!alive) : return
	behaviour(delta)
