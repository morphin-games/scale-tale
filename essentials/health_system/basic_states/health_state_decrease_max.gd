class_name HealthStateDecreaseMax
extends HealthState

var original_health : int
var decrement : int
var heal_on_exit : bool

func _init(decrement : int, heal_on_exit : bool) -> void:
	self.decrement = decrement
	self.heal_on_exit = heal_on_exit

# Virtual function. Called when the HealthState enters [Health].
# Overwrite to add custom behaviour.
func enter() -> void:
	original_health = _health.max_health
	var original_heal_on_set_max_health : bool = _health.heal_on_set_max_health 
	_health.heal_on_set_max_health = false
	_health.max_health = decrement
	if(_health.health > _health.max_health):
		_health.health = _health.max_health
	_health.heal_on_set_max_health = original_heal_on_set_max_health
	
# Virtual function. Called when the HealthState leaves [Health].
# Overwrite to add custom behaviour.
func exit() -> void:
	_health.max_health = original_health
	if(!heal_on_exit): return
	var original_heal_on_set_max_health : bool = _health.heal_on_set_max_health 
	_health.heal_on_set_max_health = false
	_health.health = _health.max_health
	_health.heal_on_set_max_health = original_heal_on_set_max_health

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
	return "HealthStateDecreaseMax"
	
static func get_state_static_name() -> String:
	return "HealthStateDecreaseMax"
