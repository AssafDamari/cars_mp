extends Spatial
 
var pickup_data:powerup_data
var original_count = 0 

func init_pickup(pickup:powerup_data):
	if pickup == null:
		pickup = pickup_data
	rpc("pickup_setup", pickup.scene_path, pickup.pickup_path, pickup.icon, pickup.count)
	
func _on_area_body_entered(body):
	if body.owner == null:
		return
		
	if body.owner.is_in_group("Characters"):
		body.owner.equipt(pickup_data)
		rpc("pickup_picked")
		
		
sync func pickup_setup(scene_path, pickup_path, icon, count):
	pickup_data = powerup_data.new(scene_path, pickup_path, icon, count)
	var prefab = load(pickup_data.pickup_path)
	$display/position_3d_1.add_child(prefab.instance())
	$display/position_3d_2.add_child(prefab.instance())
	$display/position_3d_3.add_child(prefab.instance())
	original_count = pickup_data.count

sync func pickup_picked():
	$area/collision_shape.disabled = true
	self.visible = false
	$timer.start()
#	for n in $display.get_children():
#			n.visible = false
	
func _on_timer_timeout():
	$area/collision_shape.disabled = false
	self.visible = true
	pickup_data.count = original_count
	
