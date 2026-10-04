extends Node

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"
const MAIN_GAME_PATH  := "res://scenes/game/MainGame.tscn"

var is_final: bool = false


func _ready() -> void:
	# Tombol disambungkan lewat scene
	pass


## Dipanggil MainGame setelah overlay di-instantiate
func setup(final_stage: bool) -> void:
	is_final = final_stage
	if is_final:
		$VBoxContainer/TitleLabel.text = "TAMAT!"
		$VBoxContainer/SubLabel.text = "Semua musuh berhasil dikalahkan!"
		$VBoxContainer/NextButton.text = "MAIN LAGI"
	else:
		$VBoxContainer/NextButton.text = "STAGE BERIKUTNYA"


func _on_next_pressed() -> void:
	AudioManager.play_sfx("button_click")
	# Stage berikutnya sudah diset di GameManager oleh MainGame (final -> kembali ke stage 1)
	get_tree().change_scene_to_file(MAIN_GAME_PATH)


func _on_menu_pressed() -> void:
	AudioManager.play_sfx("button_click")
	GameManager.current_stage_index = 0
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
