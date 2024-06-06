class_name json_loader extends Node

func load_json(file_path):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.get_file_as_string(file_path)
		var dict = JSON.parse_string(file)
		return dict
	else:
		return null
