extends Node

# Number ID of a string, 1-6 for guitar, 1-4 for bass, to reflect to the correct string on
# the fretboard sprite from highest to lowest pitch
@export_range(1, 6, 1) var string_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello! I'm string " + str(string_id))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
