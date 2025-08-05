extends Control

signal countdown_finished

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var countdown_timer: Timer = $CountdownTimer
@onready var countdown_label: Label = $CountdownLabel
@onready var color_rect: ColorRect = $ColorRect

# This will be assigned to countdown_label and reduced by 1 every time the 1 second timer ends
# giving us a 3 second countdown.
var countdown_value: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	v_box_container.visible = true
	countdown_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Hides the Ready? menu and shows the countdown_label with the countdown_value
# and starting the countdown_timer
func _on_yes_button_pressed() -> void:
	v_box_container.hide()
	color_rect.hide()
	countdown_label.visible = true
	countdown_label.text = str(countdown_value)
	countdown_timer.start()

# Handles things when the timer countdowns to start the game, with a signal
# for the "game" node to listen for to start the actual game.
func _on_countdown_timer_timeout() -> void:
	countdown_value -= 1
	if countdown_value > 0:
		countdown_label.text = str(countdown_value)
	else:
		countdown_timer.queue_free()
		countdown_label.text = "Go!"
		await get_tree().create_timer(1.0).timeout
		print("Countdown complete!")
		countdown_finished.emit()

# God help you if this isn't obvious
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
