#extends Control
#
##@onready var blur_animation: AnimationPlayer = $BlurAnimation
#
#func _ready():
	#get_tree().paused = true
	##blur_animation.play()
	#
#func resume():
	#print("time to del")
	#get_tree().paused = false
	#queue_free()
	##blur_animation.play_backwards()
	##blur_animation.animation_finished.connect(func():
		##queue_free())
#
#
#func _on_resume_pressed() -> void:
	#resume()
#
#func _on_quit_game_pressed() -> void:
	## are you sure you want to quit?
	## return to main menu
	#pass
