extends Node2D

const MAIN_MENU = preload("res://scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game ready")
	print("loading main menu")
	
	var main_menu = MAIN_MENU.new()
	add_child(main_menu)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
