extends Node
class_name ClueManager

signal clue_updated(clue_text: String, word_length: int)

var current_clue: String = ""
var current_word_length: int = 0


func set_word_data(word_data: Dictionary) -> void:
	current_clue = str(word_data.get("clue", ""))
	var word_text = str(word_data.get("word", ""))
	current_word_length = word_text.length()
	clue_updated.emit(current_clue, current_word_length)


func get_formatted_clue() -> String:
	return current_clue


func get_word_length_hint() -> String:
	return "%d Huruf" % current_word_length
