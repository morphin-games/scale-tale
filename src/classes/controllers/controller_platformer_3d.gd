class_name ControllerPlatformer3D
extends Controller

var momentum : Vector3

func _process(delta: float) -> void:
	var direction : Vector2
	
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if(Input.is_action_just_pressed("ui_jump")):
		direction.y = 1.0
		
	target._move(direction)
