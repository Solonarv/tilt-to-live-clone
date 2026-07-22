class_name Formation
extends Node2D

var target: Player
var velocity := Vector2.ZERO
var angular_velocity := 0.0
var children : Array[Enemy] = []
var radius := 0.0
var shrink_speed := 0.0

var enemy_scene: PackedScene
var spawner: EnemySpawner


func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	position += velocity * delta
	rotation += angular_velocity * delta
	if !get_viewport_rect().grow(radius).has_point(position):
		queue_free()


func begin(spawner: EnemySpawner, enemy_scene: PackedScene, player: Player) -> void:
	target = player
	self.enemy_scene = enemy_scene
	self.spawner = spawner
	# print_debug(shape)
	#if (not self.is_mirror
	#	and (shape==SHAPES.SWEEPER_H or shape == SHAPES.SWEEPER_V)
	#	and randf_range(0,1)<mirror_chance):
	#	var copy: Formation = self.duplicate()
	#	copy.is_mirror = true
	#	copy.shape = shape
	#	get_parent().add_child(copy)
	#	copy.begin(spawner, enemy_scene, target)
	populate()


func populate() -> void:
	assert(false, "populate() must be overridden!")
			

func make_rect(width: int, height: int, offset: Vector2) -> void:
	for x in range(width):
		for y in range(height):
			var pos = offset + Vector2(x, y)
			add_child_at(pos * 8)


func add_child_at(pos: Vector2) -> Enemy:
	var enemy : Enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemy.in_formation = true
	children.append(enemy)
	add_child(enemy)
	enemy.start(target)
	radius = max(radius, pos.length())
	return enemy
