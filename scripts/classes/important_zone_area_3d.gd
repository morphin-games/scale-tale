class_name ImportantZoneArea3D
extends Area3D

signal important_zone_entered

@export var zone_name : String = "Unnamed"
@export var ui : Label

func _ready() -> void:
	body_entered.connect(Callable(func(body : PhysicsBody3D) -> void:
		if(body.name == "Player"):
			ui.text = zone_name
			
			var v_tween : Tween = get_tree().create_tween()
			
			v_tween.finished.connect(Callable(func() -> void:
				await get_tree().create_timer(2.0).timeout
				var h_tween : Tween = get_tree().create_tween()
				h_tween.tween_property(ui, "modulate:a", 0.0, 0.5)
			))
			
			v_tween.tween_property(ui, "modulate:a", 1.0, 0.5)
	))
