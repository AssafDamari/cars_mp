extends Spatial

var ball
var speed_input = 300

func _ready():
	ball = get_parent().get_owner().get_node("Ball")
	
func _physics_process(delta):
	ball.add_central_force(-global_transform.basis.z * speed_input)

func _on_timer_timeout():
	SignalManager.emit_signal("ui_show_pickup",null)
	queue_free()
