extends StaticBody


func _on_area_body_entered(body):
	if body.owner == null or not body.owner is Character:
		return
		
	if body.owner.is_in_group("Characters"):
		$Icosphere.visible = false
		$collision_shape.disabled = true
		$area/collision_shape.disabled = true
		$particles.emitting = true
		$timer.start()


func _on_timer_timeout():
	queue_free()
