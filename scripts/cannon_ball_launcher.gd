extends Spatial

var count = 3
	
func _ready():
	add_cannon_ball()
	
func _on_timer_timeout():
	add_cannon_ball()
	
func add_cannon_ball():
	if count > 0:
		count = count - 1
		add_child(load("res://scenes/cannon_ball.tscn").instance())
	else:
		$timer.stop()
