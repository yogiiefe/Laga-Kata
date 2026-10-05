extends Control

const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"

@onready var bgm_slider: HSlider = $VBoxContainer/MusicRow/Slider
@onready var bgm_value: Label = $VBoxContainer/MusicRow/Value
@onready var sfx_slider: HSlider = $VBoxContainer/SfxRow/Slider
@onready var sfx_value: Label = $VBoxContainer/SfxRow/Value
@onready var mute_toggle: CheckButton = $VBoxContainer/MuteRow/Toggle
@onready var mute_state: Label = $VBoxContainer/MuteRow/State
@onready var labels_toggle: CheckButton = $VBoxContainer/LabelRow/Toggle
@onready var labels_state: Label = $VBoxContainer/LabelRow/State


func _ready() -> void:
	# Satu-satunya sumber state: AudioManager + SaveManager (sama untuk menu utama dan jeda)
	bgm_slider.set_value_no_signal(AudioManager.bgm_volume)
	sfx_slider.set_value_no_signal(AudioManager.sfx_volume)
	mute_toggle.set_pressed_no_signal(AudioManager.is_muted())
	labels_toggle.set_pressed_no_signal(SaveManager.save_data["settings"].get("show_labels", true))
	_refresh_texts()


func _exit_tree() -> void:
	SaveManager.save_game()


func _refresh_texts() -> void:
	bgm_value.text = "%d%%" % roundi(bgm_slider.value * 100.0)
	sfx_value.text = "%d%%" % roundi(sfx_slider.value * 100.0)
	mute_state.text = "YA" if mute_toggle.button_pressed else "TIDAK"
	labels_state.text = "NYALA" if labels_toggle.button_pressed else "MATI"


func _on_bgm_changed(value: float) -> void:
	AudioManager.set_bgm_volume(value)
	SaveManager.save_data["settings"]["bgm_volume"] = value
	_refresh_texts()


func _on_sfx_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	SaveManager.save_data["settings"]["sfx_volume"] = value
	AudioManager.play_sfx("button_click")
	_refresh_texts()


func _on_mute_toggled(pressed: bool) -> void:
	AudioManager.set_muted(pressed)
	_refresh_texts()


func _on_labels_toggled(pressed: bool) -> void:
	SaveManager.save_data["settings"]["show_labels"] = pressed
	_refresh_texts()


func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	if get_tree().current_scene == self:
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
	else:
		queue_free() # dibuka sebagai overlay dari menu jeda
