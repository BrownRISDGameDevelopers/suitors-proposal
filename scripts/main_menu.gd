extends Control

const MAIN := preload("res://scenes/Main.tscn")

func _ready():
	pass


func _on_start_button_pressed():
	
	# var main = MAIN.new()
	# add_child(main)
	pass



func _on_quit_button_pressed() -> void:
	get_tree().quit() # Replace with function body.
