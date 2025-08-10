extends Node2D

signal no_longer_immune(cause: Node2D)

@export var delayed_bomb_scene: PackedScene
@export var time_between_bombs: float

var player: Player
var time_since_trail := 0.0
var exploding := false

@onready var duration := $Duration


func _ready() -> void:
	position = Vector2(0,0)


func _physics_process(delta: float) -> void:
	time_since_trail += delta
	if time_since_trail >= time_between_bombs:
		time_since_trail -= time_between_bombs
		var bomb_timeout: float = duration.wait_time - duration.time_left * 0.1
		var bomb: DelayedBomb = delayed_bomb_scene.instantiate()
		bomb.wait_time = bomb_timeout
		bomb.position = player.position
		bomb.begin(player)


func begin(player: Player) -> void:
	self.player = player
	player.add_child.call_deferred(self)
	player.become_immune(self)


func _on_duration_timeout() -> void:
	queue_free()
	no_longer_immune.emit(self)
