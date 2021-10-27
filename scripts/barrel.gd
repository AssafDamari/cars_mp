extends Spatial

const exploitationPrefab = preload("res://scenes/exploitation.tscn")

func _on_area_body_entered(body):
	print(body.name)
	
	if body is RigidBody:
		var impulse_direction = (body.global_transform.origin - global_transform.origin).normalized()
		var exploation_force_factor = -body.linear_velocity
		body.apply_impulse(Vector3(0,0,0), impulse_direction * exploation_force_factor)
		if body.get_owner() and body.get_owner().has_method("take_damage"):
			body.get_owner().take_damage()
			
	add_exploitation()
	queue_free()

func add_exploitation():
	var exploitation = exploitationPrefab.instance()
	exploitation.global_transform = global_transform
	get_tree().root.add_child(exploitation)
