class_name IntroVidManager
extends Control

@export var video : VideoStreamPlayer
@export var anim : AnimationPlayer
@export var next_scene : PackedScene

func _ready() -> void:
	if(video != null):
		video.finished.connect(Callable(func() -> void:
			get_tree().change_scene_to_packed(next_scene)
		))
		
	if(anim != null):
		anim.animation_finished.connect(Callable(func(anim_name : String) -> void:
			get_tree().change_scene_to_packed(next_scene)
		))
		
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_toggle")):
		get_tree().change_scene_to_packed(next_scene)
