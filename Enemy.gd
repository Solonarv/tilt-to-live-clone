extends Area2D

var is_enemy = true
var target
export var speed = 100


func _ready():
	pass

func start(player):
	target = player

func _process(delta):
	var direction = (target.position - position).normalized()
	var slowdown = clamp((target.position - position).length() / speed, 0.2, 1)
	position += direction * speed * delta * slowdown
	
