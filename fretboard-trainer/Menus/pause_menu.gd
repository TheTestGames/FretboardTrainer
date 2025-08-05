extends CanvasLayer

@onready var resume: Button = $CanvasLayer/VBoxContainer/HBoxContainer/Resume
@onready var main_menu: Button = $CanvasLayer/VBoxContainer/HBoxContainer/MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
