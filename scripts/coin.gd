extends Spatial

var is_active = true

func _ready():
	$win_particles.emitting = false

func _on_area_body_entered(body):
	var info = InfoManager.load_player_info()
	info.coins += 5
	InfoManager.save_player_info(info)
	SignalManager.emit_signal("coins_updated", info.coins)
	$win_particles.emitting = true
	hide()

func hide():
	toggle()

func show():
	$win_particles.emitting = false
	toggle()
	
func toggle():
	is_active = !is_active
	$mesh_instance.visible = is_active
	$area/collision_shape.disabled = !is_active
	
func show_if_hidden():
	if not is_active:
		show()

