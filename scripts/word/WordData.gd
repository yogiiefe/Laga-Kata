extends RefCounted
class_name WordData

var id: String = ""
var word: String = ""
var clue: String = ""
var difficulty: int = 1
var category: String = "umum"


func _init(p_id: String = "", p_word: String = "", p_clue: String = "", p_difficulty: int = 1, p_category: String = "umum") -> void:
	id = p_id
	word = p_word
	clue = p_clue
	difficulty = p_difficulty
	category = p_category


static func from_dict(dict: Dictionary) -> WordData:
	return WordData.new(
		str(dict.get("id", "")),
		str(dict.get("word", "")),
		str(dict.get("clue", "")),
		int(dict.get("difficulty", 1)),
		str(dict.get("category", "umum"))
	)


func to_dict() -> Dictionary:
	return {
		"id": id,
		"word": word,
		"clue": clue,
		"difficulty": difficulty,
		"category": category
	}
