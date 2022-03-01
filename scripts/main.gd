extends Node

const MAX_PLAYERS = 32

# To play over internet check your IP and change it here
export var ip : String = "127.0.0.1"
# To use a background server download the server export template without graphics and audio from:
# https://godotengine.org/download/server
# And choose it as a custom template upon export
export var background_server : bool = false

# Preload a character and controllersr
# Character is a node which we control by the controller node
# This way we can extend the Controller class to create an AI controller
# Peer controller represents other players in the network
onready var character_scene = preload("res://scenes/character.tscn")
onready var player_scene = preload("res://scenes/player.tscn")
onready var peer_scene = preload("res://scenes/peer.tscn")
onready var ai_scene = preload("res://scenes/ai.tscn")
onready var ui = $display/ui
onready var output = $output
onready var lunch_pad = $lunch_pad
onready var characters = $characters


var ai_ids = []#[900, 901, 902, 903, 904, 905, 906, 907] # for each id in this list an ai car will be created (starts with 900)
var maps = ["res://scenes/map.tscn",
			"res://scenes/map_deset.tscn", 
			"res://scenes/map_snow.tscn"]
var map
var registered_players = {}
var pickups
var checkpoints
var road_path

func _ready():
	
	SignalManager.connect("host_game_pressed", self, "_on_host_pressed")
	SignalManager.connect("join_game_pressed", self, "_on_join_pressed")
	SignalManager.connect("start_race", self, "start_race")
	
	
# When a Host button is pressed
func _on_host_pressed(port, map_index):
	select_map(map_index)
	# Create the server
	create_server(port)
	start_brodcast_server_info(port, map_index)
	# Create our player, 1 is a reference for a host/server
	create_player(1, ControllerType.PLAYER)
	for id in ai_ids:
		create_player(id, ControllerType.AI)
	# Hide a menu
	$display/main_menu.queue_free()
	output.text = "Connected as host ID:1 ip=" + ip + " port=" + str(port)
	$display/ui.visible = true
	ui.init_ui(true)
	
# When Connect button is pressed
func _on_join_pressed(host_ip, port, map_index):
	# Connect network events
	var _peer_connected = get_tree().connect("network_peer_connected", self, "_on_peer_connected")
	var _peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	var _connection_failed = get_tree().connect("connection_failed", self, "_on_connection_failed")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	
	# Set up an ENet instance
	var network = NetworkedMultiplayerENet.new()

	network.create_client(host_ip, port)
	get_tree().set_network_peer(network)
	select_map(map_index)
	$display/main_menu.queue_free()
	$display/ui.visible = true
	ui.init_ui(false)


func _on_peer_connected(id):
	# When other players connect a character and a child player controller are created
	create_player(id, ControllerType.PEER)
	#if the connected peer is host (id=1) then also add the ai it created as peer
	if id==1:
		for id in ai_ids:
			create_player(id, ControllerType.PEER)
		
func _on_peer_disconnected(id):
	# Remove unused nodes when player disconnects
	remove_player(id)

func _on_connected_to_server():
	# Upon successful connection get the unique network ID
	# This ID is used to name the character node so the network can distinguish the characters
	var id = get_tree().get_network_unique_id()
	output.text = "Connected! ID: " + str(id)
	# Create a player
	create_player(id, ControllerType.PLAYER)
	
func _on_connection_failed():
	# Upon failed connection reset the RPC system
	get_tree().set_network_peer(null)
	output.text = "Connection failed"

func _on_server_disconnected():
	# If server disconnects just reload the game
	var _reloaded = get_tree().reload_current_scene()

func create_server(port):
	# Connect network events
	var _peer_connected = get_tree().connect("network_peer_connected", self, "_on_peer_connected")
	var _peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
	# Set up an ENet instance
	var network = NetworkedMultiplayerENet.new()
	network.create_server(port, MAX_PLAYERS)
	get_tree().set_network_peer(network)

func start_brodcast_server_info(port, map_index):
	# start brodcast ip and port
	var advertiser = load("res://scenes/server_advertiser_wrap.tscn").instance()
	advertiser.get_node("ServerAdvertiser").serverInfo["port"] = port
	advertiser.get_node("ServerAdvertiser").serverInfo["map_index"] = map_index
	var serverInfo = advertiser.get_node("ServerAdvertiser").serverInfo
	print("server info ", serverInfo)
	add_child(advertiser)
	
func create_player(id, controllerType = ControllerType.PEER):
	# Create a character with a player or a peer controller attached
	var controller : Controller
	# Check whether we are creating a player or a peer controller
	if controllerType == ControllerType.PEER:
		# Peer controller represents other connected players on the network
		controller = peer_scene.instance()		
	elif controllerType == ControllerType.PLAYER:
		# Player controller is our input which controls the character node
		controller = player_scene.instance()
		# Enable the controller's camera if it's not an other player 
		controller.get_node("camera").current = true
	elif controllerType == ControllerType.AI:
		# Player controller is our input which controls the character node
		controller = ai_scene.instance()
		controller.path = road_path
	# Instantiate the character
	var character = character_scene.instance()
	# Attach the controller to the character
	character.add_child(controller)
	# Set the controller's name for easier reference by the character
	controller.name = "controller"
	# Set the character's name to a given network id for synchronization
	character.name = str(id)
	# Add the character to this (main) scene 
	characters.add_child(character)
	# Spawn the character at random location in launch pad
	set_start_pos(character)
	# set trails color
	character.set_trails_color(map.get_trails_color())
	if controllerType == ControllerType.PLAYER:
		lunch_pad.init_lunch_pad()
		pickups.init_pickups()
	
func remove_player(id):
	# Remove unused characters
	characters.get_node(str(id)).free()

func output_str(str_to_print):
	output.visible = true
	output.text = str(str_to_print)

func _on_timer_timeout():
	pass
#	print(Engine.get_frames_per_second())

func set_start_pos(character):
	var rand_offset = 10
	var lunch_pad_transform = lunch_pad.global_transform
	# Random point within some area units
	randomize()
	character.global_transform = lunch_pad_transform
	character.global_transform.origin.x = rand_range(lunch_pad_transform.origin.x-rand_offset, lunch_pad_transform.origin.x+rand_offset)
	character.global_transform.origin.z = rand_range(lunch_pad_transform.origin.z-rand_offset, lunch_pad_transform.origin.z+rand_offset)
	character.global_transform.origin.y += 5
	

func start_race():
	rpc("activate_start")

sync func activate_start():
	if lunch_pad.started:
		for c in characters.get_children():
			var ctrl = c.get_node("controller")
			ctrl.character.reset_character()
			if ctrl.has_method("is_ai"):
				ctrl.target_inedx = 0 
#				ctrl.reset_markers()
			set_start_pos(ctrl.character.ball)
		
	lunch_pad.activate_start()
	# rest coins
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.show_if_hidden()
	
func select_map(map_index):
	if has_node("map"):
		remove_child(get_node("map"))
		
	map = load(maps[map_index]).instance()
	map.name = "map"
	add_child(map)
	pickups = map.get_node("pickups")
	checkpoints = map.get_node("checkpoints")
	road_path = map.get_node("road_path")
	
enum ControllerType{
	PLAYER,
	PEER,
	AI
}
