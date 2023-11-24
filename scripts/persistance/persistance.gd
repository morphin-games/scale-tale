extends Node

const PATH : String = "user://savefile.tres"

signal persistance_data_changed

var persistance_data : PersistanceData = PersistanceData.new()
	
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_reset_persistance")):
		var new_pers : PersistanceData = PersistanceData.new()
		persistance_data.respawn_position = new_pers.respawn_position
		print("Persistance reseted")
		save()
	
func _init() -> void:
	var loaded : Resource = ResourceLoader.load(PATH)
	if(loaded == null):
		ResourceSaver.save(persistance_data, PATH)
	else:
		persistance_data = loaded
#		load_config()
		
func save() -> void:
	emit_signal("persistance_data_changed")
	ResourceSaver.save(persistance_data, PATH)
