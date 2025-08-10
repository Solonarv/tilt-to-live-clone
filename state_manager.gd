extends Node

signal game_state_changed(old: STATE, new: STATE)

enum STATE {
	MENU, PLAYING, POST_GAME, PLAYING_PAUSED
}

const state_str = {
	STATE.MENU: "MENU",
	STATE.PLAYING: "PLAYING",
	STATE.POST_GAME: "POST_GAME",
	STATE.PLAYING_PAUSED: "PLAYING_PAUSED"
}

const should_pause = {
	STATE.MENU: true,
	STATE.PLAYING: false,
	STATE.POST_GAME: true,
	STATE.PLAYING_PAUSED: true
}

const state_mouse_mode = {
	STATE.MENU: Input.MOUSE_MODE_VISIBLE,
	STATE.PLAYING: Input.MOUSE_MODE_VISIBLE,
	STATE.POST_GAME: Input.MOUSE_MODE_VISIBLE,
	STATE.PLAYING_PAUSED: Input.MOUSE_MODE_VISIBLE
}


var game_state: STATE = STATE.MENU


func _ready():
	get_tree().paused = should_pause[game_state]


func _invalid(fname, new):
	print("Invalid state transition from " + fname + ": " + state_str[game_state] + " ⇒ " + state_str[new])


func _transition(old, new):
	if old == new: return

	if game_state == old:
		game_state = new
		get_tree().paused = should_pause[new]
		Input.set_mouse_mode(state_mouse_mode[new])
		# print_debug("went from %s to %s" % [state_str[old], state_str[new]])
		emit_signal("game_state_changed", old, new)
	else:
		print_debug("Can't transition from %s⇒%s: current state is %s" % [
			state_str[old],
			state_str[new],
			state_str[game_state]
		])


func pause():
	_transition(STATE.PLAYING, STATE.PLAYING_PAUSED)

func resume():
	_transition(STATE.PLAYING_PAUSED, STATE.PLAYING)

func toggle_pause():
	match game_state:
		STATE.PLAYING:
			pause()
		STATE.PLAYING_PAUSED:
			resume()

func start():
	_transition(STATE.MENU, STATE.PLAYING)

func die():
	_transition(STATE.PLAYING, STATE.POST_GAME)

func restart():
	_transition(STATE.POST_GAME, STATE.MENU)
