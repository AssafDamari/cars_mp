extends Spatial

var started = false

func init_lunch_pad():
	if get_tree().get_network_unique_id() != 1:
		# if we are not host we will ask host for lunch_pad state (this will be usefull if we join after start)
		rpc_id(1, "lunch_pad_state_request")
			
func activate_start():
	$timer.start()
	$animation_player.play("start")
	started = true
		
func _on_timer_timeout():
	$walls.transform.origin.y -=10

remote func lunch_pad_state_request():
	print("lunch_pad_state_request")
	rpc_id(get_tree().get_rpc_sender_id(),"set_lunch_pad_state", started)
	
remote func set_lunch_pad_state(started):
	print("set_lunch_pad_state")
	if started:
		activate_start()
