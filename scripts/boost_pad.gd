extends Spatial

var boost_ammount = 300

func _on_area_body_entered(body):
	if body.owner == null or not body.owner is Character:
		return
		
	if body.owner.is_in_group("Characters") and (body.owner.controller_is_player or body.owner.controller_is_ai):
		body.apply_central_impulse(-global_transform.basis.z * boost_ammount)
		
		if body.owner.controller_is_player:
			$audio_stream_player.play()
