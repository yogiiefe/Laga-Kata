extends Node2D
class_name Player

## Signal dipancarkan ketika HP pemain berubah
signal hp_changed(current_hp: int, max_hp: int)
## Signal dipancarkan ketika jumlah kata pemain bertambah
signal word_count_changed(new_count: int)
## Signal dipancarkan ketika HP pemain mencapai 0
signal player_defeated()

@export var max_hp: int = 100

var current_hp: int = 100
var word_count: int = 0
var last_word_time: float = 0.0
var state: String = "idle"

# Paths ke assets character
const SPRITE_IDLE    := "res://assets/graphics/characters/user/user.idle.animation.svg"
const SPRITE_TYPING  := "res://assets/graphics/characters/user/user.typing.animation.svg"
const SPRITE_DEFEAT  := "res://assets/graphics/characters/user/user.defeat.animation.svg"
const SPRITE_WIN     := "res://assets/graphics/characters/user/user.win.animation.svg"

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null


func _ready() -> void:
	current_hp = max_hp
	word_count = 0
	last_word_time = 0.0
	_load_sprite(SPRITE_IDLE)
	call_deferred("_emit_initial_hp")


func _emit_initial_hp() -> void:
	hp_changed.emit(current_hp, max_hp)


func _load_sprite(path: String) -> void:
	if sprite == null:
		return
	if ResourceLoader.exists(path):
		sprite.texture = load(path)


## Mengurangi HP pemain
func take_damage(amount: int) -> void:
	if current_hp <= 0:
		return
	current_hp = max(0, current_hp - amount)
	hp_changed.emit(current_hp, max_hp)
	if AudioManager:
		AudioManager.play_sfx("player_hurt")
	if current_hp <= 0:
		state = "defeated"
		_load_sprite(SPRITE_DEFEAT)
		player_defeated.emit()
	else:
		state = "hurt"
		# Flash merah lalu kembali idle
		get_tree().create_timer(0.5).timeout.connect(func():
			if state == "hurt":
				state = "idle"
				_load_sprite(SPRITE_IDLE)
		)


## Menyembuhkan HP pemain
func heal(amount: int) -> void:
	if current_hp <= 0:
		return
	current_hp = min(max_hp, current_hp + amount)
	hp_changed.emit(current_hp, max_hp)


## Tambah kata dan rekam waktu
func add_word(amount: int = 1) -> void:
	word_count += amount
	last_word_time = Time.get_ticks_msec() / 1000.0
	word_count_changed.emit(word_count)
	# Tampilkan animasi typing
	_load_sprite(SPRITE_TYPING)
	get_tree().create_timer(0.6).timeout.connect(func():
		if state == "idle" or state == "typing":
			_load_sprite(SPRITE_IDLE)
	)


## Reset word count untuk ronde baru
func reset_round() -> void:
	word_count = 0
	last_word_time = 0.0
	word_count_changed.emit(word_count)


## Reset penuh (restart battle)
func reset_full() -> void:
	current_hp = max_hp
	word_count = 0
	last_word_time = 0.0
	state = "idle"
	_load_sprite(SPRITE_IDLE)
	hp_changed.emit(current_hp, max_hp)
	word_count_changed.emit(word_count)


## Set state menang
func play_win() -> void:
	state = "win"
	_load_sprite(SPRITE_WIN)


func play_animation(anim_name: String) -> void:
	match anim_name:
		"idle":    _load_sprite(SPRITE_IDLE)
		"typing":  _load_sprite(SPRITE_TYPING)
		"defeat":  _load_sprite(SPRITE_DEFEAT)
		"win":     _load_sprite(SPRITE_WIN)
		"hurt":    pass  # Handled via take_damage
