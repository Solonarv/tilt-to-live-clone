class_name KillingArea
extends Area2D

var player : Player

func _ready() -> void:
	for area in get_overlapping_areas():
		area.queue_free()
		player.get_score(area)

func begin(player: Player):
	player.call_deferred("add_sibling", self)
	self.player = player

func _on_area_entered(area: Area2D) -> void:
	if should_kill(area):
		do_kill(area)

func should_kill(area : Area2D) -> bool:
	return area.is_in_group("enemies")

func do_kill(area : Area2D) -> void:
		area.queue_free()
		player.get_score(area)
