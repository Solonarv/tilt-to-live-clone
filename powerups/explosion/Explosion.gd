class_name Explosion
extends Area2D

var player : Player

func begin(player: Player):
	self.player = player

func _physics_process(delta: float) -> void:
	for area in get_overlapping_areas():
		area.queue_free()
		player.get_score(area)
