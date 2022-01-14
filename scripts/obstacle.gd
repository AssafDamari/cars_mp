extends StaticBody

func _ready():
	$area.connect("body_entered", self, "_on_area_body_entered")

func _on_area_body_entered(body):
	if body.owner == null or not body.owner is Character:
		return
		
	if body.owner.is_in_group("Characters"):
		$body.visible = false
		$collision_shape.disabled = true
		$area/collision_shape.disabled = true
		$particles.emitting = true
		$timer.start()


func _on_timer_timeout():
	queue_free()
