extends StaticBody

func _ready():
	if get_index() == 0:
		SignalManager.connect("first_checkpoint_request", self , "_on_first_checkpoint_request")
		set_as_next_cp()
	SignalManager.connect("start_race", self, "start_race")
		
func start_race():
	if get_index() == 0:
		set_as_next_cp()
	else:
		remove_as_next_cp()
		
func _on_area_body_entered(body):
	if body.owner == null or not body.owner is Character:
		return
		
	if body.owner.is_in_group("Characters"):
		var my_index_in_parent = get_index()
		if body.owner.next_checkpoint_index == my_index_in_parent:
			# set next checkpoint
			var checkpoints_list = get_parent().get_children()
			
			for i in range(len(checkpoints_list)):
				if get_parent().get_child(i).name == name:
					var next_cp_index = i + 1 if len(checkpoints_list) > i+1 else -1
					body.owner.next_checkpoint_index = next_cp_index
					remove_as_next_cp()
					if next_cp_index!=-1:
						var next_cp = get_parent().get_child(next_cp_index)
						next_cp.set_as_next_cp()
						SignalManager.emit_signal("checkpoint_reached", next_cp.global_transform.origin, body.owner)

func set_as_next_cp():
	$marker.visible = true

func remove_as_next_cp():
	$marker.visible = false
		
func _on_first_checkpoint_request():
	#someone asked for my initial cp pos
	SignalManager.emit_signal("checkpoint_reached", global_transform.origin)
