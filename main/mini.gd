extends Control

@onready var mini_id_label = $Background/Mini_Image/MiniID_Label

# HP GUI Variables:
@onready var hp_bar = $Background/HP_Bar
@onready var hp_bar_Label = $Background/HP_Label
@onready var hp_delta_Label = $Mini_Popup/Body/Top/Points/HP_Control/HP_Delta
@onready var hp_line = $Mini_Popup/Body/Top/Points/HP_Control/HP_Line

# AP GUI Variables:
@onready var ap_bar = $Background/AP_Bar
@onready var ap_bar_Label = $Background/AP_Label
@onready var ap_delta_Label = $Mini_Popup/Body/Top/Points/AP_Control/AP_Delta
@onready var ap_line = $Mini_Popup/Body/Top/Points/AP_Control/AP_Line

# SP GUI Variables:
@onready var sp_bar = $Background/SP_Bar
@onready var sp_bar_Label = $Background/SP_Label
@onready var sp_delta_Label = $Mini_Popup/Body/Top/Points/SP_Control/SP_Delta
@onready var sp_line = $Mini_Popup/Body/Top/Points/SP_Control/SP_Line

# Mini's Stats:
var hp = 99
var hp_max = 99
var ap = 99
var ap_max = 99
var sp = 99
var sp_max = 99

# GUI Stats:
var hp_delta = 0
var ap_delta = 0
var sp_delta = 0
var mini_id = 99
var mini_type = 99
var barLabel = "{value} / {max}"

# Conditions:
# -1: Condition was added before the turn.
#  0: Condition is not active.
#  1: Condition was added on turn.
var conditions = {}
var conditions_count = 0
var conditions_stacks = {"RGN": 1, "FCS": 1, "SCK": 1, "WND": 1, "SHCK": 1, "SHRD": 1, "DST": 1}

func _ready():
	pass

func _end_round():
	_apply_doom_effect()

func _begin_turn():
	_apply_wnd_effect()
	_apply_rgn_effect()

func _end_turn():
	_disable_conditions()

func _apply_doom_effect(): # End of Round.
	if "DOOM" in conditions.keys():
		if conditions["DOOM"] != 0:
			conditions["DOOM"] = 0
			var damage = Global.doom_damage
			_modify_hp(-damage)
			
			var doom_node = $Mini_Popup/Body/Top/Points/Conditions/DOOM_Toggle
			doom_node.button_pressed = false
		else:
			pass
	else:
		pass

func _apply_wnd_effect(): # Beginning of Turn.
	if "WND" in conditions.keys():
		if conditions["WND"] != 0:
			_modify_hp(-conditions_stacks["WND"])
		else:
			pass
	else:
		pass

func _apply_rgn_effect(): # Beginning of Turn.
	if "RGN" in conditions.keys():
		if conditions["RGN"] != 0:
			_modify_hp(+conditions_stacks["RGN"])
		else:
			pass
	else:
		pass

func _disable_conditions():
	pass

func _update_size():
	if conditions_count > 0 and conditions_count < 5:
		var conditions_box = $ScrollContainer
		conditions_box.size.y = 30
		var mini = $"."
		mini.size.y = 90
		
	elif conditions_count >= 5:
		var conditions_box = $ScrollContainer
		conditions_box.size.y = 60
		var mini = $"."
		mini.size.y = 120
		
	else:
		var conditions_box = $ScrollContainer
		conditions_box.size.y = 0
		var mini = $"."
		mini.size.y = 60

func _setup_mini(id, type, creature_name):
	_ready()
	if type == 0:
		mini_type = "boss"
	elif type == 10:
		mini_type = "elite"
	elif type == 20:
		mini_type = "normal"
	elif type == 30:
		mini_type = "minion"
	else:
		mini_type = "normal"
	var creature_ref = Global.cards[creature_name]["object"]
	
	# Mini Creature Image :
	var image = Image.load_from_file(creature_ref.creature_avatar)
	var miniTexture = ImageTexture.create_from_image(image)
	var miniImage = get_node("Background/Mini_Image")
	miniImage.texture = miniTexture
	
	# Mini Creature Border color based on creature type :
	if mini_type == "elite" or mini_type == "boss":
		image = Image.load_from_file("res://resources/interface/minis_ui/border_elite.png")
	elif mini_type == "normal":
		image = Image.load_from_file("res://resources/interface/minis_ui/border_normal.png")
	elif mini_type == "minion":
		image = Image.load_from_file("res://resources/interface/minis_ui/border_minion.png")
	miniTexture = ImageTexture.create_from_image(image)
	miniImage = get_node("Background/Mini_Image/Mini_Border")
	miniImage.texture = miniTexture
	
	# Stat Block :
	mini_id = id
	mini_id_label.text = mini_id
	
	hp = int(creature_ref.creature_stat_block[mini_type][creature_ref.creature_level]["HP"])
	hp_max = hp
	hp_bar.max_value = hp_max
	_update_hp()
	
	ap = int(creature_ref.creature_stat_block[mini_type][creature_ref.creature_level]["AP"])
	ap_max = ap
	ap_bar.max_value = ap_max
	_update_ap()
	
	sp = int(creature_ref.creature_stat_block[mini_type][creature_ref.creature_level]["SP"])
	sp_max = sp
	sp_bar.max_value = sp_max
	_update_sp()

#===================================================================================================
# HP Block and Functions:
#===================================================================================================
func _on_hp_sub_pressed():
	_modify_hp(-1)

func _on_hp_add_pressed():
	_modify_hp(+1)

func _modify_hp(value):
	hp += value
	
	if hp > hp_max:
		hp = hp_max
	elif hp < 0:
		hp = 0
	else:
		hp_delta += value
		_hp_delta_modified()
	
	_update_hp()

func _hp_delta_modified():
	var hp_string = ""

	if hp_delta < 0:
		hp_delta_Label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		hp_string = str(hp_delta)
	elif hp_delta > 0:
		hp_delta_Label.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		hp_string = "+{hpDelta}"
		hp_string = hp_string.format({"hpDelta":hp_delta})
	else:
		hp_delta_Label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		hp_string = ""
	hp_delta_Label.text = hp_string
	
func _update_hp():
	hp_bar.value = hp
	hp_line.value = hp
	hp_bar_Label.text = barLabel.format({"value": hp, "max": hp_max})

#===================================================================================================
# AP Block and Functions:
#===================================================================================================
func _on_ap_sub_pressed():
	_modify_ap(-1)

func _on_ap_add_pressed():
	_modify_ap(+1)

func _modify_ap(value):
	ap += value
	
	if ap > ap_max:
		ap = ap_max
	elif ap < 0:
		ap = 0
	else:
		ap_delta += value
		_ap_delta_modified()
	
	_update_ap()

func _ap_delta_modified():
	var ap_string = ""

	if ap_delta < 0:
		ap_delta_Label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		ap_string = str(ap_delta)
	elif ap_delta > 0:
		ap_delta_Label.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		ap_string = "+{apDelta}"
		ap_string = ap_string.format({"apDelta":ap_delta})
	else:
		ap_delta_Label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		ap_string = ""
	ap_delta_Label.text = ap_string

func _update_ap():
	ap_bar.value = ap
	ap_line.value = ap
	ap_bar_Label.text = barLabel.format({"value": ap, "max": ap_max})

#===================================================================================================
# SP Block and Functions:
#===================================================================================================
func _on_sp_sub_pressed():
	_modify_sp(-1)

func _on_sp_add_pressed():
	_modify_sp(+1)

func _modify_sp(value):
	sp += value
	
	if sp > sp_max:
		sp = sp_max
	elif sp < 0:
		sp = 0
	else:
		sp_delta += value
		_sp_delta_modified()
	
	_update_sp()

func _sp_delta_modified():
	var sp_string = ""

	if sp_delta < 0:
		sp_delta_Label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
		sp_string = str(sp_delta)
	elif sp_delta > 0:
		sp_delta_Label.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		sp_string = "+{spDelta}"
		sp_string = sp_string.format({"spDelta":sp_delta})
	else:
		sp_delta_Label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		sp_string = ""
	sp_delta_Label.text = sp_string

func _update_sp():
	sp_bar.value = sp
	sp_line.value = sp
	sp_bar_Label.text = barLabel.format({"value": sp, "max": sp_max})

func _on_mini_open_button_pressed():
	var miniPopup = get_node("Mini_Popup")
	var mousePosition = get_global_mouse_position()
	
	miniPopup.position.x = mousePosition.x
	miniPopup.position.y = mousePosition.y
	
	if miniPopup.visible == true:
		miniPopup.visible = false
	else:
		miniPopup.visible = true

func _on_mini_popup_popup_hide():
	# Reset the deltas before opening the Popup Window :
	hp_delta = 0
	ap_delta = 0
	sp_delta = 0
	
	hp_delta_Label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
	hp_delta_Label.text = ""
	
	ap_delta_Label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
	ap_delta_Label.text = ""
	
	sp_delta_Label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
	sp_delta_Label.text = ""

#===================================================================================================
# Conditions Block and Functions:
# Normal Conditions.
#===================================================================================================
func _toggle_condition(button_pressed, condition_key):
	var condition_node = get_node("ScrollContainer/Conditions/{node}".format({"node": condition_key}))
	var disabled_node = get_node("Mini_Popup/Body/Top/Points/Conditions/{node}_Toggle/Disabled".format({"node": condition_key}))
	
	if button_pressed == true:
		condition_node.visible = true
		disabled_node.visible = true
		conditions_count += 1
		conditions[condition_key] = 1
	else:
		condition_node.visible = false
		disabled_node.visible = false
		conditions_count -= 1
		conditions[condition_key] = 0
	
	_update_size()

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

#===================================================================================================
# Conditions Block and Functions:
# Stackable Conditions.
#===================================================================================================
func _toggle_stacked_condition(button_pressed, condition_key):
	var condition_node = get_node("ScrollContainer/Conditions/{node}".format({"node": condition_key}))
	var disabled_node = get_node("Mini_Popup/Body/Top/Stacking_Conditions/{node_1}/{node_1}_Toggle/Disabled".format({"node_1": condition_key, "node_2": condition_key}))
	if button_pressed == true:
		condition_node.visible = true
		disabled_node.visible = true
		conditions_count += 1
		conditions[condition_key] = 1
	else:
		condition_node.visible = false
		disabled_node.visible = false
		conditions_count -= 1
		conditions[condition_key] = 0
	
	_update_size()

func _modify_stacked_condition(condition_key, value):
	var mini_stacks = get_node("ScrollContainer/Conditions/{node}/Stack".format({"node": condition_key}))
	var popup_stacks = get_node("Mini_Popup/Body/Top/Stacking_Conditions/{node_1}/{node_2}_Toggle/Stack".format({"node_1": condition_key, "node_2": condition_key}))
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

func _on_rgn_add_pressed():
	_modify_stacked_condition("RGN", 1)

func _on_rgn_sub_pressed():
	_modify_stacked_condition("RGN", -1)

func _on_rgn_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "RGN")

func _on_fcs_add_pressed():
	_modify_stacked_condition("FCS", 1)

func _on_fcs_sub_pressed():
	_modify_stacked_condition("FCS", -1)

func _on_fcs_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "FCS")

func _on_sck_add_pressed():
	_modify_stacked_condition("SCK", 1)

func _on_sck_sub_pressed():
	_modify_stacked_condition("SCK", -1)

func _on_sck_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "SCK")

func _on_wnd_add_pressed():
	_modify_stacked_condition("WND", 1)

func _on_wnd_sub_pressed():
	_modify_stacked_condition("WND", -1)

func _on_wnd_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "WND")

func _on_shck_add_pressed():
	_modify_stacked_condition("SHCK", 1)

func _on_shck_sub_pressed():
	_modify_stacked_condition("SHCK", -1)

func _on_shck_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "SHCK")

func _on_shrd_add_pressed():
	_modify_stacked_condition("SHRD", 1)

func _on_shrd_sub_pressed():
	_modify_stacked_condition("SHRD", -1)

func _on_shrd_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "SHRD")

func _on_dst_add_pressed():
	_modify_stacked_condition("DST", 1)

func _on_dst_sub_pressed():
	_modify_stacked_condition("DST", -1)

func _on_dst_toggle_toggled(button_pressed):
	_toggle_stacked_condition(button_pressed, "DST")
