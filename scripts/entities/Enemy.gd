extends Node2D
class_name Enemy

## Signal dipancarkan ketika HP musuh berubah
signal hp_changed(current_hp: int, max_hp: int)
## Signal dipancarkan ketika jumlah kata musuh bertambah
signal word_count_changed(new_count: int)
## Signal dipancarkan setiap kali AI musuh berhasil "mengetik" 1 kata
signal word_typed()
## Signal dipancarkan ketika HP musuh mencapai 0
signal enemy_defeated()

const ENEMIES_DATA_PATH := "res://data/enemies.json"

@export var enemy_id: String = "enemy_01"
@export var auto_load_data: bool = true

var max_hp: int = 50
var current_hp: int = 50
var word_count: int = 0
var last_word_time: float = 0.0 # Timestamp tie-breaker (dalam detik)
var typing_cooldown: float = 5.0 # Jeda ketik per kata dalam detik (diambil dari word_speed)
var damage: int = 5
var enemy_name: String = "Musuh"
var special_ability: String = "none"
var enemy_data: Dictionary = {}

var state: String = "idle" # "idle", "typing", "attack", "hurt", "defeated"

var typing_timer: Timer
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var anim_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null


func _ready() -> void:
	_setup_typing_timer()
	if auto_load_data:
		load_enemy_data(enemy_id)
	else:
		current_hp = max_hp
		
	call_deferred("_emit_initial_hp")


func _setup_typing_timer() -> void:
	if has_node("TypingTimer"):
		typing_timer = get_node("TypingTimer") as Timer
	elif has_node("Timer"):
		typing_timer = get_node("Timer") as Timer
	else:
		typing_timer = Timer.new()
		typing_timer.name = "TypingTimer"
		add_child(typing_timer)

	if not typing_timer.timeout.is_connected(_on_typing_timer_timeout):
		typing_timer.timeout.connect(_on_typing_timer_timeout)


func _emit_initial_hp() -> void:
	hp_changed.emit(current_hp, max_hp)


## Memuat data musuh dari res://data/enemies.json berdasarkan ID
func load_enemy_data(id: String) -> bool:
	enemy_id = id
	if not FileAccess.file_exists(ENEMIES_DATA_PATH):
		push_error("Enemy: File JSON tidak ditemukan: " + ENEMIES_DATA_PATH)
		return false

	var file := FileAccess.open(ENEMIES_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Enemy: Gagal membaca file: " + ENEMIES_DATA_PATH)
		return false

	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	file.close()

	if parse_result != OK:
		push_error("Enemy: Gagal parse JSON enemies.json")
		return false

	var data = json.data
	if not data is Dictionary or not data.has("enemies"):
		push_error("Enemy: Struktur JSON enemies.json tidak valid")
		return false

	var found_data: Dictionary = {}
	for item in data["enemies"]:
		if item is Dictionary and item.get("id", "") == id:
			found_data = item
			break

	if found_data.is_empty():
		push_warning("Enemy: ID " + id + " tidak ditemukan di enemies.json!")
		return false

	apply_enemy_data(found_data)
	return true


## Menerapkan Dictionary data musuh ke properti entitas
func apply_enemy_data(data: Dictionary) -> void:
	enemy_data = data
	enemy_name = str(data.get("name", "Musuh"))
	max_hp = int(data.get("hp", 50))
	current_hp = max_hp
	damage = int(data.get("damage", 5))
	special_ability = str(data.get("special", "none"))

	var sprite_path := str(data.get("sprite", ""))
	if sprite and not sprite_path.is_empty() and ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)

	# word_speed dari JSON menyatakan jeda detik per kata (contoh: 8.0, 6.5, 5.0)
	# Support typing_cooldown atau word_speed
	typing_cooldown = float(data.get("typing_cooldown", data.get("word_speed", 5.0)))
	if typing_cooldown <= 0:
		typing_cooldown = 5.0

	if typing_timer:
		typing_timer.wait_time = typing_cooldown

	word_count = 0
	last_word_time = 0.0
	hp_changed.emit(current_hp, max_hp)
	word_count_changed.emit(word_count)


## Memulai proses auto-typing AI musuh (Timer berjalan)
func start_typing() -> void:
	if current_hp <= 0:
		return
	state = "typing"
	if typing_timer:
		typing_timer.wait_time = typing_cooldown
		typing_timer.start()


## Menghentikan proses auto-typing AI musuh
func stop_typing() -> void:
	state = "idle"
	if typing_timer and not typing_timer.is_stopped():
		typing_timer.stop()


## Handler otomatis saat typing_timer timeout
func _on_typing_timer_timeout() -> void:
	if current_hp <= 0:
		stop_typing()
		return

	add_word(1)
	word_typed.emit()

	if AudioManager:
		AudioManager.play_sfx("type")


## Menambah word_count musuh dan mencatat timestamp tebakan
func add_word(amount: int = 1) -> void:
	word_count += amount
	last_word_time = Time.get_ticks_msec() / 1000.0
	word_count_changed.emit(word_count)


## Mengurangi HP musuh dan memancarkan signal hp_changed
func take_damage(amount: int) -> void:
	if current_hp <= 0:
		return

	current_hp = max(0, current_hp - amount)
	hp_changed.emit(current_hp, max_hp)

	if AudioManager:
		AudioManager.play_sfx("hit")

	if current_hp <= 0:
		state = "defeated"
		stop_typing()
		play_animation("defeat")
		if AudioManager:
			AudioManager.play_sfx("enemy_defeat")
		enemy_defeated.emit()
	else:
		state = "hurt"
		play_animation("hurt")


## Reset word count untuk ronde baru
func reset_round() -> void:
	word_count = 0
	last_word_time = 0.0
	word_count_changed.emit(word_count)


## Reset status musuh secara penuh
func reset_full() -> void:
	stop_typing()
	current_hp = max_hp
	word_count = 0
	last_word_time = 0.0
	state = "idle"
	play_animation("idle")
	hp_changed.emit(current_hp, max_hp)
	word_count_changed.emit(word_count)


## Memainkan animasi visual musuh jika AnimationPlayer tersedia
func play_animation(anim_name: String) -> void:
	if anim_player and anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
