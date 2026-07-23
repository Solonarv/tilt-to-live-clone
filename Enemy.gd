class_name Enemy
extends Area2D


@export var speed := 100.0

var target: Player
var in_formation := false
var normal_physics := false
var velocity := Vector2(0,0)


func _physics_process(delta: float) -> void:
	if !in_formation:
		move(delta)
	else:
		if normal_physics:
			position += velocity * delta
	


func start(player: Player) -> void:
	target = player


func move(delta: float) -> void:
	if target != null:
		var direction = (target.position - position).normalized()
		var slowdown = clamp((target.position - position).length() / speed, 0.2, 1)
		velocity = direction * speed * slowdown
		position += velocity * delta
	
