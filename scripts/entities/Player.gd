extends Node2D
class_name Player

## Signal dipancarkan ketika HP pemain berubah
signal hp_changed(current_hp: int, max_hp: int)
## Signal dipancarkan ketika jumlah kata pemain bertambah
signal word_count_changed(new_count: int)
## Signal dipancarkan ketika HP pemain mencapai 0
signal player_defeated()

@export var max_hp: int = 100
## Damage dasar saat pemain memenangkan ronde
@export var damage: int = 12

var current_hp: int = 100
var word_count: int = 0
var last_word_time: float = 0.0
var state: String = "idle"

# Karakter ditampilkan statis: Player.tscn memakai satu frame dari
# user.idle.animation.svg (region Sprite2D). File animasi lain tidak dipakai dulu.
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null


func _ready() -> void:
	current_hp = max_hp
	word_count = 0
	last_word_time = 0.0
	call_deferred("_emit_initial_hp")


func _emit_initial_hp() -> void:
	hp_changed.emit(current_hp, max_hp)


func _flash(color: Color) -> void:
	if sprite == null:
		return
	sprite.modulate = color
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.3)


## Mengurangi HP pemain
func take_damage(amount: int) -> void:
	if current_hp <= 0:
		return
	current_hp = max(0, current_hp - amount)
	hp_changed.emit(current_hp, max_hp)
	AudioManager.play_sfx("player_hurt")
	if current_hp <= 0:
		state = "defeated"
		if sprite:
			sprite.modulate = Color(0.45, 0.45, 0.45)
		player_defeated.emit()
	else:
		state = "idle"
		_flash(Color(1.0, 0.4, 0.4))


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
	if sprite:
		sprite.modulate = Color.WHITE
	hp_changed.emit(current_hp, max_hp)
	word_count_changed.emit(word_count)


## Set state menang
func play_win() -> void:
	state = "win"
	_flash(Color(0.7, 1.0, 0.8))
