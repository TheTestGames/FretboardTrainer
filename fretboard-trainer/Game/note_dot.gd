class_name  NoteDot
extends Sprite2D

# Note_ID will correspond to ever semitone from A to G sharp, 1-12, to be appropriately placed on the fretboard sprite
@export_range(1, 12, 1) var note_id: int = 1 # Default to A
# Fret_ID will represent the fret at which the NoteDot sprite will appear, with 0 being "open"
@export_range(0, 12, 1) var fret_id: int
