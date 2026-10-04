extends Node

# Signal untuk memberitahu node lain jika ada perubahan global
signal game_paused(is_paused: bool)
signal stage_changed(new_stage_id: String)

# Global State Variables
var current_stage_id: String = "stage_01"
var current_stage_index: int = 0
var is_game_paused: bool = false
var player_high_score: int = 0


func _ready() -> void:
	# Load data saat game pertama kali jalan
	SaveManager.load_game()
	AudioManager.apply_saved_settings()

# Dipanggil saat pemain memilih stage dari map/menu
func set_current_stage(stage_id: String) -> void:
	current_stage_id = stage_id
	stage_changed.emit(current_stage_id)

func toggle_pause() -> void:
	is_game_paused = !is_game_paused
	get_tree().paused = is_game_paused
	game_paused.emit(is_game_paused)

func reset_session() -> void:
	# Reset state yang hanya berlaku untuk sesi main ini
	is_game_paused = false
	get_tree().paused = false
