class_name HealthStateIncreaseMax
extends HealthState

var original_health : int
var increment : int
var heal_on_exit : bool

# Godot virtual function.
# Overwrite to add custom behaviour.
func _init(increment : int) -> void:
	self.increment = increment

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
	return "HealthStateIncreaseMax"

# Virtual function. Determines the name of the HealthState for search purposes.
# Overwrite to set the name of the HealthState when instanced inside [Health].
static func get_state_static_name() -> String:
	return "HealthStateIncreaseMax"
