@icon("ipooler.svg")
class_name Pooler
extends Node

signal node_activated(pooled : Pooled)
signal node_deactivated(pooled : Pooled)

@export var pooled_scene : PackedScene
@export var max_pooled : int = 100

var _pooled : Array[Pooled]
var _next_pool : int = 0

func _ready() -> void:
	for i in range(0, max_pooled):
		var instance : Pooled = pooled_scene.instantiate() as Pooled
		instance.activated.connect(Callable(func() -> void:
			emit_signal("node_activated", instance)
		))
		instance.deactivated.connect(Callable(func() -> void:
			emit_signal("node_deactivated", instance)
		))
		add_child(instance)
		_pooled.append(instance)
		
## Activates the next instance of [class Pooled].
func activate() -> Pooled:
	var pooled : Pooled = _pooled[_next_pool]
	pooled.activate()
	_next_pool += 1
	if(_next_pool >= max_pooled):
		_next_pool = 0
	return pooled
