extends Control

export var ip : String = "127.0.0.1"
var port = 27015


var maps_bgs = [
	"res://textures/track_map_bg.png",
	"res://textures/desert_map_bg.png",
	"res://textures/snow_map_bg.png"
]

var ip_text_edit
var port_server_text_edit
var port_client_text_edit
var server_map_select_box
var client_map_select_box
var ServerListener
var output
var server_map_texture_rect
var client_map_texture_rect
var host_panel
var join_panel
var main_panel


func _ready():
	# get ref to controls
	ip_text_edit = find_node("ip_text_edit")
	port_server_text_edit = find_node("port_server_text_edit")
	port_client_text_edit = find_node("port_client_text_edit")
	server_map_select_box = find_node("server_map_select_box")
	client_map_select_box = find_node("client_map_select_box")
	server_map_texture_rect = find_node("server_map_texture_rect")
	client_map_texture_rect = find_node("client_map_texture_rect")
	ServerListener = find_node("ServerListener")
	output = find_node("output")
	host_panel = find_node("host_panel")
	join_panel = find_node("join_panel")
	main_panel = find_node("main_panel")
	
	# set default values 
	ip_text_edit.text = str(ip)
	port_server_text_edit.text = str(port)
	port_client_text_edit.text = str(port)
	output.text = "Searching for LAN games..."
	
	# populate maps 
	server_map_select_box.add_item("Track map", 0 )
	server_map_select_box.add_item("Desert map", 1 )
	server_map_select_box.add_item("Snow map", 2 )
	server_map_select_box.connect("item_selected", self, "server_selected_map")
	server_selected_map(0)
	
	client_map_select_box.add_item("Track map", 0 )
	client_map_select_box.add_item("Desert map", 1 )
	client_map_select_box.add_item("Snow map", 2 )
	client_map_select_box.connect("item_selected", self, "client_selected_map")
	
	# hook server listener
	ServerListener.connect("new_server", self, "_on_server_listener_new_server")
	ServerListener.connect("remove_server", self, "_on_server_listener_remove_server")
	
	
func server_selected_map(map_index):
	server_map_texture_rect.texture = load(maps_bgs[map_index])
	
	
func client_selected_map(map_index):
	client_map_texture_rect.texture = load(maps_bgs[map_index])
	
	
func _on_host_button_pressed():
	SignalManager.emit_signal("host_game_pressed", int(port_server_text_edit.text), server_map_select_box.selected)


func _on_join_button_pressed():
	SignalManager.emit_signal("join_game_pressed", ip_text_edit.text, int(port_client_text_edit.text), client_map_select_box.selected)


func _on_server_listener_new_server(serverInfo):
	print("new server ", serverInfo)
	
	ip_text_edit.text = serverInfo["ip"]
	port_client_text_edit.text = str(serverInfo["port"])
	client_map_select_box.select(serverInfo["map_index"])
#	client_map_select_box.disabled = true
	client_selected_map(serverInfo["map_index"])
	output.text = "found server " + serverInfo["ip"] + ":" + str(serverInfo["port"])
	
	
func _on_server_listener_remove_server(serverIp):
	ServerListener.disconnect("new_server", self, "_on_server_listener_new_server")
	ServerListener.disconnect("remove_server", self, "_on_server_listener_remove_server")
		

func _on_play_button_pressed():
	host_panel.visible = true
	join_panel.visible = false
	main_panel.visible = false


func _on_join_main_button_pressed():
	host_panel.visible = false
	join_panel.visible = true
	main_panel.visible = false


func _on_cancel_button_pressed():
	show_main_buttons_menu()
	
	
func _on_cancel_join_button_pressed():
	show_main_buttons_menu()


func show_main_buttons_menu():
	host_panel.visible = false
	join_panel.visible = false
	main_panel.visible = true
