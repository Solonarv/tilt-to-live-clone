class_name HUD
extends CanvasLayer

signal start_game
signal pause_game
signal resume_game

@onready var message: Label = $BetweenGameHud/Message
@onready var message_timer: Timer = $BetweenGameHud/MessageTimer
@onready var start_button: Button = $BetweenGameHud/StartButton
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	StateManager.connect("game_state_changed", self._on_game_state_changed)
	$PauseHud/RotateInputModeButton.text = $InputHandler.current_input_mode_name()


func show_message(text: String) -> void:
	message.text = text
	message.show()
	message_timer.start()


func show_game_over() -> void:
	show_message("Game Over")
	await message_timer.timeout
	
	message.text = "Dodge the\nDots!"
	message.show()
	await get_tree().create_timer(1).timeout
	start_button.show()


func update_score(score: int, mult: float) -> void:
	score_label.text = "%d  x %.1f" % [score, mult]


func _on_MessageTimer_timeout() -> void:
	$Message.hide()


func _on_StartButton_pressed() -> void:
	StateManager.start()


func _on_ResumeButton_pressed() -> void:
	StateManager.resume()


func _on_RestartButton_pressed() -> void:
	StateManager.restart()


func _on_game_state_changed(old: StateManager.STATE, new: StateManager.STATE) -> void:
	match old:
		StateManager.STATE.MENU:
			$BetweenGameHud.deactivate()
		StateManager.STATE.PLAYING_PAUSED:
			$PauseHud.deactivate()
		StateManager.STATE.POST_GAME:
			$PostGameHud.deactivate()
		StateManager.STATE.PLAYING:
			$IngameHud.deactivate()
	
	match new:
		StateManager.STATE.MENU:
			$BetweenGameHud.activate()
		StateManager.STATE.PLAYING_PAUSED:
			$PauseHud.activate()
		StateManager.STATE.POST_GAME:
			$PostGameHud.activate()
		StateManager.STATE.PLAYING:
			$IngameHud.activate()


func _on_rotate_input_mode_button_pressed() -> void:
	var hdl: InputHandler = $InputHandler
	hdl.next_input_mode()
	$PauseHud/RotateInputModeButton.text = hdl.current_input_mode_name()
