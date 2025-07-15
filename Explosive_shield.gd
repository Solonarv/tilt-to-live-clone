extends Area2D


var activator : Player = null
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func begin(source : Pickup, player : Player):
	player.call_deferred("add_child", self)
	activator = player

func _on_Timer_timeout():
	queue_free()

func _on_area_entered(area):
	if !active:
		active = true
		scale *= 8
		$Timer.start()
	if area.is_in_group("enemies"):
		area.queue_free()
		if activator != null: activator.get_score(area)
