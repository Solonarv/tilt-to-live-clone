class_name Enemy
extends Area2D


@export var speed := 100.0

var target: Player
var in_formation := false


func _physics_process(delta: float) -> void:
	if !in_formation:
		move(delta)


func start(player: Player) -> void:
	target = player


func move(delta: float) -> void:
	if target != null:
		var direction = (target.position - position).normalized()
		var slowdown = clamp((target.position - position).length() / speed, 0.2, 1)
		position += direction * speed * delta * slowdown
	
