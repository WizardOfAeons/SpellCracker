extends Node2D

@onready var sorted_cards = []

var new_character_name = null
var new_character_class = null
var new_character_level = null

# Rounds : 0 is a new round, 1 is end of round.
var round_tracker = 0
var round_status = 0

# Elements : 0 is 0, 1 is 50, 2 is 100.
# Order is : 0 Fire, 1 Earth, 2 Water, 3 Wind, 4 Electric, 5 Bio, 6 Nuclear, 7 Spacetime.
var elements_list = [2, 2, 2, 2, 2, 2, 2, 2]
var elements_masks = ["Background/Sections/Bottom_Menu/Element_Box/Element_Fire/mask", "Background/Sections/Bottom_Menu/Element_Box/Element_Earth/mask", 
						"Background/Sections/Bottom_Menu/Element_Box/Element_Water/mask", "Background/Sections/Bottom_Menu/Element_Box/Element_Wind/mask", 
						"Background/Sections/Bottom_Menu/Element_Box/Element_Electric/mask", "Background/Sections/Bottom_Menu/Element_Box/Element_Bio/mask",
						"Background/Sections/Bottom_Menu/Element_Box/Element_Nuclear/mask", "Background/Sections/Bottom_Menu/Element_Box/Element_Spacetime/mask"]

# ==================================================================================================
# Main :
# ==================================================================================================
func _ready():
	pass

func _update_levels():
	Global._calculate_levels_variables()

# ==================================================================================================
# Scenario Menu :
# ==================================================================================================
func _on_scenario_id_pressed(id):
	if id == 1:
		pass
	elif id == 2:
		pass
	
	# Creatures -> Add :
	elif id == 4:
		var creature_panel = $Creature_Panel
		creature_panel.visible = true
	elif id == 5:
		pass

# ==================================================================================================
# Creature Panel :
# ==================================================================================================
func _add_creature(creature_name):
	if creature_name in Global.cards.keys():
		pass
	else:
		# New Creature Handling :
		var new_creature = Creature.new()
		var file_path = "res://resources/statblocks/creatures/{creature_name}.json"
		file_path = file_path.format({"creature_name": creature_name})
		new_creature._load_blocks(file_path)
		Global._add_creature_to_list(creature_name, new_creature)
		
		# New Card Handling :
		var card_mat = get_node("Background/Sections/Play_Area/Card_Mat")
		var new_card = load("res://main/creature_card.tscn").instantiate()
		new_card._set_creature_card(creature_name)
		Global._set_creature_node(creature_name, new_card)
		
		card_mat.add_child(new_card)
		sorted_cards.append(creature_name)

func _remove_creature(creature_name):
	if creature_name in Global.cards.keys():
		var card_mat = get_node("Background/Sections/Play_Area/Card_Mat")
		card_mat.remove_child(Global.cards[creature_name]["node"])
		Global._remove_creature_from_list(creature_name)
		sorted_cards.erase(creature_name)
	else:
		pass

func _on_beat_security_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("beat_security")
			
	elif button_pressed == false:
		_remove_creature("beat_security")

func _on_gutter_shaman_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("gutter_shaman")
			
	elif button_pressed == false:
		_remove_creature("gutter_shaman")

func _on_spirit_of_man_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("spirit_of_man")
			
	elif button_pressed == false:
		_remove_creature("spirit_of_man")

func _on_spirit_of_toxicity_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("spirit_of_toxicity")
			
	elif button_pressed == false:
		_remove_creature("spirit_of_toxicity")

func _on_street_pawang_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("street_pawang")
			
	elif button_pressed == false:
		_remove_creature("street_pawang")

func _on_street_punk_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("street_punk")
			
	elif button_pressed == false:
		_remove_creature("street_punk")

func _on_street_robber_toggled(button_pressed):
	if button_pressed == true:
		_add_creature("street_robber")
			
	elif button_pressed == false:
		_remove_creature("street_robber")

# ==================================================================================================
# Campaign Menu :
# ==================================================================================================
func _on_campaign_id_pressed(id):
	if id == 1: # Create Campaign.
		print("1")
	elif id == 2: # Save Campaign.
		print("2")
	elif id == 3: # Load Campaign.
		print("3")
	elif id == 5: # Create Party.
		print("5")
	elif id == 6: # Deleta Party.
		print("6")
	elif id == 8: # Create Character.
		_open_create_character_panel()
	elif id == 9: # Add Character.
		print("9")
	elif id == 10: # Retire Character.
		print("10")
	elif id == 11: # Delete Character.
		print("11")
	else:
		print(str(id))

# ==================================================================================================
# Create Character Panel Menu :
# ==================================================================================================
func _open_create_character_panel():
	var node_to_load = ""
	#var character_name_edit = $Create_Character_Panel/Body/Character_Name # Seems to be done by default.
	#character_name_edit.text = new_character_name
	
	if new_character_class != null:
		node_to_load = "Create_Character_Panel/Body/Default_Classes/Class_{new_character_class}"
		node_to_load = node_to_load.format({"new_character_class": new_character_class})
		var selected_class_button = get_node(node_to_load)
		selected_class_button.button_pressed = true
	
	node_to_load = "Create_Character_Panel/Body/Character_Level/Level_{level}"
	node_to_load = node_to_load.format({"level": Global._get_starting_level()})
	var selected_level_button = get_node(node_to_load)
	selected_level_button.button_pressed = true
	
	var character_panel = $Create_Character_Panel
	character_panel.visible = true

func _on_character_name_text_changed(new_text):
	new_character_name = new_text

func _on_class_100_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 100
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New Street Samurai"
			new_character_name = "New Street Samurai"

func _on_class_200_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 200
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New Gun Bunny"
			new_character_name = "New Gun Bunny"

func _on_class_300_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 300
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New Moonshiner"
			new_character_name = "New Moonshiner"

func _on_class_400_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 400
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New Enforcer"
			new_character_name = "New Enforcer"

func _on_class_500_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 500
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New Elementalist"
			new_character_name = "New Elementalist"

func _on_class_600_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 600
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New Boffin"
			new_character_name = "New Boffin"

func _on_class_700_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 700
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 700"
			new_character_name = "New 700"

func _on_class_800_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 800
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 800"
			new_character_name = "New 800"

func _on_class_900_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 900
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 900"
			new_character_name = "New 900"

func _on_class_1000_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1000
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1000"
			new_character_name = "New 1000"

func _on_class_1100_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1100
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1100"
			new_character_name = "New 1100"

func _on_class_1200_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1200
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1200"
			new_character_name = "New 1200"

func _on_class_1300_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1300
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1300"
			new_character_name = "New 1300"

func _on_class_1400_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1400
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1400"
			new_character_name = "New 1400"

func _on_class_1500_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1500
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1500"
			new_character_name = "New 1500"

func _on_class_1600_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1600
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1600"
			new_character_name = "New 1600"

func _on_class_1700_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1700
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1700"
			new_character_name = "New 1700"

func _on_class_1800_toggled(button_pressed):
	if button_pressed == true:
		new_character_class = 1800
		
		var character_name_line = $Create_Character_Panel/Body/Character_Name
		if character_name_line.text == null or character_name_line.text == "":
			character_name_line.text = "New 1800"
			new_character_name = "New 1800"

func _on_level_0_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 0

func _on_level_1_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 1

func _on_level_2_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 2

func _on_level_3_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 3

func _on_level_4_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 4

func _on_level_5_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 5

func _on_level_6_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 6

func _on_level_7_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 7

func _on_level_8_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 8

func _on_level_9_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 9

func _on_level_10_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 10

func _on_level_11_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 11

func _on_level_12_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 12

func _on_level_13_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 13

func _on_level_14_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 14

func _on_level_15_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 15

func _on_level_16_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 16

func _on_level_17_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 17

func _on_level_18_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 18

func _on_level_19_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 19

func _on_level_20_toggled(button_pressed):
	if button_pressed == true:
		new_character_level = 20

func _on_create_button_pressed():
	if new_character_name != null:
		if new_character_class != null:
			if new_character_level != null:
				if new_character_name in Global.cards.keys():
					print("Character with the same name is already in play.")
				else:
					var new_character = Character.new()
					new_character._create_class(new_character_level, new_character_class, new_character_name)
					Global._add_character_to_list(new_character_name, new_character)
					
					var new_card = load("res://main/player_card.tscn").instantiate()
					new_card._set_player_card(new_character_name)
					Global._set_character_node(new_character_name, new_card)
					
					var card_mat = get_node("Background/Sections/Play_Area/Card_Mat")
					card_mat.add_child(new_card)
					sorted_cards.append(new_character_name)
				
				var character_panel = $Create_Character_Panel
				character_panel.visible = false
			else:
				print("Missing a character level!") # Do Something.
		else:
			print("Missing a character class!") # Do Something.
	else:
		print("Missing a Character Name!") # Do Something.

func _on_cancel_button_pressed():
	var character_panel = $Create_Character_Panel
	character_panel.visible = false

# ==================================================================================================
# Bottom Bar :
# ==================================================================================================
func _on_round_button_pressed():
	var round_button = $Background/Sections/Bottom_Menu/Round_Button
	
	# New Round :
	# Sort Creatures X, Pull new Cards X, Scenario Effects.
	if round_status == 0:
		_begin_round()
		
		round_button.text = "End Round"
		round_tracker += 1
		round_status = 1
	
	# End Round :
	# Clear Elements X, Clear Conditions, Clear Speed, Scenario Effects.
	elif round_status == 1:
		_end_round()
		
		round_button.text = "New Round"
		round_status = 0
	
	_sort_creatures()
	
	var round_tracker_label = $"Background/Sections/Bottom_Menu/Round Tracker"
	round_tracker_label.text = str(round_tracker)

func _sort_creatures():
	sorted_cards.sort_custom(_sort_by_speed)
	
	var card_mat = $Background/Sections/Play_Area/Card_Mat
	for node in card_mat.get_children():
		card_mat.remove_child(node)
	
	for card in sorted_cards:
		card_mat.add_child(Global.cards[card]["node"])

func _sort_by_speed(a, b):
	var speed_a = Global.cards[a]["node"].speed
	var speed_b = Global.cards[b]["node"].speed
	
	var type_a = Global.cards[a]["type"]
	var type_b = Global.cards[b]["type"]
	
	# Greater Speed has Priority:
	if speed_a > speed_b:
		return true
	elif speed_a == speed_b:
		# If Speeds are equal, the Player Characters have priority.
		if type_a == Character and type_b == Creature:
			return true
		else:
			return false
	else:
		return false

func _modify_element(element_index):
	var element_status = elements_list[element_index]
	var element_mask = get_node(elements_masks[element_index])
	
	if element_status == 2:
		elements_list[element_index] = 0
		element_mask.size.y = 0
		
	elif element_status == 1:
		elements_list[element_index] = 2
		element_mask.size.y = 64
	
	else:
		elements_list[element_index] = 2
		element_mask.size.y = 64

func _on_element_fire_pressed():
	_modify_element(0)

func _on_element_earth_pressed():
	_modify_element(1)

func _on_element_water_pressed():
	_modify_element(2)

func _on_element_wind_pressed():
	_modify_element(3)

func _on_element_electric_pressed():
	_modify_element(4)

func _on_element_bio_pressed():
	_modify_element(5)

func _on_element_nuclear_pressed():
	_modify_element(6)

func _on_element_spacetime_pressed():
	_modify_element(7)

# ==================================================================================================
# Begin Round:
# ==================================================================================================
func _begin_round():
	for card in Global.cards:
		Global.cards[card]["node"]._begin_round()
	
# ==================================================================================================
# End Round:
# ==================================================================================================
func _end_round():
	for card in Global.cards.keys():
		Global.cards[card]["node"]._end_round()
	
	_end_round_elements()

func _end_round_elements():
	var element_index = 0
	
	while element_index < 8:
		var element_status = elements_list[element_index]
		var element_mask = get_node(elements_masks[element_index]) 
		
		if element_status == 0:
			elements_list[element_index] = 1
			element_mask.size.y = 32
			
		elif element_status == 1:
			elements_list[element_index] = 2
			element_mask.size.y = 64
			
		else:
			pass
		element_index += 1

# ==================================================================================================
# Turns :
# ==================================================================================================
func _on_button_pressed():
	pass # Replace with function body.
