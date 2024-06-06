extends Control

var hp = 10
var max_hp = 10
var hp_delta = 0

var ap = 10
var max_ap = 10
var ap_delta = 0

var sp = 10
var max_sp = 10
var sp_delta = 0

var speed = 00
var speed_panel_total = ""
var speed_panel_value_1 = ""
var speed_panel_value_2 = ""

var conditions_stacks = {"RGN": 1, "FCS": 1, "SCK": 1, "WND": 1, "SHCK": 1, "SHRD": 1, "DST": 1}

# ==================================================================================================
# Main:
# ==================================================================================================
func _ready():
	pass

func _set_player_card(new_character_name: String):
	var character_ref = Global.cards[new_character_name]["object"]
	
	# Setup Character Name :
	var character_name_label = $Body/Sections/Main/Top/Character_Name
	character_name_label.text = new_character_name
	
	# Setup Character HP, AP, and SP.
	hp = character_ref.hp
	max_hp = character_ref.max_hp
	var hp_bar = $Body/Sections/Main/Stats/Character/HP_Line/HP_Bar
	hp_bar.value = hp
	hp_bar.max_value = max_hp
	hp_delta = 0
	_update_hp_label()
	
	ap = character_ref.ap
	max_ap = character_ref.max_ap
	var ap_bar = $Body/Sections/Main/Stats/Character/AP_Line/AP_Bar
	ap_bar.value = ap
	ap_bar.max_value = max_ap
	ap_delta = 0
	_update_ap_label()
	
	sp = character_ref.sp
	max_sp = character_ref.max_sp
	var sp_bar = $Body/Sections/Main/Stats/Character/SP_Line/SP_Bar
	sp_bar.value = sp
	sp_bar.max_value = max_sp
	sp_delta = 0
	_update_sp_label()
	
	# Setup Character Experience and Credits :
	var exp_value = $Body/Sections/Main/Stats/Options/Exp/Exp_Value
	exp_value.text = str(character_ref.character_experience)
	
	var credits_value = $Body/Sections/Main/Stats/Options/Credits/Credits_Value
	credits_value.text = str(character_ref.character_credits)
	
	# Setup Character Avatar and Icon :
	var image = Image.load_from_file(character_ref.character_avatar)
	var avatar_texture = ImageTexture.create_from_image(image)
	var avatar_node = $Body/Sections/Avatar
	avatar_node.texture = avatar_texture
	
	image = Image.load_from_file(character_ref.character_icon)
	var icon_texture = ImageTexture.create_from_image(image)
	var icon_node = $Body/Sections/Main/Top/Class_Icon
	icon_node.texture = icon_texture

# ==================================================================================================
# HP, AP and SP:
# ==================================================================================================
func _update_hp_label():
	var hp_label = $Body/Sections/Main/Stats/Character/HP_Line/HP_Bar/HP_Label
	var hp_new_label = "{current} / {max}"
	hp_label.text = hp_new_label.format({"current": hp, "max": max_hp})
	_hp_delta_modified()

func _on_sub_hp_pressed():
	var hp_bar = $Body/Sections/Main/Stats/Character/HP_Line/HP_Bar
	if hp >= 1:
		hp -= 1
		hp_delta -= 1
	else:
		pass
	
	hp_bar.value = hp
	_update_hp_label()

func _on_add_hp_pressed():
	var hp_bar = $Body/Sections/Main/Stats/Character/HP_Line/HP_Bar
	if hp < max_hp:
		hp += 1
		hp_delta += 1
	else:
		pass
	
	hp_bar.value = hp
	_update_hp_label()

func _hp_delta_modified():
	var hp_delta_label = $Body/Sections/Main/Stats/Character/HP_Line/HP_Delta
	if hp_delta < 0:
		hp_delta_label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		hp_delta_label.text = str(hp_delta)
		
	elif hp_delta > 0:
		hp_delta_label.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		var hp_string = "+{hp_delta}"
		hp_delta_label.text = hp_string.format({"hp_delta": hp_delta})
	else:
		hp_delta_label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		hp_delta_label.text = ""

func _update_ap_label():
	var ap_label = $Body/Sections/Main/Stats/Character/AP_Line/AP_Bar/AP_Label
	var ap_new_label = "{current} / {max}"
	ap_label.text = ap_new_label.format({"current": ap, "max": max_ap})
	_ap_delta_modified()

func _on_sub_ap_pressed():
	var ap_bar = $Body/Sections/Main/Stats/Character/AP_Line/AP_Bar
	if ap >= 1:
		ap -= 1
		ap_delta -= 1
	else:
		pass
	
	ap_bar.value = ap
	_update_ap_label()

func _on_add_ap_pressed():
	var ap_bar = $Body/Sections/Main/Stats/Character/AP_Line/AP_Bar
	if ap < max_ap:
		ap += 1
		ap_delta += 1
	else:
		pass
	
	ap_bar.value = ap
	_update_ap_label()

func _ap_delta_modified():
	var ap_delta_label = $Body/Sections/Main/Stats/Character/AP_Line/AP_Delta
	if ap_delta < 0:
		ap_delta_label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		ap_delta_label.text = str(ap_delta)
		
	elif ap_delta > 0:
		ap_delta_label.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		var ap_string = "+{ap_delta}"
		ap_delta_label.text = ap_string.format({"ap_delta": ap_delta})
	else:
		ap_delta_label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		ap_delta_label.text = ""

func _update_sp_label():
	var sp_label = $Body/Sections/Main/Stats/Character/SP_Line/SP_Bar/SP_Label
	var sp_new_label = "{current} / {max}"
	sp_label.text = sp_new_label.format({"current": sp, "max": max_sp})
	_sp_delta_modified()

func _on_sub_sp_pressed():
	var sp_bar = $Body/Sections/Main/Stats/Character/SP_Line/SP_Bar
	if sp >= 1:
		sp -= 1
		sp_delta -= 1
	else:
		pass
	
	sp_bar.value = sp
	_update_sp_label()

func _on_add_sp_pressed():
	var sp_bar = $Body/Sections/Main/Stats/Character/SP_Line/SP_Bar
	if sp < max_sp:
		sp += 1
		sp_delta += 1
	else:
		pass
	
	sp_bar.value = sp
	_update_sp_label()

func _sp_delta_modified():
	var sp_delta_label = $Body/Sections/Main/Stats/Character/SP_Line/SP_Delta
	if sp_delta < 0:
		sp_delta_label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		sp_delta_label.text = str(sp_delta)
		
	elif sp_delta > 0:
		sp_delta_label.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		var sp_string = "+{sp_delta}"
		sp_delta_label.text = sp_string.format({"sp_delta": sp_delta})
	else:
		sp_delta_label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		sp_delta_label.text = ""
		
# ==================================================================================================
# Speed Panel and Speed Values:
# ==================================================================================================
func _update_speed():
	var speed_label = $Body/Sections/Speed/Speed_Label
	speed_label.text = str(speed)

func _on_increase_pressed():
	var speed_label = $Body/Sections/Speed/Speed_Label
	speed = int(speed_label.text)
	if speed < 99:
		speed += 1
	speed_label.text = str(speed)

func _on_decrease_pressed():
	var speed_label = $Body/Sections/Speed/Speed_Label
	speed = int(speed_label.text)
	if speed >= 1:
		speed -= 1
	speed_label.text = str(speed)

func _on_edit_speed_label_pressed():
	var speed_panel_label = $Speed/Rows/Speed_Label
	var speed_label = $Body/Sections/Speed/Speed_Label
	var speed_panel_label_1 = $Speed/Rows/Sub_Speed/Speed_1
	var speed_panel_label_2 = $Speed/Rows/Sub_Speed/Speed_2
	speed_panel_label_1.text = ""
	speed_panel_label_2.text = ""
	
	if int(speed_label.text):
		speed_panel_label.text = speed_label.text
	else:
		speed_panel_label.text = ""
		
	speed_panel_total = ""
	speed_panel_value_1 = ""
	speed_panel_value_2 = ""
	
	var speed_panel = $Speed
	var mouse_position = get_global_mouse_position()
	speed_panel.position.x = mouse_position.x
	speed_panel.position.y = mouse_position.y
	speed_panel.visible = true

func _speed_panel_update(value):
	var speed_label = $Speed/Rows/Speed_Label
	var speed_panel_label_1 = $Speed/Rows/Sub_Speed/Speed_1
	var speed_panel_label_2 = $Speed/Rows/Sub_Speed/Speed_2
	
	if speed_panel_value_1.length() < 1:
		speed_panel_value_1 = value
		speed_panel_label_1.text = speed_panel_value_1
		
	elif speed_panel_value_1.length() == 1:
		speed_panel_value_1 += value
		speed_panel_label_1.text = speed_panel_value_1
		
		if int(speed_panel_value_1) >= 50:
			speed_panel_value_1 = ""
			speed_panel_label_1.text = ""
		
	elif speed_panel_value_2.length() < 1:
		speed_panel_value_2 = value
		speed_panel_label_2.text = speed_panel_value_2
		
		speed_label.text = str(int(speed_panel_value_1) + int(speed_panel_value_2))
		
	elif speed_panel_value_2.length() == 1:
		speed_panel_value_2 += value
		speed_panel_label_2.text = speed_panel_value_2
		
		if int(speed_panel_value_2) >= 50:
			speed_panel_value_2 = ""
			speed_panel_label_2.text = ""
		
		else:
			speed = int(speed_panel_value_1) + int(speed_panel_value_2)
			speed_label.text = str(speed)
			_update_speed()
		
			var speed_panel = $Speed
			speed_panel.visible = false
		
func _on_num_7_pressed():
	_speed_panel_update("7")

func _on_num_8_pressed():
	_speed_panel_update("8")

func _on_num_9_pressed():
	_speed_panel_update("9")

func _on_num_4_pressed():
	_speed_panel_update("4")

func _on_num_5_pressed():
	_speed_panel_update("5")

func _on_num_6_pressed():
	_speed_panel_update("6")

func _on_num_1_pressed():
	_speed_panel_update("1")

func _on_num_2_pressed():
	_speed_panel_update("2")

func _on_num_3_pressed():
	_speed_panel_update("3")

func _on_num_0_pressed():
	_speed_panel_update("0")

func _reset_speed():
	speed = 00
	_update_speed()

# ==================================================================================================
# Conditions:
# ==================================================================================================
func _on_modify_pressed():
	var condition_panel = $Conditions
	var mouse_position = get_global_mouse_position()
	condition_panel.position.x = mouse_position.x
	condition_panel.position.y = mouse_position.y
	condition_panel.visible = true

func _toggle_condition(button_pressed, condition_key):
	var condition = get_node("Body/Sections/Main/Conditions/{node}".format({"node": condition_key}))
	var disabled = get_node("Conditions/HBoxContainer/Conditions/{node}_Toggle/Disabled".format({"node": condition_key}))
	if button_pressed == true:
		condition.visible = true
		disabled.visible = true
	else:
		condition.visible = false
		disabled.visible = false

func _on_rvt_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "RVT")

func _on_stn_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "STN")

func _on_doom_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "DOOM")

func _on_dsrm_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "DSRM")

func _on_immb_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "IMMB")

func _on_lck_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "LCK")

func _on_jnx_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "JNX")

func _on_prss_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "PRSS")

func _on_pwr_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "PWR")

func _on_wkn_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "WKN")

func _on_hst_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "HST")

func _on_slw_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "SLW")

func _on_inv_toggle_toggled(button_pressed):
	_toggle_condition(button_pressed, "INV")

# ==================================================================================================
# Stackable Conditions:
# ==================================================================================================
func _toggle_stacked_condition(button_pressed, condition_key):
	var condition_node = get_node("Body/Sections/Main/Conditions/{node}".format({"node": condition_key}))
	var disabled_node = get_node("Conditions/HBoxContainer/Stacking_Conditions/HBoxContainer/{node_1}/{node_2}_Toggle/Disabled".format({"node_1": condition_key, 
																																		"node_2": condition_key}))
	if button_pressed == true:
		condition_node.visible = true
		disabled_node.visible = true
	else:
		condition_node.visible = false
		disabled_node.visible = false

func _modify_stacked_condition(condition_key, value):
	var mini_stacks = get_node("Body/Sections/Main/Conditions/{node}/Stack".format({"node": condition_key}))
	var popup_stacks = get_node("Conditions/HBoxContainer/Stacking_Conditions/HBoxContainer/{node_1}/{node_2}_Toggle/Stack".format({"node_1": condition_key, 
																																	"node_2": condition_key}))
	var stacks = 1
	
	if condition_key in conditions_stacks:
		stacks = conditions_stacks[condition_key]
		stacks += value
		
		if stacks > 99:
			stacks = 99
		elif stacks < 1:
			stacks = 1
		
		conditions_stacks[condition_key] = stacks
	
	mini_stacks.text = str(stacks)
	popup_stacks.text = str(stacks)

func _on_rgn_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "RGN")

func _on_rgn_add_pressed():
	_modify_stacked_condition("RGN", 1)
		
func _on_rgn_sub_pressed():
	_modify_stacked_condition("RGN", -1)

func _on_fcs_toggle_toggled(button_pressed):
		_toggle_stacked_condition(button_pressed, "FCS")

func _on_fcs_add_pressed():
	_modify_stacked_condition("FCS", 1)

func _on_fcs_sub_pressed():
	_modify_stacked_condition("FCS", -1)

func _on_sck_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "SCK")

func _on_sck_add_pressed():
	_modify_stacked_condition("SCK", 1)

func _on_sck_sub_pressed():
	_modify_stacked_condition("SCK", -1)

func _on_wnd_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "WND")

func _on_wnd_add_pressed():
	_modify_stacked_condition("WND", 1)

func _on_wnd_sub_pressed():
	_modify_stacked_condition("WND", -1)

func _on_shck_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "SHCK")

func _on_shck_add_pressed():
	_modify_stacked_condition("SHCK", 1)

func _on_shck_sub_pressed():
	_modify_stacked_condition("SHCK", -1)

func _on_shrd_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "SHRD")

func _on_shrd_add_pressed():
	_modify_stacked_condition("SHRD", 1)

func _on_shrd_sub_pressed():
	_modify_stacked_condition("SHRD", -1)

func _on_dst_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "DST")

func _on_dst_add_pressed():
	_modify_stacked_condition("DST", 1)

func _on_dst_sub_pressed():
	_modify_stacked_condition("DST", -1)

# ==================================================================================================
# Rounds and Turns Handler:
# Would it be better to let the players always do this stuff by themselves?
# ==================================================================================================
func _begin_turn():
	pass

func _end_turn():
	pass

func _begin_round():
	pass

func _end_round():
	_reset_speed()
	
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
