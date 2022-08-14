extends KinematicBody

var exploation_force_factor = 20
var speed = 6000
var direction = Vector3()
var gravity = -5

func _ready():
	set_as_toplevel(true)
	direction = -get_parent().global_transform.basis.z.normalized()
	
func _physics_process(delta):
	if not is_on_floor():
		global_transform.origin.y += gravity * delta
	move_and_slide(direction * speed * delta)
	
	

func _on_area_body_entered(body):
	if body.name != "rocket":
		$exploitation.boom()
		
		#var impulse_direction = (body.global_transform.origin - global_transform.origin).normalized()
		if body.has_method("take_damage"):
			body.add_force(global_transform.origin, Vector3.UP * exploation_force_factor)
		if body.get_owner() and body.get_owner().has_method("take_damage"):
			body.get_owner().take_damage()
				
		$timer.connect("timeout", self, "queue_free")
		$timer.start()


func _on_timer_lifetime_timeout():
	queue_free()
