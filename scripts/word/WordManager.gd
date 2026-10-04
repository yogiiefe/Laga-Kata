extends Node
class_name WordManager

signal word_selected(word_data: Dictionary)
signal word_completed(word_data: Dictionary)
signal word_failed(submitted_word: String)

const WORDS_PATH := "res://data/words.json"
## Sumber utama kosakata: KBBI. kolom `kata` = jawaban, kolom `makna` = petunjuk (clue)
const KBBI_PATH := "res://assets/word/kbbi_v6.1.0_full.csv"
const KBBI_COLUMNS := 16
const KBBI_MAX_TRIES := 500
const MAX_CLUE_LENGTH := 110
# difficulty stage -> panjang kata maksimum (minimum selalu 3 huruf)
const MAX_LENGTH_BY_DIFFICULTY := {1: 5, 2: 8, 3: 11}

var words: Array = [] # cadangan dari words.json bila CSV tidak bisa dibuka
## Satu-satunya sumber kebenaran: {id, word (=kata), clue (=makna), ...}
var current_word: Dictionary = {}
## Hanya true selama ronde aktif; di luar itu jawaban diabaikan (tidak dihitung)
var accepting: bool = false

var _kbbi_file: FileAccess
var _regex_word := RegEx.new()
var _regex_next_sense := RegEx.new()
var _regex_tag := RegEx.new()
var _regex_lead_number := RegEx.new()
var _regex_spaces := RegEx.new()


func _ready() -> void:
	_regex_word.compile("^[a-z]+$")
	_regex_next_sense.compile("\\s\\d+\\.\\s*\\[.*$")
	_regex_tag.compile("\\[[^\\]]*\\]")
	_regex_lead_number.compile("^\\d+\\.\\s*")
	_regex_spaces.compile("\\s+")

	load_words() # cadangan bila CSV tidak bisa dibaca / tidak ada kata yang cocok
	_kbbi_file = FileAccess.open(KBBI_PATH, FileAccess.READ)
	if _kbbi_file == null:
		push_warning("WordManager: KBBI CSV tidak bisa dibuka (%s), memakai words.json" % KBBI_PATH)


func load_words() -> void:
	if not FileAccess.file_exists(WORDS_PATH):
		push_error("WordManager: File tidak ditemukan: " + WORDS_PATH)
		return

	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(WORDS_PATH)) != OK:
		push_error("WordManager: JSON tidak valid: " + json.get_error_message())
		return

	var data = json.data
	if data is Dictionary and data.get("words") is Array:
		words = data["words"]


## Ambil satu entri acak dari KBBI tanpa mengubah kata aktif.
## File CSV (35 MB) tidak dimuat penuh: kita lompat ke posisi acak lalu baca satu baris.
func sample_word(max_difficulty: int = 3) -> Dictionary:
	var level := clampi(max_difficulty, 1, 3)
	if _kbbi_file == null:
		return _sample_fallback(level)

	var max_len: int = MAX_LENGTH_BY_DIFFICULTY[level]
	var file_len := _kbbi_file.get_length()

	for _i in range(KBBI_MAX_TRIES):
		_kbbi_file.seek(randi() % file_len)
		_kbbi_file.get_line() # buang sisa baris yang terpotong
		if _kbbi_file.eof_reached():
			continue

		var row := _kbbi_file.get_csv_line(",")
		if row.size() != KBBI_COLUMNS:
			continue

		var kata := row[0]
		if kata == str(current_word.get("id", "")):
			continue # jangan ulang kata yang sama berturut-turut
		if kata.length() < 3 or kata.length() > max_len:
			continue
		if _regex_word.search(kata) == null:
			continue

		var clue := _clean_clue(row[4])
		if clue.is_empty() or clue.length() > MAX_CLUE_LENGTH:
			continue
		if clue.containsn(kata):
			continue # jangan membocorkan jawaban

		return {
			"id": kata,
			"word": kata.to_upper(),
			"clue": clue,
			"difficulty": level,
			"category": str(row[3]),
		}

	push_warning("WordManager: tidak menemukan kata KBBI yang cocok, memakai words.json")
	return _sample_fallback(level)


func _sample_fallback(level: int) -> Dictionary:
	var available: Array = words.filter(func(w): return int(w.get("difficulty", 1)) <= level)
	if available.is_empty():
		push_warning("WordManager: tidak ada kata yang tersedia.")
		return {}
	return available.pick_random()


## Ambil makna pertama KBBI sebagai clue (tanpa nomor, tag kelas kata, dan makna lain)
func _clean_clue(makna: String) -> String:
	var clue := _regex_next_sense.sub(makna.strip_edges(), "")
	clue = _regex_lead_number.sub(clue, "")
	clue = _regex_tag.sub(clue, "", true)
	clue = _regex_spaces.sub(clue, " ", true).strip_edges()
	var cut := clue.find(";")
	if cut > 0:
		clue = clue.substr(0, cut)
	return clue.trim_suffix(":").strip_edges()


func get_random_word(max_difficulty: int = 3) -> Dictionary:
	var selected := sample_word(max_difficulty)
	if selected.is_empty():
		return {}

	current_word = selected
	print("WordManager: kata=%s | clue=%s" % [current_word.get("word"), current_word.get("clue")])
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
	if not accepting:
		return false
	if WordValidator.is_empty(player_input):
		return false # input kosong diabaikan
	if current_word.is_empty():
		push_warning("WordManager: Belum ada current word.")
		return false

	# Bandingkan dengan `kata` (jawaban), BUKAN dengan `makna` (clue)
	var solved: Dictionary = current_word
	if WordValidator.validate(player_input, str(solved.get("word", ""))):
		current_word = {} # satu kata hanya boleh dihitung sekali
		word_completed.emit(solved)
		return true

	word_failed.emit(player_input)
	return false


func get_current_word() -> Dictionary:
	return current_word


func get_current_answer() -> String:
	return str(current_word.get("word", ""))


func get_current_clue() -> String:
	return str(current_word.get("clue", ""))
