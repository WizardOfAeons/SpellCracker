class_name Character extends Node

# On character Creation, create a save file in user://Spell Cracker//Characters//Character_Name

var character_level = 0
var character_class_id = 000
var character_class = ""
var character_name = ""
var character_experience = 0
var character_credits = 0
var character_stats = {} # HP, AP, and SP using level.
var character_skills = {}
var character_abilities = {}

var character_assets = {} # Might be unnecessary.
var character_augments = {} # Might be unnecessary.

var character_avatar = ""
var character_icon = ""
var character_color = []

var max_hp = 0
var hp = 0
var max_ap = 0
var ap = 0
var max_sp = 0
var sp = 0

func _ready():
	pass

func _create_class(level, class_id, char_name):
	character_level = level
	character_class_id = class_id
	character_name = char_name
	
	character_experience = character_level * 25 # Need to make a rule for this.
	character_credits = character_level * 5
	
	var stat_block_path = "res://resources/statblocks/player_classes/{class_id}.json"
	stat_block_path = stat_block_path.format({"class_id": character_class_id})
	_load_blocks(stat_block_path)
	_update_character_level(character_level)
	_save_to_file()

func _load_blocks(file_path):
	var loader = json_loader.new()
	var json = loader.load_json(file_path)
	if json != null:
		character_class = json["name"]
		character_avatar = "res://resources/interface/avatars/class/{avatar}".format({"avatar": json["avatar"]})
		character_icon = "res://resources/interface/icons/class/{icon}".format({"icon": json["icon"]})
		character_color = json["color"]
		
		character_stats = json["stat_block"]
		character_skills = json["skill_block"]
		character_abilities = json["ability_block"]

func _update_character_level(new_level):
	character_level = new_level
	max_hp = character_stats[str(character_level)]["HP"]
	hp = max_hp
	max_ap = character_stats[str(character_level)]["AP"]
	ap = max_ap
	max_sp = character_stats[str(character_level)]["SP"]
	sp = max_sp

func _update_character_name(new_name):
	var path = "user://saves/characters/{character_name}.json".format({"character_name": character_name})
	
	if FileAccess.file_exists(path):
		var new_path = "user://saves/characters/{character_name}.json".format({"character_name": new_name})
		var dir = DirAccess.rename_absolute(path, new_path)
		character_name = new_name

func _save_to_file(): # Make a .JSON from the variables.
	# Make sure the save folder exists:
	var dir_path = "user://saves/characters"
	if DirAccess.dir_exists_absolute(dir_path) != true:
		var new_dir = DirAccess.make_dir_recursive_absolute(dir_path)
	
	# Create a DICT to store the character's data inside:
	var save_dict = {"character_level": character_level, "character_class_id": character_class_id, "character_class": character_class,
					"character_name": character_name, "character_experience": character_experience, "character_credits": character_credits,
					"character_stats": character_stats, "character_skills": character_skills, "character_abilities": character_abilities,
					"character_assets": character_assets, "character_augments": character_augments, "character_avatar": character_avatar,
					"character_icon": character_icon, "character_color": character_color, "max_hp": max_hp, "hp": hp, "max_ap": max_ap,
					"ap": ap, "max_sp": max_sp, "sp": sp}
	
	var json = JSON.stringify(save_dict)
	
	# Create a .JSON and put the character's data inside:
	var path = "user://saves/characters/{character_name}.json".format({"character_name": character_name})
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(json)
	
func _load_from_file(): # Load from a .JSON back into the variables. THIS NEEDS TESTING.
	var path = "user://saves/characters/{character_name}.json".format({"character_name": character_name})
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		
		while file.get_position() < file.get_length():
			var file_line = file.get_line()
			var json = JSON.new()
			var parsed_line = json.parse(file_line)
			var data = json.get_data()
			
			for key in data.keys():
				self.set(key, data[key])
