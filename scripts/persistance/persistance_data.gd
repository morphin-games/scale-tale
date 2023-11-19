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
@export var respawn_position : Vector3
@export var coin_recount : int = 0

# Config
@export var fullscreen : bool = true
@export var resolution : Vector2 = Vector2(1280, 720)
@export var graphical_level : int = GraphicalLevels.HIGH_END
@export var volume_db : float = 0.0

