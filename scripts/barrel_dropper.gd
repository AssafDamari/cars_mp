extends Spatial

var burrel_prefab = "res://scenes/barrel.tscn"
var burrel_count = 5

func _ready():
	add_burrel()
	
func add_burrel():
	if burrel_count > 0:
		burrel_count = burrel_count - 1
		var burrel_instance = load(burrel_prefab).instance()
		$drop_position.add_child(burrel_instance)
		burrel_instance.global_transform.origin.y -= 0.8
		burrel_instance.set_as_toplevel(true)
	else:
		$timer.stop()

	
func _on_timer_timeout():
	add_burrel()
