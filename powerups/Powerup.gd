class_name Powerup
extends Area2D

@export var explosion_scene: PackedScene
@export var explosive_shield_scene: PackedScene

var kind: int

func _ready() -> void:
	kind = randi()%2

func get_powerup() -> PackedScene:
	return [explosion_scene, explosive_shield_scene][kind]

func _on_area_entered(area: Area2D) -> void:
	if !(area is Player):
		push_error("powerup collided with non-player: " + str(area))
		return
	var instance : Area2D = get_powerup().instantiate()
	instance.position = position
	instance.begin(area)
	queue_free()
