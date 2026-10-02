extends Node
class_name WordManager

signal word_selected(word_data: Dictionary)
signal word_completed(word_data: Dictionary)
signal word_failed(submitted_word: String)

const WORDS_PATH := "res://data/words.json"
const WordValidator = preload("res://scripts/word/WordValidator.gd")

var words: Array = []
var current_word: Dictionary = {}


func _ready() -> void:
	load_words()


func load_words() -> void:
	if not FileAccess.file_exists(WORDS_PATH):
		push_error("WordManager: File tidak ditemukan: " + WORDS_PATH)
		return

	var file := FileAccess.open(WORDS_PATH, FileAccess.READ)

	if file == null:
		push_error("WordManager: Gagal membuka " + WORDS_PATH)
		return

	var json_text: String = file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(json_text)

	if parse_result != OK:
		push_error(
			"WordManager: JSON tidak valid. Error: "
			+ json.get_error_message()
			+ " pada line "
			+ str(json.get_error_line())
		)
		return

	var data = json.data

	if not data is Dictionary:
		push_error("WordManager: Root JSON harus berupa object.")
		return

	if not data.has("words"):
		push_error("WordManager: Key 'words' tidak ditemukan.")
		return

	if not data["words"] is Array:
		push_error("WordManager: 'words' harus berupa array.")
		return

	words = data["words"]

	print("WordManager: Loaded ", words.size(), " words.")


func get_random_word(max_difficulty: int = 3) -> Dictionary:
	var available_words: Array = []

	for word_data in words:
		if not word_data is Dictionary:
			continue

		var difficulty: int = int(word_data.get("difficulty", 1))

		if difficulty <= max_difficulty:
			available_words.append(word_data)

	if available_words.is_empty():
		push_warning("Tidak ada word yang sesuai difficulty.")
		return {}

	var selected: Dictionary = available_words.pick_random()

	current_word = selected
	word_selected.emit(current_word)

	return current_word


func get_word_by_id(word_id: String) -> Dictionary:
	for word_data in words:
		if word_data.get("id", "") == word_id:
			return word_data

	return {}


func get_random_word_by_category(category: String) -> Dictionary:
	var available_words: Array = []

	for word_data in words:
		if word_data.get("category", "") == category:
			available_words.append(word_data)

	if available_words.is_empty():
		return {}

	var selected: Dictionary = available_words.pick_random()

	current_word = selected
	word_selected.emit(current_word)

	return current_word


func submit_word(player_input: String) -> bool:
	if current_word.is_empty():
		push_warning("WordManager: Belum ada current word.")
		return false

	var correct_word: String = str(current_word.get("word", ""))

	var is_correct: bool = WordValidator.validate(
		player_input,
		correct_word
	)

	if is_correct:
		word_completed.emit(current_word)
	else:
		word_failed.emit(player_input)

	return is_correct


func get_current_word() -> Dictionary:
	return current_word


func get_current_answer() -> String:
	return str(current_word.get("word", ""))


func get_current_clue() -> String:
	return str(current_word.get("clue", ""))
