extends Control

signal word_submitted(text: String)

# Path ke LineEdit menyesuaikan struktur WordInput.tscn
@onready var input_field: LineEdit = _find_line_edit()

@export var word_manager: Node


func _ready() -> void:
	if input_field:
		input_field.text_submitted.connect(_on_text_submitted)
		input_field.grab_focus()
	else:
		push_error("WordInput: Tidak bisa menemukan LineEdit!")


func _find_line_edit() -> LineEdit:
	# Coba berbagai path yang mungkin
	if has_node("TextureRect/HBoxContainer/LineEdit"):
		return get_node("TextureRect/HBoxContainer/LineEdit") as LineEdit
	elif has_node("LineEdit"):
		return get_node("LineEdit") as LineEdit
	elif has_node("HBoxContainer/LineEdit"):
		return get_node("HBoxContainer/LineEdit") as LineEdit
	# Fallback: cari secara rekursif
	return _find_line_edit_recursive(self)


func _find_line_edit_recursive(node: Node) -> LineEdit:
	for child in node.get_children():
		if child is LineEdit:
			return child as LineEdit
		var found = _find_line_edit_recursive(child)
		if found:
			return found
	return null


func _on_text_submitted(new_text: String) -> void:
	var text_clean := new_text.strip_edges()

	if text_clean.is_empty():
		return

	word_submitted.emit(text_clean)

	if word_manager and word_manager.has_method("submit_word"):
		var correct: bool = word_manager.submit_word(text_clean)
		_show_feedback(correct)
	else:
		push_warning("WordInput: word_manager belum di-assign atau tidak valid!")

	if input_field:
		input_field.clear()
		input_field.grab_focus()


func _show_feedback(correct: bool) -> void:
	if not input_field:
		return
	# Flash warna hijau (benar) atau merah (salah)
	var flash_color: Color = Color.GREEN if correct else Color.RED

	input_field.add_theme_color_override("font_color", flash_color)
	# Reset warna setelah 0.3 detik
	get_tree().create_timer(0.3).timeout.connect(func():
		input_field.remove_theme_color_override("font_color")
	)


func set_enabled(enabled: bool) -> void:
	if input_field == null:
		return
	input_field.editable = enabled
	if enabled:
		input_field.grab_focus()
	else:
		input_field.clear()


func grab_focus_input() -> void:
	if input_field:
		input_field.grab_focus()
