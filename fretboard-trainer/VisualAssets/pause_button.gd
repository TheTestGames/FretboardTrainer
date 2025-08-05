extends Button

@onready var pause_menu: CanvasLayer = $"../PauseMenu"

func _on_pressed() -> void:
	get_tree().paused = true
	pause_menu.show()
