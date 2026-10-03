extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")
		
	get_tree().quit()
