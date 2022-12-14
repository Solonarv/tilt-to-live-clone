extends Node


export (PackedScene) var enemy_scene
export (PackedScene) var powerup_scene
export (PackedScene) var cross_scene
export var safe_zone = 100
export var base_powerup_chance = 0.02
export var cross_chance = 0.05

var powerup_chance
var score
var viewport


func _ready():
	randomize()
	viewport = get_node("/root")
	powerup_chance = base_powerup_chance


func game_over():
	$MobSpawner.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$Player.start($PlayerStartPosition.position)
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	start_timers()
	$HUD.update_score(score)
	# $HUD.show_message("Get Ready")

func start_timers():
	$MobSpawner.start()

func gen_spawn_location(safe_zone_multiplier = 1):
	var spawn_location
	while true:
		spawn_location = Vector2(rand_range(0, viewport.size.x), rand_range(0, viewport.size.y))
		if (spawn_location - $Player.position).length() > safe_zone:
			break
	return spawn_location

func _on_MobSpawner_timeout():
	var enemy = enemy_scene.instance()
	enemy.position = gen_spawn_location()
	enemy.start($Player)
	add_child(enemy)
	
	if randf() < powerup_chance:
		var powerup = powerup_scene.instance()
		powerup.position = gen_spawn_location()
		add_child(powerup)
		powerup_chance = base_powerup_chance
	else:
		powerup_chance += base_powerup_chance
		
	if randf() < cross_chance:
		var cross = cross_scene.instance()
		cross.position = gen_spawn_location(5)
		cross.start($Player)
		add_child(cross)


func _on_Player_score():
	score += 1
	$HUD.update_score(score)
