extends Control

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"

@onready var bgm_slider: HSlider = $VBoxContainer/BgmSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SfxSlider


func _ready() -> void:
	bgm_slider.set_value_no_signal(AudioManager.bgm_volume)
	sfx_slider.set_value_no_signal(AudioManager.sfx_volume)


func _on_bgm_changed(value: float) -> void:
	AudioManager.set_bgm_volume(value)
	SaveManager.save_data["settings"]["bgm_volume"] = value


func _on_sfx_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	SaveManager.save_data["settings"]["sfx_volume"] = value
	AudioManager.play_sfx("button_click")


func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	SaveManager.save_game()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
