extends Node
class_name CombatManager

signal round_resolved(winner: String, attacker: Node, defender: Node, damage: int, is_tie_breaker: bool)

@export var base_damage: int = 5


## Mengkalkulasi dan menerapkan damage dari ronde pertempuran kata
func resolve_round(player: Player, enemy: Enemy) -> Dictionary:
	if player == null or enemy == null:
		push_error("CombatManager: Player atau Enemy null!")
		return {}

	var player_words: int = player.word_count
	var enemy_words: int = enemy.word_count

	var winner: String = "" # "player", "enemy", atau "draw"
	var attacker: Node = null
	var defender: Node = null
	var is_tie_breaker: bool = false

	if player_words > enemy_words:
		winner = "player"
		attacker = player
		defender = enemy
	elif enemy_words > player_words:
		winner = "enemy"
		attacker = enemy
		defender = player
	else:
		# TIE-BREAKER: Siapa yang paling terakhir berhasil mengetik kata
		is_tie_breaker = true
		if player.last_word_time > enemy.last_word_time:
			winner = "player"
			attacker = player
			defender = enemy
		elif enemy.last_word_time > player.last_word_time:
			winner = "enemy"
			attacker = enemy
			defender = player
		else:
			# Keduanya tidak menjawab sama sekali
			winner = "draw"

	var damage_dealt: int = 0
	if winner != "draw" and attacker != null and defender != null:
		var word_diff: int = abs(player_words - enemy_words)
		var attacker_damage: int = base_damage
		if "damage" in attacker:
			attacker_damage = int(attacker.damage)

		damage_dealt = attacker_damage + word_diff

		# Terapkan damage ke pihak yang kalah
		defender.take_damage(damage_dealt)

	var result := {
		"winner": winner,
		"attacker": attacker,
		"defender": defender,
		"damage": damage_dealt,
		"player_words": player_words,
		"enemy_words": enemy_words,
		"is_tie_breaker": is_tie_breaker
	}

	round_resolved.emit(winner, attacker, defender, damage_dealt, is_tie_breaker)
	return result
