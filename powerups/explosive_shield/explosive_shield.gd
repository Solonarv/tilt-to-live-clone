extends KillingArea


var expanded: bool = false


func _ready() -> void:
	super()
	reparent(player)
	position = Vector2(0,0)
	# scale /= 8
	print_debug("explosive shield ready!")


func do_kill(area: Area2D) -> void:
	super(area)
	if !expanded:
		scale *= 8
		expanded = true
		$Timer.start()
		reparent.call_deferred(player.get_parent())


func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.
