@tool
extends EditorPlugin

const KURIAKUTO_LOCAL_PATH : String = "res://_kuriakuto"
const KURIAKUTO_DICT_PATH : String = "res://_kuriakuto/kuriakuto_dict.gd"
const KD_REFERENCE_MANAGER_PATH : String = "res://_kuriakuto/kd_kreference_manager.tres"
const KURIAKUTO_LOCAL_README_PATH : String = "res://_kuriakuto/README.md"

func _enter_tree() -> void:
	_setup_private_folder()
	add_autoload_singleton("KuriakutoCore", "kuriakuto_core.gd")
	add_autoload_singleton("KD", KURIAKUTO_DICT_PATH)
	scene_saved.connect(Callable(func(scene_path : String) -> void:
		var scene : Node = load(scene_path).instantiate()
		var child_index : int = 0
		for child in _get_all_children(scene):
			if(child.get_script() == null): continue
			_save_kresources(child.get_script(), (child.get_script() as GDScript).resource_path, child.name + str(child_index))
			child_index += 1
	))
	resource_saved.connect(Callable(func(resource : Resource) -> void:
		if(resource is not GDScript): return
		var script : GDScript = resource as GDScript
		_save_kresources(script, resource.resource_path)
	))
	
func _exit_tree() -> void:
	remove_autoload_singleton("KuriakutoCore")
	remove_autoload_singleton("KD")
	
	
	
# Kuriakuto needs a _kuriakuto folder with certain files for autocompletion.
func _setup_private_folder() -> void:
	if(!DirAccess.dir_exists_absolute(KURIAKUTO_LOCAL_PATH)):
		var k = DirAccess.make_dir_absolute(KURIAKUTO_LOCAL_PATH)
	if(!FileAccess.file_exists(KURIAKUTO_DICT_PATH)):
		var kuriakuto_dict_path : FileAccess = FileAccess.open(KURIAKUTO_DICT_PATH, FileAccess.WRITE)
		kuriakuto_dict_path.close()
	if(!ResourceLoader.exists(KD_REFERENCE_MANAGER_PATH)):
		ResourceSaver.save(KDReferenceManager.new(), KD_REFERENCE_MANAGER_PATH)
	if(!FileAccess.file_exists(KURIAKUTO_LOCAL_README_PATH)):
		var kuriakuto_local_readme : FileAccess = FileAccess.open(KURIAKUTO_LOCAL_README_PATH, FileAccess.WRITE)
		kuriakuto_local_readme.store_line("# IMPORTANT")
		kuriakuto_local_readme.store_line("Kuriakuto relies on the content of this folder to correctly display autocompletion of KResources.")
		kuriakuto_local_readme.store_line("DO NOT modify kuriakuto_dict.gd or kd_reference_manager.tres by yourself if you don't know what you are doing.")
		kuriakuto_local_readme.close()
	
# Saves all the KResources to Singleton kuriakuto_dict.gd.
# This function makes every KResource autocompletable.
# To autocomplete a KResource, simply write "KD.[kresource_name]".
func _save_kresources(script_from : GDScript, script_path : String, extra_id : String = "") -> void:
	_setup_private_folder()
	var kuriakuto_dict : GDScript = load(KURIAKUTO_DICT_PATH) as GDScript
	var sf_source : String = script_from.source_code
	var kd_source : String = kuriakuto_dict.source_code
	var kresource_regex = RegEx.new()
	kresource_regex.compile("=(\\s?)+[a-zA-Z]+.new\\(\"([a-zA-Z0-9_-]+)\"")
	var all_kresources : Dictionary = _get_all_kresource_references()
	var current_kresources : Dictionary
	for kresource in kresource_regex.search_all(sf_source):
		var kresource_match = kresource.get_string(2)
		if(kresource_match == ""):
			continue
		current_kresources[kresource_match] = null
		current_kresources["source_path"] = script_path
	# First, remove previous kuriakuto_dict.gd, it will be recreated with the new values.
	DirAccess.remove_absolute(KURIAKUTO_DICT_PATH)
	# all_kresources is a Dictionary that holds all the stored KResources.
	# script_path + extra_id is the key in the Dictionary that represents the KResources inside a script or scene.
	# Change the previous KResources of a script to the new ones.
	# This way, Kuriakuto keeps track of deleted KResources.
	all_kresources[script_path + extra_id] = current_kresources
	# Creating again the source string of kuriakuto_dict.gd.
	# The source string contains all the KResource names stored as variables of the same name.
	var kuriakuto_dict_file_new_source : String = "extends Node\n\n"
	kuriakuto_dict_file_new_source += "# IMPORTANT\n"
	kuriakuto_dict_file_new_source += "# Kuriakuto relies on this Singleton to correctly display autocompletion of KResources.\n"
	kuriakuto_dict_file_new_source += "# Each time you save, the content of this Singleton is automatically updated.\n"
	kuriakuto_dict_file_new_source += "# DO NOT modify this file by yourself if you don't know what you are doing.\n"
	# Storing all KResources inside all_kresources Dictionary.
	var last_key : String = ""
	for file_path in all_kresources.keys():
		for kresource in all_kresources[file_path].keys():
			var kresource_in_all_kresources_regex : RegEx = RegEx.new()
			kresource_in_all_kresources_regex.compile("&\"" + kresource + "\"")
			var kresource_in_all_kresources_regex_result = kresource_in_all_kresources_regex.search(kuriakuto_dict_file_new_source)
			if(kresource_in_all_kresources_regex_result != null):
				continue
			if(kresource == "source_path"): # Skip "source_path" keys (they represent the real path of a KResource, not a KResource).
				continue
			if(all_kresources[file_path]["source_path"] != last_key): # Include source of KResource only if it changes from previous source
				kuriakuto_dict_file_new_source += "\n\n## Declared inside \"" + all_kresources[file_path]["source_path"] + "\""
			kuriakuto_dict_file_new_source += "\nvar " + kresource + " : StringName = &\"" + kresource + "\""
			last_key = all_kresources[file_path]["source_path"]
	# Save again kuriakuto_dict.gd.
	var kuriakuto_dict_file : FileAccess = FileAccess.open(KURIAKUTO_DICT_PATH, FileAccess.WRITE)
	kuriakuto_dict_file.store_string(kuriakuto_dict_file_new_source)
	kuriakuto_dict_file.close()
	# Save all the KResources from this iteration.
	# When _save_kresources is called again, this KDReferenceManager will hold which KResources were stored before.
	# This way, Kuriakuto keeps track of deleted KResources.
	var new_kd_manager : KDReferenceManager = KDReferenceManager.new()
	new_kd_manager.references = all_kresources
	ResourceSaver.save(new_kd_manager, KD_REFERENCE_MANAGER_PATH)
	
# Returns all the stored references to a KResource.
# This function is used to compare the current script KResources to the KResources stored before.
# If there are less KResources in the current version, they should be removed inside [method _save_kresources]
func _get_all_kresource_references() -> Dictionary:
	var kd_kreference_manager : KDReferenceManager = ResourceLoader.load(KD_REFERENCE_MANAGER_PATH) as KDReferenceManager
	return kd_kreference_manager.references
	
func _get_all_children(node : Node, children : Array[Node] = []) -> Array[Node]:
	children.push_back(node)
	for child in node.get_children():
		children = _get_all_children(child, children)
	return children
