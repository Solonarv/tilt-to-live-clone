extends Node

class_name Main

@export var enemy_scene: PackedScene
@export var powerup_scene: PackedScene
@export var formation_scene: PackedScene
@export var enemy_safe_zone = 100
@export var base_powerup_chance = 0.02
@export var cross_chance = 0.05

var powerup_chance
var score
var viewport


func _ready():
	randomize()
	viewport = get_node("/root")
	powerup_chance = base_powerup_chance
	StateManager.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
	$Player.set_input_handler($HUD/InputHandler)


func game_over():
	StateManager.die()


func new_game():
	score = 0
	$Player.start($PlayerStartPosition.position)
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	start_timers()
	$HUD.update_score(score)


func start_timers():
	$MobSpawner.start()


func gen_spawn_location(extra_safe_zone = 0):
	var safe_zone = enemy_safe_zone + extra_safe_zone
	var spawn_location
	while true:
		spawn_location = Vector2(randf_range(0, viewport.size.x), randf_range(0, viewport.size.y))
		if (spawn_location - $Player.position).length() > safe_zone:
			break
	return spawn_location

func _on_MobSpawner_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = gen_spawn_location()
	enemy.start($Player)
	add_child(enemy)
	
	if randf() < powerup_chance:
		var powerup = powerup_scene.instantiate()
		powerup.position = gen_spawn_location()
		add_child(powerup)
		powerup_chance = base_powerup_chance
	else:
		powerup_chance += base_powerup_chance
		
	if randf() < cross_chance:
		var formation = formation_scene.instantiate()
		var shape = formation.shapes[randi()%formation.shapes.size()]
		add_child(formation)
		formation.begin($Player, shape)


func _on_Player_score():
	score += 1
	$HUD.update_score(score)


func _on_game_state_changed(old, new):
	if old == StateManager.STATE_MENU && new == StateManager.STATE_PLAYING:
		new_game()
		



func _unhandled_input(event):
	match StateManager.game_state:
		StateManager.STATE_PLAYING:
			$HUD/InputHandler.on_input(event)
