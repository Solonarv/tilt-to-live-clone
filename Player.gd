extends Area2D

signal hit
signal score

export (float) var friction_coeff = 0.15
export (float) var acceleration = 7
export (float) var max_distance = 100
export (float) var dead_zone = 10


export (float) var input_falloff = 0
var input_falloff_compl = 1


var velocity = Vector2(0, 0)
var dead = false

var last_input = Vector2(0, 0)
var relative_target = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead:
		return
	relative_target = relative_target + last_input
	var direction = relative_target.normalized()
	var distance = relative_target.length()
	var clamped_distance = clamp(distance, 0, max_distance)
	if clamped_distance > 0:
		relative_target *= clamped_distance / distance
		$IndicatorLine.points[1] = Vector2(clamped_distance, 0)
		look_at(position + relative_target)
		if clamped_distance > dead_zone:
			velocity = relative_target * acceleration
			position += velocity * delta
	last_input = Vector2(0,0)


func motion(rel: Vector2):
	last_input += rel
	

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
