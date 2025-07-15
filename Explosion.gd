class_name Explosion
extends Area2D

var activator : Player = null
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for area in get_overlapping_areas():
		maybe_kill(area)
	$Timer.start()
	print_debug("explosion ready")

func begin(source: Pickup, player : Player):
	source.get_parent().call_deferred("add_child", self)
	position = source.position
	activator = player
	print_debug("explosion begin")

func _on_Timer_timeout():
	queue_free()

func _on_area_entered(area):
	maybe_kill(area)

func maybe_kill(area):
	if area.is_in_group("enemies"):
		area.queue_free()
		if activator != null: activator.get_score(area)
