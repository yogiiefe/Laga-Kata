extends Control

signal resumed()

const SETTINGS_SCENE := preload("res://scenes/menus/Settings.tscn")
const MAIN_MENU_PATH := "res://scenes/menus/MainMenu.tscn"

var _settings: Control = null


func _ready() -> void:
	get_tree().paused = true
	$VBoxContainer/ResumeButton.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and _settings == null:
		get_viewport().set_input_as_handled()
		_on_resume_pressed()


func _on_resume_pressed() -> void:
	AudioManager.play_sfx("button_click")
	get_tree().paused = false
	resumed.emit()
	queue_free()


func _on_settings_pressed() -> void:
	AudioManager.play_sfx("button_click")
	_settings = SETTINGS_SCENE.instantiate()
	add_child(_settings)
	$VBoxContainer.hide()
	_settings.tree_exited.connect(func():
		_settings = null
		$VBoxContainer.show()
	)


func _on_exit_pressed() -> void:
	AudioManager.play_sfx("button_click")
	get_tree().paused = false
	GameManager.current_stage_index = 0
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
