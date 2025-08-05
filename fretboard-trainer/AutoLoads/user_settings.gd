extends Node

var settings: Dictionary = {
	"round_length": 60 # Default to 60 seconds
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load saved round length if it exists
	if FileAccess.file_exists("user://settings.save"):
		var file = FileAccess.open("user://settings.save", FileAccess.READ)
		if file == null:
			print("Error opening settings.save: ", FileAccess.get_open_error())
			return
		var loaded_settings = file.get_var()
		file.close()
		if loaded_settings is Dictionary:
			settings = loaded_settings
			print("Loaded settings: ", settings)
		else:
			print("Error: settings.save contains invalid data, using defaults")
	else:
		print("No saved settings, using defaults: ", settings)
		save_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_round_length(new_length: int) -> void:
	if new_length in [60, 90, 120]:
		settings["round_length"] = new_length
		save_settings()
		print("Set round length to: ", settings["round_length"])
	else:
		print("Invalid round length!")

func save_settings() -> void:
	var file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	if file == null:
		print("Error opening settings.save for write: ", FileAccess.get_open_error())
		return
	file.store_var(settings)
	file.close()
