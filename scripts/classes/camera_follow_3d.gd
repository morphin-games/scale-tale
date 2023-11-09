class_name CameraFollow3D
extends Camera3D

@export_category("Target")
@export var target : Node3D
@export var follow_speed : float = 0.33
@export_category("Position")
@export var distance : float = 5.0
@export var height : float = 2.0

@onready var angle : float = 0.0
@onready var r_height : float = height

var direction : Vector2

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		angle += event.relative.x * 0.01
		height -= event.relative.y * 0.012
	elif(event is InputEventMouseButton):
		if(event.is_pressed()):
			if(event.button_index == MOUSE_BUTTON_WHEEL_UP):
				distance -= 0.5
			elif(event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
				distance += 0.5

func _physics_process(delta: float) -> void:
	distance = clampf(distance, 2.0, 10.0)
	height = clampf(height, -0.5, 6.0)
	
	direction = Vector2.RIGHT.from_angle(angle).normalized() * distance
	global_transform.origin = lerp(global_transform.origin, target.global_transform.origin + Vector3(direction.x, height, direction.y), follow_speed)
	global_transform.origin.y 
	look_at(target.global_transform.origin)
