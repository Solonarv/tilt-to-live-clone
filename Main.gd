extends Node

class_name Main

@export var enemy_scene: PackedScene
@export var powerup_scene: PackedScene
@export var formation_scene: PackedScene
@export var enemy_safe_zone := 100.0
@export var base_powerup_chance := 0.02
@export var cross_chance := 0.05
@export var score_multiplier_scale := 0.2

var score: int = 0
var recent_kill_count: int = 0

@onready var powerup_chance := base_powerup_chance
@onready var viewport: Viewport = $"/root"
@onready var player: Player = $Player
@onready var input_handler: InputHandler = $HUD/InputHandler
@onready var hud: HUD = $HUD
@onready var mob_spawner: Timer = $MobSpawner
@onready var multiplier_grace_period: Timer = $MultiplierGracePeriod


func _ready():
	randomize()
	StateManager.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
	player.set_input_handler(input_handler)


func _unhandled_input(event):
	$HUD/InputHandler.on_input(event)


func game_over():
	StateManager.die()


func new_game():
	score = 0
	player.start($PlayerStartPosition.position)
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	start_timers()
	_show_score()
	

func start_timers():
	mob_spawner.start()


func gen_spawn_location(extra_safe_zone: float = 0) -> Vector2:
	var safe_zone = enemy_safe_zone + extra_safe_zone
	var spawn_location
	while true:
		spawn_location = Vector2(randf_range(0, viewport.size.x), randf_range(0, viewport.size.y))
		if (spawn_location - $Player.position).length() > safe_zone:
			break
	return spawn_location


func _on_mob_spawner_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.position = gen_spawn_location()
	enemy.start(player)
	add_child(enemy)
	
	if randf() < powerup_chance:
		var powerup: Powerup = powerup_scene.instantiate()
		powerup.position = gen_spawn_location()
		add_child(powerup)
		powerup_chance = base_powerup_chance
	else:
		powerup_chance += base_powerup_chance
		
	if randf() < cross_chance:
		var formation: Formation = formation_scene.instantiate()
		add_child(formation)
		formation.begin(player)


func _on_player_scored() -> void:
	multiplier_grace_period.start()
	score += _get_effective_multiplier()
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
