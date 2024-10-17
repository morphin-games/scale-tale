class_name PlatformerControlContext
extends ControlContext

@export var direction : Vector2 = Vector2(0.0, 0.0)
@export var last_direction : Vector2 = Vector2(0.0, 1.0)
## Direction angle in the current frame.
@export var direction_angle : float = 0.0
## Direction angle in the previous frame.
@export var last_direction_angle : float = 0.0
## Direction angle before changing direction.
@export var last_registered_direction_angle : float = 0.0
