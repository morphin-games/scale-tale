class_name KuriakutoNodeSync
## Kuriakuto Node to sync Kuriakuto values to properties without the need of code.
## Place a KuriakutoNodeSync Node as child of the Node that will be synced and configure [member kuriakuto_property] and [member node_property].
## The sync will automatically end once the parent node is destroyed.
extends Node


## Kuriakuto property where the value is taken
@export var kuriakuto_property : String = ""
## Node property that will react to [member kuriakuto_property] value changes
@export var node_property : String = ""

func _ready() -> void:
	KuriakutoCore.kuriakuto_resource_added.connect(Callable(func(kuriakuto_resource : KResource) -> void:
		if(kuriakuto_resource.get_kuriakuto_name() != kuriakuto_property): return
		KuriakutoCore.sync(get_parent(), node_property, kuriakuto_property)
		tree_exiting.connect(Callable(func() -> void:
			KuriakutoCore.desync(get_parent(), node_property, kuriakuto_property)
		))
	))
