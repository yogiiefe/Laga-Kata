extends Control
class_name WordProgress

@export var player_count_label: Label
@export var enemy_count_label: Label
@export var status_label: Label
@export var player_bar: TextureProgressBar
@export var enemy_bar: TextureProgressBar


func _ready() -> void:
	_resolve_nodes()


func _resolve_nodes() -> void:
	if player_count_label == null and has_node("PlayerCountLabel"):
		player_count_label = get_node("PlayerCountLabel") as Label
	if enemy_count_label == null and has_node("EnemyCountLabel"):
		enemy_count_label = get_node("EnemyCountLabel") as Label
	if status_label == null and has_node("StatusLabel"):
		status_label = get_node("StatusLabel") as Label
	if player_bar == null and has_node("PlayerBar"):
		player_bar = get_node("PlayerBar") as TextureProgressBar
	if enemy_bar == null and has_node("EnemyBar"):
		enemy_bar = get_node("EnemyBar") as TextureProgressBar


func update_progress(player_words: int, enemy_words: int) -> void:
	_resolve_nodes()

	if player_count_label:
		player_count_label.text = "PLAYER: %d words" % player_words
	if enemy_count_label:
		enemy_count_label.text = "ENEMY: %d words" % enemy_words

	if player_bar:
		player_bar.value = player_words
	if enemy_bar:
		enemy_bar.value = enemy_words

	if status_label:
		if player_words > enemy_words:
			status_label.text = "Kamu Unggul! 🔥"
		elif enemy_words > player_words:
			status_label.text = "Musuh Unggul! ⚠️"
		else:
			status_label.text = "SERI!"



func reset_progress() -> void:
	update_progress(0, 0)
