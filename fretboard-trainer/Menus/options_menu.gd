extends Control

@onready var sixty_sec: Button = $CanvasLayer/VBoxContainer/HBoxContainer/SixtySec
@onready var ninety_sec: Button = $CanvasLayer/VBoxContainer/HBoxContainer/NinetySec
@onready var hundred_twenty_sec: Button = $CanvasLayer/VBoxContainer/HBoxContainer/HundredTwentySec


var round_time: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")

func _on_sixty_sec_pressed() -> void:
	UserSettings.set_round_length(60)

func _on_ninety_sec_pressed() -> void:
	UserSettings.set_round_length(90)

func _on_hundred_twenty_sec_pressed() -> void:
	UserSettings.set_round_length(120)

func update_button_states() -> void:
	# Get the "Pressed" and "Normal" text colors from the first button's theme
	var pressed_color = sixty_sec.get_theme_color("font_pressed_color", "Button")
	var normal_color = sixty_sec.get_theme_color("font_color", "Button")
	
	# Reset all buttons to normal color
	sixty_sec.add_theme_color_override("font_color", normal_color)
	ninety_sec.add_theme_color_override("font_color", normal_color)
	hundred_twenty_sec.add_theme_color_override("font_color", normal_color)
	
	# Apply pressed color to the selected button
	match UserSettings.settings["round_length"]:
		60:
			sixty_sec.add_theme_color_override("font_color", pressed_color)
		90:
			ninety_sec.add_theme_color_override("font_color", pressed_color)
		120:
			hundred_twenty_sec.add_theme_color_override("font_color", pressed_color)
