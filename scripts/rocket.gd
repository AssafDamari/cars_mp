extends KinematicBody

var exploation_force_factor = 20
var speed = 6000
const exploitationPrefab = preload("res://scenes/exploitation.tscn")
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
		add_exploitation()
		
		#var impulse_direction = (body.global_transform.origin - global_transform.origin).normalized()
		if body.has_method("take_damage"):
			body.add_force(global_transform.origin, Vector3.UP * exploation_force_factor)
		if body.get_owner() and body.get_owner().has_method("take_damage"):
			body.get_owner().take_damage()
				
		queue_free()

func add_exploitation():
	var exploitation = exploitationPrefab.instance()
	exploitation.global_transform = global_transform
	get_tree().root.add_child(exploitation)


func _on_timer_timeout():
	add_exploitation()
	queue_free()
