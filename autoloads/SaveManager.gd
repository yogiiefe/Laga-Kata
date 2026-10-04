extends Node

const SAVE_FILE_PATH: String = "user://save_data.json"

# Template data save awal jika belum ada save file
var save_data: Dictionary = {
	"unlocked_stages": ["stage_01"],
	"high_scores": {},
	"settings": {
		"bgm_volume": 1.0,
		"sfx_volume": 1.0,
		"show_labels": true
	}
}

func _ready() -> void:
	pass # GameManager yang akan memanggil load_game()

func save_game() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t") # Gunakan "\t" agar JSON mudah dibaca
		file.store_string(json_string)
		file.close()
		print("Game berhasil di-save!")
	else:
		push_error("Gagal membuka file save untuk menulis.")

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Save file tidak ditemukan. Menggunakan data default.")
		save_game() # Buat file baru
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			var data = json.get_data()
			if typeof(data) == TYPE_DICTIONARY:
				# Gabungkan save data lama dengan default (agar jika ada update fitur, tidak error)
				save_data.merge(data, true)
				print("Save file berhasil di-load.")
			else:
				push_error("Format data save tidak valid (bukan dictionary).")
		else:
			push_error("Gagal melakukan parse JSON di file save.")

# Fungsi helper untuk update data
func unlock_stage(stage_id: String) -> void:
	if not save_data["unlocked_stages"].has(stage_id):
		save_data["unlocked_stages"].append(stage_id)
		save_game()

func update_high_score(stage_id: String, score: int) -> void:
	if not save_data["high_scores"].has(stage_id) or score > save_data["high_scores"][stage_id]:
		save_data["high_scores"][stage_id] = score
		save_game()
