extends Control
# FIX THE AVATAR : LOAD FROM FILE
# FIX Stat Blocks

@onready var minis = {}
@onready var sorted_minis = []

# "boss" = 0, "elite" = 10, "normal" = 20, "minion" = 30
var minisSelectedType = 20
var creature_name = ""
@onready var elite_column = get_node("Card_Body/Stat_Block_Control/Stat_Block_Columns/Elite_Background")
@onready var normal_column = get_node("Card_Body/Stat_Block_Control/Stat_Block_Columns/Normal_Background")
@onready var minion_column = get_node("Card_Body/Stat_Block_Control/Stat_Block_Columns/Minion_Background")

var minis_count = 0
var speed = 0

# ==================================================================================================
# Main :
# ==================================================================================================
func _ready():
	pass

func _set_creature_card(new_creature_name: String):
	_ready()
	creature_name = new_creature_name
	var creature_ref = Global.cards[creature_name]["object"]
	
	var image = Image.load_from_file(creature_ref.creature_avatar)
	var avatar_texture = ImageTexture.create_from_image(image)
	var avatar_node = get_node("Card_Body/Avatar_Control/Avatar")
	avatar_node.texture = avatar_texture
	
	_set_creature_card_stat_block()
	_set_creature_card_ability_block()

func _set_creature_card_stat_block():
	var hp_label = ""
	var ap_label = ""
	var sp_label = ""
	var attack_label = ""
	var move_label = ""
	
	var creature_ref = Global.cards[creature_name]["object"]
	if creature_ref.creature_stat_elite != null:
		hp_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Elite_Background/Stat_Block_Elite/Health
		hp_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["HP"], 
						"value" : creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["HP"]})
		
		ap_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Elite_Background/Stat_Block_Elite/Armor
		ap_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["AP"], 
						"value" : creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["AP"]})
		
		sp_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Elite_Background/Stat_Block_Elite/Shield
		sp_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["SP"], 
						"value" : creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["SP"]})
		
		attack_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Elite_Background/Stat_Block_Elite/Attack
		var attack_range = int(creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["R"])
		if attack_range > 0:
			attack_label.text = "[img=30x30]{icon_1}[/img] {value_1} [img=30x30]{icon_2}[/img] {value_2}".format({"icon_1": Global.main_stats_icons["A"], 
								"value_1": creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["A"], 
								"icon_2": Global.main_stats_icons["R"], "value_2": creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["R"]})
		else:
			attack_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["A"], 
								"value" : creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["A"]})
		
		move_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Elite_Background/Stat_Block_Elite/Move
		move_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["M"], 
						"value" : creature_ref.creature_stat_elite[str(Global._get_scenario_level())]["M"]})
		
		elite_column.visible = true
		
	else:
		elite_column.visible = false
		
	if creature_ref.creature_stat_normal != null:
		hp_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Normal_Background/Stat_Block_Normal/Health
		hp_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["HP"], 
						"value" : creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["HP"]})
		
		ap_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Normal_Background/Stat_Block_Normal/Armor
		ap_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["AP"], 
						"value" : creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["AP"]})
		
		sp_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Normal_Background/Stat_Block_Normal/Shield
		sp_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["SP"], 
						"value" : creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["SP"]})
		
		attack_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Normal_Background/Stat_Block_Normal/Attack
		var attack_range = int(creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["R"])
		if attack_range > 0:
			attack_label.text = "[img=30x30]{icon_1}[/img] {value_1} [img=30x30]{icon_2}[/img] {value_2}".format({"icon_1": Global.main_stats_icons["A"], 
								"value_1": creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["A"], 
								"icon_2": Global.main_stats_icons["R"], "value_2": creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["R"]})
		else:
			attack_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["A"], 
								"value" : creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["A"]})
		
		move_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Normal_Background/Stat_Block_Normal/Move
		move_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["M"], 
						"value" : creature_ref.creature_stat_normal[str(Global._get_scenario_level())]["M"]})
		
		normal_column.visible = true
		
	else:
		normal_column.visible = false
		
	if creature_ref.creature_stat_minion != null:
		hp_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Minion_Background/Stat_Block_Minion/Health
		hp_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["HP"], 
						"value" : creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["HP"]})
		
		ap_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Minion_Background/Stat_Block_Minion/Armor
		ap_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["AP"], 
						"value" : creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["AP"]})
		
		sp_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Minion_Background/Stat_Block_Minion/Shield
		sp_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["SP"], 
						"value" : creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["SP"]})
		
		attack_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Minion_Background/Stat_Block_Minion/Attack
		var attack_range = int(creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["R"])
		if attack_range > 0:
			attack_label.text = "[img=30x30]{icon_1}[/img] {value_1} [img=30x30]{icon_2}[/img] {value_2}".format({"icon_1": Global.main_stats_icons["A"], 
								"value_1": creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["A"], 
								"icon_2": Global.main_stats_icons["R"], "value_2": creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["R"]})
		else:
			attack_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["A"], 
								"value" : creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["A"]})
		
		move_label = $Card_Body/Stat_Block_Control/Stat_Block_Columns/Minion_Background/Stat_Block_Minion/Move
		move_label.text = "[img=30x30]{icon}[/img] {value}".format({"icon": Global.main_stats_icons["M"], 
						"value" : creature_ref.creature_stat_minion[str(Global._get_scenario_level())]["M"]})
		minion_column.visible = true
		
	else:
		minion_column.visible = false

func _set_creature_card_ability_block():
	var creature_name_label = $Card_Body/Ability_Block/Background/Ability/Creature_Name
	var creature_ref = Global.cards[creature_name]["object"]
	creature_name_label.text = creature_ref.creature_name
	
	var line_1 = $Card_Body/Ability_Block/Background/Ability/Line_1
	line_1.visible = false
	var line_2 = $Card_Body/Ability_Block/Background/Ability/Line_2
	line_2.visible = false
	var line_3 = $Card_Body/Ability_Block/Background/Ability/Line_3
	line_3.visible = false
	var line_4 = $Card_Body/Ability_Block/Background/Ability/Line_4
	line_4.visible = false
	var line_5 = $Card_Body/Ability_Block/Background/Ability/Line_5
	line_5.visible = false

# ==================================================================================================
# Rounds and Turns Handler:
# ==================================================================================================
func _begin_turn():
	# RGN and WND?
	pass

func _end_turn():
	# Remove Conditions?
	pass

func _begin_round():
	var creature_ref = Global.cards[creature_name]["object"]
	var ability = creature_ref._pull_ability_card()
	var available_lines = ability.keys()
	
	if "L1" in available_lines:
		var line_1 = $Card_Body/Ability_Block/Background/Ability/Line_1
		line_1.text = ability["L1"]
		line_1.visible = true
	
	if "L2" in available_lines:
		var line_2 = $Card_Body/Ability_Block/Background/Ability/Line_2
		line_2.text = ability["L2"]
		line_2.visible = true
	
	if "L3" in available_lines:
		var line_3 = $Card_Body/Ability_Block/Background/Ability/Line_3
		line_3.text = ability["L3"]
		line_3.visible = true
	
	if "L4" in available_lines:
		var line_4 = $Card_Body/Ability_Block/Background/Ability/Line_4
		line_4.text = ability["L4"]
		line_4.visible = true
	
	if "L5" in available_lines:
		var line_5 = $Card_Body/Ability_Block/Background/Ability/Line_5
		line_5.text = ability["L5"]
		line_5.visible = true
	
	var speed_label = $Card_Body/Avatar_Control/Speed_Label
	speed = creature_ref.creature_speed
	speed_label.text = str(speed)

func _end_round():
	var line_1 = $Card_Body/Ability_Block/Background/Ability/Line_1
	line_1.visible = false
	var line_2 = $Card_Body/Ability_Block/Background/Ability/Line_2
	line_2.visible = false
	var line_3 = $Card_Body/Ability_Block/Background/Ability/Line_3
	line_3.visible = false
	var line_4 = $Card_Body/Ability_Block/Background/Ability/Line_4
	line_4.visible = false
	var line_5 = $Card_Body/Ability_Block/Background/Ability/Line_5
	line_5.visible = false
	
	var speed_label = $Card_Body/Avatar_Control/Speed_Label
	speed = 0
	speed_label.text = str(speed)
	
	for mini in minis.keys():
		minis[mini]._end_round()

"""func _mini_height_changed():
	var card = $"."
	var row_1 = $Minis_Rows/Minis_Row_1
	var row_2 = $Minis_Rows/Minis_Row_2
	var rows = $Minis_Rows
	var max_mini_height = 0
	
	for mini in row_1.get_children():
		if mini.size.y > max_mini_height:
			max_mini_height = mini.size.y
	row_1.size.y = max_mini_height
	
	max_mini_height = 0
	for mini in row_2.get_children():
		if mini.size.y > max_mini_height:
			max_mini_height = mini.size.y
	row_2.size.y = max_mini_height
	
	rows.size.y = row_1.size.y + row_2.size.y
	card.size.y = 220 + rows.size.y
	
	_redraw_minis()"""

func _add_mini(mini_id):
	if minis.size() <= 9:
		var new_mini = load("res://main/mini.tscn").instantiate()
		new_mini._setup_mini(mini_id, minisSelectedType, creature_name)
		#new_mini.resized.connect(_mini_height_changed)
		
		minis[mini_id] = new_mini
		sorted_minis.append({"id" : mini_id, "type": minisSelectedType})
		minis_count += 1
		_redraw_minis()
	else:
		pass

func _redraw_minis():
	var card = $"."
	var row_1 = $Minis_Rows/Minis_Row_1
	var row_2 = $Minis_Rows/Minis_Row_2
	var rows = $Minis_Rows
	
	for node in row_1.get_children():
		row_1.remove_child(node)
	for node in row_2.get_children():
		row_2.remove_child(node)
	
	sorted_minis.sort_custom(_doubleSortFunction)
	for mini_card in sorted_minis:
		if row_1.get_children().size() < 5:
			row_1.add_child(minis[mini_card["id"]])
		else:
			row_2.add_child(minis[mini_card["id"]])
	
	"""if minis_count >= 6:
		rows.size.y = 240
	elif minis_count > 0 and minis_count < 6:
		rows.size.y = 120
	else:
		rows.size.y = 0"""

func _doubleSortFunction(a, b):
	var a_score = int(a["id"]) + a["type"]
	var b_score = int(b["id"]) + b["type"]

	if a_score < b_score:
		return true
	else:
		return false

# ==================================================================================================
# Add Minis Popup Menu:
# ==================================================================================================
func _on_elite_button_toggled(button_pressed):
	if button_pressed == true:
		minisSelectedType = 10

func _on_normal_button_toggled(button_pressed):
	if button_pressed == true:
		minisSelectedType = 20

func _on_minion_button_toggled(button_pressed):
	if button_pressed == true:
		minisSelectedType = 30

func _on_id_1_toggled(button_pressed):
	if button_pressed == true:
		if "1" in minis.keys():
			pass
		else:
			_add_mini("1")
	elif button_pressed == false:
		pass

func _on_id_2_toggled(button_pressed):
	if button_pressed == true:
		if "2" in minis.keys():
			pass
		else:
			_add_mini("2")
	elif button_pressed == false:
		pass

func _on_id_3_toggled(button_pressed):
	if button_pressed == true:
		if "3" in minis.keys():
			pass
		else:
			_add_mini("3")
	elif button_pressed == false:
		pass

func _on_id_4_toggled(button_pressed):
	if button_pressed == true:
		if "4" in minis.keys():
			pass
		else:
			_add_mini("4")
	elif button_pressed == false:
		pass

func _on_id_5_toggled(button_pressed):
	if button_pressed == true:
		if "5" in minis.keys():
			pass
		else:
			_add_mini("5")
	elif button_pressed == false:
		pass

func _on_id_6_toggled(button_pressed):
	if button_pressed == true:
		if "6" in minis.keys():
			pass
		else:
			_add_mini("6")
	elif button_pressed == false:
		pass

func _on_id_7_toggled(button_pressed):
	if button_pressed == true:
		if "7" in minis.keys():
			pass
		else:
			_add_mini("7")
	elif button_pressed == false:
		pass

func _on_id_8_toggled(button_pressed):
	if button_pressed == true:
		if "8" in minis.keys():
			pass
		else:
			_add_mini("8")
	elif button_pressed == false:
		pass

func _on_id_9_toggled(button_pressed):
	if button_pressed == true:
		if "9" in minis.keys():
			pass
		else:
			_add_mini("9")
	elif button_pressed == false:
		pass

func _on_id_10_toggled(button_pressed):
	if button_pressed == true:
		if "10" in minis.keys():
			pass
		else:
			_add_mini("10")
	elif button_pressed == false:
		pass

func _on_add_elite_pressed():
	var selected_button = $AddMinis_Popup/AddMinis_Body/AddMinis_TypeBox/Elite_Button
	selected_button.button_pressed = true
	
	minisSelectedType = 10
	var addMinis_Popup = get_node("AddMinis_Popup")
	if addMinis_Popup.visible == true:
		addMinis_Popup.visible = false
	else:
		addMinis_Popup.visible = true

func _on_add_normal_pressed():
	var selected_button = $AddMinis_Popup/AddMinis_Body/AddMinis_TypeBox/Normal_Button
	selected_button.button_pressed = true
	
	minisSelectedType = 20
	var addMinis_Popup = get_node("AddMinis_Popup")
	if addMinis_Popup.visible == true:
		addMinis_Popup.visible = false
	else:
		addMinis_Popup.visible = true

func _on_add_minion_pressed():
	var selected_button = $AddMinis_Popup/AddMinis_Body/AddMinis_TypeBox/Minion_Button
	selected_button.button_pressed = true
	
	minisSelectedType = 30
	var addMinis_Popup = get_node("AddMinis_Popup")
	if addMinis_Popup.visible == true:
		addMinis_Popup.visible = false
	else:
		addMinis_Popup.visible = true

#===================================================================================================
# Focus Functions:
#===================================================================================================
func _release_focus():
	self.release_focus()

func _grab_focus():
	self.grab_focus()

func _on_focus_entered():
	self.modulate = Color(1, 1, 1, 1.0)

func _on_focus_exited():
	self.modulate = Color(0.5, 0.5, 0.5, 1.0)
