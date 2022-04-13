extends Spatial

export var trails_color:Color = Color.sienna

func _ready():
	SignalManager.emit_signal("toggle_music")
	
func get_trails_color():
	return trails_color
