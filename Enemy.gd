extends Area2D

var is_enemy = true
var target
export var speed = 100


func _ready():
	pass

func start(player):
	target = player

func _physics_process(delta):
	if !get_parent().is_in_group("formations"):
		move(delta)

func move(delta):
	if target != null:
		var direction = (target.position - position).normalized()
		var slowdown = clamp((target.position - position).length() / speed, 0.2, 1)
		position += direction * speed * delta * slowdown
	
