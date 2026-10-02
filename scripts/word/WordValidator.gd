extends Node
class_name WordValidator


static func validate(player_input: String, correct_word: String) -> bool:
	var input: String = normalize_word(player_input)
	var answer: String = normalize_word(correct_word)

	return input == answer


static func normalize_word(word: String) -> String:
	return word.strip_edges().to_upper()


static func is_empty(word: String) -> bool:
	return normalize_word(word).is_empty()


static func get_word_length(word: String) -> int:
	return normalize_word(word).length()
