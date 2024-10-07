class_name Projectile
## Base class for all projectiles.
## Even though projectiles inherit from [CharacterBody3D], they MUST NOT have a [CollisionShape3D].
## To interact on collisions, add an [Area3D] and connect it to [member area].
extends CharacterBody3D

@export var area : Area3D

var projectile_data : ProjectileData

func setup(projectile_data : ProjectileData) -> void:
	self.projectile_data = projectile_data
	velocity = projectile_data.direction * projectile_data.speed
	if(area == null):
		push_warning("Area3D not configured for Projectile!")
		return
		
	area.area_entered.connect(Callable(func(area : Area3D):
		area_hit(area)
	))
	
## Called when an external area hits with [member area].
## Override to add custom behaviour.
func area_hit(area : Area3D) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
