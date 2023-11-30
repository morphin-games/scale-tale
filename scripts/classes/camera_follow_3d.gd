class_name CameraFollow3D
extends Camera3D

@export var spring : RayCast3D
@export_category("Target")
@export var target : Node3D
@export var follow_speed : float = 0.33
@export_category("Position")
@export var distance : float = 5.0
@export var height : float = 2.0
@export_category("Effects")
@export var underwater : MeshInstance3D

@onready var real_distance : float = distance
@onready var angle : float = 0.0
@onready var r_height : float = height
@onready var min_height : float = -0.5
@onready var max_height : float = 9.0
@onready var max_distance : float = 10.0
@onready var last_real_distance : float = 666.666

@onready var cam_speed_x : float = (Persistance.persistance_data as PersistanceData).cam_speed_x
@onready var cam_speed_y : float = (Persistance.persistance_data as PersistanceData).cam_speed_y
@onready var invert_cam_x : int = (Persistance.persistance_data as PersistanceData).invert_cam_x
@onready var invert_cam_y : int = (Persistance.persistance_data as PersistanceData).invert_cam_y

var direction : Vector2
var springed : bool = false

class PrevCamData:
	var distance : float
	var height : float
	
func get_prev_cam_data() -> Dictionary:
	return {
		"distance": distance
		,"height": height
	}
	
func _ready() -> void:
	current = true
	if((Persistance.persistance_data as PersistanceData).invert_cam_x):
		invert_cam_x = -1
	else:
		invert_cam_x = 1
		
	if((Persistance.persistance_data as PersistanceData).invert_cam_y):
		invert_cam_y = -1
	else:
		invert_cam_y = 1
			
	Persistance.persistance_data_changed.connect(Callable(func() -> void:
		cam_speed_x = (Persistance.persistance_data as PersistanceData).cam_speed_x
		cam_speed_y = (Persistance.persistance_data as PersistanceData).cam_speed_y
		if((Persistance.persistance_data as PersistanceData).invert_cam_x):
			invert_cam_x = -1
		else:
			invert_cam_x = 1
			
		if((Persistance.persistance_data as PersistanceData).invert_cam_y):
			invert_cam_y = -1
		else:
			invert_cam_y = 1
	))

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		angle += event.relative.x * 0.01 * cam_speed_x * invert_cam_x
		height -= event.relative.y * 0.012 * cam_speed_y * invert_cam_y
	elif(event is InputEventMouseButton):
		if(event.is_pressed()):
			if(event.button_index == MOUSE_BUTTON_WHEEL_UP):
				real_distance -= 0.5
			elif(event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
				real_distance += 0.5

func _process(delta: float) -> void:
	height = clampf(height, min_height, max_height)
	
	if(spring.is_colliding() and real_distance + (target as SPPlayer3D).added_cam_scale >= (global_transform.origin - spring.get_collision_point()).length()):
		springed = true
		distance = (global_transform.origin - spring.get_collision_point()).length()
		distance = clampf(distance, 1.0, max_distance)
	else:
		springed = false
		real_distance = clampf(real_distance, 2.0, max_distance)
		distance = real_distance
		
	if(Input.is_action_pressed("ui_camera_further")):
		real_distance += 5.0 * delta
	elif(Input.is_action_pressed("ui_camera_nearer")):
		real_distance -= 5.0 * delta
		
	var camera_direction_x : float = Input.get_axis("ui_left_camera", "ui_right_camera")
	angle -= camera_direction_x * delta * 4.0 * cam_speed_x * invert_cam_x
	
	var camera_direction_y : float = Input.get_axis("ui_down_camera", "ui_up_camera")
	height += camera_direction_y * delta * 8.0 * cam_speed_y * invert_cam_y

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.from_angle(angle).normalized() * distance
	global_transform.origin = lerp(global_transform.origin, target.global_transform.origin + Vector3(direction.x, height, direction.y), follow_speed)
	global_transform.origin.y 
	look_at(target.global_transform.origin)
