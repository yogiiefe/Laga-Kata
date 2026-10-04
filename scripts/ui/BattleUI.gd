extends Control
class_name BattleUI

signal pause_pressed()
signal settings_pressed()

@onready var player_health_bar: HealthBar = $PlayerHealthBar if has_node("PlayerHealthBar") else null
@onready var enemy_health_bar: HealthBar = $EnemyHealthBar if has_node("EnemyHealthBar") else null
@onready var clue_label: Label = $CluePanel/ClueLabel if has_node("CluePanel/ClueLabel") else null
@onready var timer_label: Label = $TimerLabel if has_node("TimerLabel") else null
@onready var word_progress: WordProgress = $WordProgress if has_node("WordProgress") else null
@onready var user_word_label: Label = $UserBubble/UserWordLabel
@onready var enemy_word_label: Label = $EnemyBubble/EnemyWordLabel
@onready var pause_button: TextureButton = $PauseButton
@onready var settings_button: TextureButton = $SettingsButton
@onready var mute_button: TextureButton = $MuteButton


func _ready() -> void:
	pause_button.pressed.connect(func(): pause_pressed.emit())
	settings_button.pressed.connect(func(): settings_pressed.emit())
	mute_button.pressed.connect(_on_mute_pressed)
	apply_label_setting()


## Pengaturan "Tampilkan Label": menyembunyikan angka HP dan jumlah kata bila dimatikan
func apply_label_setting() -> void:
	var show_labels: bool = SaveManager.save_data.get("settings", {}).get("show_labels", true)
	player_health_bar.set_label_visible(show_labels)
	enemy_health_bar.set_label_visible(show_labels)
	if word_progress:
		word_progress.player_count_label.visible = show_labels
		word_progress.enemy_count_label.visible = show_labels


func _on_mute_pressed() -> void:
	var muted := AudioManager.toggle_mute()
	mute_button.modulate = Color(1, 1, 1, 0.45) if muted else Color.WHITE


func set_clue(clue_text: String) -> void:
	if clue_label:
		clue_label.text = clue_text


## Tampilkan sisa waktu ronde dalam format MM:SS
func update_timer(seconds_left: int) -> void:
	if timer_label:
		timer_label.text = "%02d:%02d" % [floori(seconds_left / 60.0), seconds_left % 60]


func update_word_progress(player_words: int, enemy_words: int) -> void:
	if word_progress:
		word_progress.update_progress(player_words, enemy_words)


## Kata terakhir yang diketik pemain (hijau = benar, merah = salah)
func set_user_word(text: String, correct: bool = true) -> void:
	user_word_label.text = text
	user_word_label.add_theme_color_override("font_color", Color(0.0, 0.5, 0.2) if correct else Color(0.85, 0.1, 0.1))


func set_enemy_word(text: String) -> void:
	enemy_word_label.text = text
