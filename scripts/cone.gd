extends Spatial

func _on_collision_shape_body_entered(body):
	$particles_red.emitting = true
	$particles_white.emitting = true
	$Plane.visible = false
	$timer.start()


func _on_timer_timeout():
	queue_free()
