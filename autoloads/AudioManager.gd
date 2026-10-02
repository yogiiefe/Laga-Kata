extends Node

# Node references
var bgm_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_pool_size: int = 5

func _ready() -> void:
	# Bikin BGM Player dinamis
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music" # Bisa diatur nanti di Audio Server
	add_child(bgm_player)
	
	# Bikin SFX Pool dinamis (agar multiple SFX bisa bunyi bersamaan)
	for i in range(sfx_pool_size):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.bus = "SFX"
		add_child(sfx_player)
		sfx_players.append(sfx_player)

# BGM Functions
func play_bgm(bgm_name: String) -> void:
	var path = "res://assets/audio/bgm/%s.ogg" % bgm_name
	if ResourceLoader.exists(path):
		var stream = load(path)
		# Jangan restart kalau lagu yang sama sudah main
		if bgm_player.stream == stream and bgm_player.playing:
			return
		bgm_player.stream = stream
		bgm_player.play()
	else:
		push_warning("BGM tidak ditemukan: ", path)

func stop_bgm() -> void:
	bgm_player.stop()

# SFX Functions
func play_sfx(sfx_name: String) -> void:
	var path = "res://assets/audio/sfx/%s.ogg" % sfx_name
	if ResourceLoader.exists(path):
		var stream = load(path)
		# Cari player SFX yang sedang nganggur
		for player in sfx_players:
			if not player.playing:
				player.stream = stream
				player.play()
				return
		
		# Kalau semua player penuh, paksa player pertama untuk play SFX baru
		sfx_players[0].stream = stream
		sfx_players[0].play()
	else:
		push_warning("SFX tidak ditemukan: ", path)
