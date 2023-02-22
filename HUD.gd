extends CanvasLayer

signal start_game
signal pause_game
signal unpause_game


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
	$StartButton.hide()
	$Message.hide()
	emit_signal("start_game")

func _on_pause_game():
	$Message.text = "Game Paused"
	$Message.show()
	$FakePauseButton.hide()
	$GlobalPauseButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UnpauseButton.show()
	$UnpauseButton.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_unpause_game():
	print("hi")
	$Message.hide()
	$FakePauseButton.show()
	$GlobalPauseButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$UnpauseButton.hide()
	$UnpauseButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_GlobalPauseButton_gui_input(event):
	if !(event is InputEventMouseMotion): print("hi", event)
	if (event is InputEventMouseButton or event is InputEventKey) and event.pressed:
		emit_signal("pause_game")

func _on_UnpauseButton_pressed():
	print("hi")
	emit_signal("unpause_game")
