extends Area2D

signal hit
signal score

export (float) var friction_coeff = 0.15
export (float) var acceleration = 10
export (float) var max_distance = 100

var velocity = Vector2(0, 0)
var dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead:
		return
	look_at(get_global_mouse_position())
	var direction = (position - get_global_mouse_position()).normalized()
	var distance = (position - get_global_mouse_position()).length()
	distance = clamp(distance, 0.1, max_distance) / max_distance
	if distance > 0.1:
		velocity = -direction * distance * acceleration * 100
		position += velocity * delta

func die():
	dead = true
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	dead = false
	$CollisionShape2D.disabled = false


func _on_Player_area_entered(area):
	if area.is_in_group("enemies"):
		die()
	elif area.is_in_group("powerups"):
		area.activate(self)

func score(area):
	emit_signal("score")
