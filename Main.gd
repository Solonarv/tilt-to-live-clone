extends Node


export (PackedScene) var enemy_scene
export var safe_zone = 100
var score
var viewport


func _ready():
	randomize()
	viewport = get_node("/root")


func game_over():
	$ScoreCounter.stop()
	$MobSpawner.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$Player.start($PlayerStartPosition.position)
	get_tree().call_group("enemies", "queue_free")
	start_timers()
	$HUD.update_score(score)
	# $HUD.show_message("Get Ready")

func start_timers():
	$MobSpawner.start()
	$ScoreCounter.start()

func _on_MobSpawner_timeout():
	var enemy = enemy_scene.instance()
	var spawn_location
	while true:
		spawn_location = Vector2(rand_range(0, viewport.size.x), rand_range(0, viewport.size.y))
		if (spawn_location - $Player.position).length() > safe_zone:
			break
	enemy.position = spawn_location
	enemy.start($Player)
	add_child(enemy)


func _on_ScoreCounter_timeout():
	score += 1
	$HUD.update_score(score)
