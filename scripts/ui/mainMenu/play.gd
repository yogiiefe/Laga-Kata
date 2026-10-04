extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
	GameManager.current_stage_index = 0
	get_tree().change_scene_to_file("res://scenes/game/MainGame.tscn")
