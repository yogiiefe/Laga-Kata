extends Node

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"
const MAIN_GAME_PATH  := "res://scenes/game/MainGame.tscn"


func _ready() -> void:
	pass


func _on_next_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
	# stage_index sudah di-increment oleh MainGame sebelum overlay ini ditampilkan
	get_tree().change_scene_to_file(MAIN_GAME_PATH)


func _on_menu_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
	# Reset stage index saat kembali ke menu
	if GameManager and "current_stage_index" in GameManager:
		GameManager.current_stage_index = 0
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
