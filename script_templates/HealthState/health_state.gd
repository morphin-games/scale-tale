# meta-name: HealthState base template
# meta-description: Ready with all functions that can or must be overriden
# meta-default: true
# meta-space-indent: 4

class_name _CLASS_
extends HealthState

# Godot virtual function.
# Overwrite to add custom behaviour.
func _init() -> void:
	pass

# Virtual function. Called when the HealthState enters [Health].
# Overwrite to add custom behaviour.
func enter() -> void:
	pass

# Virtual function. Called when the HealthState leaves [Health].
# Overwrite to add custom behaviour.
func exit() -> void:
	pass

# Virtual function. Called every frame inside [Health].
# Overwrite to add custom behaviour.
func process(delta : float) -> void:
	pass

# Virtual function. Determines if a HealthState can be instanced multiple times in the same [Health].
# Overwrite to set if this HealthState can be instanced more than once inside the same [Health].
func allows_multiple() -> bool:
	return false

# Virtual function. Determines the name of the HealthState for search purposes.
# Overwrite to set the name of the HealthState when instanced inside [Health].
func get_state_name() -> String:
	return "_CLASS_"

# Virtual function. Determines the name of the HealthState for search purposes.
# Overwrite to set the name of the HealthState when instanced inside [Health].
static func get_state_static_name() -> String:
	return "_CLASS_"
