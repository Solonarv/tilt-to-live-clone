class_name Pickup
extends Area2D

var activator = null

enum POWERUP_KIND {
	EXPLOSION, EXPLOSIVE_SHIELD
}

static var POWERUP_SCRIPTS = {
	POWERUP_KIND.EXPLOSION: preload("res://Explosion.tscn").instantiate(),
	POWERUP_KIND.EXPLOSIVE_SHIELD: preload("res://Explosive_shield.tscn").instantiate()
}

var kind : POWERUP_KIND

# Called when the node enters the scene tree for the first time.
func _ready():
	kind = 0  # randomize once explosion actually works

func activate(player):
	var script : Area2D = POWERUP_SCRIPTS[kind]
	var instance = script.duplicate()
	if instance.get_parent() != null:
		instance.get_parent().call_deferred("remove_child", instance)
	instance.begin(self, player)
	print_debug("activating pickup of kind: " + str(kind))
