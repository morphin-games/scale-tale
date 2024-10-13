class_name PPContextPlatformer
extends PPContext

@export_category("Stats")
## The "default" speed. Any modification that has to return to the base value will return to this value.
@export var return_speed : float = 8.0
## The "default" acceleration. Any modification that has to return to the base value will return to this value.
@export var return_acceleration : float = 1.5
## The "default" gravity. Any modification that has to return to the base value will return to this value.
@export var return_gravity : float = 0.49
## Number of seconds before being affected by gravity after leaving a platform.
@export var return_coyote_time : float = 0.09

var fixed_xz_velocity : Vector2 = Vector2(0.0, 0.0)
var velocity_y : float = 0.0
var speed : float = return_speed
var acceleration : float = return_acceleration
var gravity : float = return_gravity
var coyote_time : float = return_coyote_time
