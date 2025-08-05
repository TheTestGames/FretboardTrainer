extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() in ["Windows", "macOS", "Linux"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Takes user to the six-string guitar trainer
func _on_guitar_pressed() -> void:
	print("Guitar trainer initiated")
	get_tree().change_scene_to_file("res://Game/the_game.tscn")

# Takes user to the 4 string bass trainer
func _on_bass_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/bass_game.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/OptionsMenu.tscn")
