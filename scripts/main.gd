extends Node2D

const SETTINGS = preload("res://scenes/Settings.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# var main_menu = MAIN_MENU.new()
	# add_child(main_menu)
	pass # Replace with function body.

func testEsc():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pauseGame()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()

func pauseGame() -> void:
	var settingsScreen = SETTINGS.instantiate()
	add_child(settingsScreen)

func _on_settings_button_pressed() -> void:
	print("pres'd")
	pauseGame()
