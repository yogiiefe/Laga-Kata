extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
		
	print("Menu Credits diklik (Belum ada scene-nya)")
	get_tree().change_scene_to_file("res://scenes/menus/Achievements.tscn")
