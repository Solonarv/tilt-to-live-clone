class_name Powerup
extends Area2D

@export var explosion_scene: PackedScene

func _on_area_entered(area: Area2D) -> void:
	print_debug("powerup collided with:" + str(area))
	var instance : Area2D = explosion_scene.instantiate()
	get_parent().call_deferred("add_child", instance)
	instance.position = position
	instance.begin(area)
	queue_free()
