class_name InputHandler
extends Node


# code order guidelines deliberately broken here
# to group related functionality


enum INPUT_MODE {
	MOUSE_ABS, TILT, TOUCH_DRAG
}
var mode: INPUT_MODE = INPUT_MODE.MOUSE_ABS

# MOUSE_ABS related vars
var last_mouse_pos: Vector2 = Vector2(0,0)

# TILT related vars
var last_gravity: Vector3 = Vector3.ZERO
@onready var base_gravity: Vector3 = Input.get_gravity()

# TOUCH_DRAG related vars
var touch_anchor := Vector2.ZERO
var last_touch_pos := Vector2.ZERO
var currently_touching := false :
	get: return currently_touching
	set(val):
		currently_touching = val
		touch_indicator.visible = val
var active_touch_index: int = -1

@onready var touch_indicator: CanvasLayer = $"../TouchDragIndicator"
@onready var touch_indicator_line: Line2D = $"../TouchDragIndicator/Line2D"


func _ready() -> void:
	if DisplayServer.is_touchscreen_available():
		mode = INPUT_MODE.TOUCH_DRAG


func _physics_process(_dt: float) -> void:
	if base_gravity != Vector3.ZERO:
		last_gravity = Input.get_gravity()


## get the player's current "i want to go in this direction" heading.
## result length is between 0 (don't move) and 1 (move as fast as possible).
func get_player_control(player_pos: Vector2) -> Vector2:
	match mode:
		INPUT_MODE.MOUSE_ABS:
			return _fix_control_length(last_mouse_pos - player_pos, 100)
		INPUT_MODE.TILT:
			return _fix_control_length(Vector2(last_gravity.x, last_gravity.y), 10)
		INPUT_MODE.TOUCH_DRAG:
			return _fix_control_length(last_touch_pos - touch_anchor, 300)
	return Vector2(0,0)


func next_input_mode() -> void:
	mode += 1
	mode %= INPUT_MODE.size()
	if not using_touch():
		currently_touching = false


func current_input_mode_name() -> String:
	return INPUT_MODE.keys()[mode]


func using_mouse() -> bool:
	return mode == INPUT_MODE.MOUSE_ABS


func using_touch() -> bool:
	return mode == INPUT_MODE.TOUCH_DRAG


func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if using_mouse():
			last_mouse_pos = event.position
		elif using_touch():
			last_touch_pos = event.position
			touch_indicator_line.points[1] = last_touch_pos - touch_anchor
	elif event is InputEventMouseButton:
		print_debug("mouse button in state %s, event is: %s" % [current_input_mode_name(), event])
		if event.pressed and not using_touch():
			StateManager.pause()
			return
		if mode == INPUT_MODE.TOUCH_DRAG:
			if event.pressed:
				touch_anchor = event.position
				touch_indicator.transform.origin = touch_anchor
				print_debug("touch_drag start at %s" % touch_anchor)
				currently_touching = true
				last_touch_pos = touch_anchor
			else:
				currently_touching = false
	elif event is InputEventKey:
		if event.pressed and not event.is_echo():
			StateManager.toggle_pause()


func _fix_control_length(raw_control: Vector2, max_distance: float) -> Vector2:
	var raw_len = raw_control.length()
	var real_len = clamp(raw_len, 0, max_distance) / max_distance
	if real_len == 0: return Vector2.ZERO
	return raw_control / raw_len * real_len


func _on_ingame_hud_gui_input(event: InputEvent) -> void:
	on_input(event)
