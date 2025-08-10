class_name Player
extends Area2D

signal hit
signal scored

@export var acceleration: float = 700
@export var dead_zone_squared: float = 0.01

var input_handler: InputHandler
var dead := false
var immune_to_enemies := {}

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var indicator_line: Line2D = $IndicatorLine
@onready var viewport: Viewport = $"/root"

func _physics_process(delta: float) -> void:
	if dead:
		return
	var relative_target := input_handler.get_player_control(position)
	if !relative_target.is_zero_approx():
		indicator_line.points[1] = Vector2(relative_target.length()*100, 0)
		look_at(position + relative_target)
		if true: #relative_target.length_squared() > dead_zone_squared:
			var velocity := relative_target * acceleration
			position += velocity * delta
			position = position.clamp(Vector2.ZERO, viewport.size)


func set_input_handler(hdl: InputHandler) -> void:
	input_handler = hdl


func die() -> void:
	dead = true
	emit_signal("hit")
	collider.set_deferred(&"disabled", true)


func start(pos: Vector2) -> void:
	position = pos
	show()
	dead = false
	collider.disabled = false

func become_immune(cause: Node) -> void:
	print_debug("player became immune because of", cause)
	immune_to_enemies[cause] = 1 + immune_to_enemies.get_or_add(cause, 0)
	cause.connect(&"no_longer_immune", self._on_no_longer_immune)

func _on_player_area_entered(area: Area2D) -> void:
	if immune_to_enemies.size() == 0 and area.is_in_group(&"enemies"):
		die()


func get_score(_area: Area2D) -> void:
	emit_signal(&"scored")

func _on_no_longer_immune(cause) -> void:
	immune_to_enemies[cause] -= 1
	if immune_to_enemies[cause] <= 0:
		immune_to_enemies.erase(cause)
		print_debug("player lost immunity granted by: ", cause)
	if immune_to_enemies.size() == 0:
		print_debug("player is no longer immune!")
