extends Node

# What makes up a Network?
# List of Characters: Loaded from a .JSON. Tied to the campaign.
# List of Players: Current Character and List of Retired Characters.
#				And we want to tie Player Characters to the Players.
# Reputations: Values for the different factions.
# Network Assets: ...
# JOBS: Available, Completed, Locked.
# Current Campaign.

var network_name = ""
var player_list = {"1": {"player_name": "", "characters": {}, "retired_characters": {}}, "2": {"player_name": "", "characters": {}, "retired_characters": {}},
					"3": {"player_name": "", "characters": {}, "retired_characters": {}}, "4": {"player_name": "", "characters": {}, "retired_characters": {}}}
var player_character_list = {}

func _create_player(player_name, player_id):
	player_list[player_id] = {"player_name": player_name, "characters": {}, "retired_characters": {}}

func _add_character_to_player():
	pass

func _remove_character_from_player():
	pass

func _change_character_from_player_to_player():
	pass

func _create_player_character(new_character_level, new_character_class, new_character_name, player_id):
	var new_character = Character.new()
	new_character._create_class(new_character_level, new_character_class, new_character_name)
	
	player_character_list[new_character_name] = new_character

func _delete_player_character():
	pass

func _retire_player_character():
	pass
