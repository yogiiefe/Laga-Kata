extends Control
class_name BattleUI

@onready var player_health_bar: HealthBar = $PlayerHealthBar if has_node("PlayerHealthBar") else null
@onready var enemy_health_bar: HealthBar = $EnemyHealthBar if has_node("EnemyHealthBar") else null
@onready var clue_label: Label = $CluePanel/ClueLabel if has_node("CluePanel/ClueLabel") else null
@onready var timer_label: Label = $TimerLabel if has_node("TimerLabel") else null
@onready var word_progress: WordProgress = $WordProgress if has_node("WordProgress") else null


func set_clue(clue_text: String) -> void:
	if clue_label:
		clue_label.text = clue_text


func update_timer(seconds_left: int) -> void:
	if timer_label:
		timer_label.text = "%02d" % seconds_left


func update_word_progress(player_words: int, enemy_words: int) -> void:
	if word_progress:
		word_progress.update_progress(player_words, enemy_words)
