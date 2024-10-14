class_name PPStateAnimator
extends Node

@export var state_machine : PPStateMachine
@export var animation_tree : AnimationTree
@export var animations : Array[PPStateAnimation]

func _ready() -> void:
	state_machine.state_changed.connect(Callable(func(state : State) -> void:
		for animation in animations:
			if(animation.pp_state_class == (state.get_script() as GDScript).get_global_name()):
				var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
				state_machine.travel(animation.animation_name)
	))
