class_name Formation
extends Node2D


enum SHAPES {
	CROSS,
	COLLAPSING_CIRCLE
}


@export var enemy_scene: PackedScene


var target: Player
var velocity := Vector2.ZERO
var angular_velocity := 0.0
var children : Array[Enemy] = []
var radius := 0.0
var shrink_speed := 0.0
var shape: SHAPES


func _ready() -> void:
	randomize()
	shape = randi_range(0, SHAPES.size())


func _physics_process(delta: float) -> void:
	position += velocity * delta
	rotation += angular_velocity * delta
	if shrink_speed != null and radius > 20*shrink_speed:
		for child in children:
			if is_instance_valid(child):
				var move = child.position.limit_length(shrink_speed*delta)
				child.position -= move
		radius += shrink_speed
	if !get_viewport_rect().grow(radius).has_point(position):
		queue_free()


func begin(player: Player) -> void:
	target = player
	# print_debug(shape)
	populate()
	match shape:
		SHAPES.CROSS:
			var direction = Vector2(1,0).rotated(randf_range(0, 2*PI))
			velocity = direction * randf_range(0.7, 1.4) * 50
			angular_velocity = randf_range(-PI, PI) * 0.5
			position = get_parent().gen_spawn_location(radius)
		SHAPES.COLLAPSING_CIRCLE:
			var direction = Vector2(1,0).rotated(randf_range(0, 2*PI))
			velocity = direction * randf_range(0.7, 1.4) * 20
			angular_velocity = randf_range(-PI, PI) * 0.1
			position = target.position
			shrink_speed = 10


func populate() -> void:
	match shape:
		SHAPES.CROSS:
			make_rect(5, 5, Vector2(-2, -2))
			make_rect(5, 5, Vector2(3, -2))
			make_rect(5, 5, Vector2(-7, -2))
			make_rect(5, 5, Vector2(-2, 3))
			make_rect(5, 5, Vector2(-2, -7))
		SHAPES.COLLAPSING_CIRCLE:
			for i in range(0, 50):
				var direction = Vector2(1,0).rotated(2*PI*i/50)
				add_child_at(direction * 320)
				add_child_at(direction * 328)
			

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
