class_name Player
extends Area2D

signal hit
signal score

@export var friction_coeff: float = 0.15
@export var acceleration: float = 7
@export var max_distance: float = 100
@export var dead_zone: float = 10


@export var input_falloff: float = 0
var input_falloff_compl = 1


var velocity = Vector2(0, 0)
var dead = false

enum INPUT_MODE {
	ABS, REL
}

@export var input_mode: INPUT_MODE = INPUT_MODE.REL

var last_input = Vector2(0, 0)
var last_input_abs = Vector2(0, 0)
var relative_target = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead:
		return
	match input_mode:
		INPUT_MODE.ABS:
			relative_target = last_input_abs - position
		INPUT_MODE.REL:
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


func on_motion(rel: Vector2, pos: Vector2):
	last_input += rel
	last_input_abs = pos
	

func die():
	dead = true
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	dead = false
	$CollisionShape2D.disabled = false


func _on_Player_area_entered(area : Area2D):
	print_debug("player entered area: " + area.name)
	if area.is_in_group("enemies"):
		die()

func get_score(area):
	emit_signal("score")
