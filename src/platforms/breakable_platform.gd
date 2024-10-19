class_name BreakablePlatform extends Area3D

var to_break : bool = false
@export var time_to_destroy : float = 2.0
@export var timer_to_respawn : float = 2.0
@onready var target : PhysicsBody3D = get_parent() as PhysicsBody3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(to_break):
		to_break = false
		get_tree().create_timer(timer_to_respawn)
		await get_tree().create_timer(timer_to_respawn).timeout
		to_break = false 
		print("to respawn timeout")
		#Respawn Timeout
		target.set_collision_layer_value(1,true)	
		target.set_collision_layer_value(2,true)
		target.visible = true

func _on_body_entered(body: Node3D) -> void:
	print("player detected") # Replace with function body.
	get_tree().create_timer(time_to_destroy)
	await get_tree().create_timer(time_to_destroy).timeout
	#Timeout
	target.set_collision_layer_value(1,false)	
	target.set_collision_layer_value(2,false)
	target.visible = false
	to_break = true 
	
