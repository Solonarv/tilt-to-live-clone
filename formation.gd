class_name Formation
extends Node2D


enum SHAPES {
	CROSS,
	COLLAPSING_CIRCLE,
	SWEEPER_H,
	SWEEPER_V
}


@export var enemy_scene: PackedScene

@export var mirror_chance := 0.1

var target: Player
var velocity := Vector2.ZERO
var angular_velocity := 0.0
var children : Array[Enemy] = []
var radius := 0.0
var shrink_speed := 0.0
var shape: SHAPES
var is_mirror := false


func _ready() -> void:
	if !is_mirror:
		randomize()
		shape = SHAPES.SWEEPER_H


func _physics_process(delta: float) -> void:
	position += velocity * delta
	rotation += angular_velocity * delta
	if shrink_speed != null and radius > 32:
		for child in children:
			if is_instance_valid(child):
				var move = child.position.limit_length(shrink_speed*delta)
				child.position -= move
		radius -= shrink_speed*delta
	if !get_viewport_rect().grow(radius).has_point(position):
		queue_free()


func begin(player: Player) -> void:
	target = player
	# print_debug(shape)
	if (not self.is_mirror
		and (shape==SHAPES.SWEEPER_H or shape == SHAPES.SWEEPER_V)
		and randf_range(0,1)<mirror_chance):
		var copy: Formation = self.duplicate()
		copy.is_mirror = true
		copy.shape = shape
		get_parent().add_child(copy)
		copy.begin(target)
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
			shrink_speed = 4**randf_range(0, 1) * 10
		SHAPES.SWEEPER_H:
			var direction: Vector2
			if target.position.x < get_parent().viewport.size.x/2:
				direction = Vector2(1,0)
			else:
				direction = Vector2(-1,0)
			if is_mirror: direction = -direction
			position = get_parent().get_edge_center(direction) - direction*8
			velocity = -direction * 2**randf_range(0,1) * 80
		SHAPES.SWEEPER_V:
			var direction: Vector2
			if target.position.y < get_parent().viewport.size.y/2:
				direction = Vector2(0,1)
			else:
				direction = Vector2(0,-1)
			if is_mirror: direction = -direction
			position = get_parent().get_edge_center(direction) - direction*8
			velocity = -direction * 2**randf_range(0,1) * 80


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
		SHAPES.SWEEPER_H:
			make_rect(2, 90, Vector2(-1, -45))
		SHAPES.SWEEPER_V:
			make_rect(160, 2, Vector2(-80, -1))
			

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
