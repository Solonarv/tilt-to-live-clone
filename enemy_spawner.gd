class_name EnemySpawner
extends Timer

@export var enemy_scene: PackedScene
@export var powerup_scene: PackedScene
@export var formations: Array[PackedScene]
@export var formation_weights: Array[float]
@export var enemy_safe_zone := 100.0
@export var base_powerup_chance := 0.02
@export var powerup_littering_penalty := 4.0
@export var cross_chance := 0.05

@onready var powerup_chance := base_powerup_chance
@onready var parent: Main = get_parent()
var extent: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(formations.size() == formation_weights.size(),
		"Formation and formation_weights array must be the same size!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gen_spawn_location(extra_safe_zone: float = 0) -> Vector2:
	var safe_zone = enemy_safe_zone + extra_safe_zone
	var spawn_location
	while true:
		spawn_location = Vector2(randf_range(0, extent.x), randf_range(0, extent.y))
		if (spawn_location - parent.player.position).length() > safe_zone:
			break
	return spawn_location



func get_edge_center(direction: Vector2) -> Vector2:
	var x:=0.0
	var y:=0.0
	if abs(direction.x) > abs(direction.y):
		x = extent.x if direction.x>0 else 0
		y = extent.y/2
	else:
		x = extent.x/2
		y = extent.y if direction.y>0 else 0
	return Vector2(x,y)


func _on_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.position = gen_spawn_location()
	enemy.start(parent.player)
	parent.add_child(enemy)
	
	if randf() < powerup_chance:
		var total_powerups: float = get_tree().get_node_count_in_group(&"powerups")
		if randf() < pow(0.5, total_powerups/powerup_littering_penalty):
			var powerup: Powerup = powerup_scene.instantiate()
			powerup.position = gen_spawn_location()
			parent.add_child(powerup)
		powerup_chance = base_powerup_chance
	else:
		powerup_chance += base_powerup_chance
		
	if randf() < cross_chance:
		var total_weight: float = formation_weights.reduce(func(x,y):return x+y)
		var roll := randf_range(0, total_weight)
		var weight_sofar := 0.0
		var formation_scene: PackedScene = null
		for i in range(0, formations.size()):
			weight_sofar += formation_weights[i]
			if roll <= weight_sofar:
				formation_scene = formations[i]
				break
		var formation: Formation = formation_scene.instantiate()
		parent.add_child(formation)
		formation.begin(self, enemy_scene, parent.player)
