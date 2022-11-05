extends Spatial

var count = 5
var scene = ""

func setup(powerup_scene, powerup_count):
	scene = powerup_scene
	count = powerup_count
		
func _ready():
	add_cannon_ball()
	
func _on_timer_timeout():
	add_cannon_ball()
	
func add_cannon_ball():
	if count > 0:
		count = count - 1
		add_child(load(scene).instance())
	else:
		$timer.stop()
