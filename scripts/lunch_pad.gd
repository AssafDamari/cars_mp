extends Spatial

var started = false
var latest_rank = 1

func init_lunch_pad():
	if get_tree().get_network_unique_id() != 1:
		# if we are not host we will ask host for lunch_pad state (this will be usefull if we join after start)
		rpc_id(1, "lunch_pad_state_request")
			
func activate_start():
	if not started:
		started = true
		$timer.start()
		$animation_player.play("start")
		latest_rank = 1 
	else:
		started = false
		$timer.stop()		
		$walls.transform.origin.y = 0
		$animation_player.seek(0, true)
		
func _on_timer_timeout():
	$walls.transform.origin.y = -10

remote func lunch_pad_state_request():
	rpc_id(get_tree().get_rpc_sender_id(),"set_lunch_pad_state", started)
	
remote func set_lunch_pad_state(_started):
	if _started:
		activate_start()
		
sync func update_latest_rank(new_latest_rank):
	latest_rank = new_latest_rank
	
func _on_area_body_entered(body):
	var _character = body.owner
	if _character and _character.is_in_group("Characters") and _character.next_checkpoint_index < 0: 
		# if character rank was not yet set, then set it now
		if _character.rank == 0:
			_character.set_rank(latest_rank)
			rpc("update_latest_rank", latest_rank + 1)

		
