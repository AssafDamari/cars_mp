extends Spatial

var started = false
var winner = ""

func init_lunch_pad():
	if get_tree().get_network_unique_id() != 1:
		# if we are not host we will ask host for lunch_pad state (this will be usefull if we join after start)
		rpc_id(1, "lunch_pad_state_request")
			
func activate_start():
	if not started:
		started = true
		$timer.start()
		$animation_player.play("start")
	else:
		started = false
		$timer.stop()		
		$walls.transform.origin.y = 0
		$animation_player.seek(0, true)
		
func _on_timer_timeout():
	$walls.transform.origin.y = -10

remote func lunch_pad_state_request():
	rpc_id(get_tree().get_rpc_sender_id(),"set_lunch_pad_state", started)
	
remote func set_lunch_pad_state(started):
	if started:
		activate_start()

func _on_area_body_entered(body):
	var _character = body.owner
	if winner == "" and _character and _character.is_in_group("Characters") and _character.next_checkpoint_index < 0: 
		_character.win()
		winner = _character.name
		print(_character.name + " is the winner")
