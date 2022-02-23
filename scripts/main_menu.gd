extends Control

export var ip : String = "127.0.0.1"
var port = 27015


var maps_bgs = [
	"res://textures/track_map_bg.png",
	"res://textures/desert_map_bg.png",
	"res://textures/snow_map_bg.png"
]

onready var ip_text_edit = $v_box_container/center_container/h_box_container/v_box_container_2/h_box_container/ip_text_edit
onready var port_server_text_edit = $v_box_container/center_container/h_box_container/v_box_container/h_box_container/port_server_text_edit
onready var port_client_text_edit = $v_box_container/center_container/h_box_container/v_box_container_2/h_box_container_3/port_client_text_edit
onready var server_map_select_box = $v_box_container/center_container/h_box_container/v_box_container/h_box_container_2/server_map_select_box
onready var client_map_select_box = $v_box_container/center_container/h_box_container/v_box_container_2/h_box_container_2/client_map_select_box
onready var ServerListener = $ServerListener
onready var output = $v_box_container/center_container/h_box_container/v_box_container_2/output
onready var server_map_texture_rect = $v_box_container/center_container/h_box_container/v_box_container/server_map_texture_rect
onready var client_map_texture_rect = $v_box_container/center_container/h_box_container/v_box_container_2/client_map_texture_rect

func _ready():
	ip_text_edit.text = str(ip)
	port_server_text_edit.text = str(port)
	port_client_text_edit.text = str(port)
	
	server_map_select_box.add_item("Track map", 0 )
	server_map_select_box.add_item("Desert map", 1 )
	server_map_select_box.add_item("Snow map", 2 )
	server_map_select_box.connect("item_selected", self, "server_selected_map")
	server_selected_map(0)
	
	client_map_select_box.add_item("Track map", 0 )
	client_map_select_box.add_item("Desert map", 1 )
	client_map_select_box.add_item("Snow map", 2 )
	client_map_select_box.connect("item_selected", self, "client_selected_map")
	#client_selected_map(0)
	
	ServerListener.connect("new_server", self, "_on_server_listener_new_server")
	ServerListener.connect("remove_server", self, "_on_server_listener_remove_server")
	output.text = "Searching for LAN games..."
	
	
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
		
