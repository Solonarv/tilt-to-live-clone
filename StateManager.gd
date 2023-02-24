extends Node

signal game_state_changed(old, new)

var game_state = STATE_MENU

enum {
	STATE_MENU, STATE_PLAYING, STATE_POST_GAME, STATE_PLAYING_PAUSED
}

const state_str = {
	STATE_MENU: "MENU",
	STATE_PLAYING: "PLAYING",
	STATE_POST_GAME: "POST_GAME",
	STATE_PLAYING_PAUSED: "PLAYING_PAUSED"
}

const should_pause = {
	STATE_MENU: true,
	STATE_PLAYING: false,
	STATE_POST_GAME: true,
	STATE_PLAYING_PAUSED: true
}

func _ready():
	get_tree().paused = should_pause[game_state]


func _invalid(fname, new):
	print("Invalid state transition from " + fname + ": " + state_str[game_state] + " ⇒ " + state_str[new])


func _transition(old, new):
	if old == new: return

	if game_state == old:
		game_state = new
		get_tree().paused = should_pause[new]
		print_debug("went from %s to %s" % [state_str[old], state_str[new]])
		emit_signal("game_state_changed", old, new)
	else:
		print_debug("Can't transition from %s⇒%s: current state is %s" % [
			state_str[old],
			state_str[new],
			state_str[game_state]
		])


func pause():
	_transition(STATE_PLAYING, STATE_PLAYING_PAUSED)

func resume():
	_transition(STATE_PLAYING_PAUSED, STATE_PLAYING)

func start():
	_transition(STATE_MENU, STATE_PLAYING)

func die():
	_transition(STATE_PLAYING, STATE_POST_GAME)

func restart():
	_transition(STATE_POST_GAME, STATE_MENU)
