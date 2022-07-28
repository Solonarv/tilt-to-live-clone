extends Area2D

var activator = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate(player):
	if activator != null: return
	activator = player
	for area in get_overlapping_areas():
		if area.is_in_group("enemies"):
			area.queue_free()
	global_scale *= 8
	$Timer.start()

func _on_Timer_timeout():
	queue_free()



func _on_Powerup_area_entered(area):
	if activator != null && area.is_in_group("enemies"):
		area.queue_free()
		activator.score(area)
