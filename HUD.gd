extends CanvasLayer

signal start_game
signal pause_game
signal resume_game
signal mouse_motion_input(rel)

func _ready():
	StateManager.connect("game_state_changed", self, "_on_game_state_changed")

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the\nDots!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	StateManager.start()


func _on_ResumeButton_pressed():
	StateManager.resume()


func _on_RestartButton_pressed():
	StateManager.restart()


func _on_game_state_changed(old, new):
	if old == StateManager.STATE_MENU:
		$BetweenGameHud.deactivate()
	elif old == StateManager.STATE_PLAYING_PAUSED:
		$PauseHud.deactivate()
	elif old == StateManager.STATE_POST_GAME:
		$PostGameHud.deactivate()
	elif old == StateManager.STATE_PLAYING:
		$IngameHud.deactivate()
	
	if new == StateManager.STATE_MENU:
		$BetweenGameHud.activate()
	elif new == StateManager.STATE_PLAYING_PAUSED:
		$PauseHud.activate()
	elif new == StateManager.STATE_POST_GAME:
		$PostGameHud.activate()
	elif new == StateManager.STATE_PLAYING:
		$IngameHud.activate()


func _unhandled_input(event):
	print_debug("hi")


func _on_IngameHud_gui_input(event):
	if StateManager.game_state != StateManager.STATE_PLAYING:
		print_debug("got input from ingame hud when it should be inactive")
		return
	if event is InputEventMouseButton and event.pressed:
		StateManager.pause()
	elif event is InputEventMouseMotion:
		emit_signal("mouse_motion_input", event.relative)
