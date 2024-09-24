# meta-name: Controller base template
# meta-description: Read the inputs and interact with the Pawn using the ControlContext.
# meta-default: true
# meta-space-indent: 4

@tool
class_name _CLASS_
extends Controller

# Virtual function, called on ready.
# Override to add your behaviour.
func ready() -> void:
	pass
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func input(event: InputEvent) -> void:
	pass
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func process(delta : float) -> void:
	pass
	
# Virtual function, called on the associated [member pawn].
# Override to add your behaviour.
func physics_process(delta : float) -> void:
	pass
