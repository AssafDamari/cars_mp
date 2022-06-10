extends Spatial

var burrel_prefab = "res://scenes/barrel.tscn"

func _ready():
	set_as_toplevel(true)
	var burrel_instance = load(burrel_prefab).instance()
	$drop_position.add_child(burrel_instance)
	burrel_instance.global_transform.origin.y -= 0.8
