extends Node

const SETTINGS_FILE = "user://settings.save"

var game_data = {}

func _ready() -> void:
	load_data()

func load_data():
	var file

	if FileAccess.file_exists(SETTINGS_FILE) == false:
		file = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
		game_data = {
			"full_screen_on": false,
			"vsync_on": false,
			"master_vol": -10,
			"music_vol": -10,
			"sfx_vol": -10,
			"mouse_sens": 0.002
		}
		save_data()
	
	file = FileAccess.open(SETTINGS_FILE,FileAccess.READ)
	game_data = file.get_var()
	print(game_data)
	file.close()
	
func save_data():
	var file : FileAccess = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	file.store_var(game_data)
	file.close()

