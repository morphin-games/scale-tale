class_name EnemyBody3D
extends CharacterBody3D

signal recovered

@export var player : SPPlayer3D
@export var detection_distance : float = 16.0

@onready var max_speed : float = 5.0
@onready var speed : float = max_speed

enum EnemyStatus {
	IDLE = 0
	,FOLLOWING = 1
	,PATROLING = 2
	,STUNNED = 3
}

var status : EnemyStatus
var last_patrol_time : int
var patrol_start_time : int
var stun_start_time : int
var player_visible : bool = false
var target : Vector3 = Vector3.ZERO
var gravity : float = ProjectSettings.get("physics/3d/default_gravity")

func stun() -> void:
	status = EnemyStatus.STUNNED
	stun_start_time = Utils.now()

func patrol(max_distance : float = 10.0) -> void:
	status = EnemyStatus.PATROLING
	patrol_start_time = Utils.now()
	target = global_transform.origin + Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized() * max_distance

func cancel_patrol() -> void:
	status = EnemyStatus.IDLE
	last_patrol_time = Utils.now()
	target = Vector3.ZERO
	
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
				
				
	if(player_visible and status != EnemyStatus.STUNNED):
		status = EnemyStatus.FOLLOWING
		detection_distance = 32.0
		target = player.global_transform.origin
	elif(!player_visible and status != EnemyStatus.STUNNED):
		if(status != EnemyStatus.PATROLING):
			status = EnemyStatus.IDLE
		detection_distance = 18.0
		if(status == EnemyStatus.IDLE):
			target = Vector3.ZERO
		if(Utils.now() - last_patrol_time > 2.0 and status == EnemyStatus.IDLE):
			patrol()
			
	if(target != Vector3.ZERO and status != EnemyStatus.STUNNED):
		$Front.look_at(target)
		$Front.rotation_degrees.x = 0.0
		$Front.rotation_degrees.z = 0.0
		$Front.rotation_degrees.y += 90
		$Mesh.look_at(target)
		$Mesh.rotation_degrees.x = 0.0
		$Mesh.rotation_degrees.z = 0.0
		$Mesh.rotation_degrees.y += 90
		
		if(Utils.now() - patrol_start_time >= 0.66):
			$Front.target_position.x = 2.5
			if($Front.is_colliding()):
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
		if(Utils.now() - stun_start_time >= 8.0):
			status = EnemyStatus.IDLE
			emit_signal("recovered")
		
	if(!is_on_floor()):
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
		
	move_and_slide()
	
	
	
func _physics_process(delta: float) -> void:
	behaviour(delta)
