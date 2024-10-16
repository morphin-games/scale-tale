@tool
class_name Grabber3D
extends Area3D

@export var pawn : Pawn3D = get_parent() as Pawn3D
@export var grab_point : Node3D
@export var state_machine : PPStateMachine
@export var offset : Vector3

enum GrabState {
	NONE,
	GRABBING,
	DROPPING,
	THROWING,
	GRABBED,
}

var grabbed_object : Node3D
var near_grabbables : Array[Grabbable3D]
var grab_state : GrabState = GrabState.NONE
var tweened_grabbed_position : Vector3 = Vector3(0.0, 0.0, 0.0)

func _ready() -> void:
	collision_layer = CollisionLayerNames.GRABBER
	collision_mask = CollisionLayerNames.GRABABBLE
	
	(pawn._controller as PlayerController).kxi_action_1_pressed.connect(Callable(func() -> void:
		if(grabbed_object == null):
			var nearest_grabbable : Grabbable3D = get_nearest_grabbable()
			if(nearest_grabbable == null): return
			
			state_machine.force_state("PPStateBeginningGrab")
			grabbed_object = nearest_grabbable.parent
			tweened_grabbed_position = grabbed_object.global_transform.origin
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(self, "tweened_grabbed_position", grab_point.global_transform.origin, 0.4)
			if(nearest_grabbable.parent is RigidBody3D):
				(nearest_grabbable.parent as RigidBody3D).freeze = true
				(nearest_grabbable.parent as RigidBody3D).linear_velocity = Vector3(0.0, 0.0, 0.0)
				(nearest_grabbable.parent as RigidBody3D).angular_velocity = Vector3(0.0, 0.0, 0.0)
		else:
			if(grabbed_object is RigidBody3D):
				(grabbed_object as RigidBody3D).freeze = false
				(grabbed_object as RigidBody3D).linear_velocity = Vector3(0.0, 0.0, 0.0)
				(grabbed_object as RigidBody3D).angular_velocity = Vector3(0.0, 0.0, 0.0)
			grabbed_object = null
			grab_state = GrabState.NONE
	))
	
func get_nearest_grabbable() -> Grabbable3D:
	if(near_grabbables.size() == 0): return null
	
	var nearest_grabbable : Grabbable3D = near_grabbables[0]
	for near_grabbable in near_grabbables:
		if(abs(near_grabbable.global_transform.origin.distance_to(global_transform.origin))):
			nearest_grabbable = near_grabbable
			
	return nearest_grabbable
	
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()): return
	
	if(state_machine.state is PPStateBeginningGrab):
		grab_state = GrabState.GRABBING
	else:
		if(grabbed_object == null):
			grab_state = GrabState.NONE
		else:
			grab_state = GrabState.GRABBED
			
	if(grabbed_object != null):
		grabbed_object.global_transform = grab_point.global_transform
			
	#if(grab_state == GrabState.GRABBING):
		#grabbed_object.global_transform.origin = tweened_grabbed_position + offset
	#elif(grab_state == GrabState.GRABBED):
		#grabbed_object.global_transform.origin = grab_point.global_transform.origin + offset
