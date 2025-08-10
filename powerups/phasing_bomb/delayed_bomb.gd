class_name DelayedBomb
extends KillingArea

var active := false
var wait_time: float

@onready var fuse: Timer = $Fuse
@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	fuse.wait_time = wait_time
	fuse.start()
	rotation = randf_range(-PI, PI)
	


func should_kill(area: Area2D) -> bool:
	return active and super(area)


func _on_fuse_timeout() -> void:
	active = true
	sprite.scale *= 4
	timer.start()
	clear_overlaps()


func _on_timer_timeout() -> void:
	queue_free()
