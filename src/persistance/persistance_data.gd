class_name PersistanceData
extends Resource

enum GraphicalLevels {
	LOW_END = 1
	,MID_END = 2
	,HIGH_END = 3
}

# Gameplay
# Each gem has an ID to recognize it
@export var taken_gems : Array[String] = []
@export var respawn_position : Vector3 = Vector3.ZERO
@export var coin_recount : int = 0

# Config
@export var fullscreen : Array = [DisplayServer.WINDOW_MODE_FULLSCREEN, true]
@export var resolution_scale : float = 1.0
@export var texture_quality : float = 1.0
@export var volume_db : float = 0.0
@export var music_db : float = 0.0
@export var effects_db : float = 0.0
@export var max_fps : int = 60

# Controls
@export var invert_cam_x : bool = false
@export var invert_cam_y : bool = false
@export var cam_speed_x : float = 1.0
@export var cam_speed_y : float = 1.0

