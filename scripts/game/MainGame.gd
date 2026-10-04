extends Node
class_name MainGame

const BATTLE_SCENE_PATH    := "res://scenes/game/Battle.tscn"
const STAGE_CLEAR_SCENE    := "res://scenes/menus/StageClear.tscn"
const GAME_OVER_SCENE      := "res://scenes/menus/GameOver.tscn"
const MAIN_MENU_SCENE      := "res://scenes/menus/MainMenu.tscn"

@onready var stage_manager: StageManager = $StageManager if has_node("StageManager") else null
@onready var overlay_layer: CanvasLayer  = $OverlayMenuLayer if has_node("OverlayMenuLayer") else null

var current_battle_node: Node2D = null
var current_stage_index: int = 0


func _ready() -> void:
	if stage_manager == null:
		stage_manager = StageManager.new()
		stage_manager.name = "StageManager"
		add_child(stage_manager)

	# Ambil stage index dari GameManager jika ada
	if GameManager and "current_stage_index" in GameManager:
		current_stage_index = GameManager.current_stage_index

	start_stage(current_stage_index)


func start_stage(stage_index: int) -> void:
	var stage_data: Dictionary = stage_manager.load_stage_by_index(stage_index)
	if stage_data.is_empty():
		push_warning("MainGame: Stage data kosong untuk index %d" % stage_index)
		return
	load_battle_scene(stage_data)


func load_battle_scene(stage_data: Dictionary) -> void:
	# Bersihkan battle sebelumnya jika ada
	if current_battle_node:
		current_battle_node.queue_free()
		current_battle_node = null

	var battle_packed := load(BATTLE_SCENE_PATH) as PackedScene
	if battle_packed == null:
		push_error("MainGame: Gagal load Battle.tscn")
		return

	current_battle_node = battle_packed.instantiate() as Node2D
	add_child(current_battle_node)

	# Konfigurasikan enemy berdasarkan data stage
	var enemy_id: String = str(stage_data.get("enemy_id", "enemy_01"))
	var word_diff: int   = int(stage_data.get("word_difficulty", 1))
	var enemy_node       = current_battle_node.get_node_or_null("Enemy") as Enemy

	if enemy_node:
		enemy_node.load_enemy_data(enemy_id)

	# Set round_duration sesuai stage (opsional, default 15 detik)
	if "round_duration" in current_battle_node:
		current_battle_node.round_duration = 15.0

	# Simpan stage info ke GameManager
	if GameManager and "current_stage_index" in GameManager:
		GameManager.current_stage_index = current_stage_index

	# Connect signals pertempuran
	if current_battle_node.has_signal("battle_won"):
		current_battle_node.battle_won.connect(_on_battle_won)
	if current_battle_node.has_signal("battle_lost"):
		current_battle_node.battle_lost.connect(_on_battle_lost)


func _on_battle_won() -> void:
	if AudioManager:
		AudioManager.play_sfx("stage_clear")

	var next_stage_data: Dictionary = stage_manager.next_stage()

	if not next_stage_data.is_empty():
		# Ada stage berikutnya — tampilkan StageClear overlay, lalu lanjut
		current_stage_index += 1
		_show_overlay(STAGE_CLEAR_SCENE)
	else:
		# Semua stage selesai
		print("MainGame: Semua stage selesai! TAMAT!")
		_show_overlay(STAGE_CLEAR_SCENE)


func _on_battle_lost() -> void:
	if AudioManager:
		AudioManager.play_sfx("game_over")
	_change_scene(GAME_OVER_SCENE)


## Tampilkan scene sebagai overlay di CanvasLayer (tidak menghapus battle di bawah)
func _show_overlay(scene_path: String) -> void:
	if overlay_layer == null:
		# Fallback: ganti scene langsung
		_change_scene(scene_path)
		return

	# Bersihkan overlay lama
	for child in overlay_layer.get_children():
		child.queue_free()

	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_error("MainGame: Gagal load overlay scene: " + scene_path)
		_change_scene(scene_path)
		return

	var overlay := packed.instantiate()
	overlay_layer.add_child(overlay)


func _change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
