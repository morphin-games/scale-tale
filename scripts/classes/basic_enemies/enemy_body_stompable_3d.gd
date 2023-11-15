class_name EnemyBodyStompable3D
extends EnemyBody3D

@export var stompable : Stompable3D
@export var drops : Array[Dropable]

func get_drop() -> PackedScene:
	var poll : Array[PackedScene]
	for drop in drops:
		for chance in drop.chance:
			poll.append(drop.drop)
			
	return poll.pick_random()

func _ready() -> void:
	stompable.stomped.connect(Callable(func() -> void:
		var drop : PackedScene = get_drop()
		if(drop != null):
			var instance : Node3D = drop.instantiate()
			instance.global_transform.origin = global_transform.origin
			get_parent().add_child(instance)
			
		print(name)
			
		queue_free()
	))
