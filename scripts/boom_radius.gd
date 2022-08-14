extends Spatial

var exploation_force_factor = 30

func _ready():
	$timer.connect("timeout", self, "queue_free")
	
	
func boom():
	$particles.emitting = true
	var overlapping_bodies = $area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body and body is RigidBody and body.get_owner():
			var shooter_name = get_parent().get_parent().get_parent().name
			var other_name = body.get_owner().name
			# affect other charachters only
			if shooter_name != other_name:
				var impulse_direction = (body.global_transform.origin - global_transform.origin).normalized()
				body.apply_impulse(Vector3(0,0,0), impulse_direction * exploation_force_factor)
				if body.get_owner().has_method("take_damage"):
					body.get_owner().take_damage()
	
	
func _on_area_body_entered(body):
	boom()
	$timer.start()
