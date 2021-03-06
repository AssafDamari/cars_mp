extends Node

var current_coins = 0
var was_loaded = false

func get_current_coins():
	current_coins = InfoManager.load_player_info().coins
	return current_coins

func add_coins(coins_to_add):
	var info = InfoManager.load_player_info()
	info.coins += coins_to_add
	InfoManager.save_player_info(info)
	SignalManager.emit_signal("coins_updated", info.coins)

func remove_coins(coins_to_add):
	var info = InfoManager.load_player_info()
	info.coins -= coins_to_add
	InfoManager.save_player_info(info)
	print(InfoManager.load_player_info())
	SignalManager.emit_signal("coins_updated", info.coins)
