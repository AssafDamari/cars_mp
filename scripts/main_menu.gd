extends Control

export var ip : String = "127.0.0.1"
var port = 27015


var maps_bgs = [
	"res://textures/forest_map.png",
	"res://textures/desert_map.png",
	"res://textures/snow_map_bg.png",
	"res://textures/track_map_bg.png",
	"res://textures/city_map_bg.png",
]

var ip_text_edit
var port_server_text_edit
var port_client_text_edit
var ServerListener
var output
var client_map_texture_rect
var host_panel
var join_panel
var main_panel
var settings_panel
var bots_line_edit
var selected_map = 0

func _ready():
	# get ref to controls
	ip_text_edit = find_node("ip_text_edit")
	port_server_text_edit = find_node("port_server_text_edit")
	port_client_text_edit = find_node("port_client_text_edit")
	client_map_texture_rect = find_node("client_map_texture_rect")
	ServerListener = find_node("ServerListener")
	output = find_node("output")
	host_panel = find_node("host_panel")
	join_panel = find_node("join_panel")
	main_panel = find_node("main_panel")
	settings_panel = find_node("settings_panel")
	bots_line_edit = find_node("bots_line_edit")
	# set default values 
	ip_text_edit.text = str(ip)
	port_server_text_edit.text = str(port)
	port_client_text_edit.text = str(port)
	output.text = "Searching for LAN games..."
	
	# hook server listener
	ServerListener.connect("new_server", self, "_on_server_listener_new_server")
	ServerListener.connect("remove_server", self, "_on_server_listener_remove_server")
	
	
func _on_host_pressed():
	SignalManager.emit_signal("host_game_pressed", int(port_server_text_edit.text), selected_map, int(bots_line_edit.text) )


func _on_join_button_pressed():
	SignalManager.emit_signal("join_game_pressed", ip_text_edit.text, int(port_client_text_edit.text), selected_map, int(bots_line_edit.text))


func _on_server_listener_new_server(serverInfo):
	print("new server ", serverInfo)
	
	ip_text_edit.text = serverInfo["ip"]
	port_client_text_edit.text = str(serverInfo["port"])
	selected_map = serverInfo["map_index"]
	client_map_texture_rect.texture = load(maps_bgs[selected_map])
	bots_line_edit.text = str(serverInfo["bots_count"])
	output.text = "found server " + serverInfo["ip"] + ":" + str(serverInfo["port"])
	
	
func _on_server_listener_remove_server(serverIp):
	ServerListener.disconnect("new_server", self, "_on_server_listener_new_server")
	ServerListener.disconnect("remove_server", self, "_on_server_listener_remove_server")
		

func _on_play_button_pressed():
	main_panel.visible = false
	host_panel.visible = true
	

func _on_join_main_button_pressed():
	main_panel.visible = false
	join_panel.visible = true


func _on_cancel_button_pressed():
	show_main_buttons_menu()
	
	
func _on_cancel_join_button_pressed():
	show_main_buttons_menu()


func show_main_buttons_menu():
	host_panel.visible = false
	join_panel.visible = false
	settings_panel.visible = false
	main_panel.visible = true
	

func _on_button_button_pressed():
	get_tree().change_scene("res://scenes/store.tscn")


func _on_credit_button_pressed():
	get_tree().change_scene("res://scenes/credis.tscn")


func _on_settings_button_pressed():
	main_panel.visible = false
	settings_panel.visible = true


func _on_back_button_pressed():
	show_main_buttons_menu()


func _on_deset_map_button_pressed():
	selected_map = 1
	_on_host_pressed()


func _on_forest_map_button_pressed():
	selected_map = 0
	_on_host_pressed()


func _on_snow_map_button_pressed():
	selected_map = 2
	_on_host_pressed()


func _on_track_map_button_pressed():
	selected_map = 3
	_on_host_pressed()


func _on_city_map_button_pressed():
	selected_map = 4
	_on_host_pressed()
