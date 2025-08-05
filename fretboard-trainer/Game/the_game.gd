extends Node2D

signal answer_pressed(answer_value: int)

@onready var ready_menu: Control = $CanvasLayer2/ReadyMenu
@onready var fretboard_sprite: Sprite2D = $FretboardSprite
@onready var game_timer: Timer = $GameTimer
@onready var score_label: Label = $CanvasLayer3/ScoreLabel
@onready var wrong_label: Label = $CanvasLayer3/WrongLabel
@onready var timer_label: Label = $CanvasLayer3/TimerLabel
@onready var button_container: ColorRect = $CanvasLayer/ButtonContainer
@onready var ding_player: AudioStreamPlayer = $DingPlayer
@onready var bzzt_player: AudioStreamPlayer = $BzztPlayer

var score: int = 0
var wrong: int = 0
var note_number: int
var string_number: int
var fret_number: int
var is_playing: bool
var time_left: int = 60
var string_name: String
var chosen_dot: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensuring correct values of different things when scene initiates
	score_label.text = "Score: " + str(score)
	wrong_label.text = "Wrong: " + str(wrong)
	game_timer.wait_time = 1
	time_left = UserSettings.settings["round_length"]
	timer_label.text = "Time: " + str(UserSettings.settings["round_length"])
	
	for child in button_container.get_children():
		if child is Button:
#			Connecting pressed signal to ever button node, passing the button's note_value
			print("Connecting button: ", child.name, " with note_value ", child.note_value)
			child.pressed.connect(func(): _on_button_pressed(child.note_value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed(answer_value: int):
	emit_signal("answer_pressed", answer_value)
	print("Button pressed with value: ", answer_value)

# Will select one of the String nodes based on their string_id to pick note from
# and set string_name to the nodde's name in the Scene Tree for use in the game logic
func select_string() -> void:
	string_number = randi_range(1, 6)
	for child in fretboard_sprite.get_children():
		if child.string_id == string_number:
			string_name = child.name

# Will select a fret number, from 0 (open) to 12, and set fret_number to it
# in order to be combined with string_number to select a specific position on the fretbaord
func select_fret():
	fret_number = randi_range(0, 12)
	print("You have selected fret " + str(fret_number))

# Will get specific position on the fretboard, make corresponding icon visible
# and set note_number
func get_fretboard_placement() -> void:
	select_string()
	select_fret()
	print("Selected string: %s, fret: %d" % [string_name, fret_number])
	if chosen_dot:
		chosen_dot.visible = false
	for child in fretboard_sprite.get_children():
		if child.name == string_name:
			var notes = child
			for dot in notes.get_children():
		#		"child" here are all note_dot scenes with a fret_id value set after placing
		#		the instance in the the_game.tscn's scene tree, and note_id value correspodning
		#		to whatever note its position on the fretboard would be 
				if dot.fret_id == fret_number:
					note_number = dot.note_id
					chosen_dot = dot
					dot.visible = true
					print("Chosen dot: %s, fret_id: %d, note_id: %d" % [dot.name, dot.fret_id, dot.note_id])
					return
	push_error("No NoteDot found for string: %s, fret: %d" % [string_name, fret_number])

func _on_ready_menu_countdown_finished() -> void:
	ready_menu.queue_free()
	is_playing = true
	get_fretboard_placement()
	game_timer.start()
	print("Game timer started, is_playing:", is_playing)
	play_game()

# Checks if player picked the right note to match the dot shown on the fretboard
# And either increases his score or his wrong
func check_answer(target: int) -> void:
	print("Starting check_answer with target: ", target)
	var answer = await answer_pressed
	print("Received answer: ", answer, ", Target: ", target)
	if answer == target:
		score += 1
		score_label.text = "Score: " + str(score)
		ding_player.play()
		print("Score updated: ", score)
	else:
		wrong += 1
		wrong_label.text = "Wrong: " + str(wrong)
		bzzt_player.play()
		print("Wrong updated: ", wrong)
	if chosen_dot:
		chosen_dot.visible = false

func play_game() -> void:
	while is_playing:
		print("Showing new note, is_playing: ", is_playing)
		get_fretboard_placement()
		if note_number == null:
			print("Error: note_number not set!")
			return
		print("Calling check_answer with note_number: ", note_number)
		await check_answer(note_number)
		print("Answer checked, is_playing: ", is_playing)
	game_over()

# Handles ending the game, loading the Game Over Screen, and passing through
# the necessary information
func game_over() -> void:
	print("Game Over! Final Score: ", score, ", Wrong: ", wrong)
	# Disable game buttons
	for child in button_container.get_children():
		if child is Button:
			child.disabled = true
	# Load and instantiate GameOverScreen
	var game_over_screen = load("res://Menus/GameOverScreen.tscn") as PackedScene
	if not game_over_screen:
		push_error("Failed to load GameOverScreen.tscn")
		return
	var game_over_instance = game_over_screen.instantiate()
	if not game_over_instance:
		push_error("Failed to instantiate GameOverScreen")
		return
	add_child(game_over_instance)
	# Set scene path for Play Again button in GameOverScreen
	var scene_path = "res://Game/the_game.tscn"
	print("Setting game_scene_path to: %s" % scene_path)
	game_over_instance.set_scores(score, wrong, scene_path)

# Will reduce the "time_left" variable by one, and update the TimerLabel to reflect
# the new value, every time the 1 second GameTimer times out, and set
# is_playing to false when time_left is 0
func _on_game_timer_timeout() -> void:
	time_left -= 1
	timer_label.text = "Time: " + str(time_left)
	if time_left <= 0:
		game_timer.stop()
		is_playing = false
