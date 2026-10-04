extends Node
class_name StageManager

signal stage_loaded(stage_data: Dictionary)
signal stage_completed(stage_id: int)
signal all_stages_cleared()

const STAGES_DATA_PATH := "res://data/stages.json"

var stages: Array = []
var current_stage_index: int = 0
var current_stage_data: Dictionary = {}


func _ready() -> void:
	load_stages()


func load_stages() -> bool:
	if not FileAccess.file_exists(STAGES_DATA_PATH):
		push_error("StageManager: File tidak ditemukan: " + STAGES_DATA_PATH)
		return false

	var file := FileAccess.open(STAGES_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("StageManager: Gagal membuka file " + STAGES_DATA_PATH)
		return false

	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	file.close()

	if parse_result != OK:
		push_error("StageManager: Gagal parse JSON " + STAGES_DATA_PATH)
		return false

	var data = json.data
	if not data is Dictionary or not data.has("stages"):
		push_error("StageManager: Key 'stages' tidak ditemukan di JSON")
		return false

	stages = data["stages"]
	print("StageManager: Loaded ", stages.size(), " stages.")
	return true


func load_stage_by_index(index: int) -> Dictionary:
	if stages.is_empty():
		load_stages()

	if index < 0 or index >= stages.size():
		push_warning("StageManager: Index stage di luar jangkauan: ", index)
		return {}

	current_stage_index = index
	current_stage_data = stages[index]
	stage_loaded.emit(current_stage_data)
	return current_stage_data


func load_stage_by_id(stage_id: int) -> Dictionary:
	if stages.is_empty():
		load_stages()

	for i in range(stages.size()):
		var item = stages[i]
		if item is Dictionary and int(item.get("id", 0)) == stage_id:
			return load_stage_by_index(i)

	return {}


func next_stage() -> Dictionary:
	var next_idx = current_stage_index + 1
	if next_idx < stages.size():
		return load_stage_by_index(next_idx)
	else:
		all_stages_cleared.emit()
		return {}


func get_current_stage() -> Dictionary:
	if current_stage_data.is_empty() and not stages.is_empty():
		return load_stage_by_index(0)
	return current_stage_data
