class_name Creature extends Node

var creature_name = ""
var creature_avatar = "res://resources/interface/avatars/creatures/{file}"
var creature_ability_block = {}
var creature_maximum = 0
var creature_level = "1"
var creature_speed = 0

var creature_stat_block = {}
var creature_stat_boss = null
var creature_stat_elite = null
var creature_stat_normal = null
var creature_stat_minion = null

var ability_list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

func _ready():
	pass

func _load_blocks(file_path):
	var loader = json_loader.new()
	var json = loader.load_json(file_path)
	if json != null:
		creature_name = json["name"]
		creature_avatar = creature_avatar.format({"file": json["avatar"]})
		creature_maximum = json["maximum"]
		creature_stat_block = json["stat_block"]
		creature_ability_block = json["ability_block"]
		
		for creature_type in creature_stat_block.keys():
			if creature_type == "elite":
				creature_stat_elite = creature_stat_block["elite"]
			elif creature_type == "normal":
				creature_stat_normal = creature_stat_block["normal"]
			elif creature_type == "boss":
				creature_stat_boss = creature_stat_block["boss"]
			elif creature_type == "minion":
				creature_stat_minion = creature_stat_block["minion"]
			else:
				pass
		
		ability_list.shuffle()
	else:
		print("Error!")

func _shuffle_abilities_cards():
	ability_list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
	ability_list.shuffle()

func _pull_ability_card():
	var pulled_number = ability_list.pop_front()
	
	if pulled_number == 10 or pulled_number == 11:
		_shuffle_abilities_cards()
	
	var pulled_ability = _parse_ability_Card(creature_ability_block[str(pulled_number)])
	return pulled_ability

func _parse_ability_Card(ability):
	creature_speed = ability["speed"]
	var current_card = {}
	if ability["L1"] != null:
		current_card["L1"] = _parse_ability_line(ability["L1"])
		
	if ability["L2"] != null:
		current_card["L2"] = _parse_ability_line(ability["L2"])
		
	if ability["L3"] != null:
		current_card["L3"] = _parse_ability_line(ability["L3"])
		
	if ability["L4"] != null:
		current_card["L4"] = _parse_ability_line(ability["L4"])
		
	if ability["L5"] != null:
		current_card["L5"] = _parse_ability_line(ability["L5"])
	
	return current_card

func _parse_ability_line(ability_line: String):
	var formatted_ability_line = ""
	# A line can be made of different "parts" delimited by ":" :
	var abilities = ability_line.split(":", true)
	
	# Each of these parts represent a stat or a condition and a modifer :
	for ability in abilities:
		formatted_ability_line += _find_ability(ability)
	
	return formatted_ability_line

func _find_ability(ability):
	var ability_modifiers = ability.split("+")
	
	if ability_modifiers[0] in Global.main_stats_list: # Main Stat Handler :
		return _handle_main_stats(ability_modifiers)
		
	elif ability_modifiers[0] in Global.conditions_list: # Condition Handler. Simple or Stackable Condition :
		if ability_modifiers.size() >= 2:
			return _handle_stackable_conditions(ability_modifiers)
			
		else:
			return _handle_simple_conditions(ability_modifiers)
		
	else:
		return ability_modifiers[0] # Probably Text or a Special.

func _handle_main_stats(ability_modifier):
	var card_line = "[img=30x30]%s[/img]{boss}{elite}{normal}{minion}" % Global.main_stats_icons[ability_modifier[0]]
	var boss_stat = ""
	var elite_stat = ""
	var normal_stat = ""
	var minion_stat = ""
	
	if creature_stat_boss != null:
		if ability_modifier[0] in creature_stat_boss[creature_level].keys():
			boss_stat = " [color=#FF0000]%s[/color] " % str(int(creature_stat_boss[creature_level][ability_modifier[0]]) + int(ability_modifier[1]))
		else:
			boss_stat = " [color=#FF0000]%s[/color] " %  ability_modifier[1]
	if creature_stat_elite != null:
		if ability_modifier[0] in creature_stat_elite[creature_level].keys():
			elite_stat = " [color=#FF0000]%s[/color] " % str(int(creature_stat_elite[creature_level][ability_modifier[0]]) + int(ability_modifier[1]))
		else:
			elite_stat = " [color=#FF0000]%s[/color] " %  ability_modifier[1]
	if creature_stat_normal != null:
		if ability_modifier[0] in creature_stat_normal[creature_level].keys():
			normal_stat = " [color=#FFFFFF]%s[/color] " % str(int(creature_stat_normal[creature_level][ability_modifier[0]]) + int(ability_modifier[1]))
		else:
			normal_stat = " [color=#FFFFFF]%s[/color] " %  ability_modifier[1]
	if creature_stat_minion != null:
		if ability_modifier[0] in creature_stat_minion[creature_level].keys():
			minion_stat = " [color=#00FFFF]%s[/color] " % str(int(creature_stat_minion[creature_level][ability_modifier[0]]) + int(ability_modifier[1]))
		else:
			minion_stat = " [color=#00FFFF]%s[/color] " %  ability_modifier[1]
	
	card_line = card_line.format({"boss": boss_stat, "elite": elite_stat, "normal": normal_stat, "minion": minion_stat})
	return card_line

func _handle_simple_conditions(ability_modifier):
	var card_line = " [img=30x30]%s[/img] " % Global.conditions_icons[ability_modifier[0]]
	return card_line

func _handle_stackable_conditions(ability_modifier):
	var card_line =" [img=30x30]%s[/img] " % Global.conditions_icons[ability_modifier[0]] + ability_modifier[1] + " "
	return card_line
