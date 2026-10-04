extends Node

const BGM_DIR := "res://assets/audio/bgm/"
const SFX_DIR := "res://assets/audio/sfx/"

# Nama logis (dipakai script) -> nama file asli di assets/audio.
# SFX yang belum punya file (type, hit, dll.) cukup dilewati tanpa error.
const BGM_FILES := {
	"menu": "menu.backsound.mp3",
	"battle": "battle.backsound.mp3",
	"win": "battle.win.mp3",
	"defeat": "battle.defeat.mp3",
}
const SFX_FILES := {
	"button_click": "sellect.mp3",
	"type": "sellect.mp3",
	"word_correct": "sellect.mp3",
}

var bgm_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_pool_size: int = 5

var bgm_volume: float = 1.0
var sfx_volume: float = 1.0
var current_bgm: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)

	for i in range(sfx_pool_size):
		var sfx_player := AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_players.append(sfx_player)

	apply_saved_settings()


func apply_saved_settings() -> void:
	var settings: Dictionary = SaveManager.save_data.get("settings", {})
	set_bgm_volume(float(settings.get("bgm_volume", 1.0)))
	set_sfx_volume(float(settings.get("sfx_volume", 1.0)))


func toggle_mute() -> bool:
	var muted := not AudioServer.is_bus_mute(0)
	AudioServer.set_bus_mute(0, muted)
	return muted


func set_bgm_volume(value: float) -> void:
	bgm_volume = clampf(value, 0.0, 1.0)
	if bgm_player:
		bgm_player.volume_db = linear_to_db(maxf(bgm_volume, 0.0001))


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	for player in sfx_players:
		player.volume_db = linear_to_db(maxf(sfx_volume, 0.0001))


func play_bgm(bgm_name: String, loop: bool = true) -> void:
	if not BGM_FILES.has(bgm_name):
		return
	if current_bgm == bgm_name and bgm_player.playing:
		return

	var path: String = BGM_DIR + BGM_FILES[bgm_name]
	var stream := load(path) as AudioStream
	if stream == null:
		push_warning("BGM tidak ditemukan: " + path)
		return
	if stream is AudioStreamMP3:
		stream.loop = loop

	current_bgm = bgm_name
	bgm_player.stream = stream
	bgm_player.play()


func stop_bgm() -> void:
	current_bgm = ""
	bgm_player.stop()


func play_sfx(sfx_name: String) -> void:
	if not SFX_FILES.has(sfx_name):
		return # belum ada file SFX untuk nama ini

	var stream := load(SFX_DIR + SFX_FILES[sfx_name]) as AudioStream
	if stream == null:
		return

	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return

	sfx_players[0].stream = stream
	sfx_players[0].play()
