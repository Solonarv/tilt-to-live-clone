extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target
var velocity = Vector2()
var angular_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func start(player):
	var direction = Vector2(1,0).rotated(rand_range(0, 2*PI))
	velocity = direction * rand_range(0.7, 1.4) * 50
	angular_velocity = rand_range(-PI, PI) * 0.3

func _process(delta):
	position += velocity * delta
	rotation += angular_velocity * delta
