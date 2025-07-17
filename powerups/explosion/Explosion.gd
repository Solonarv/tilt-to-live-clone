class_name Explosion
extends KillingArea

func _ready() -> void:
	super()
	$Timer.start()

func _on_timer_timeout() -> void:
	queue_free()
