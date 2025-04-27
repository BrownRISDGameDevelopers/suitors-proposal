extends Control

const MAIN := preload("res://scenes/Main.tscn")
@onready var credits_scroll: Credits = $CreditsScroll

func _ready():
	credits_scroll.close()

func _on_start_button_pressed():
	
	# var main = MAIN.new()
	# add_child(main)
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit() # Replace with function body.

func _on_credits_pressed() -> void:
	print("showing")
	credits_scroll.open()
	
