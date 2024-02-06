extends CanvasLayer
signal start_game
signal end_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_countdown(seconds):
	$Countdown.seconds = seconds
	$Countdown.show()
	$MessageTimer.start()
	
func show_game_over():
	end_game.emit()
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Message.text = "Honest XP"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$XPBar.hide()
	$TextureProgressBar.hide()
	$ScoreLabel.hide()
	
# Called when the node enters the scene tree for the first time.
func update_score(score):
	$ScoreLabel.text = "Lv. " + str(score)

func update_count(seconds):
	$Countdown.text = str(seconds)
	
func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
