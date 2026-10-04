extends Control
class_name LetterTile

signal tile_clicked(letter: String)
signal tile_dragged(letter: String, target_position: Vector2)

@export var letter: String = "A"
@export var is_selected: bool = false

@onready var label: Label = $Label if has_node("Label") else null
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null


func _ready() -> void:
	set_letter(letter)
	gui_input.connect(_on_gui_input)


func set_letter(new_letter: String) -> void:
	letter = new_letter.to_upper()
	if label:
		label.text = letter


func select() -> void:
	is_selected = true
	modulate = Color(0.7, 0.9, 1.0) # Visual highlight feedback


func deselect() -> void:
	is_selected = false
	modulate = Color(1.0, 1.0, 1.0)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_selected:
			deselect()
		else:
			select()

		if AudioManager:
			AudioManager.play_sfx("type")

		tile_clicked.emit(letter)
