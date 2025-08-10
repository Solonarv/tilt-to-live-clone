class_name KillingArea
extends Area2D


var player: Player


func _ready() -> void:
	clear_overlaps()


func _on_area_entered(area: Area2D) -> void:
	_try_kill(area)


func begin(player: Player) -> void:
	player.add_sibling.call_deferred(self)
	self.player = player


func clear_overlaps() -> void:
	for area in get_overlapping_areas():
		_try_kill(area)

func should_kill(area: Area2D) -> bool:
	return area.is_in_group(&"enemies")


func do_kill(area: Area2D) -> void:
	area.queue_free()
	player.get_score(area)


func _try_kill(area: Area2D) -> void:
	if should_kill(area):
		do_kill(area)
