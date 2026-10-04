extends Node2D

signal battle_won()
signal battle_lost()

@export var round_duration: float = 15.0
## Kesulitan kata maksimum untuk stage ini (diset oleh MainGame dari stages.json)
@export var max_word_difficulty: int = 3

@onready var word_manager: WordManager = $WordManager
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var battle_timer: BattleTimer = $BattleTimer

@onready var combat_manager: CombatManager = $CombatManager if has_node("CombatManager") else null
@onready var clue_manager: ClueManager = $ClueManager if has_node("ClueManager") else null

@onready var battle_ui: BattleUI = $Battle_UI_Layer/BattleUI if has_node("Battle_UI_Layer/BattleUI") else null
@onready var word_input: Control = $Battle_UI_Layer/WordInput if has_node("Battle_UI_Layer/WordInput") else null

const PAUSE_SCENE := preload("res://scenes/menus/PauseMenu.tscn")

var _battle_active: bool = false
var _round_active: bool = false


func _ready() -> void:
	_ensure_components()
	_update_layout()
	get_viewport().size_changed.connect(_update_layout)
	# Gunakan call_deferred agar semua @onready sudah selesai init
	call_deferred("_setup_battle")


## Pemain selalu di kiri, musuh di kanan (mengikuti lebar viewport)
func _update_layout() -> void:
	var width := get_viewport_rect().size.x
	if player:
		player.position.x = 190.0
	if enemy:
		enemy.position.x = width - 210.0


func _open_pause(open_settings: bool = false) -> void:
	if not _battle_active or get_tree().paused:
		return
	var pause_menu := PAUSE_SCENE.instantiate()
	$Battle_UI_Layer.add_child(pause_menu)
	pause_menu.resumed.connect(func():
		battle_ui.apply_label_setting()
		if word_input:
			word_input.grab_focus_input()
	)
	if open_settings:
		pause_menu.call("_on_settings_pressed")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_open_pause()


func _on_enemy_word_typed() -> void:
	# Musuh "mengetik" satu kata: tampilkan kata KBBI acak di balon musuh
	var sample := word_manager.sample_word(max_word_difficulty)
	if battle_ui:
		battle_ui.set_enemy_word(str(sample.get("word", "...")))


func _ensure_components() -> void:
	if combat_manager == null:
		combat_manager = CombatManager.new()
		combat_manager.name = "CombatManager"
		add_child(combat_manager)

	if clue_manager == null:
		clue_manager = ClueManager.new()
		clue_manager.name = "ClueManager"
		add_child(clue_manager)


func _setup_battle() -> void:
	# Bind HealthBars ke entitas lewat BattleUI
	if battle_ui:
		if battle_ui.player_health_bar and player:
			battle_ui.player_health_bar.bind_entity(player)
		if battle_ui.enemy_health_bar and enemy:
			battle_ui.enemy_health_bar.bind_entity(enemy)

	# Connect WordManager signals
	if word_manager:
		if not word_manager.word_completed.is_connected(_on_player_word_completed):
			word_manager.word_completed.connect(_on_player_word_completed)
		if not word_manager.word_selected.is_connected(_on_word_selected):
			word_manager.word_selected.connect(_on_word_selected)
		if not word_manager.word_failed.is_connected(_on_word_failed):
			word_manager.word_failed.connect(_on_word_failed)

	# Assign WordManager ke WordInput
	if word_input:
		word_input.word_manager = word_manager
		word_input.text_edited.connect(func(t: String): battle_ui.set_user_word(t.to_upper(), "typing"))

	# Connect Player signals
	if player:
		if not player.word_count_changed.is_connected(_on_word_count_changed):
			player.word_count_changed.connect(_on_word_count_changed)
		if not player.player_defeated.is_connected(_on_player_defeated):
			player.player_defeated.connect(_on_player_defeated)

	# Connect Enemy signals
	if enemy:
		if not enemy.word_count_changed.is_connected(_on_word_count_changed):
			enemy.word_count_changed.connect(_on_word_count_changed)
		if not enemy.word_typed.is_connected(_on_enemy_word_typed):
			enemy.word_typed.connect(_on_enemy_word_typed)
		if not enemy.enemy_defeated.is_connected(_on_enemy_defeated):
			enemy.enemy_defeated.connect(_on_enemy_defeated)

	if battle_ui:
		battle_ui.pause_pressed.connect(_open_pause)
		battle_ui.settings_pressed.connect(_open_pause.bind(true))

	# Connect Timer signals
	if battle_timer:
		if battle_timer.has_signal("second_ticked"):
			if not battle_timer.second_ticked.is_connected(_on_timer_second_ticked):
				battle_timer.second_ticked.connect(_on_timer_second_ticked)
		if battle_timer.has_signal("round_ended"):
			if not battle_timer.round_ended.is_connected(_on_round_ended):
				battle_timer.round_ended.connect(_on_round_ended)

	AudioManager.play_bgm("battle")
	_battle_active = true
	start_new_round()


func start_new_round() -> void:
	if not _battle_active:
		return

	_round_active = true
	if word_input:
		word_input.set_enabled(true)

	if player:
		player.reset_round()
	if enemy:
		enemy.reset_round()

	if battle_ui:
		battle_ui.update_word_progress(0, 0)
		battle_ui.set_user_word("")
		battle_ui.set_enemy_word("")
		battle_ui.set_clue("Memuat petunjuk...")

	# Ambil kata acak — sinyal word_selected akan memanggil _on_word_selected
	if word_manager:
		word_manager.get_random_word(max_word_difficulty)

	# Mulai timer ronde
	if battle_timer and battle_timer.has_method("start_round"):
		battle_timer.start_round(round_duration)

	# Mulai AI musuh
	if enemy:
		enemy.start_typing()


func _on_word_selected(word_data: Dictionary) -> void:
	if clue_manager:
		clue_manager.set_word_data(word_data)

	if battle_ui:
		var clue_text := str(word_data.get("clue", "???"))
		var word_len := str(word_data.get("word", "")).length()
		battle_ui.set_clue(clue_text + "\n[%d huruf]" % word_len)


func _on_player_word_completed(word_data: Dictionary) -> void:
	if not _battle_active or not _round_active:
		return
	if player:
		player.add_word(1)
	if AudioManager:
		AudioManager.play_sfx("word_correct")
	if battle_ui:
		battle_ui.set_user_word(str(word_data.get("word", "")), "ok")

	# Ambil kata baru setelah jawaban benar
	if word_manager:
		word_manager.get_random_word(max_word_difficulty)


func _on_word_failed(submitted: String) -> void:
	if battle_ui:
		battle_ui.set_user_word(submitted.to_upper(), "bad")
	# Feedback salah sudah ditangani di WordInput._show_feedback
	if AudioManager:
		AudioManager.play_sfx("word_wrong")


func _on_word_count_changed(_count: int) -> void:
	if battle_ui and player and enemy:
		battle_ui.update_word_progress(player.word_count, enemy.word_count)


func _on_timer_second_ticked(seconds_left: int) -> void:
	if battle_ui:
		battle_ui.update_timer(seconds_left)


func _on_round_ended() -> void:
	if not _battle_active:
		return

	_round_active = false
	if word_input:
		word_input.set_enabled(false)

	if enemy:
		enemy.stop_typing()

	# Evaluasi pemenang ronde dan berikan damage
	if combat_manager and player and enemy:
		var result: Dictionary = combat_manager.resolve_round(player, enemy)
		var winner: String = result.get("winner", "draw")
		var damage: int = result.get("damage", 0)

		# Tampilkan hasil ronde di UI
		if battle_ui:
			_show_round_result(winner, damage)

		print("Round ended → winner: %s | damage: %d" % [winner, damage])

	# Cek apakah pertarungan selesai
	if player and enemy:
		if player.current_hp <= 0 or enemy.current_hp <= 0:
			return  # Salah satu sudah defeated, tunggu signal defeated

	# Lanjut ronde baru setelah jeda singkat
	get_tree().create_timer(2.0, false).timeout.connect(start_new_round)


func _show_round_result(winner: String, damage: int) -> void:
	if battle_ui == null:
		return
	var msg: String
	match winner:
		"player":
			msg = "Kamu menang ronde ini!\n-%d HP musuh" % damage
		"enemy":
			msg = "Musuh menang ronde ini!\n-%d HP kamu" % damage
		_:
			msg = "SERI! Tidak ada damage."
	battle_ui.set_clue(msg)


func _on_player_defeated() -> void:
	if not _battle_active:
		return
	_battle_active = false
	_round_active = false
	if word_input:
		word_input.set_enabled(false)

	if enemy:
		enemy.stop_typing()
	if battle_timer and battle_timer.has_method("stop_round"):
		battle_timer.stop_round()

	if battle_ui:
		battle_ui.set_clue("Kamu kalah...")
	AudioManager.play_bgm("defeat", false)

	print("Battle: Player Kalah!")
	# Beri jeda sebelum pindah scene
	get_tree().create_timer(1.5, false).timeout.connect(func(): battle_lost.emit())


func _on_enemy_defeated() -> void:
	if not _battle_active:
		return
	_battle_active = false
	_round_active = false
	if word_input:
		word_input.set_enabled(false)

	if battle_timer and battle_timer.has_method("stop_round"):
		battle_timer.stop_round()

	if player:
		player.play_win()
	if battle_ui:
		battle_ui.set_clue("Musuh dikalahkan!")
	AudioManager.play_bgm("win", false)

	print("Battle: Player Menang!")
	get_tree().create_timer(1.5, false).timeout.connect(func(): battle_won.emit())
