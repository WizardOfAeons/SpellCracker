extends Node2D

# Campaign Variables:
var campaign_name = null
var campaign_selected = 100000
var campaign_difficulty = 0

# Network Variables:
var network_name = ""
var player_1_name = ""
var player_2_name = ""
var player_3_name = ""
var player_4_name = ""

# Validation Variables:
var campaign_check = false
var network_check = false

func _on_return_button_pressed():
	SceneTransition.change_scene_dissolve("res://main/main.tscn")

#===================================================================================================
# Field Edits:
#===================================================================================================
func _on_campaign_name_line_edit_text_changed(new_text):
	campaign_name = new_text
	_update_campaign_checks()

func _on_network_name_line_edit_text_changed(new_text):
	network_name = new_text
	_update_network_checks()

func _on_player_1_name_text_changed(new_text):
	player_1_name = new_text
	_update_network_checks()

func _on_player_2_name_text_changed(new_text):
	player_2_name = new_text
	_update_network_checks()

func _on_p_3_toggle_toggled(button_pressed):
	if button_pressed:
		var node = $Background/Options/Columns/Network/Player_3/Player_3_Name
		node.visible = true
	else:
		var node = $Background/Options/Columns/Network/Player_3/Player_3_Name
		node.visible = false
	_update_network_checks()

func _on_player_3_name_text_changed(new_text):
	player_3_name = new_text
	_update_network_checks()

func _on_p_4_toggle_toggled(button_pressed):
	if button_pressed:
		var node = $Background/Options/Columns/Network/Player_4/Player_4_Name
		node.visible = true
	else:
		var node = $Background/Options/Columns/Network/Player_4/Player_4_Name
		node.visible = false
	_update_network_checks()

func _on_player_4_name_text_changed(new_text):
	player_4_name = new_text
	_update_network_checks()

#===================================================================================================
# Difficulty Selection Buttons:
#===================================================================================================
func _on_gofer_button_toggled(button_pressed):
	var label = $Background/Options/Columns/Campaign/Difficulty_Description
	label.text = "[b]Gofer[/b]:"
	label.append_text("\n\n")
	label.append_text("Scenario Level Modifier : [b][color=7FFF00]-1[/color][/b]")
	label.append_text("\n\n")
	label.append_text("Creatures, Traps and Conditions gain a level [b]reduction[/b] of 1. This is an easier difficulty for if you came across a challenge you cannot overcome.")
	campaign_difficulty = -1
	_update_campaign_checks()

func _on_street_thug_button_toggled(button_pressed):
	var label = $Background/Options/Columns/Campaign/Difficulty_Description
	label.text = "[b]Street Thug[/b]:"
	label.append_text("\n\n")
	label.append_text("Scenario Level Modifier : [b][color=FFD700]0[/color][/b]")
	label.append_text("\n\n")
	label.append_text("Creatures, Traps and Conditions gain no BONUS or MALUS. This is how the game is meant to be played.")
	campaign_difficulty = 0
	_update_campaign_checks()

func _on_runner_button_toggled(button_pressed):
	var label = $Background/Options/Columns/Campaign/Difficulty_Description
	label.text = "[b]Runner[/b]:"
	label.append_text("\n\n")
	label.append_text("Scenario Level Modifier : [b][color=FFA500]+1[/color][/b]")
	label.append_text("\n\n")
	label.append_text("Creatures, Traps and Conditions gain a level [b]increase[/b] of 1. This is an increased difficulty for those who want a little bit of extra challenge.")
	campaign_difficulty = 1
	_update_campaign_checks()

func _on_mercenary_button_toggled(button_pressed):
	var label = $Background/Options/Columns/Campaign/Difficulty_Description
	label.text = "[b]Mercenary[/b]:"
	label.append_text("\n\n")
	label.append_text("Scenario Level Modifier : [b][color=FF4500]+2[/color][/b]")
	label.append_text("\n\n")
	label.append_text("Creatures, Traps and Conditions gain a level [b]increase[/b] of 2. This is the hardest difficulty, for those who want a real challenge.")
	campaign_difficulty = 2
	_update_campaign_checks()

#===================================================================================================
# Campaign Selection Buttons:
#===================================================================================================
func _on_original_campaign_choice_toggled(button_pressed):
	if button_pressed == true:
		$Background/Options/Columns/Campaign/Campaign_Choice/Label.text = "Original\nSelected"
		$Background/Options/Columns/Campaign/Campaign_Choice/Label/Original_Campaign_Choice.modulate = Color(1, 1, 1, 1)
		campaign_selected = 100000
	else:
		$Background/Options/Columns/Campaign/Campaign_Choice/Label.text = "Original\n "
		$Background/Options/Columns/Campaign/Campaign_Choice/Label/Original_Campaign_Choice.modulate = Color(0.5, 0.5, 0.5, 1)
	_update_campaign_checks()

#===================================================================================================
# Checks:
#===================================================================================================
func _update_campaign_checks():
	var label = $Background/Options/Checks/Campaign_Checks
	label.clear()
	
	label.text = ""
	var campaign_bool = false
	if campaign_name == "" or campaign_name == null:
		label.append_text("[color=red]Missing a Campaign Name.[/color]")
		campaign_bool = false
	else:
		label.append_text(" ")
		campaign_bool = true
	
	var selection_bool = false
	if campaign_selected != null:
		label.append_text("\n ")
		selection_bool = true
	else:
		label.append_text("\n[color=red]Choose a campaign.[/color]")
		selection_bool = false
	
	if campaign_difficulty == -1:
		label.append_text("\nCampaign Difficulty is [b][color=7FFF00]Gofer[/color][/b].")
	elif campaign_difficulty == 0:
		label.append_text("\nCampaign Difficulty is [b][color=FFD700]Street Thug[/color][/b].")
	elif campaign_difficulty == 1:
		label.append_text("\nCampaign Difficulty is [b][color=FFA500]Runner[/color][/b].")
	elif campaign_difficulty == 2:
		label.append_text("\nCampaign Difficulty is [b][color=FF4500]Mercenary[/color][/b].")
	
	if campaign_bool == true and selection_bool == true:
		campaign_check = true
	else:
		campaign_check = false
	_validate_options()

func _update_network_checks():
	var label = $Background/Options/Checks/Network_Checks
	label.clear()
	
	label.text = ""
	var network_bool = false
	if network_name == "" or network_name == null:
		label.append_text("[color=red]Missing a Network Name.[/color]")
		network_bool = false
	else:
		label.append_text(" ")
		network_bool = true
	
	var warning = "\n "
	var player_bool = [false, false, null, null]
	if player_1_name == "" or player_1_name == null:
		warning = "\n[color=red]All Players require a name.[/color]"
		player_bool[0] = false
	else:
		player_bool[0] = true
	
	if player_2_name == "" or player_2_name == null:
		warning = "\n[color=red]All Players require a name.[/color]"
		player_bool[1] = false
	else:
		player_bool[1] = true
		
	if $Background/Options/Columns/Network/Player_3/P3_Toggle.button_pressed == true:
		if player_3_name == "" or player_3_name == null:
			warning = "\n[color=red]All Players require a name.[/color]"
			player_bool[2] =  false
		else:
			player_bool[2] =  true
	else:
		player_bool[2] = null
		
	if $Background/Options/Columns/Network/Player_4/P4_Toggle.button_pressed == true:
		if player_4_name == "" or player_4_name == null:
			warning = "\n[color=red]All Players require a name.[/color]"
			player_bool[3] =  false
		else:
			player_bool[3] = true
	else:
		player_bool[3] = null
	label.append_text(warning)
	
	if network_bool == true:
		var players_check = true
		for index in player_bool.size():
			if player_bool[index] == null:
				pass
			elif player_bool[index] == false:
				players_check = false
		if players_check == true:
			network_check =  true
		else:
			network_check = false
	else:
		network_check = false
	_validate_options()

func _validate_options():
	if campaign_check == true and network_check == true:
		$Background/Options/Button_Create_Campaign.disabled =  false
	else:
		$Background/Options/Button_Create_Campaign.disabled =  true

func _on_button_create_campaign_pressed():
	# Create Saves for Campaign and Network
	# We need to know what's in a campaign save.
	# We need to know what's in a Network Save.
	# Send over to the main game screen?
	# Or start at the map where the players can select their first mission?
	pass
