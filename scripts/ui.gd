extends Control

onready var pickup_sprite = $powreup/pickup_sprite
onready var pickup_count = $powreup/pickup_count
onready var start_button = $h_box_container/start_button
onready var reset_button = $h_box_container/reset_button
onready var coins_label = $coins_label
onready var timer = $timer
onready var lap_time_label = $lap_time_label
onready var countdown = $countdown
onready var music_button = $h_box_container/music_button
var empty_icon = "res://textures/empty_pickup.png"
var lap_time_seconds = 0
var music_on = true
var music_on_icon = "res://textures/audioOn.png"
var music_off_icon = "res://textures/audioOff.png"

func _ready():
	SignalManager.connect("countdown_finished", self , "_on_countdown_finished")
	
func _on_ui_show_pickup(powerup:powerup_data):
	if powerup:
		pickup_sprite.set_texture(load(powerup.icon))	
		pickup_count.text = str(powerup.count)
	else:		
		pickup_sprite.set_texture(load(empty_icon))
		pickup_count.text = ""

	
func init_ui(is_host:bool):
	# show start button only for server
	start_button.visible = get_tree().get_network_unique_id() == 1
	if is_network_master():
		SignalManager.connect("ui_show_pickup", self, "_on_ui_show_pickup")
		SignalManager.connect("coins_updated", self, "_on_coins_updated")
	if is_host:
		start_button.visible = true
		
	coins_label.text = str(CoinsManager.get_current_coins())


func _on_countdown_finished(current_countdown):
	SignalManager.emit_signal("start_race")
	start_button.focus_mode = Control.FOCUS_NONE
	rpc("increse_lap_time", true)
	timer.start()


func _on_timer_timeout():
	rpc("increse_lap_time", false)


sync func increse_lap_time(reset = false):
	lap_time_seconds = 0 if reset else lap_time_seconds + 1
	lap_time_label.text = "Lap time: " + str(lap_time_seconds)


func _on_coins_updated(coins):
	coins_label.text = str(coins)
	
	
func _on_back_button_pressed():
	var is_server = get_tree().get_network_unique_id() == 1
	if is_server:
		rpc("server_ended_metch")
	get_tree().reload_current_scene()


remote func server_ended_metch():
	get_tree().reload_current_scene()


func _on_start_button_pressed():
	start_button.visible = false
	reset_button.visible = true
	rpc("start_countdown_network")
	
sync func start_countdown_network():
	countdown.start_countdown()

func _on_reset_button_pressed():
	start_button.visible = true
	reset_button.visible = false
	countdown.reset()
	SignalManager.emit_signal("reset_race")
	reset_button.focus_mode = Control.FOCUS_NONE


func _on_music_button_pressed():
	SignalManager.emit_signal("toggle_music")
	if music_on:
		music_button.icon = load(music_off_icon)
		music_on = false
	else:
		music_button.icon = load(music_on_icon)
		music_on = true
	
	music_button.focus_mode = Control.FOCUS_NONE
		
func _on_break_button_button_up():
	Input.action_release("backward")

func _on_break_button_button_down():
	Input.action_press("backward")

func _on_left_touch_screen_button_pressed():
	Input.action_press("left")

func _on_left_touch_screen_button_released():
	Input.action_release("left")

func _on_right_touch_screen_button_pressed():
	Input.action_press("right")

func _on_right_touch_screen_button_released():
	Input.action_release("right")

func _on_shoot_touch_screen_button_pressed():
	Input.action_press("jump")

func _on_camera_button_pressed():
	Input.action_press("camera_pos")
