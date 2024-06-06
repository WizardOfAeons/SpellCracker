extends Node

# Campaign Variables:
var characters_average_level = 0 # 0 to 10
var playable_characters_count = 0 # Should be 4 max in a scenario.
var starting_level = 0 # 0 to 20.

# Scenario Variables:
var scenario_difficulty = 0 # -1, 0, 1, or 2.
var scenario_level = 1 + characters_average_level + scenario_difficulty # 0 to 13
var trap_damage = 2 + scenario_level # Min of 2, Max of 15.
var hazardous_damage = 1 + roundi((scenario_level + 0.01) / 2) # +1 Per 2 Scenario Levels. Min is 1, max is 8.
var doom_damage = 5 + roundi((5/4) * scenario_level) # +5 per 4 Scenario Levels. Min is 5, max 21 Damage.
var cards = {} # cards = {"name_1": {"type": "creature", "object": Creature/Character, "node": Node}, ...}
var round_tracker = 0

# Pointers: These Do not need to be saved.
var main_stats_list = ["HP", "AP", "SP", "A", "M", "R", "RET", "T", "H"]
var main_stats_icons = {"HP": "res://resources/interface/icons/stats/health_point_icon.png", "AP": "res://resources/interface/icons/stats/armor_point_icon.png",
						"SP": "res://resources/interface/icons/stats/shield_point_icon.png", "A": "res://resources/interface/icons/stats/physical_attack_icon.png", 
						"M": "res://resources/interface/icons/stats/movement_icon.png", "H": "res://resources/interface/icons/stats/healing_icon.png", 
						"RET": "res://resources/interface/icons/stats/retribution_icon.png", "R": "res://resources/interface/icons/stats/range_icon.png",
						"T": "res://resources/interface/icons/stats/target_icon.png", "EA": "res://resources/interface/icons/stats/energy_attack_icon.png",
						"DA": "res://resources/interface/icons/stats/direct_attack_icon.png"}
var conditions_list = ["PWR", "FCS", "HST", "INV", "LCK", "RGN", "RVT", "DSRM", "DST", "DOOM", "IMMB", "JNX", "PRSS", "SHRD", "SHCK", "SCK", "SLW", "STN", "WKN", "WND"]
var conditions_icons = {"PWR": "res://resources/interface/icons/conditions/PWR_icon.png", "FCS": "res://resources/interface/icons/conditions/FCS_icon.png",
						"HST": "res://resources/interface/icons/conditions/HST_icon.png", "INV": "res://resources/interface/icons/conditions/INV_icon.png",
						"LCK": "res://resources/interface/icons/conditions/LCK_icon.png", "RGN": "res://resources/interface/icons/conditions/RGN_icon.png",
						"RVT": "res://resources/interface/icons/conditions/RVT_icon.png", "DSRM": "res://resources/interface/icons/conditions/DSRM_icon.png",
						"DST": "res://resources/interface/icons/conditions/DST_icon.png", "DOOM": "res://resources/interface/icons/conditions/DOOM_icon.png",
						"IMMB": "res://resources/interface/icons/conditions/IMMB_icon.png", "JNX": "res://resources/interface/icons/conditions/JNX_icon.png",
						"PRSS": "res://resources/interface/icons/conditions/PRSS_icon.png", "SHRD": "res://resources/interface/icons/conditions/SHRD_icon.png",
						"SHCK": "res://resources/interface/icons/conditions/SHCK_icon.png", "SCK": "res://resources/interface/icons/conditions/SCK_icon.png",
						"SLW": "res://resources/interface/icons/conditions/SLW_icon.png", "STN": "res://resources/interface/icons/conditions/STN_icon.png",
						"WKN": "res://resources/interface/icons/conditions/WKN_icon.png", "WND": "res://resources/interface/icons/conditions/WND_icon.png"}

func _add_creature_to_list(creature_name: String, new_creature: Creature):
	cards[creature_name] = {"type": null, "object": null, "node": null}
	cards[creature_name]["type"] = Creature
	cards[creature_name]["object"] = new_creature

func _set_creature_node(creature_name: String, new_node: Control):
	cards[creature_name]["node"] = new_node

func _remove_creature_from_list(creature_name: String):
	cards[creature_name]["object"].free()
	cards[creature_name]["node"].free()
	cards.erase(creature_name)

func _add_character_to_list(character_name: String, new_character: Character):
	cards[character_name] = {"type": null, "object": null, "node": null}
	cards[character_name]["type"] = Character
	cards[character_name]["object"] = new_character
	playable_characters_count += 1

func _set_character_node(character_name: String, new_node: Control):
	cards[character_name]["node"] = new_node

func _remove_character_from_list(character_name: String):
	cards[character_name]["object"].free()
	cards[character_name]["node"].free()
	cards.erase(character_name)
	playable_characters_count -= 1

func _calculate_characters_average_level():
	var level_sum = 0
	for key in cards.keys():
		if cards[key]["type"] == Character:
			level_sum += cards[key]["object"].character_level
	
	characters_average_level = ceili(level_sum / playable_characters_count)

func _get_character_average_level():
	return characters_average_level

func _calculate_scenario_level():
	scenario_level = 1 + characters_average_level + scenario_difficulty

func _get_scenario_level():
	return scenario_level

func _get_starting_level():
	return starting_level

func _calculate_trap_damage():
	trap_damage = 2 + scenario_level

func _calculate_hazardous_damage():
	hazardous_damage = 1 + roundi((scenario_level + 0.01) / 2)

func _calculate_doom_damage():
	doom_damage = 5 + roundi((5/4) * scenario_level)

func _calculate_passive_damage():
	_calculate_trap_damage()
	_calculate_hazardous_damage()
	_calculate_doom_damage()

func _calculate_levels_variables():
	_calculate_characters_average_level()
	_calculate_scenario_level()
	_calculate_passive_damage()
