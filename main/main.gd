extends Node2D

func _ready():
	# Check if there are any saved campaign.
	pass # Replace with function body.

func _on_new_campaign_button_pressed():
	SceneTransition.change_scene_dissolve("res://main/campaign_creation.tscn")

func _on_continue_button_pressed():
	pass # Replace with function body.

func _on_load_button_pressed():
	pass # Replace with function body.

func _on_options_button_pressed():
	pass # Replace with function body.

func _on_exit_button_pressed():
	get_tree().quit()
