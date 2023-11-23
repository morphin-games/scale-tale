extends Node

const PATH : String = "user://savefile.tres"

var persistance_data : PersistanceData = PersistanceData.new()
	
func _init() -> void:
	var loaded : Resource = ResourceLoader.load(PATH)
	if(loaded == null):
		ResourceSaver.save(persistance_data, PATH)
	else:
		persistance_data = loaded
#		load_config()
		
func save() -> void:
	ResourceSaver.save(persistance_data, PATH)
