extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var enemy_scene: PackedScene
var target
var velocity = Vector2()
var angular_velocity = 0
var children = []
var radius = 0
var shrink_speed
var shapes = ["cross", "collapsing-circle"]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func begin(player, shape):
	target = player
	print_debug(shape)
	populate(shape)
	if shape == "cross":
		var direction = Vector2(1,0).rotated(randf_range(0, 2*PI))
		velocity = direction * randf_range(0.7, 1.4) * 50
		angular_velocity = randf_range(-PI, PI) * 0.5
		position = get_parent().gen_spawn_location(radius)
	elif shape == "collapsing-circle":
		var direction = Vector2(1,0).rotated(randf_range(0, 2*PI))
		velocity = direction * randf_range(0.7, 1.4) * 20
		angular_velocity = randf_range(-PI, PI) * 0.1
		position = target.position
		shrink_speed = 10

func populate(shape):
	if shape == "cross":
		make_rect(5, 5, Vector2(-2, -2))
		make_rect(5, 5, Vector2(3, -2))
		make_rect(5, 5, Vector2(-7, -2))
		make_rect(5, 5, Vector2(-2, 3))
		make_rect(5, 5, Vector2(-2, -7))
	if shape == "collapsing-circle":
		for i in range(0, 50):
			var direction = Vector2(1,0).rotated(2*PI*i/50)
			add_child_at(direction * 320)
			add_child_at(direction * 328)
			

func make_rect(width, height, offset):
	for x in range(width):
		for y in range(height):
			var pos = offset + Vector2(x, y)
			add_child_at(pos * 8)
			

func add_child_at(pos):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	children.append(enemy)
	add_child(enemy)
	enemy.start(target)
	radius = max(radius, pos.length())
	return enemy

func _physics_process(delta):
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
