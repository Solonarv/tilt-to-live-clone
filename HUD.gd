extends CanvasLayer

signal start_game
signal pause_game
signal resume_game

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


func _on_game_state_changed(old, new):
	if old == StateManager.STATE_MENU:
		$BetweenGameHud.hide()
	elif old == StateManager.STATE_PLAYING_PAUSED:
		$PauseHud.hide()
	elif old == StateManager.STATE_POST_GAME:
		$PostGameHud.hide()
	elif old == StateManager.STATE_PLAYING:
		$InGameHud.hide()
	
	if new == StateManager.STATE_MENU:
		$BetweenGameHud.show()
	elif new == StateManager.STATE_PLAYING_PAUSED:
		$PauseHud.show()
	elif new == StateManager.STATE_POST_GAME:
		$PostGameHud.show()
	elif new == StateManager.STATE_PLAYING:
		$InGameHud.show()


func _on_RestartButton_pressed():
	StateManager.restart()


func _on_game_input(evt):
	print("hi")


func _on_InGameHud_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		StateManager.pause()
