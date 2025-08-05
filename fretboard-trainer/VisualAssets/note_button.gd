extends Button
class_name Answer

# note_value will be set to match the semi-tone, A through G sharp, represented by the button text
# to be returned when the user presses the button as an answer, to be compared to the
# note_id of whatever dot was randomly selected, to judge if the user was correct
@export_range(1,12,1) var note_value: int
