class_name Player
extends Area2D

signal hit
signal score

@export var friction_coeff: float = 0.15
@export var acceleration: float = 700
@export var max_distance: float = 100
@export var dead_zone_squared: float = 0.01


@export var input_falloff: float = 0
var input_falloff_compl = 1

var input_handler: InputHandler

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
	relative_target = input_handler.get_player_control(position)
	if !relative_target.is_zero_approx():
		$IndicatorLine.points[1] = Vector2(relative_target.length()*100, 0)
		look_at(position + relative_target)
		if true: #relative_target.length_squared() > dead_zone_squared:
			velocity = relative_target * acceleration
			position += velocity * delta


func set_input_handler(hdl: InputHandler) -> void:
	input_handler = hdl

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
