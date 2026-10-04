extends Node
class_name WordValidator

## Aturan pencocokan: EXACT MATCH setelah normalisasi (tanpa fuzzy).
## Normalisasi: tab/newline -> spasi, spasi berlebih dirapikan, huruf kecil.
## Tidak ada karakter bermakna yang dibuang ("komputer123" tetap salah).


static func validate(player_input: String, correct_word: String) -> bool:
	var input: String = normalize_word(player_input)
	if input.is_empty():
		return false
	return input == normalize_word(correct_word)


static func normalize_word(word: String) -> String:
	var cleaned := word.replace("", " ").replace("
", " ").replace("	", " ")
	return cleaned.simplify_whitespace().to_lower()


static func is_empty(word: String) -> bool:
	return normalize_word(word).is_empty()


static func get_word_length(word: String) -> int:
	return normalize_word(word).length()
