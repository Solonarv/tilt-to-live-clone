extends KinematicBody2D

signal hit

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
	velocity = -direction * distance * acceleration * 100
	#velocity *= pow(friction_coeff * distance, delta)
	#velocity += Vector2(acceleration, 0).rotated(rotation) * distance
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get("is_enemy"):
			die()

func die():
	dead = true
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	dead = false
	$CollisionShape2D.disabled = false
