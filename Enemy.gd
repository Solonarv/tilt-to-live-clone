extends KinematicBody2D

var is_enemy = true
var target
export var speed = 20


func _ready():
	pass

func start(player):
	target = player

func _physics_process(delta):
	var direction = (target.position - position).normalized()
	var collision = move_and_collide(direction * speed * delta)
	if collision != null:
		collision.collider.call("die")
