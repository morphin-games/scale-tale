@tool
class_name PlatformerController
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

@onready var platformer_control_context : PlatformerControlContext = control_context as PlatformerControlContext 

# Virtual function, called on ready.
# Override to add your behaviour.
func ready() -> void:
	print("platformer_control_context:", platformer_control_context)
	pass
	
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
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func process(delta : float) -> void:
	platformer_control_context.direction.x = Input.get_axis("kxi_left", "kxi_right")
	platformer_control_context.direction.y = Input.get_axis("kxi_down", "kxi_up")
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	pass
