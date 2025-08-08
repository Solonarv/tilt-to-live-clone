extends CanvasLayer

signal start_game
signal pause_game
signal resume_game
signal mouse_motion_input(rel, pos)

func _ready():
	StateManager.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
	$PauseHud/RotateInputModeButton.text = $InputHandler.current_input_mode_name()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\nDots!"
	$Message.show()
	await get_tree().create_timer(1).timeout
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
	#print_debug("unhandled input! " + str(event))
	pass



func _on_rotate_input_mode_button_pressed() -> void:
	var hdl: InputHandler = $InputHandler
	hdl.next_input_mode()
	$PauseHud/RotateInputModeButton.text = hdl.current_input_mode_name()
