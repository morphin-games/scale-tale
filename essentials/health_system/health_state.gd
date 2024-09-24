@icon("ihealth_state.svg")
class_name HealthState
## Base class for all HealthStates. A HealthState modifies the behaviour of [Health].
extends Resource

var _health : Health

## Virtual function. Called when the HealthState enters [Health].
## Overwrite to add custom behaviour.
func enter() -> void:
	pass

## Virtual function. Called when the HealthState leaves [Health].
## Overwrite to add custom behaviour.
func exit() -> void:
	pass

## Virtual function. Called every frame inside [Health].
## Overwrite to add custom behaviour.
func process(delta : float) -> void:
	pass

## Function called when the HealthState has finished applying itself.
func erase_self() -> void:
	_health.health_states.erase(self)
	exit()
	
func link_health(health : Health) -> void:
	if(_health != null): return
	_health = health

## Virtual function. Determines if a HealthState can be instanced multiple times in the same [Health].
## Overwrite to set if this HealthState can be instanced more than once inside the same [Health].
func allows_multiple() -> bool:
	return false

## Virtual function. Determines the name of the HealthState for search purposes.
## Overwrite to set the name of the HealthState when instanced inside [Health].
func get_state_name() -> String:
	return "HealthState"
	
static func get_state_static_name() -> String:
	return "HealthState"
