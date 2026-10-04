extends Control
class_name HealthBar

@export var progress_bar_path: NodePath
@export var hp_label_path: NodePath
@export var animate_smooth: bool = true
@export var tween_duration: float = 0.35

var progress_bar: Range # Menerima TextureProgressBar atau ProgressBar
var hp_label: Label
var current_tween: Tween


func _ready() -> void:
	_resolve_node_references()


func _resolve_node_references() -> void:
	if progress_bar == null:
		if not progress_bar_path.is_empty():
			progress_bar = get_node_or_null(progress_bar_path) as Range
		elif has_node("TextureProgressBar"):
			progress_bar = get_node("TextureProgressBar") as Range
		elif has_node("ProgressBar"):
			progress_bar = get_node("ProgressBar") as Range

	if hp_label == null:
		if not hp_label_path.is_empty():
			hp_label = get_node_or_null(hp_label_path) as Label
		elif has_node("Label"):
			hp_label = get_node("Label") as Label
		elif has_node("HPLabel"):
			hp_label = get_node("HPLabel") as Label


## Mengikat HealthBar ke entitas (Player/Enemy) dan mendengarkan signal hp_changed
func bind_entity(entity: Node) -> void:
	if entity == null:
		push_warning("HealthBar: Entitas null!")
		return

	if entity.has_signal("hp_changed"):
		if not entity.hp_changed.is_connected(update_health):
			entity.hp_changed.connect(update_health)

	# Inisialisasi awal jika entitas mempunyai current_hp dan max_hp
	if "current_hp" in entity and "max_hp" in entity:
		setup(entity.max_hp, entity.current_hp)


## Mengatur nilai awal HP (Max dan Current)
func setup(max_hp: int, current_hp: int) -> void:
	_resolve_node_references()

	if progress_bar:
		progress_bar.max_value = max_hp
		progress_bar.value = current_hp

	_update_label(current_hp, max_hp)


## Meng-update nilai HealthBar (terhubung dengan signal hp_changed)
func update_health(current_hp: int, max_hp: int) -> void:
	_resolve_node_references()

	if progress_bar:
		progress_bar.max_value = max_hp

		if animate_smooth and is_inside_tree():
			if current_tween and current_tween.is_running():
				current_tween.kill()

			current_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			current_tween.tween_property(progress_bar, "value", float(current_hp), tween_duration)
		else:
			progress_bar.value = current_hp

	_update_label(current_hp, max_hp)


func _update_label(current_hp: int, max_hp: int) -> void:
	if hp_label:
		hp_label.text = "%d / %d" % [current_hp, max_hp]
