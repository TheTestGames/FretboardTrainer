extends Control

@onready var times_up_layer: CanvasLayer = $TimesUpLayer
@onready var times_up_label: Label = $TimesUpLayer/TimesUpLabel
@onready var times_up_timer: Timer = $TimesUpLayer/TimesUpLabel/TimesUpTimer
@onready var game_over_layer: CanvasLayer = $GameOverLayer
@onready var score_label: Label = $GameOverLayer/VBoxContainer/HBoxContainer/ScoreLabel
@onready var wrong_label: Label = $GameOverLayer/VBoxContainer/HBoxContainer/WrongLabel

var score: int = 0
var wrong: int = 0
var game_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	times_up_layer.visible = true
	game_over_layer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_times_up_timer_timeout() -> void:
	times_up_layer.visible = false
	game_over_layer.visible = true

func set_scores(final_score: int, final_wrong: int, scene_path: String) -> void:
	score = final_score
	wrong = final_wrong
	game_scene_path = scene_path
	score_label.text = "Score: %d" % score
	wrong_label.text = "Wrong: %d" % wrong
	if game_scene_path == "":
		print("Warning!  game_scene_path not set!")
	

func _on_play_again_pressed() -> void:
	if game_scene_path == "":
		print("Error: No game scene path set, cannot reload game!")
		return
	print("Reloading game scene, %s" % game_scene_path)
	var scene: PackedScene = load(game_scene_path) as PackedScene
	if not scene:
		push_error("Failed to load PackedScene: %s" % game_scene_path)
		return
	var error = get_tree().change_scene_to_packed(scene)
	if error != OK:
		push_error("Failed to change to scene: %s, Error code: %d" % [game_scene_path, error])

func _on_main_menu_pressed() -> void:
	print("Main Menu button pressed, loading MainMenu.tscn")
	var scene: PackedScene = load("res://Menus/MainMenu.tscn") as PackedScene
	if not scene:
		push_error("Failed to load MainMenu.tscn")
		return
	var error = get_tree().change_scene_to_packed(scene)
	if error != OK:
		push_error("Failed to load MainMenu.tscn, Error code: %d" % error)
