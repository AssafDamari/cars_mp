extends Control

var empty_icon ="res://textures/empty_pickup.png"
var lap_time_seconds=0

func _on_ui_show_pickup(powerup:powerup_data):
	if powerup:
		$powreup/pickup_sprite.set_texture(load(powerup.icon))	
		$powreup/pickup_count.text = str(powerup.count)
	else:		
		$powreup/pickup_sprite.set_texture(load(empty_icon))
		$powreup/pickup_count.text = ""
	
func init_ui(is_host:bool):
	# show start button only for server
	$start_button.visible = get_tree().get_network_unique_id() == 1
	if is_network_master():
		SignalManager.connect("ui_show_pickup", self, "_on_ui_show_pickup")
		SignalManager.connect("coins_updated", self, "_on_coins_updated")
	if is_host:
		$start_button.visible = true
		
	$coins_label.text = str(CoinsManager.get_current_coins())

func _on_start_button_pressed():
	SignalManager.emit_signal("start_race")
	$start_button.focus_mode = Control.FOCUS_NONE
	rpc("increse_lap_time", true)
	$timer.start()

func _on_timer_timeout():
	rpc("increse_lap_time", false)

sync func increse_lap_time(reset = false):
	lap_time_seconds = 0 if reset else lap_time_seconds + 1
	$lap_time_label.text = str(lap_time_seconds)

func _on_coins_updated(coins):
	$coins_label.text = str(coins)
	


func _on_back_button_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
