class_name Hurtbox3D
## Used to send damage signals.
extends Area3D

@export_range(1, 12) var damage : int = 1

@export_group("Damage continuity")
## Continue dealing damage if Hitbox stays inside.
@export var continuous_damage : bool = false
## Time between damage ticks.
@export var damage_rate : float = 1.0

var hitboxes : Dictionary

func _ready() -> void:
	if(!continuous_damage):
		set_process(false)
	
	area_entered.connect(Callable(func(area : Area3D) -> void:
		if(area is not Hitbox3D): return
		
		(area as Hitbox3D).health.damage(damage)
		hitboxes[area] = {}
		hitboxes[area]["last_damaged"] = damage_rate
		hitboxes[area]["hitbox"] = area
	))
	
	area_exited.connect(Callable(func(area : Area3D) -> void:
		if(area is not Hitbox3D): return
		
		hitboxes.erase(area.name + area.get_parent().name)
	))
	
func _process(delta: float) -> void:
	for key in hitboxes.keys():
		hitboxes[key].last_damaged -= delta
		if(hitboxes[key].last_damaged < 0.0):
			hitboxes[key].last_damaged = damage_rate
			(hitboxes[key].hitbox as Hitbox3D).health.damage(damage)
