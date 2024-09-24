@icon("ipooled.svg")
class_name Pooled
extends Node

signal activated
signal deactivated

@onready var pooled : Variant = get_child(0)
@onready var active : bool = false

## [member active] will begin as false when the scene loads
var pooler : Pooler

func _ready() -> void:
	deactivate()

## Activates the pooled object. DO NOT call this function by yourself, this is handled by the [class Pooler].
func activate() -> void:
	active = true
	if(pooled.get("visible") != null):
		pooled.visible = true
	if(pooled.has_method("set_process")):
		pooled.set_process(true)
		pooled.set_physics_process(true)
	emit_signal("activated")
	
## Deactivates the pooled object. DO NOT call this function by yourself, this is handled by the [class Pooler].
func deactivate() -> void:
	active = false
	if(pooled.get("visible") != null):
		pooled.visible = false
	if(pooled.has_method("set_process")):
		pooled.set_process(false)
		pooled.set_physics_process(false)
	emit_signal("deactivated")
	
func _process(delta : float) -> void:
	if(!active): return
	if(deactivation_condition() == true):
		deactivate()
		
## Virtual function.
## Add your own deactivation condition. This function must return a boolean (true -> deactivates, false -> keeps active).
func deactivation_condition() -> bool:
	return true
