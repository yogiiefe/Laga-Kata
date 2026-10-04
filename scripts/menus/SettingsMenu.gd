extends Control

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"

@onready var bgm_slider: HSlider = $VBoxContainer/BgmSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SfxSlider
@onready var labels_check: CheckButton = $VBoxContainer/LabelsCheck


func _ready() -> void:
	bgm_slider.set_value_no_signal(AudioManager.bgm_volume)
	sfx_slider.set_value_no_signal(AudioManager.sfx_volume)
	labels_check.set_pressed_no_signal(SaveManager.save_data["settings"].get("show_labels", true))


func _on_bgm_changed(value: float) -> void:
	AudioManager.set_bgm_volume(value)
	SaveManager.save_data["settings"]["bgm_volume"] = value


func _on_sfx_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	SaveManager.save_data["settings"]["sfx_volume"] = value
	AudioManager.play_sfx("button_click")


func _on_labels_toggled(pressed: bool) -> void:
	SaveManager.save_data["settings"]["show_labels"] = pressed


func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	SaveManager.save_game()
	if get_tree().current_scene == self:
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
	else:
		queue_free() # dibuka sebagai overlay dari menu jeda
