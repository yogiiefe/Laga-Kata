extends Node
class_name BattleTimer

signal second_ticked(seconds_left: int)
signal round_ended()

@export var default_round_duration: float = 15.0

var time_left: float = 0.0
var is_running: bool = false
var internal_timer: Timer


func _ready() -> void:
	_setup_internal_timer()


func _setup_internal_timer() -> void:
	if has_node("Timer"):
		internal_timer = get_node("Timer") as Timer
	else:
		internal_timer = Timer.new()
		internal_timer.name = "Timer"
		add_child(internal_timer)

	internal_timer.wait_time = 1.0
	internal_timer.one_shot = false
	if not internal_timer.timeout.is_connected(_on_timer_timeout):
		internal_timer.timeout.connect(_on_timer_timeout)


func start_round(duration: float = -1.0) -> void:
	if duration <= 0:
		duration = default_round_duration

	time_left = duration
	is_running = true
	second_ticked.emit(int(ceil(time_left)))

	if internal_timer:
		internal_timer.start()


func stop_round() -> void:
	is_running = false
	if internal_timer and not internal_timer.is_stopped():
		internal_timer.stop()


func pause_round() -> void:
	is_running = false
	if internal_timer:
		internal_timer.stop()


func resume_round() -> void:
	if time_left > 0:
		is_running = true
		if internal_timer:
			internal_timer.start()


func _on_timer_timeout() -> void:
	if not is_running:
		return

	time_left -= 1.0
	var seconds_int: int = max(0, int(ceil(time_left)))
	second_ticked.emit(seconds_int)

	if time_left <= 0:
		stop_round()
		round_ended.emit()
