extends Control

func _ready():
	var blur_animation: AnimationPlayer = $BlurAnimation
	blur_animation.play("RESET")
	

func _process(delta):
	testEsc()

func resume():
	get_tree().paused = false
	var blur_animation: AnimationPlayer = $BlurAnimation
	blur_animation.play_backwards()

func pause():
	get_tree().paused = true
	var blur_animation: AnimationPlayer = $BlurAnimation
	blur_animation.play()

func testEsc():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_game_pressed() -> void:
	# are you sure you want to quit?
	# return to main menu
	pass

func _on_settings_button_pressed() -> void:
	pause()
