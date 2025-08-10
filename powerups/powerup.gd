class_name Powerup
extends Area2D


@export var powerups: Array[PackedScene]
@export var sprites: Array[Texture2D]

var kind: int

@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	kind = randi_range(0, powerups.size() - 1)
	sprite.texture = sprites[kind]


func get_powerup() -> PackedScene:
	return powerups[kind]


func _on_area_entered(area: Area2D) -> void:
	if !(area is Player):
		push_error("powerup collided with non-player: " + str(area))
		return
	var instance: Node2D = get_powerup().instantiate()
	instance.position = position
	instance.begin(area)
	queue_free()
