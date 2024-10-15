class_name PlayerPawn
extends PlatformerPawn

@onready var edge_hang_top : RayCast3D = %EdgeHangTop
@onready var edge_hang_low : RayCast3D = %EdgeHangLow
@onready var shadow_offset : RayCast3D = %ShadowOffset as RayCast3D

func process(delta : float) -> void:
	var ctx : PPContextPlatformer = $PPStateMachine.context as PPContextPlatformer
	super(delta)
	print(body.is_on_floor())
	if(edge_hang_low.is_colliding()):
		var face : Basis = (edge_hang_low.get_collider() as Node3D).global_basis.orthonormalized()
		var normal : Vector3 = edge_hang_low.get_collision_normal()
		var direction : Vector3 = face * normal
