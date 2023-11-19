extends Node

const PATH : String = "user://savefile.tres"

var persistance_data : PersistanceData = PersistanceData.new()

func _init() -> void:
	print("PERSISTANCE INITIALIZED")
	var loaded : Resource = ResourceLoader.load(PATH)
	if(loaded == null):
		ResourceSaver.save(persistance_data, PATH)
	else:
		persistance_data = loaded
		print(loaded.respawn_position)
		print(persistance_data.respawn_position)
		
		
func save() -> void:
	print("pers data: ", persistance_data.respawn_position)
	ResourceSaver.save(persistance_data, PATH)
