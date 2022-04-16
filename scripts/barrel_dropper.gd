extends Spatial

var burrel_prefab = "res://scenes/barrel.tscn"

func _ready():
	set_as_toplevel(true)
	$drop_position.add_child(load(burrel_prefab).instance())
