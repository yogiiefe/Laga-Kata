extends Control

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"


func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
