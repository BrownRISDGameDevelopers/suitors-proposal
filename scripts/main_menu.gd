extends Control

const MAIN = preload("res://scenes/Main.tscn")
const CREDITS = preload("res://scenes/Credits.tscn")

func _ready():
	pass

func _on_start_button_pressed():
	# var main = MAIN.new()
	# add_child(main)
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit() # Replace with function body.

func _on_credits_pressed() -> void:
	print("showing")
	var credits = CREDITS.instantiate()
	self.add_child(credits)
	credits.open()
	
func _on_play_pressed() -> void:
	print("launching game")
	get_tree().change_scene_to_packed(MAIN)
