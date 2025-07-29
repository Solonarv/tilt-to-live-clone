class_name InputHandler
extends Node

enum INPUT_MODE {
	MOUSE_ABS, TILT
}
var mode: INPUT_MODE = INPUT_MODE.MOUSE_ABS

var last_mouse_pos: Vector2 = Vector2(0,0)
@onready
var base_down: Vector3 = Input.get_gravity()
var last_down: Vector3 = Vector3.ZERO
@export var max_distance = 100


func _physics_process(dt: float) -> void:
	if base_down != Vector3.ZERO:
		last_down = Input.get_gravity()

func fix_control_length(raw_control: Vector2, max_distance: float) -> Vector2:
	var raw_len = raw_control.length()
	var real_len = clamp(raw_len, 0, max_distance) / max_distance
	if real_len == 0: return Vector2.ZERO
	return raw_control / raw_len * real_len

## get the player's current "i want to go in this direction" heading.
## result length is between 0 (don't move) and 1 (move as fast as possible).
func get_player_control(player_pos: Vector2) -> Vector2:
	match mode:
		INPUT_MODE.MOUSE_ABS:
			return fix_control_length(last_mouse_pos - player_pos, 100)
		INPUT_MODE.TILT:
			return fix_control_length(Vector2(last_down.x, last_down.y), 10)
	return Vector2(0,0)


func _on_ingame_hud_gui_input(event: InputEvent) -> void:
	on_input(event)
		
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		last_mouse_pos = event.position

func next_input_mode() -> void:
	mode += 1
	mode %= INPUT_MODE.size()

func current_input_mode_name() -> String:
	return INPUT_MODE.keys()[mode]
