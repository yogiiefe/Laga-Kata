extends Node

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"
const MAIN_GAME_PATH := "res://scenes/game/MainGame.tscn"


func _ready() -> void:
	# Tombol disambungkan lewat scene
	pass


func _on_retry_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file(MAIN_GAME_PATH)


func _on_menu_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
