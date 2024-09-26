@tool
class_name PlayerController
extends Controller

#region Signals
signal kxi_up_pressed
signal kxi_down_pressed
signal kxi_left_pressed
signal kxi_right_pressed
signal kxi_jump_pressed
signal kxi_crouch_pressed
signal kxi_pressed

signal kxi_up_released
signal kxi_down_released
signal kxi_left_released
signal kxi_right_released
signal kxi_jump_released
signal kxi_crouch_released
signal kxi_released
#endregion

@export_category("Camera")
@export var player_camera : PlayerCamera
@export_group("Camera settings") 
@export var camera_y_offset : float = 3.0
@export var camera_distance : float = 6.0
@export var camera_follow_speed : float = 0.04
## When set to true, the player direction will be also determined by the camera's look direction.
@export var get_direction_from_camera : bool = false

@onready var player_control_context : PlayerControlContext = control_context as PlatformerControlContext 
@onready var camera_rotation_pivot_x : Node3D = Node3D.new()
@onready var camera_rotation_pivot_y : Node3D = Node3D.new()

# Virtual function, called on ready.
# Override to add your behaviour.
func ready() -> void:
	player_camera.controller = self
	add_child(camera_rotation_pivot_x)
	camera_rotation_pivot_x.add_child(camera_rotation_pivot_y)
	player_camera.camera_rotation_pivot_x = camera_rotation_pivot_x
	player_camera.camera_rotation_pivot_y = camera_rotation_pivot_y
	pawn_posessed.connect(Callable(func(pawn : Node) -> void:
		player_camera.pawn = pawn
		if(pawn is PlatformerPawn):
			get_direction_from_camera = true
	))
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func input(event: InputEvent) -> void:
	if(event.is_action_pressed("kxi_jump")):
		kxi_jump_pressed.emit()
	elif(event.is_action_pressed("kxi_crouch")):
		kxi_crouch_pressed.emit()
	elif(event.is_action_released("kxi_jump")):
		kxi_jump_released.emit()
	elif(event.is_action_released("kxi_crouch")):
		kxi_crouch_released.emit()
		
	if(event is InputEventMouseMotion):
		player_control_context.camera_motion = event.relative
	
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func process(delta : float) -> void:
	player_control_context.direction.x = Input.get_axis("kxi_right", "kxi_left")
	player_control_context.direction.y = Input.get_axis("kxi_down", "kxi_up")
	player_control_context.direction = player_control_context.direction.normalized()
	
	if(get_direction_from_camera and player_control_context.direction != Vector2(0.0, 0.0)):
		var direction_angle : float = player_control_context.camera_look_direction.angle_to(player_control_context.direction)
		var combined_direction : Vector2 = Vector2.RIGHT.rotated(direction_angle + deg_to_rad(90)).normalized()
		player_control_context.direction = combined_direction
		player_control_context.direction_angle = direction_angle
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	pass
