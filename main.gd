extends Node

class_name Main


@export var score_multiplier_scale := 0.2

var score: int = 0
var recent_kill_count: int = 0

@onready var viewport: Viewport = $"/root"
@onready var player: Player = $Player
@onready var input_handler: InputHandler = $HUD/InputHandler
@onready var hud: HUD = $HUD
@onready var mob_spawner: Timer = $EnemySpawner
@onready var multiplier_grace_period: Timer = $MultiplierGracePeriod


func _ready():
	randomize()
	StateManager.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
	player.set_input_handler(input_handler)
	mob_spawner.extent = viewport.size


func _unhandled_input(event):
	$HUD/InputHandler.on_input(event)


func game_over():
	StateManager.die()


func new_game():
	score = 0
	player.start($PlayerStartPosition.position)
	get_tree().call_group(&"game_objects", "queue_free")
	start_timers()
	_show_score()
	

func start_timers():
	mob_spawner.start()



func _on_player_scored() -> void:
	multiplier_grace_period.start()
	score += floori(_get_effective_multiplier())
	recent_kill_count += 1
	_show_score()


func _on_multiplier_grace_period_timeout() -> void:
	recent_kill_count = 0
	_show_score()


func _on_game_state_changed(old: StateManager.STATE, new) -> void:
	if old == StateManager.STATE.MENU and new == StateManager.STATE.PLAYING:
		new_game()


func _get_effective_multiplier() -> float:
	return 1 + sqrt(recent_kill_count) * score_multiplier_scale


func _show_score() -> void:
	hud.update_score(score, _get_effective_multiplier())
