extends RigidBody

var exploation_force_factor = 30
var initial_speed_factor = 200

func _ready():
	set_as_toplevel(true)
	var direction = -get_parent().global_transform.basis.z.normalized() * initial_speed_factor
	var parent_velocity = get_parent().get_owner().get_node("Ball").linear_velocity
	direction = direction + Vector3.UP * 45
	apply_impulse(Vector3(0.1, 0.1, 0.1), direction + parent_velocity)
	
	
func _on_cannon_ball_body_entered(body):
	if not body.is_in_group("cannon_balls"):
		apply_force_and_damage_on_overlapping_bodies()
		$cannot_ball_mesh.visible = false
		$collision_shape.disabled = true
		$area/collision_shape.disabled = true
		$exploitation.set_as_toplevel(true)
		$exploitation.boom()
		$timer.connect("timeout", self, "queue_free")
		$timer.start()


func apply_force_and_damage_on_overlapping_bodies():
	var overlapping_bodies = $area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is RigidBody and not body.is_in_group("cannon_balls"):
			var impulse_direction = (body.global_transform.origin - global_transform.origin).normalized()
			body.apply_impulse(Vector3(0,0,0), impulse_direction * exploation_force_factor)
			if body.get_owner().has_method("take_damage"):
				body.get_owner().take_damage()


