class_name Grabable3D
extends Node

signal grabbed
signal ungrabbed

@export var item : Node3D
@export var interactuable : Interactuable3D

var player : SPPlayer3D
var time_taken : float
var time_ungrabbed : float
var enabled : bool = true

func _ready() -> void:
	interactuable.interacted.connect(Callable(func() -> void:
		if(player != null) : return
		if(!enabled) : return
		if(Time.get_unix_time_from_system() - time_ungrabbed < 0.33): return
			
		player = interactuable.player_near
		GrabableDistanceSystem.all_disabled = true
		grab()
		time_taken = Time.get_unix_time_from_system()
	))

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_interact") and Time.get_unix_time_from_system() - time_taken > 0.33):
		if(player != null):
			drop()
			time_ungrabbed = Time.get_unix_time_from_system()
			player = null
			GrabableDistanceSystem.all_disabled = false
			
	if(event.is_action_pressed("ui_throw") and Time.get_unix_time_from_system() - time_taken > 0.33):
		if(player != null):
			throw()
			time_ungrabbed = Time.get_unix_time_from_system()
			player = null
			GrabableDistanceSystem.all_disabled = false
	
func set_colliders_disabled(disabled : bool) -> void:
	for collider in item.get_children(true):
		if(collider is CollisionShape3D):
			collider.disabled = disabled
		
func get_y_impulse() -> float:
	var current_camera : Camera3D = get_viewport().get_camera_3d()
	if(current_camera != null):
		if(current_camera is CameraFollow3D):
			if(current_camera.height > 2.33):
				return (-current_camera.height + 2.33) * 4.0
			elif(current_camera.height < 0.0):
				return -current_camera.height * 35.0
			else:
				return 3.0
		else:
			return 3.0
	else:
		return 3.0

func grab() -> void:
#	if(player.grabbed_item == null):
#		var current_camera : Camera3D = get_viewport().get_camera_3d()
#		if(current_camera != null):
#			if(current_camera is CameraFollow3D):
#				player.prev_cam_data = current_camera.get_prev_cam_data()
	if(player.grabbed_item == null):
		emit_signal("grabbed")
		player.grabbed_item = item
		set_colliders_disabled(true)
		
		
func drop() -> void:
#	var current_camera : Camera3D = get_viewport().get_camera_3d()
#	if(current_camera != null):
#		if(current_camera is CameraFollow3D):
#			current_camera.distance = player.prev_cam_data.distance
#			current_camera.height = player.prev_cam_data.height
#			player.prev_cam_data = {}
	emit_signal("ungrabbed")
	player.grabbed_item = null
	set_colliders_disabled(false)
	
func throw() -> void:
	emit_signal("ungrabbed")
	var current_camera : Camera3D = get_viewport().get_camera_3d()
	if(current_camera != null):
		if(current_camera is CameraFollow3D):
			current_camera.distance = player.prev_cam_data.distance
			current_camera.height = player.prev_cam_data.height
			player.prev_cam_data = {}
			
	player.grabbed_item = null
	set_colliders_disabled(false)
