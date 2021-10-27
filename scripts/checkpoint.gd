extends StaticBody

func _ready():
	if get_index() == 0:
		SignalManager.connect("first_checkpoint_request", self , "_on_first_checkpoint_request")
		
func _on_area_body_entered(body):
	if body.owner == null:
		return
		
	if body.owner.is_in_group("Characters") and body.owner.controller_is_player:
		var my_index_in_parent = get_index()
		if body.owner.next_checkpoint_index == my_index_in_parent:
			# set next checkpoint
			var checkpoints_list = get_parent().get_children()
			
			for i in range(len(checkpoints_list)):
				if get_parent().get_child(i).name == name:
					var next_cp_index = i + 1 if len(checkpoints_list) > i+1 else 0
					body.owner.next_checkpoint_index = next_cp_index
					var next_cp_position = get_parent().get_child(next_cp_index).global_transform.origin
					SignalManager.emit_signal("checkpoint_reached", next_cp_position)


func _on_first_checkpoint_request():
	#someone asked for my initial cp pos
	SignalManager.emit_signal("checkpoint_reached", global_transform.origin)
