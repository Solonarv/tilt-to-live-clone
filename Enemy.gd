class_name Enemy
extends Area2D

var is_enemy = true
var target
var in_formation = false
@export var speed = 100


func _ready():
	pass

func start(player):
	target = player

func _physics_process(delta):
	if !in_formation:
		move(delta)

func move(delta):
	if target != null:
		var direction = (target.position - position).normalized()
		var slowdown = clamp((target.position - position).length() / speed, 0.2, 1)
		position += direction * speed * delta * slowdown
	
