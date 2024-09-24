extends Node

@onready var debug : bool = true
@onready var slots : int = 3
# Change SaveFile for your custom save file resource
@onready var save_file : SaveFile = SaveFile.new()
# Change SettingsFile for your custom settings file resource
@onready var settings_file : SettingsFile = SettingsFile.new()
# Change SaveMeta for your custom save_meta file resource
@onready var save_file_meta : SaveMeta = SaveMeta.new()
@onready var save_file_metas : SaveMetas = SaveMetas.new()
@onready var current_slot : int = 0

func _ready() -> void:
	var path : String = _get_path() + "save_file_metas.tres"
	if(!ResourceLoader.exists(path)):
		ResourceSaver.save(save_file_metas, path)
	save_file_metas = ResourceLoader.load(path)
		
func _get_path() -> String:
	if(debug):
		return "res://"
	else:
		return "user://"

## Save the game to the specified slot.
## The saved values are those of property [save_file].
func save_game(slot : int = current_slot) -> void:
	var path : String = _get_path() + "save_" + str(slot) + ".tres"
	var path_metas : String = _get_path() + "save_file_metas.tres"
	if(slot - 1 > slots):
		push_warning("Slot [" + str(slot) + "] out of bounds.")
		return
	if(!save_file_metas.save_metas.has(slot)):
		save_file_metas.save_metas[slot] = save_file_meta
		save_file_metas.save_metas[slot]["id"] = str(int(Time.get_unix_time_from_system()))
	ResourceSaver.save(save_file, path)
	ResourceSaver.save(save_file_metas, path_metas)
	
## Load the game to the specified slot.
## The loaded values are stored in property [save_file].
func load_game(slot : int) -> void:
	current_slot = slot
	var path : String = _get_path() + "save_" + str(slot) + ".tres"
	var path_metas : String = _get_path() + "save_file_metas.tres"
	if(!ResourceLoader.exists(path)):
		push_warning("No save file on slot [" + str(slot) + "].")
		return
	if(slot - 1 > slots):
		push_warning("Slot [" + str(slot) + "] out of bounds.")
		return
	save_file = ResourceLoader.load(path)
	save_file_metas = ResourceLoader.load(path_metas)
	
## Save the SaveFile meta to the specified slot.
## The saved values are those of property [save_file_meta].
func save_meta(slot : int = current_slot) -> void:
	var path : String = _get_path() + "save_file_metas.tres"
	if(slot - 1 > slots):
		push_warning("Slot [" + str(slot) + "] out of bounds.")
		return
	if(!save_file_metas.save_metas.has(slot)):
		save_file_metas.save_metas[slot] = save_file_meta
		save_file_metas.save_metas[slot]["id"] = str(int(Time.get_unix_time_from_system()))
	ResourceSaver.save(save_file_metas, path)
	
## Save the settings.
## The saved values are those of property [settings_file].
func save_settings() -> void:
	var path : String = _get_path() + "settings.tres"
	ResourceSaver.save(save_file, path)
	
## Load the settings.
## The loaded values are stored in property [settings_file].
func load_settings() -> void:
	var path : String = _get_path() + "settings.tres"
	if(!ResourceLoader.exists(path)):
		push_warning("No settings file found.")
		return
	settings_file = ResourceLoader.load(path)
