@icon("isave_meta.svg")
class_name SaveMeta
## Base Class for all SaveMeta resources.
## If you need more meta properties, extend a script from this class and change the type of [member SaveSystem.save_meta] to your new SaveMeta class.
extends Resource

@export var id : String = "default_id"
@export var name : String = "default_name"
@export var description : String = "default_description"
@export var creation_date : String = "0000-00-00 00:00"
@export var modification_date : String = "0000-00-00 00:00"
@export var version : String = "0.0.0"
